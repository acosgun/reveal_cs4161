//
//  LoginViewController.m
//  Reveal
//
//  Created by Akansel Cosgun on 6/17/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//


/* BUT FOUND BY ALEX ON 6/19/14  
    During login after entering username and password, if user selects the login button before selecting
    return on the text editor (meaning it is still displayed), the performSegueToTabbar method will crash. 
 */
#import "LoginViewController.h"
#import "JsonHandler.h"


@interface LoginViewController ()


@end

@implementation LoginViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
    self.json_handler = [[JsonHandler alloc] init];
    self.json_handler.delegate = self;
    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"view did appear");
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *auth_token =[prefs stringForKey:@"auth_token"];
    if(auth_token != nil) //already logged in. Perform segue
    {
        [self updateUserProfileImage];
        NSLog(@"Logged in! TODO:Perform segue to FEED VC");
        [self performSegueToTabbar];
        
    }
    else
    {
        NSLog(@"Not logged in");
    }
}


-(void) performSegueToTabbar
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"login_tabbar" sender: self];
    });
 
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
    NSLog(@"textFieldShouldReturn");
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
        [self.json_handler makeLoginRequest:username pass:password];
        [self updateUserProfileImage];
    }
    
    
}

- (void) updateUserProfileImage {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger user_id = [[defaults objectForKey:@"user_id"] integerValue];
    [self.json_handler getUserInformation:&user_id includeAuthToken:FALSE];
}

#pragma mark - Callbacks

-(void)makeLoginRequestCallback:(BOOL) success
{
    NSLog(@"makeLoginRequestCallback");
    if(success)
    {
        
        [self performSegueToTabbar];
        NSLog(@"login  successful");
    }
    else
    {
        NSLog(@"login not successful");
        //TODO: Show login error
    }
}

-(void) getUserInformationCallback:(NSDictionary *)userInformation {
    [self.json_handler updateUserProfileImage:userInformation];
}


@end
