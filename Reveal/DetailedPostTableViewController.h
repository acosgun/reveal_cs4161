//
//  DetailedPostTableViewController.h
//  Reveal
//
//  Created by Alexander Stephen Miller on 6/28/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JsonHandler.h"
#import "DataHandler.h"

@class RevealPost;

@interface DetailedPostTableViewController : UITableViewController <JsonHandlerDelegate, DataHandlerDelegate, UIActionSheetDelegate>

@property(strong, nonatomic) RevealPost *post;
@property (strong, nonatomic) JsonHandler *json_handler;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;

- (IBAction)deleteButtonPressed:(id)sender;
- (IBAction)facebookButtonPressed:(id)sender;

- (IBAction)twitterButtonPressed:(id)sender;

@end
