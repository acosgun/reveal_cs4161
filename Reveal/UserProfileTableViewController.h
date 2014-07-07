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
@property (nonatomic, assign) BOOL current_user_follows;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIButton *followers_button;
@property (weak, nonatomic) IBOutlet UIButton *following_button;
@property (weak, nonatomic) IBOutlet UIButton *follow_button;
- (IBAction)followButtonPressed:(id)sender;

@end
