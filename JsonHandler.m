//
//  JsonHandler.m
//  Reveal
//
//  Created by Akansel Cosgun on 6/18/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//

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
    [delegate jsonResponseCallback:self];
}

-(void)jsonResponseCallback:(JsonHandler *)jsonClass {
    NSLog(@"Hiya!");
}

@end
