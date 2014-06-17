//
//  SignupViewController.m
//  Reveal
//
//  Created by Akansel Cosgun on 6/17/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//

#import "SignupViewController.h"

@interface SignupViewController ()

@end

@implementation SignupViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
    self.rePasswordField.delegate = self;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //NSLog(@"textFieldShouldReturn");
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)signupButtonAction:(id)sender {
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *repassword = [self.rePasswordField.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if([username length] == 0 || [password length] == 0 || [repassword length] == 0)
    {
        UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Make sure you enter a username, password and re-enter password!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else if(![password isEqualToString: repassword])
    {
        UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Passwords don't match!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
    NSLog(@"TODO: Signup HTTP request will be made to server");
    }
}
@end
