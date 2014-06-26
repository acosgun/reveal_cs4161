//
//  JsonHandler.m
//  Reveal
//
//  Created by Akansel Cosgun on 6/18/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//

#define LOGIN_URL @"http://reveal-api.herokuapp.com/users/login"
#define USERS_URL @"http://reveal-api.herokuapp.com/users"

#import "JsonHandler.h"

@implementation JsonHandler

@synthesize delegate;

-(id)init {
    
    self = [super init];
    
    return self;
    
}

-(void) sendJsonRequest:(NSDictionary*) user_data user_url:(NSURL*)url user_urlrequest:(NSMutableURLRequest*)request;
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
    
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:user_data options:0 error:&error];
    [request setHTTPBody:postData];
    
    
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
                NSString *auth_token = [in_json objectForKey:@"auth_token"];
                NSLog(@"auth_token: %@",auth_token);
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSLog(@"defaults contents: %@", defaults);
                [defaults setObject:auth_token forKey:@"auth_token"];
                
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
    
    
    
    NSMutableURLRequest *request = [self createJSONMutableURLRequest:LOGIN_URL method:@"POST" userData:user_data];
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
                NSString *auth_token = [in_json objectForKey:@"auth_token"];
                NSString *userID = [in_json objectForKey:@"id"];
                NSLog(@"auth_token: %@",auth_token);
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                
                [defaults setObject:auth_token forKey:@"auth_token"];
                [defaults setObject:userID forKey:@"userID"];
                [defaults setObject:username forKey:@"userName"];
                
                NSLog(@"user ID: %@", [defaults objectForKey:@"userID"]);

                
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

@end
