//
//  SignupViewController.h
//  Reveal
//
//  Created by Akansel Cosgun on 6/17/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JsonHandler.h"

@interface SignupViewController : UIViewController <UITextFieldDelegate, NSURLSessionTaskDelegate, JsonHandlerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *rePasswordField;
@property (strong, nonatomic) JsonHandler* json_handler;
- (IBAction)signupButtonAction:(id)sender;

@end
