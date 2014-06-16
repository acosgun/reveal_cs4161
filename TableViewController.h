//
//  TableViewController.h
//  Reveal
//
//  Created by Akansel Cosgun on 6/14/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RevealPost;

@interface TableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *feed;
@property (nonatomic, strong) NSMutableArray *titles; //default, will delete later
@property (nonatomic, strong) RevealPost *revealPost;

@end
