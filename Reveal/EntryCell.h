//
//  EntryCell.h
//  Reveal
//
//  Created by Alexander Stephen Miller on 6/15/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RevealPost;

@interface EntryCell : UITableViewCell

+ (CGFloat)heightForPost:(RevealPost *)revealPost;

- (void) configureCellForPost:(RevealPost *)revealPost;

@end
