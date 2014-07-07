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
        [self.json_handler getPopularPosts];
        //[self.json_handler getNearbyPosts];
        //[self.json_handler getFollowedPosts];
    }
}

- (void) updateFeedsWithIdentifier:(NSString *)identifier postClass:(RevealPost *)revealPost {
    
    self.json_handler = [[JsonHandler alloc] init];
    self.json_handler.delegate = self;
    
    if ([identifier isEqualToString:@"MeFeedTableViewController"]) {
        [self.json_handler getUserPosts:revealPost];
    } else if ([identifier isEqualToString:@"UserProfileTableViewController"]) {
        NSLog(@"!!!JsonHandler call (from UserProfileTVC) in datahandler class, reveal post info: %@     %@", revealPost.userID, revealPost.userName);
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
        self.feed = [NSMutableArray array];
    }
    return self;
}

- (void) fillFeedWithTenMostRecentPosts:(NSArray *)posts {
    //NSLog(@"fillFeedWithTenMostRecentPosts");
    self.feed = [[NSMutableArray alloc] init];
    
    self.feed = [self createPostArrayFromJSONResponse:posts];
    //NSLog(@"nearby_feed count: %d",self.feed.count);
    //NSLog(@"ten recent posts from fillFeedWithTenMostRecentPosts: %@", self.feed);
}

- (void) fillFeedWithPopularPosts:(NSArray *)posts {
    self.popularFeed = [[NSMutableArray alloc] init];
    self.popularFeed = [self createPostArrayFromJSONResponse:posts];
}

- (NSMutableArray *)createPostArrayFromJSONResponse:(NSArray *)posts {
    
    NSMutableArray *postsArray = [[NSMutableArray alloc] init];
    
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
        revealPost.current_user_vote = [post objectForKey:@"current_user_vote"];
        
        [postsArray addObject:revealPost];
    }
    return postsArray;
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

- (void) watchPost:(NSInteger *)post_id HTTMethod:(NSString *)method {
    [self.json_handler changeWatchStatus:post_id action:@"watch" HTTPMethod:method];
}

- (void) ignorePost:(NSInteger *)post_id HTTMethod:(NSString *)method {
    [self.json_handler changeWatchStatus:post_id action:@"ignore" HTTPMethod:method];
}

- (void) getUserInfo:(NSInteger *) user_id includeAuthToken:(BOOL)include_token {
    [self.json_handler getUserInformation:user_id includeAuthToken:include_token];
}


#pragma mark - JSON Callbacks
-(void) getTenMostRecentPostsCallback:tenMostRecentPosts {
    //self.feed = tenMostRecentPosts;
    [self fillFeedWithTenMostRecentPosts:tenMostRecentPosts];
    //NSLog(@"Ten most recent posts sent back to DataHandler.m");
    [self.delegate feedUpdatedCallback:self];
}

- (void) getPopularPostsCallback:(NSArray *)posts {
    [self fillFeedWithPopularPosts:posts];
    [self.delegate popularFeedUpdatedCallback:self];
    NSLog(@"Popular Posts were updated");
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

-(void) changeWatchStatusCallback:(BOOL)success action:(NSString *)action {
    if ([action isEqualToString:@"watch"]) {
        [self.delegate watchPostCallback:success];
    } else if ([action isEqualToString:@"ignore"]) {
        [self.delegate ignorePostCallbackL:success];
    }
}

-(void) getUserInformationCallback:(NSDictionary *)userInformation {
    //NSLog(
    [self.delegate getUserInformationCallback:userInformation];
}



@end
