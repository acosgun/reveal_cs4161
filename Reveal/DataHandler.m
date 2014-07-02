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
    //NSLog(@"updateFeeds");
    //TODO: Make RESTful call to server
    
    self.json_handler = [[JsonHandler alloc] init];
    self.json_handler.delegate = self;
    
    if ([identifier  isEqualToString:@"TableViewController"]) {
        [self.json_handler getTenMostRecentPosts];
    }
}

- (void) updateFeedsWithIdentifier:(NSString *)identifier postClass:(RevealPost *)revealPost {
    
    self.json_handler = [[JsonHandler alloc] init];
    self.json_handler.delegate = self;
    
    if ([identifier isEqualToString:@"MeFeedTableViewController"]) {
        [self.json_handler getUserPosts:revealPost];
    } else if ([identifier isEqualToString:@"UserProfileTableViewController"]) {
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

    //NSLog(@"fillFeedWithTenMostRecentPosts");
    self.nearby_feed = [[NSMutableArray alloc] init];
    //[self.nearby_feed removeAllObjects];
    
    for (NSDictionary *post in posts)
    {
        RevealPost *revealPost = [RevealPost postWithIDNumber:[post objectForKey:@"id"]];
        revealPost.userName = [post objectForKey:@"username"];
        revealPost.votes = [post objectForKey:@"watch_stat"];
        revealPost.thumbnail = [post objectForKey:@"avatar_thumb"];
        revealPost.date = [NSDate dateWithTimeIntervalSinceNow:-60*2];
        revealPost.dateString = [post objectForKey:@"created_at"];
        revealPost.body = [post objectForKey:@"content"];
        revealPost.revealed = [[post objectForKey:@"revealed"]boolValue];
        revealPost.userID = [post objectForKey:@"user_id"];
        
        [self.nearby_feed addObject:revealPost];
    }
    //NSLog(@"nearby_feed count: %d",self.nearby_feed.count);
    //NSLog(@"ten recent posts from fillFeedWithTenMostRecentPosts: %@", self.nearby_feed);
}

- (void) revealPost:(NSInteger *) post_id
{
    NSInteger action_id = 0;
    [self.json_handler changeRevealStatus:post_id action:&action_id];
}
- (void) hidePost:(NSInteger *) post_id
{
    NSInteger action_id = 1;
    [self.json_handler changeRevealStatus:post_id action:&action_id];
}
- (void) deletePost:(NSInteger *) post_id
{
    NSInteger action_id = 2;
    [self.json_handler changeRevealStatus:post_id action:&action_id];
}

#pragma mark - JSON Callbacks
-(void) getTenMostRecentPostsCallback:tenMostRecentPosts {
    //self.nearby_feed = tenMostRecentPosts;
    [self fillFeedWithTenMostRecentPosts:tenMostRecentPosts];
    //NSLog(@"Ten most recent posts sent back to DataHandler.m");
    [self.delegate feedUpdatedCallback:self];
}

-(void) getUserPostsCallBack:(NSArray *)userPosts {
    [self fillFeedWithTenMostRecentPosts:userPosts];
    //NSLog(@"User posts sent back to DataHandler.m");
    [self.delegate feedUpdatedCallback:self];
}

-(void)revealStatusCallback:(BOOL)success action:(NSInteger)action_id
{
    NSLog(@"revealStatusCallback in DataHandler.m");
    NSLog(@"action_id: %d",action_id);
    [self.delegate revealStatusCallback:success action:action_id];
}





@end
