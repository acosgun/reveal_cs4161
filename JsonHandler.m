//
//  JsonHandler.m
//  Reveal
//
//  Created by Akansel Cosgun on 6/18/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//

#define LOGIN_URL            @"http://reveal-api.herokuapp.com/users/login"
#define USERS_URL            @"http://reveal-api.herokuapp.com/users/"
#define POSTS_URL            @"http://reveal-api.herokuapp.com/posts"
#define TEN_RECENT_POSTS_URL @"http://reveal-api.herokuapp.com/posts/index"
#define POPULAR_POSTS_URL    @"http://reveal-api.herokuapp.com/posts/index_popular"
#define NEARBY_POSTS_URL     @"http://reveal-api.herokuapp.com/posts/index_by_location?"
#define USER_POSTS           @"http://reveal-api.herokuapp.com/posts/index_for_user/"
#define SHARES_URL           @"http://reveal-api.herokuapp.com/shares"
#define REVEAL_URL           @"http://reveal-api.herokuapp.com/posts/reveal"
#define HIDE_URL             @"http://reveal-api.herokuapp.com/posts/hide"
#define WATCH_URL            @"http://reveal-api.herokuapp.com/votes/"
#define FOLLOWER_URL         @"http://reveal-api.herokuapp.com/followers/"

#import "JsonHandler.h"
#import "RevealPost.h"

@implementation JsonHandler

@synthesize delegate;

-(id)init {
    
    self = [super init];
    
    return self;
    
}

#pragma mark - JSON Initializers

-(void) sendJsonRequest:(NSDictionary*)user_data user_url:(NSURL*)url user_urlrequest:(NSMutableURLRequest*)request;
{
    NSLog(@"request received");    
    [self.delegate jsonResponseCallback:self];
}




-(NSMutableURLRequest*) createJSONMutableURLRequest:(NSString*) url_str method:(NSString*) method_str userData:(NSDictionary*) user_data
{
    NSURL *url = [NSURL URLWithString:url_str];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    
    
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:method_str];
    
    if (user_data != nil) {
        NSError *error;
        NSData *postData = [NSJSONSerialization dataWithJSONObject:user_data options:0 error:&error];
        [request setHTTPBody:postData];
    }
    
    
    return request;
}

-(NSURLSession*) createDefaultNSURLSession
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    return [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
}



# pragma mark - Server Requests

-(void) makeSignupRequest:(NSString*)username pass:(NSString*)password
{
    NSDictionary *user_data = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSDictionary dictionaryWithObjectsAndKeys:
                                username, @"username",
                                password, @"password",
                                nil],
                               @"user", nil];
    

    NSMutableURLRequest *request = [self createJSONMutableURLRequest:USERS_URL method:@"POST" userData:user_data];
    NSURLSession *session = [self createDefaultNSURLSession];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //NSLog(@"Sent POST Request");
        if (!error)
        {
            //NSLog(@"Status code: %i", ((NSHTTPURLResponse *)response).statusCode);
            NSDictionary *in_json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSNumber *success = [in_json objectForKey:@"success"];
            NSLog(@"success: %@",success);
            if([success boolValue] == YES)
            {
                /*
                NSString *auth_token = [in_json objectForKey:@"auth_token"];
                NSLog(@"auth_token: %@",auth_token);
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSLog(@"defaults contents: %@", defaults);
                [defaults setObject:auth_token forKey:@"auth_token"];
                [defaults setObject:userID forKey:@"userID"];
                [defaults setObject:username forKey:@"userName"];
                 */
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                defaults = [self setDefaults:defaults jsonData:in_json];
                
                
                [self.delegate makeSignupRequestCallback:true];
            }
            else
            {
                [self.delegate makeSignupRequestCallback:false];
            }
        }
        else
        {
            
            NSLog(@"Error: %@", error.localizedDescription);
            [self.delegate makeSignupRequestCallback:false];
        }
    }];
    [postDataTask resume];
}

-(void) makeLoginRequest:(NSString*)username pass:(NSString*)password
{
    NSLog(@"makeLoginRequest");
    
    NSDictionary *user_data = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSDictionary dictionaryWithObjectsAndKeys:
                                username, @"username",
                                password, @"password",
                                nil],
                               @"user", nil];
    NSLog(@"login: user_data: %@", user_data);
    
    NSMutableURLRequest *request = [self createJSONMutableURLRequest:LOGIN_URL method:@"POST" userData:user_data];
    NSURLSession *session = [self createDefaultNSURLSession];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"Sent POST Request");
        if (!error)
        {
            //NSLog(@"Status code: %i", ((NSHTTPURLResponse *)response).statusCode);
            NSDictionary *in_json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"login: in_json: %@", in_json);
            NSNumber *success = [in_json objectForKey:@"success"];
            NSLog(@"success: %@",success);
            if([success boolValue] == YES)
            {
                // can setDefaults method be implemented to do this work?
                /*
                NSString *auth_token = [in_json objectForKey:@"auth_token"];
                NSString *userID = [in_json objectForKey:@"id"];
                NSLog(@"auth_token: %@",auth_token);
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                
                [defaults setObject:auth_token forKey:@"auth_token"];
                [defaults setObject:userID forKey:@"userID"];
                [defaults setObject:username forKey:@"userName"];
                 */
                // end of setDefaults method
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                defaults = [self setDefaults:defaults jsonData:in_json];
                
                NSLog(@"user ID (test): %@", [defaults objectForKey:@"user_id"]);

                
                [self.delegate makeLoginRequestCallback:true];
            }
            else
            {
                [self.delegate makeLoginRequestCallback:false];
            }
        }
        else
        {
            [self.delegate makeLoginRequestCallback:false];
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
    [postDataTask resume];
}

- (void) createPostRequestWithContent:(NSString *)body isRevealed:(BOOL)isRevealed locationEnabled:(BOOL)location_enabled lat:(CLLocationDegrees)lat lon:(CLLocationDegrees)lon {
    NSLog(@"createPostRequestWithContent");
    NSNumber *isRevealedBOOL = [NSNumber numberWithBool:isRevealed];
    
    
    CLLocationDegrees latitute = 0.0;
    CLLocationDegrees longitude = 0.0;
    if(location_enabled)
    {
        latitute = lat;
        longitude = lon;
    }
    
    //NSNumber *latitude = [NSNumber numberWithFloat:5.2f];
    //NSNumber *longitude = [NSNumber numberWithFloat:10.11f];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *auth_token =[defaults stringForKey:@"auth_token"];
    NSString *user_id = [defaults objectForKey:@"user_id"];
    
    //NSLog(@"username: %@ | user_id: %@", [defaults objectForKey:@"username"], [defaults objectForKey:@"user_id"]);

    NSMutableURLRequest *request;
    
    if(location_enabled)
    {
        
        NSNumber *lat_number = [NSNumber numberWithDouble:lat];
        NSNumber *lon_number = [NSNumber numberWithDouble:lon];
        
        //NSLog(@"sending location_enabled");
        NSLog(@"latitude: %4.2f, longitude: %4.2f",[lat_number doubleValue],[lon_number doubleValue]);
    NSDictionary *post_data = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSDictionary dictionaryWithObjectsAndKeys:
                                user_id, @"user_id",
                                isRevealedBOOL, @"revealed",
                                body, @"content",
                                lat_number, @"latitude",
                                lon_number, @"longitude",
                                nil],
                               @"post",
                               nil];
    request = [self createJSONMutableURLRequest:POSTS_URL method:@"POST" userData:post_data];
        
    }
    else
    {
        NSLog(@"sending NOT location_enabled");
        NSDictionary *post_data = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSDictionary dictionaryWithObjectsAndKeys:
                                    user_id, @"user_id",
                                    isRevealedBOOL, @"revealed",
                                    body, @"content",
                                    nil],
                                   @"post",
                                   nil];
        
        request = [self createJSONMutableURLRequest:POSTS_URL method:@"POST" userData:post_data];
    }
    
    NSString *authen_str = [NSString stringWithFormat:@"Token token=%@", auth_token];
    [request addValue:authen_str forHTTPHeaderField:@"Authorization"];
    
    
    NSURLSession *session = [self createDefaultNSURLSession];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"Sent POST Request from createPostRequestWithContent:isRevealed");
        if (!error)
        {
            NSLog(@"there was no error");
            NSDictionary *in_json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSNumber *success = [in_json objectForKey:@"success"];
            NSLog(@"success: %@",success);
            if([success boolValue] == YES)
            {
                NSLog(@"create post data in_json dictionary: %@", in_json);
                [self.delegate createPostRequestCallback:true];
            }
            else
            {
                //NSLog(@"data in_json dictionary: %@", in_json);
                [self.delegate createPostRequestCallback:false];
            }
        }
        else
        {
            [self.delegate createPostRequestCallback:FALSE];
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
    [postDataTask resume];
}


-(void) getTenMostRecentPosts {

    NSMutableURLRequest *request = [self createJSONMutableURLRequest:TEN_RECENT_POSTS_URL method:@"GET" userData:nil];
    NSURLSession *session = [self createDefaultNSURLSession];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *auth_token = [defaults objectForKey:@"auth_token"];
    NSString *authen_str = [NSString stringWithFormat:@"Token token=%@", auth_token];
    [request addValue:authen_str forHTTPHeaderField:@"Authorization"];

    
    
    NSURLSessionDataTask *getDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //NSLog(@"Sent GET Request from getTenMostRecentPosts");
        if (!error)
        {
            //NSLog(@"there was no error");
            //Must create dictionary of posts containing dictionary of JSON data so that it can be easily converted to an array
            NSDictionary *in_json = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSJSONSerialization JSONObjectWithData:data options:0 error:nil], @"posts", nil];
            //NSLog(@"data in_json dictionary: %@", in_json);
            
            NSArray *tenMostRecentPosts = [in_json objectForKey:@"posts"];
            //NSLog(@"tenMostRecentPosts Array: %@", tenMostRecentPosts);
            
            [self.delegate getTenMostRecentPostsCallback:tenMostRecentPosts];
        }
        else
        {
            NSArray *tenMostRecentPosts = [[NSArray alloc] init];
            [self.delegate getTenMostRecentPostsCallback:tenMostRecentPosts];
        }
    }];
    [getDataTask resume];
    
}

- (void) getPopularPosts {
    NSMutableURLRequest *request = [self createJSONMutableURLRequest:POPULAR_POSTS_URL method:@"GET" userData:nil];
    NSURLSession *session = [self createDefaultNSURLSession];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *auth_token = [defaults objectForKey:@"auth_token"];
    NSString *authen_str = [NSString stringWithFormat:@"Token token=%@", auth_token];
    [request addValue:authen_str forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionDataTask *getDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //NSLog(@"Sent GET Request from getTenMostRecentPosts");
        if (!error)
        {
            //NSLog(@"there was no error");
            //Must create dictionary of posts containing dictionary of JSON data so that it can be easily converted to an array
            NSDictionary *in_json = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSJSONSerialization JSONObjectWithData:data options:0 error:nil], @"posts", nil];
            //NSLog(@"data in_json dictionary: %@", in_json);
            
            NSArray *popularPosts = [in_json objectForKey:@"posts"];
            //NSLog(@"tenMostRecentPosts Array: %@", tenMostRecentPosts);
            
            [self.delegate getPopularPostsCallback:popularPosts];
        }
        else
        {
            NSLog(@"ERROR with getPopularPosts");
        }
    }];
    [getDataTask resume];
}

- (void) getNearbyPosts:(CLLocationDegrees)lat lon:(CLLocationDegrees)lon {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSNumber *lat_number = [NSNumber numberWithDouble:lat];
    NSNumber *lon_number = [NSNumber numberWithDouble:lon];
    /// example call: posts/index_by_location?latitude=12.1&longitude=-13.3
    NSMutableString *url = [NSMutableString stringWithFormat:@"%@latitude=%@&longitude=%@&radius=%@", NEARBY_POSTS_URL, lat_number, lon_number, [defaults objectForKey:@"location_radius"]];
    NSLog(@"nearby posts URL: %@", url);
    
    NSMutableURLRequest *request = [self createJSONMutableURLRequest:url method:@"GET" userData:nil];
    NSURLSession *session = [self createDefaultNSURLSession];
    
    NSString *auth_token = [defaults objectForKey:@"auth_token"];
    NSString *authen_str = [NSString stringWithFormat:@"Token token=%@", auth_token];
    [request addValue:authen_str forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionDataTask *getDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //NSLog(@"Sent GET Request from getTenMostRecentPosts");
        if (!error)
        {
            NSLog(@"no error in getNearbyPosts in jsonhandler");
            NSDictionary *in_json = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSJSONSerialization JSONObjectWithData:data options:0 error:nil], @"posts", nil];
            NSLog(@"data in_json dictionary for nearyPosts: %@", in_json);
            
            NSArray *nearbyPosts = [in_json objectForKey:@"posts"];
            //NSLog(@"tenMostRecentPosts Array: %@", tenMostRecentPosts);
            
            [self.delegate getNearbyPostsCallback:nearbyPosts];
        }
        else
        {
            NSLog(@"ERROR with getNearbyPosts in jsonhandler");
        }
    }];
    [getDataTask resume];
}


- (void) getUserPosts:(RevealPost *)revealPost {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *auth_token =[defaults stringForKey:@"auth_token"];
    
    NSMutableString *urlString = [NSMutableString stringWithString:USER_POSTS];
    
    if (revealPost) {
        [urlString appendString:[revealPost.userID stringValue]];
    } else {
        [urlString appendString:[[defaults objectForKey:@"user_id"] stringValue]];
    }
    //NSLog(@"URL for getUserPosts: %@", urlString);
    NSMutableURLRequest *request = [self createJSONMutableURLRequest:urlString method:@"GET" userData:nil];
    
    NSString *authen_str = [NSString stringWithFormat:@"Token token=%@", auth_token];
    //NSLog(@"authen_str: %@",authen_str);
    [request addValue:authen_str forHTTPHeaderField:@"Authorization"];
    
    NSURLSession *session = [self createDefaultNSURLSession];
    
    NSURLSessionDataTask *getDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //NSLog(@"Sent GET Request from getUserPosts");
        if (!error)
        {
            //NSLog(@"there was no error");
            //Must create dictionary of posts containing dictionary of JSON data so that it can be easily converted to an array
            NSDictionary *in_json = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSJSONSerialization JSONObjectWithData:data options:0 error:nil], @"posts", nil];
            //NSLog(@"data in_json dictionary: %@", in_json);
            
            NSArray *userPosts = [in_json objectForKey:@"posts"];
            //NSLog(@"userPosts Array: %@", userPosts);
            
            [self.delegate getUserPostsCallBack:userPosts];
        }
    }];
    [getDataTask resume];
}

- (void) createSharePost:(RevealPost *)revealPost {
    
    //{"share":{"post_id":1,"user_id":1}}
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *auth_token =[defaults stringForKey:@"auth_token"];
    
    NSDictionary *share_data = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSDictionary dictionaryWithObjectsAndKeys:
                                revealPost.IDNumber, @"post_id",
                                [revealPost.userID stringValue], @"user_id",
                                nil],
                               @"share",
                               nil];
    NSLog(@"share_data dictionary: %@", share_data);
    
    NSMutableURLRequest *request = [self createJSONMutableURLRequest:SHARES_URL method:@"POST" userData:share_data];
    NSURLSession *session = [self createDefaultNSURLSession];
    
    
    NSString *authen_str = [NSString stringWithFormat:@"Token token=%@", auth_token];
    //NSLog(@"authen_str: %@",authen_str);
    [request addValue:authen_str forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionDataTask *shareTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //NSLog(@"createSharePost: Sent POST Request");
        if (!error)
        {
            //NSLog(@"there was no error");
            
            NSDictionary *in_json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"data in_json dictionary: %@", in_json);
            
            NSNumber *success = [in_json objectForKey:@"success"];
            NSLog(@"success?: %@", success);
            
            [self.delegate createSharePostCallback:[success boolValue]];
        }
    }];
    [shareTask resume];
}

-(void) changeRevealStatus:(NSInteger*)post_id action:(NSInteger*) action_id
{
    NSLog(@"post_id: %d",*post_id);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *auth_token =[defaults stringForKey:@"auth_token"];
    
    NSDictionary *my_data = [[NSDictionary alloc] init];
   
    NSURLSession *session = [self createDefaultNSURLSession];
    NSMutableURLRequest *request;
    
    NSLog(@"action_id: %d",*action_id);
    NSInteger intActionId= *action_id;
    if(*action_id == 0) //REVEAL
    {
        NSString *req_url = [NSString stringWithFormat:@"%@/%d",REVEAL_URL,*post_id];
        NSLog(@"%@",req_url);
        request = [self createJSONMutableURLRequest:req_url method:@"PUT" userData:my_data];
    }
    else if (*action_id == 1) //HIDE
    {
        NSString *req_url = [NSString stringWithFormat:@"%@/%d",HIDE_URL,*post_id];
        NSLog(@"%@",req_url);
        request = [self createJSONMutableURLRequest:req_url method:@"PUT" userData:my_data];
    }
    else if (*action_id == 2) //DELETE
    {
        NSString *req_url = [NSString stringWithFormat:@"%@/%d",POSTS_URL,*post_id];
        request = [self createJSONMutableURLRequest:req_url method:@"DELETE" userData:my_data];
    }
    
    NSString *authen_str = [NSString stringWithFormat:@"Token token=%@", auth_token];
    [request addValue:authen_str forHTTPHeaderField:@"Authorization"];

    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error)
        {
            NSDictionary *in_json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"data in_json dictionary: %@", in_json);
            NSNumber *success = [in_json objectForKey:@"success"];
            [self.delegate revealStatusCallback:[success boolValue] action:intActionId];
        }
        else
        {
            NSNumber *success = 0;
            [self.delegate revealStatusCallback:[success boolValue] action:intActionId];
        }
    }];
    [task resume];
}

- (void) getUserInformation:(NSInteger *)userIDNumber includeAuthToken:(BOOL)include_token{
    NSLog(@"entered getUserInformation");
    
    NSMutableString *urlString = [NSMutableString stringWithString:USERS_URL];
    
    NSString *str_userID = [NSString stringWithFormat:@"%d",*userIDNumber];
    
    [urlString appendString:str_userID];
    NSLog(@"urlString: %@", urlString);
    
    NSMutableURLRequest *request = [self createJSONMutableURLRequest:urlString method:@"GET" userData:nil];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *auth_token = [defaults stringForKey:@"auth_token"];
    NSString *authen_str = [NSString stringWithFormat:@"Token token=%@", auth_token];
    [request addValue:authen_str forHTTPHeaderField:@"Authorization"];

    
    
    NSURLSession *session = [self createDefaultNSURLSession];
    
    NSLog(@"Just before getDataTask");
    NSURLSessionDataTask *getDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error)
        {
            NSLog(@"success in getUserInformation request");
            NSDictionary *in_json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            //NSLog(@"data in_json dictionary: %@", in_json);
            
            [self.delegate getUserInformationCallback:in_json];
        } else {
            NSLog(@"ERROR IN getUserInformation");
        }
    }];
    [getDataTask resume];
    
    NSLog(@"just before return in getUserInformation");
}

- (void) changeWatchStatus:(NSInteger *)post_id action:(NSString *)action HTTPMethod:(NSString *)method {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *auth_token = [defaults stringForKey:@"auth_token"];
    
    NSNumber *post_id_Num = [NSNumber numberWithInt:*post_id];
    
    //json call for watch: {"vote":{"post_id":1,"user_id":2, "action":"watch"}}
    NSDictionary *watch_data = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSDictionary dictionaryWithObjectsAndKeys:
                                post_id_Num, @"post_id",
                                [defaults objectForKey:@"user_id"], @"user_id",
                                action, @"action",
                                nil],
                               @"vote",
                               nil];
    NSLog(@"post_data dictionary: %@", watch_data);
    
    NSMutableString *url = [NSMutableString stringWithString:WATCH_URL];
    if ([method isEqualToString:@"PUT"]) {
        [url appendString:@"update"];
        NSLog(@"url for updates (PUT Method): %@", url);
    }
    
    NSMutableURLRequest *request = [self createJSONMutableURLRequest:url method:method userData:watch_data];
    
    
    NSString *authen_str = [NSString stringWithFormat:@"Token token=%@", auth_token];
    NSLog(@"authen_str: %@",authen_str);
    [request addValue:authen_str forHTTPHeaderField:@"Authorization"];
    
    
    NSURLSession *session = [self createDefaultNSURLSession];
    
    NSURLSessionDataTask *watchDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"Sent POST Request from changeWatchStatus:action");
        if (!error)
        {
            NSLog(@"there was no error");
            NSDictionary *in_json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSNumber *success = [in_json objectForKey:@"success"];
            NSLog(@"success: %@",success);
            if([success boolValue] == YES)
            {
                NSLog(@"data in_json (success=true): %@", in_json);
                [self.delegate changeWatchStatusCallback:true action:action];
            }
            else
            {
                NSLog(@"data in_json (success=false): %@", in_json);
                [self.delegate changeWatchStatusCallback:false action:action];
            }
        }
        else
        {
            [self.delegate changeWatchStatusCallback:false action:action];
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
    [watchDataTask resume];
}

- (void) followUnfollowUser:(BOOL)follow userID:(NSInteger*)user_id followedUserID:(NSInteger*)followed_user_id
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *auth_token = [defaults stringForKey:@"auth_token"];

    NSNumber *userID_num = [NSNumber numberWithInt:*user_id];
    NSNumber *followedUserID_num = [NSNumber numberWithInt:*followed_user_id];
    
    NSDictionary *user_data = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSDictionary dictionaryWithObjectsAndKeys:
                                userID_num, @"user_id",
                                followedUserID_num, @"followed_user_id",
                                nil],
                               @"follower", nil];

    NSMutableURLRequest *request;
    if(follow)
    {
        request =  [self createJSONMutableURLRequest:FOLLOWER_URL method:@"POST" userData:user_data];
    }
    else
    {
        request =  [self createJSONMutableURLRequest:FOLLOWER_URL method:@"DELETE" userData:user_data];
    }
    
    NSString *authen_str = [NSString stringWithFormat:@"Token token=%@", auth_token];
    [request addValue:authen_str forHTTPHeaderField:@"Authorization"];
    
    NSURLSession *session = [self createDefaultNSURLSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error)
        {
            NSLog(@"there was no error");
            NSDictionary *in_json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSNumber *success = [in_json objectForKey:@"success"];
            if([success boolValue] == YES)
            {
                NSLog(@"data in_json (success=true): %@", in_json);
                [self.delegate followUnfollowConfirmCallback:follow success:TRUE];
            }
            else
            {
                NSLog(@"data in_json (success=false): %@", in_json);
                [self.delegate followUnfollowConfirmCallback:follow success:FALSE];
            }
        }
        else
        {
            [self.delegate followUnfollowConfirmCallback:follow success:FALSE];
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
    [task resume];
    
    
}




# pragma mark - Private Methods

- (NSUserDefaults *)setDefaults:(NSUserDefaults *)defaults jsonData:(NSDictionary *)in_json {
    NSString *auth_token = [in_json objectForKey:@"auth_token"];
    NSString *user_id = [in_json objectForKey:@"id"];
    NSString *username = [in_json objectForKey:@"username"];
    
    [defaults setObject:auth_token forKey:@"auth_token"];
    [defaults setObject:user_id forKey:@"user_id"];
    [defaults setObject:username forKey:@"username"];
    [defaults setObject:@0.1 forKey:@"location_radius"];
    
    NSLog(@"(setDefaults) username: %@", [defaults objectForKey:@"username"]);
    NSLog(@"(setDefaults) user_id: %@", [defaults objectForKey:@"user_id"]);
    NSLog(@"(setDefaults) auth_token: %@", [defaults objectForKey:@"auth_token"]);
    
    return defaults;
}

- (void) updateUserProfileImage:(NSDictionary *)userInformation {
    NSLog(@"entered updateUserProfileImage");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSURL *imageURL = [NSURL URLWithString:[userInformation objectForKey:@"avatar_medium"]];
    NSData *image_data = [NSData dataWithContentsOfURL:imageURL];
    
    [defaults setObject:image_data forKey:@"avatar_data"];
}

-(void) getUserInformationCallback:(NSDictionary *)userInformation {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"userDataFromServer: %@", userInformation);///////
    NSURL *imageURL = [NSURL URLWithString:[userInformation objectForKey:@"avatar_medium"]];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
    
    [defaults setObject:image forKey:@"avatar"];
    NSLog(@"updateUserProfileImage: avatar is: %@", [defaults objectForKey:@"avatar_medium"]);
}

@end
