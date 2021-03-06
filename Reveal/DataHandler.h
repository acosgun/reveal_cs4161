//
//  DataHandler.h
//  Reveal
//
//  Created by Akansel Cosgun on 6/26/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonHandler.h"
#import <CoreLocation/CoreLocation.h>
#import <Social/Social.h>

@class JsonHandler;

// declare our class
@class DataHandler;

// define the protocol for the delegate
@protocol DataHandlerDelegate

// define protocol functions that can be used in any class using this delegate

@optional
-(void)feedUpdatedCallback:(DataHandler *)dataHandlerClass addingPosts:(BOOL)addingPosts;
-(void)popularFeedUpdatedCallback:(DataHandler *)dataHandlerClass addingPosts:(BOOL)addingPosts;
-(void)nearbyFeedUpdatedCallback:(DataHandler *)dataHandlerClass addingPosts:(BOOL)addingPosts;
-(void)followedFeedUpdatedCallback:(DataHandler *)dataHandlerClass addingPosts:(BOOL)addingPosts;

-(void)revealStatusCallback:(BOOL)success action:(NSInteger)action_id;
-(void)watchPostCallback:(BOOL)success;
-(void)ignorePostCallback:(BOOL)success;
-(void) updateProfileImageCallback:(BOOL)success;

- (void) getNotificationsCallbackDH:(NSArray *)notifications;
- (void) viewedNewPostsCallback:(BOOL)success;

@end


@interface DataHandler : NSObject <JsonHandlerDelegate, CLLocationManagerDelegate>

@property (nonatomic, assign) id  delegate;
@property (nonatomic, strong) NSMutableArray *feed;
@property (nonatomic, strong) NSMutableArray *popularFeed;
@property (nonatomic, strong) NSMutableArray *nearby_feed;
@property (nonatomic, strong) NSMutableArray *followedFeed;
@property (nonatomic, strong) JsonHandler *json_handler;
@property (strong, nonatomic) CLLocationManager *locationManager;

+ (DataHandler *) sharedInstance;
- (void) updateFeedsWithIdentifier:(NSString *)identifier;
- (void) updateFeedsWithIdentifier:(NSString *)identifier postClass:(RevealPost *)revealPost;
- (void) getRecentPosts:(NSNumber *)lastPostID;
- (void) getPopularPosts:(NSInteger)pageNumber;
- (void) getNearbyPosts:(NSNumber *)lastPostID;
- (void) getFollowedPosts:(RevealPost *)post;

- (void) revealPost:(NSInteger *) post_id;
- (void) hidePost:(NSInteger *) post_id;
- (void) deletePost:(NSInteger *) post_id;
- (void) watchPost:(NSInteger *)post_id HTTMethod:(NSString *)method;
- (void) ignorePost:(NSInteger *)post_id HTTMethod:(NSString *)method;
- (void) getUserInfo:(NSInteger *)user_id includeAuthToken:(BOOL)include_token;
- (void) followUser:(NSInteger *)user_id followedUserID:(NSInteger *) followed_user_id;
- (void) unfollowUser:(NSInteger *)user_id followedUserID:(NSInteger *) followed_user_id;
- (void) createPostRequestWithContent:(NSString *)body isRevealed:(BOOL)isRevealed;
- (void) postToFacebook:(NSString*)content viewController:(UIViewController*)view_controller;
- (void) postToTwitter:(NSString*)content viewController:(UIViewController*)view_controller;
- (void) updateProfileImage:(NSData *)imageData;

- (void) getNotificationsDH;
- (void) viewedNewNotifications;

@end
