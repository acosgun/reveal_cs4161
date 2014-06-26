//
//  LoginViewController.h
//  Reveal
//
//  Created by Akansel Cosgun on 6/17/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JsonHandler.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate,NSURLSessionTaskDelegate, JsonHandlerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) JsonHandler* json_handler;
- (IBAction)loginButtonAction:(id)sender;

@end
