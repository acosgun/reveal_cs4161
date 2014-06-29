//
//  DetailedPostTableViewController.h
//  Reveal
//
//  Created by Alexander Stephen Miller on 6/28/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RevealPost;

@interface DetailedPostTableViewController : UITableViewController

@property(strong, nonatomic) RevealPost *post;

@end
