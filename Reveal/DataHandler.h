//
//  DataHandler.h
//  Reveal
//
//  Created by Akansel Cosgun on 6/26/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JsonHandler;

// declare our class
@class DataHandler;

// define the protocol for the delegate
@protocol DataHandlerDelegate

// define protocol functions that can be used in any class using this delegate
-(void)feedUpdatedCallback:(DataHandler *)dataHandlerClass;

@end


@interface DataHandler : NSObject

@property (nonatomic, assign) id  delegate;
@property (nonatomic, strong) NSMutableArray *nearby_feed;
@property (nonatomic, strong) JsonHandler *json_handler;

+ (DataHandler *) sharedInstance;
- (void) updateFeeds;


@end
