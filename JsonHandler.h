//
//  JsonHandler.h
//  Reveal
//
//  Created by Akansel Cosgun on 6/18/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

// declare our class
@class JsonHandler;

// define the protocol for the delegate
@protocol JsonHandlerDelegate

// define protocol functions that can be used in any class using this delegate
-(void)jsonResponseCallback:(JsonHandler *)jsonClass;

@end




@interface JsonHandler : NSObject

@property (nonatomic, assign) id  delegate;

-(void)sendJsonRequest:(NSDictionary*) user_data user_url:(NSURL*)url user_urlrequest:(NSMutableURLRequest*)request;
//[json_handler sendJsonRequest:user_data user_url:url user_urlrequest:request];
//- (BOOL) initNetworkCommunication:(NSString*) ip port:(int) p;

@end