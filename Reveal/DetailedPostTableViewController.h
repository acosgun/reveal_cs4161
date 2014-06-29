//
//  DetailedPostTableViewController.h
//  Reveal
//
//  Created by Alexander Stephen Miller on 6/28/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JsonHandler.h"

@class RevealPost;

@interface DetailedPostTableViewController : UITableViewController <JsonHandlerDelegate>

@property(strong, nonatomic) RevealPost *post;
@property (strong, nonatomic) JsonHandler *json_handler;

@end
