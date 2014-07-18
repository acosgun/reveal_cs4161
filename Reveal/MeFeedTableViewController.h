//
//  MeFeedTableViewController.h
//  Reveal
//
//  Created by Alexander Stephen Miller on 6/16/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataHandler.h"

@class RevealPost;

@interface MeFeedTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *feed;
@property (nonatomic, strong) NSMutableArray *hiddenFeed;
@property (nonatomic, strong) NSMutableArray *publicFeed;
@property (nonatomic, strong) NSMutableArray *displayedData;
@property (nonatomic, strong) NSMutableArray *titles; //default, will delete later
@property (nonatomic, strong) RevealPost *revealPost;

@property (nonatomic, assign) BOOL current_user_follows;

@property (weak, nonatomic) IBOutlet UISegmentedControl *hiddenRevealedSelector;

@property (strong, nonatomic) UIRefreshControl *refreshControl;


- (IBAction)logoutButtonPressed:(id)sender;

@end
