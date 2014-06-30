//
//  MeDetailedPostViewController.h
//  Reveal
//
//  Created by Alexander Stephen Miller on 6/16/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataHandler.h"
#import "JsonHandler.h"

@class RevealPost;

@interface MeDetailedPostViewController : UIViewController <DataHandlerDelegate, UIAlertViewDelegate, JsonHandlerDelegate>
{
    RevealPost *_revealPost;
}

@property (strong, nonatomic) RevealPost *revealPost;
@property (strong, nonatomic) JsonHandler* json_handler;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
- (IBAction)deleteButtonPressed:(id)sender;

@end
