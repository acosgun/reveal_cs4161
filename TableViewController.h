//
//  TableViewController.h
//  Reveal
//
//  Created by Akansel Cosgun on 6/14/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataHandler.h"

@class RevealPost;

@interface TableViewController : UITableViewController <DataHandlerDelegate>

@property (nonatomic, strong) NSMutableArray *feed; // default feed for most recent posts
@property (nonatomic, strong) NSMutableArray *popularFeed;
@property (nonatomic, strong) NSMutableArray *nearbyFeed;
@property (nonatomic, strong) NSMutableArray *followedFeed;
@property (nonatomic, strong) NSMutableArray *displayedFeed;

@property (nonatomic, assign) NSInteger popularFeedPageNumber;

@property (nonatomic,strong) UIRefreshControl *refreshControl;
@end
