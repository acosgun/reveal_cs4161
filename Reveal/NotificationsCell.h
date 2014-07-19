//
//  NotificationsCell.h
//  Reveal
//
//  Created by Alexander Stephen Miller on 7/18/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RevealPost;

@interface NotificationsCell : UITableViewCell

@property (nonatomic, assign) BOOL postWasViewed;


+ (CGFloat)heightForPost:(RevealPost *)post;

- (void) configureCellForPost:(RevealPost *)post;

@end
