//
//  LoginViewController.m
//  Reveal
//
//  Created by Akansel Cosgun on 6/17/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
    
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

- (IBAction)loginButtonAction:(id)sender {
    
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if([username length] == 0 || [password length] == 0)
    {
        UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Make sure you enter a username and password!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        NSLog(@"TODO: Login HTTP request will be made to server");
    }
    
    
}
@end
