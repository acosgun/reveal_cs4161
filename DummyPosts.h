//
//  DummyPosts.h
//  Reveal
//
//  Created by Alexander Stephen Miller on 6/15/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DummyPosts : NSObject

@property (strong, nonatomic) NSMutableArray *dummyPosts;

- (id) initWithDummyData;
+ (id) arrayWithDummyData;

@end
