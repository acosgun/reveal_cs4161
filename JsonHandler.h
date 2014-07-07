//
//  JsonHandler.h
//  Reveal
//
//  Created by Akansel Cosgun on 6/18/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RevealPost;

// declare our class
@class JsonHandler;

// define the protocol for the delegate
@protocol JsonHandlerDelegate

// define protocol functions that can be used in any class using this delegate

@required

@optional
-(void)jsonResponseCallback:(JsonHandler *)jsonClass;

-(void) makeLoginRequestCallback:(BOOL)success;
-(void) makeSignupRequestCallback:(BOOL)success;
-(void) createPostRequestCallback:(BOOL)success;
-(void) getTenMostRecentPostsCallback:(NSArray *)tenMostRecentPosts;
-(void) getUserPostsCallBack:(NSArray *)userPosts;
-(void) createSharePostCallback:(BOOL)success;
-(void) revealStatusCallback:(BOOL)success action:(NSInteger)action_id;
-(void) getUserInformationCallback:(NSDictionary *)userInformation;
-(void) changeWatchStatusCallback:(BOOL)success action:(NSString *)action;
-(void) followUnfollowConfirmCallback:(BOOL)follow success:(BOOL)success;


@end





@interface JsonHandler : NSObject <NSURLSessionDelegate>

@property (nonatomic, assign) id<JsonHandlerDelegate>  delegate;


-(void) changeRevealStatus:(NSInteger*)post_id action:(NSInteger*)action_id;
-(void)sendJsonRequest:(NSDictionary*) user_data user_url:(NSURL*)url user_urlrequest:(NSMutableURLRequest*)request;
- (void) makeLoginRequest:(NSString*)username pass:(NSString*)password;
- (void) makeSignupRequest:(NSString*)username pass:(NSString*)password;
- (void) createPostRequestWithContent:(NSString *)body isRevealed:(BOOL)isRevealed;
-(void) getTenMostRecentPosts;
- (void) getUserPosts:(RevealPost *)revealPost;
- (void) createSharePost:(RevealPost *)revealPost;
- (void) getUserInformation:(NSInteger *)userIDNumber includeAuthToken:(BOOL)include_token;
- (void) updateUserProfileImage:(NSDictionary *)userInformation;
- (void) changeWatchStatus:(NSInteger *)post_id action:(NSString *)action HTTPMethod:(NSString *)method;
- (void) followUnfollowUser:(BOOL)follow userID:(NSInteger*)user_id followedUserID:(NSInteger*)followed_user_id;



@end