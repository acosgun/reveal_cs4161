//
//  UserProfileTableViewController.h
//  Reveal
//
//  Created by Alexander Stephen Miller on 7/1/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataHandler.h"

@class RevealPost;


@interface UserProfileTableViewController : UITableViewController<DataHandlerDelegate>

@property (nonatomic, strong) NSMutableArray *feed;
@property (nonatomic, strong) RevealPost *revealPost;

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end
