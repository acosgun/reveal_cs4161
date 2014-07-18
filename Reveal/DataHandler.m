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
        [self getRecentPosts:nil];
        [self getPopularPosts:0];
        [self getNearbyPosts:nil];
        
        //[self.json_handler getNearbyPosts];
        //[self.json_handler getFollowedPosts];
    }
}

- (void) getRecentPosts:(NSNumber *)lastPostID {
    [self.json_handler getTenMostRecentPosts:(NSNumber *)lastPostID];
    NSLog(@"sent HTTP request for more recent posts from datahandler");
}

- (void) getPopularPosts:(NSInteger)pageNumber {
    [self.json_handler getPopularPosts:pageNumber];
}

- (void) getNearbyPosts:(NSNumber *)lastPostID {
    [self initLocationManager];
    CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
    
    
    BOOL location_enabled = FALSE;
    if (authStatus == kCLAuthorizationStatusAuthorized)
    {
        NSLog(@"Location authorized");
        location_enabled = TRUE;
        CLLocation *location = [self.locationManager location];
        CLLocationCoordinate2D coordinate = [location coordinate];
        
        CLLocationDegrees lat = coordinate.latitude;
        CLLocationDegrees lon = coordinate.longitude;
        NSLog(@"latitude: %f    longitute: %f", lat, lon);
        //[self.json_handler createPostRequestWithContent:body isRevealed:isRevealed locationEnabled: location_enabled lat:lat lon:lon];
        [self.json_handler getNearbyPosts:lat lon:lon lastPostID:lastPostID];
    }
    else
    {
        NSLog(@"Location not authorized");
        //[self.json_handler createPostRequestWithContent:body isRevealed:isRevealed locationEnabled: location_enabled lat:0.0 lon:0.0];
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
        [self.delegate feedUpdatedCallback:self addingPosts:false];
}

- (void) createSharePost:(RevealPost *)revealPost {
    self.json_handler = [[JsonHandler alloc] init];
    self.json_handler.delegate = self;
}



- (id)init {
    if ( (self = [super init]) ) {
        // your custom initialization
        [self initialize];
        self.feed = [NSMutableArray array];
    }
    return self;
}

- (void) initialize
{
    self.nearby_feed = [NSMutableArray array];
    [self initLocationManager];
}

- (void) initLocationManager
{
    NSLog(@"initLocationManager");
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
    BOOL locationAllowed = [CLLocationManager locationServicesEnabled];
    if (locationAllowed==NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Service Disabled"
                                                        message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    
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

- (void) fillFeedWithNearbyPosts:(NSArray *)posts {
    self.nearby_feed = [[NSMutableArray alloc] init];
    self.nearby_feed = [self createPostArrayFromJSONResponse:posts];
}

- (NSMutableArray *)createPostArrayFromJSONResponse:(NSArray *)posts {
    
    NSMutableArray *postsArray = [[NSMutableArray alloc] init];
    
    int i = 0;
    for (NSDictionary *post in posts)
    {
        RevealPost *revealPost = [RevealPost postWithIDNumber:[post objectForKey:@"id"]];
        revealPost.userName = [post objectForKey:@"username"];
        revealPost.votes = [post objectForKey:@"watch_stat"];
        revealPost.downVotes = [post objectForKey:@"ignore_stat"];
        revealPost.thumbnail = [post objectForKey:@"avatar_thumb"];
        revealPost.date = [NSDate dateWithTimeIntervalSinceNow:-60*2];
        revealPost.dateString = [post objectForKey:@"created_at"];
        revealPost.body = [post objectForKey:@"content"];
        revealPost.revealed = [[post objectForKey:@"revealed"]boolValue];
        revealPost.userID = [post objectForKey:@"user_id"];
        revealPost.current_user_vote = [post objectForKey:@"current_user_vote"];
        
        /*
        if (i == 0) {
            revealPost.votes = @67;
        }
         */
        
        [postsArray addObject:revealPost];
        i = i+1;
        NSLog(@" i = %d", i);
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

- (void) followUser:(NSInteger *)user_id followedUserID:(NSInteger *) followed_user_id
{
    [self.json_handler followUnfollowUser:TRUE userID:user_id followedUserID:followed_user_id];
}

- (void) unfollowUser:(NSInteger *)user_id followedUserID:(NSInteger *) followed_user_id
{
    [self.json_handler followUnfollowUser:FALSE userID:user_id followedUserID:followed_user_id];
}
- (void) createPostRequestWithContent:(NSString *)body isRevealed:(BOOL)isRevealed
{
    CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];

    
    BOOL location_enabled = FALSE;
     if (authStatus == kCLAuthorizationStatusAuthorized)
     {
        NSLog(@"Location authorized");
         location_enabled = TRUE;
         CLLocation *location = [self.locationManager location];
         CLLocationCoordinate2D coordinate = [location coordinate];
         
         CLLocationDegrees lat = coordinate.latitude;
         CLLocationDegrees lon = coordinate.longitude;
         NSLog(@"latitude: %f    longitute: %f", lat, lon);
         [self.json_handler createPostRequestWithContent:body isRevealed:isRevealed locationEnabled: location_enabled lat:lat lon:lon];
         return;
     }
    else
    {
        NSLog(@"Location not authorized");
        [self.json_handler createPostRequestWithContent:body isRevealed:isRevealed locationEnabled: location_enabled lat:0.0 lon:0.0];
    }
    
}

#pragma mark - Location
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    //NSLog(@"didChangeAuthStatus");
    if (status == kCLAuthorizationStatusDenied)
    {
        // permission denied
        NSLog(@"Location Permission Denied");
        
    }
    else if (status == kCLAuthorizationStatusAuthorized)
    {
        // permission granted
        NSLog(@"Location Permission Granted");
    }
}

#pragma mark - Social
- (void) postToFacebook:(NSString*)content viewController:(UIViewController*)view_controller
{
    SLComposeViewController *facebookController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];;

    [facebookController setInitialText:content];
    
    //[facebookController addURL: [NSURL URLWithString:
    //@"https://itunes.apple.com/us/app/flappy-obama-vs-putin/id845630949"]];
    
    [view_controller presentViewController:facebookController animated:YES completion:nil];
    
    SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
        if (result == SLComposeViewControllerResultCancelled)
        {
            //NSLog(@"delete");
        }
        else
        {
            //NSLog(@"post");
        }
        
        [facebookController dismissViewControllerAnimated:YES completion:Nil];
    };
    facebookController.completionHandler=myBlock;
}

- (void) postToTwitter:(NSString*)content viewController:(UIViewController*)view_controller
{
SLComposeViewController *twitterController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];;
    
    
    [twitterController setInitialText:content];
        
    [view_controller presentViewController:twitterController animated:YES completion:nil];
    
    SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
        if (result == SLComposeViewControllerResultCancelled) {
            
            //NSLog(@"delete");
            
        } else
            
        {
            //NSLog(@"post");
        }
        
        [twitterController dismissViewControllerAnimated:YES completion:Nil];
    };
    twitterController.completionHandler=myBlock;
    
}


#pragma mark - JSON Callbacks
-(void) getTenMostRecentPostsCallback:(NSArray *)tenMostRecentPosts addingPosts:(BOOL)addingPosts {
    //self.feed = tenMostRecentPosts;
    [self fillFeedWithTenMostRecentPosts:tenMostRecentPosts];
    //NSLog(@"Ten most recent posts sent back to DataHandler.m");
    [self.delegate feedUpdatedCallback:self addingPosts:addingPosts];
}

- (void) getPopularPostsCallback:(NSArray *)posts addingPosts:(BOOL)addingPosts {
    [self fillFeedWithPopularPosts:posts];
    [self.delegate popularFeedUpdatedCallback:self addingPosts:addingPosts];
    NSLog(@"Popular Posts were updated");
}

- (void) getNearbyPostsCallback:(NSArray *)posts addingPosts:(BOOL)addingPosts {
    [self fillFeedWithNearbyPosts:posts];
    [self.delegate nearbyFeedUpdatedCallback:self addingPosts:addingPosts];
    NSLog(@"Nearby posts were updated");
}

-(void) getUserPostsCallBack:(NSArray *)userPosts {
    [self fillFeedWithTenMostRecentPosts:userPosts];
    //NSLog(@"User posts sent back to DataHandler.m");
    [self.delegate feedUpdatedCallback:self addingPosts:false];
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
    [self.delegate getUserInformationCallback:userInformation];
}

-(void) followUnfollowConfirmCallback:(BOOL)follow success:(BOOL)success
{
    NSLog(@"followUnfollowConfirmCallback in DataHandler.m");
    [self.delegate followUnfollowConfirmCallback:follow success:success];
}

- (void) createPostRequestCallback:(BOOL)success
{
    NSLog(@"createPostRequestCallback in DataHandler");
    [self.delegate createPostRequestCallback:success];
}





@end
