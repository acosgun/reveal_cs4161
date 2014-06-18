//
//  MeFeedTableViewController.h
//  Reveal
//
//  Created by Alexander Stephen Miller on 6/16/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RevealPost;

@interface MeFeedTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *feed;
@property (nonatomic, strong) NSMutableArray *hiddenFeed;
@property (nonatomic, strong) NSMutableArray *publicFeed;
@property (nonatomic, strong) NSMutableArray *displayedData;
@property (nonatomic, strong) NSMutableArray *titles; //default, will delete later
@property (nonatomic, strong) RevealPost *revealPost;

- (NSURL *) thumbnailURL;
- (IBAction)logoutButtonPressed:(id)sender;

@end
