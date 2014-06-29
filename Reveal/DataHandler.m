//
//  DataHandler.m
//  Reveal
//
//  Created by Akansel Cosgun on 6/26/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//

#import "DataHandler.h"
#import "RevealPost.h"
#import "JsonHandler.h"

@implementation DataHandler

static DataHandler *sharedDataSource = nil;

+ (DataHandler *) sharedInstance {
    
    if(sharedDataSource == nil)
    {
        sharedDataSource = [[super alloc] init];
    }
    return sharedDataSource;
}

- (void) updateFeedsWithIdentifier:(NSString *)identifier {
    NSLog(@"updateFeeds");
    //TODO: Make RESTful call to server
    
    //[self fillFeedWithFakeData];
    self.json_handler = [[JsonHandler alloc] init];
    self.json_handler.delegate = self;
    
    if ([identifier  isEqualToString:@"TableViewController"]) {
        [self.json_handler getTenMostRecentPosts];
    }
    
    
    [self.delegate feedUpdatedCallback:self];
}

- (void) updateFeedsWithIdentifier:(NSString *)identifier postClass:(RevealPost *)revealPost {
    
    self.json_handler = [[JsonHandler alloc] init];
    self.json_handler.delegate = self;
    
    if ([identifier isEqualToString:@"MeFeedTableViewController"]) {
        [self.json_handler getUserPosts:revealPost];
    }
        [self.delegate feedUpdatedCallback:self];
}

- (void) createSharePost:(RevealPost *)revealPost {
    self.json_handler = [[JsonHandler alloc] init];
    self.json_handler.delegate = self;
}

- (id)init {
    if ( (self = [super init]) ) {
        // your custom initialization
        self.nearby_feed = [NSMutableArray array];
    }
    return self;
}

- (void) fillFeedWithTenMostRecentPosts:(NSArray *)posts {
    self.nearby_feed = [[NSMutableArray alloc] init];
    for (NSDictionary *post in posts) {
        RevealPost *revealPost = [RevealPost postWithIDNumber:[post objectForKey:@"id"]];
        revealPost.userName = [post objectForKey:@"username"];
        revealPost.votes = [post objectForKey:@"watch_stat"];
        revealPost.thumbnail = [post objectForKey:@"avatar_thumb"];
        revealPost.date = [NSDate dateWithTimeIntervalSinceNow:-60*2];
        revealPost.body = [post objectForKey:@"content"];
        revealPost.revealed = [[post objectForKey:@"revealed"]boolValue];
        revealPost.userID = [post objectForKey:@"user_id"];
        
        [self.nearby_feed addObject:revealPost];
    }
    NSLog(@"ten recent posts from fillFeedWithTenMostRecentPosts: %@", self.nearby_feed);
}

- (void) fillFeedWithFakeData
{
    RevealPost *post1 = [RevealPost postWithIDNumber:@1];
    post1.userName = @"Travis";
    post1.votes = @50;
    post1.thumbnail = @"https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xfp1/t1.0-1/p320x320/10176093_10201958858788756_229269747_n.jpg";
    post1.date = [NSDate dateWithTimeIntervalSinceNow:-60*2];
    post1.body = @"Ohhhh I'm going to Escambia County tomorrow to inspect bridges, now whenever you visit home you'll be driving over bridges Murray inspected.";
    post1.revealed = true;
    
    RevealPost *post2 = [RevealPost postWithIDNumber:@2];
    post2.userName = @"Margarett";
    post2.votes = @3;
    post2.thumbnail = @"https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xap1/t1.0-1/p320x320/9438_10201644950541120_1028851633_n.jpg";
    post2.date = [NSDate dateWithTimeIntervalSinceNow:-60*5];
    post2.body = @"blue skies and delicious drinks at a rooftop bar in Philly? yes, please!";
    
    RevealPost *post3 = [RevealPost postWithIDNumber:@3];
    post3.userName = @"Matt";
    post3.votes = @-4;
    post3.thumbnail = @"https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xap1/t1.0-1/p320x320/10462502_10152444987365266_1812757493745827010_n.jpg";
    post3.date = [NSDate dateWithTimeIntervalSinceNow:-60*20];
    post3.body = @"Brand New tickets for Orlando in October go on sale today at noon. They will sell out extremely fast, probably before half an hour.";
    
    self.nearby_feed = [NSMutableArray arrayWithObjects:post1, post2, post3, nil];
}

#pragma mark - Callbacks
-(void) getTenMostRecentPostsCallback:tenMostRecentPosts {
    //self.nearby_feed = tenMostRecentPosts;
    [self fillFeedWithTenMostRecentPosts:tenMostRecentPosts];
    NSLog(@"Ten most recent posts sent back to DataHandler.m");
    [self.delegate feedUpdatedCallback:self];
}

-(void) getUserPostsCallBack:(NSArray *)userPosts {
    [self fillFeedWithTenMostRecentPosts:userPosts];
    NSLog(@"User posts sent back to DataHandler.m");
    [self.delegate feedUpdatedCallback:self];
}

@end
