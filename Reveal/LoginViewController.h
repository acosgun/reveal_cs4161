//
//  LoginViewController.h
//  Reveal
//
//  Created by Akansel Cosgun on 6/17/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate,NSURLSessionTaskDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)loginButtonAction:(id)sender;

@end
