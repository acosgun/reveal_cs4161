//
//  RevealPost.h
//  Reveal
//
//  Created by Alexander Stephen Miller on 6/15/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RevealPost : NSObject

@property (strong, nonatomic) NSNumber *IDNumber;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSNumber *userID;
@property (strong, nonatomic) NSString *body;
@property (strong, nonatomic) NSNumber *votes;
@property (nonatomic, assign, getter=isRevealed) BOOL revealed;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSString *thumbnail;
//@property (strong, nonatomic) NSTimeInterval *elapsedTime;


- (id) initWithIDNumber:(NSNumber *)IDNumber;
+ (id) postWithIDNumber:(NSNumber *)IDNumber;
- (NSURL *) thumbnailURL;
- (UIImage *)imageForThumbnail:(NSString *)thumbnail;

@end
