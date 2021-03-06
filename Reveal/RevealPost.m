//
//  RevealPost.m
//  Reveal
//
//  Created by Alexander Stephen Miller on 6/15/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//

#import "RevealPost.h"

@class UIImage;

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
        self.current_user_vote = nil;
        self.thumbnailData = nil;
        self.follower_item_type = nil;
        self.vote_id = nil;
    }
    return self;
}

+ (id) postWithIDNumber:(NSNumber *)IDNumber {
    return [[self alloc] initWithIDNumber:IDNumber];
}

- (NSURL *) thumbnailURL {
    return [NSURL URLWithString:self.thumbnail];
}

- (UIImage *)imageForThumbnail:(NSString *)thumbnail {
    self.thumbnail = thumbnail;
    NSData *imageData = [NSData dataWithContentsOfURL:self.thumbnailURL];
    UIImage *image = [UIImage imageWithData:imageData];
    
    return image;
}

- (void) setThumbnailDataFromImage:(UIImage *)image {
    // example: entry.imageData = UIImageJPEGRepresentation(self.pickedImage, 0.75);
    self.thumbnailData = UIImageJPEGRepresentation(image, 0.75);
}


@end
