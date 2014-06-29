//
//  JsonHandler.m
//  Reveal
//
//  Created by Akansel Cosgun on 6/18/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//

#define LOGIN_URL @"http://reveal-api.herokuapp.com/users/login"
#define USERS_URL @"http://reveal-api.herokuapp.com/users"
#define POSTS_URL @"http://reveal-api.herokuapp.com/posts"
#define TEN_RECENT_POSTS_URL @"http://reveal-api.herokuapp.com/posts/index"

#import "JsonHandler.h"

@implementation JsonHandler

@synthesize delegate;

-(id)init {
    
    self = [super init];
    
    return self;
    
}

-(void) sendJsonRequest:(NSDictionary*)user_data user_url:(NSURL*)url user_urlrequest:(NSMutableURLRequest*)request;
{
    NSLog(@"request received");    
    [self.delegate jsonResponseCallback:self];
}

-(void)jsonResponseCallback:(JsonHandler *)jsonClass {
    NSLog(@"Hiya!");
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
        NSLog(@"Sent POST Request");
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

- (void) createPostRequestWithContent:(NSString *)body isRevealed:(BOOL)isRevealed {
    //{"post":{"user_id":1,"revealed":true, "content":"add some cuel votes", "latitude":12.13, "longitude": 123.41}}
    NSLog(@"createPostRequestWithContent");
    NSLog(@"body: %@",body);
    NSNumber *isRevealedBOOL = [NSNumber numberWithBool:isRevealed];
    //NSNumber *latitude = [NSNumber numberWithFloat:5.2f];
    //NSNumber *longitude = [NSNumber numberWithFloat:10.11f];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *auth_token =[defaults stringForKey:@"auth_token"];
    NSString *user_id = [defaults objectForKey:@"user_id"];
    /*
    NSDictionary *user_data = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSDictionary dictionaryWithObjectsAndKeys:
                                username, @"username",
                                password, @"password",
                                nil],
                               @"user", nil];
     */
    //NSLog(@"contents of defaults in createPostRequestWithContent");
    NSLog(@"username: %@ | user_id: %@", [defaults objectForKey:@"username"], [defaults objectForKey:@"user_id"]);
    NSDictionary *post_data = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSDictionary dictionaryWithObjectsAndKeys:
                                user_id, @"user_id",
                                isRevealedBOOL, @"revealed",
                                body, @"content",
                                nil],
                               @"post",
                               nil];
    NSLog(@"post_data dictionary: %@", post_data);
    
    NSMutableURLRequest *request = [self createJSONMutableURLRequest:POSTS_URL method:@"POST" userData:post_data];
    
    NSString *authen_str = [NSString stringWithFormat:@"Token token=%@", auth_token];
    NSLog(@"authen_str: %@",authen_str);
    [request addValue:authen_str forHTTPHeaderField:@"Authorization"];
    
    
    NSURLSession *session = [self createDefaultNSURLSession];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"Sent POST Request from createPostRequestWithContent");
        if (!error)
        {
            NSLog(@"there was no error");
            NSDictionary *in_json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSNumber *success = [in_json objectForKey:@"success"];
            NSLog(@"success: %@",success);
            if([success boolValue] == YES)
            {
                [self.delegate createPostRequestCallback:true];
            }
            else
            {
                NSLog(@"data in_json dictionary: %@", in_json);
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
    
    NSURLSessionDataTask *getDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"Sent GET Request from createPostRequestWithContent:isRevealed");
        if (!error)
        {
            NSLog(@"there was no error");
            //Must create dictionary of posts containing dictionary of JSON data so that it can be easily converted to an array
            NSDictionary *in_json = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSJSONSerialization JSONObjectWithData:data options:0 error:nil], @"posts", nil];
            NSLog(@"data in_json dictionary: %@", in_json);
            
            NSArray *tenMostRecentPosts = [in_json objectForKey:@"posts"];
            NSLog(@"tenMostRecentPosts Array: %@", tenMostRecentPosts);
            
            [self.delegate getTenMostRecentPostsCallback:tenMostRecentPosts];
        }
    }];
    [getDataTask resume];
    
}

- (NSUserDefaults *)setDefaults:(NSUserDefaults *)defaults jsonData:(NSDictionary *)in_json {
    NSString *auth_token = [in_json objectForKey:@"auth_token"];
    NSString *user_id = [in_json objectForKey:@"id"];
    NSString *username = [in_json objectForKey:@"username"];
    
    [defaults setObject:auth_token forKey:@"auth_token"];
    [defaults setObject:user_id forKey:@"user_id"];
    [defaults setObject:username forKey:@"username"];
    
    NSLog(@"(setDefaults) username: %@", [defaults objectForKey:@"username"]);
    NSLog(@"(setDefaults) user_id: %@", [defaults objectForKey:@"user_id"]);
    NSLog(@"(setDefaults) auth_token: %@", [defaults objectForKey:@"auth_token"]);
    
    return defaults;
}

@end
