//
//  RevealPost.m
//  Reveal
//
//  Created by Alexander Stephen Miller on 6/15/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//

#import "RevealPost.h"

@implementation RevealPost


- (id) initWithIDNumber:(NSNumber *)IDNumber {
    self = [super init];
    
    if (self) {
        self.IDNumber = IDNumber;
        self.userName = nil;
        self.thumbnail = nil;
        self.votes = nil;
        self.body = nil;
        self.userName = nil;
        self.revealed = false;
    }
    return self;
}

+ (id) postWithIDNumber:(NSNumber *)IDNumber {
    return [[self alloc] initWithIDNumber:IDNumber];
}

- (NSURL *) thumbnailURL {
    return [NSURL URLWithString:self.thumbnail];
}

@end
