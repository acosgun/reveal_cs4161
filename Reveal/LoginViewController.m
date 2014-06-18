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


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"view did appear");
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *auth_token =[prefs stringForKey:@"auth_token"];
    if(auth_token != nil) //already logged in. Perform segue
    {
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
 [self performSegueWithIdentifier:@"login_tabbar" sender: self];
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
        NSLog(@"Login HTTP request will be made to server.. receive auth_token and save it.");
        
        NSDictionary *user_data = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSDictionary dictionaryWithObjectsAndKeys:
                                    username, @"username",
                                    password, @"password",
                                    nil],
                                   @"user", nil];
        
        NSURL *url = [NSURL URLWithString:@"http://reveal-api.herokuapp.com/users/login"];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:60.0];
        
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setHTTPMethod:@"POST"];
        
        NSError *error;
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:user_data options:0 error:&error];
        [request setHTTPBody:postData];
        NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSLog(@"Sent POST Request");
            if (!error)
            {
                //NSLog(@"Status code: %i", ((NSHTTPURLResponse *)response).statusCode);
                NSDictionary *in_json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSNumber *success = [in_json objectForKey:@"success"];
                //NSLog(@"success: %@",success);
                if(success)
                {
                    NSString *auth_token = [in_json objectForKey:@"auth_token"];
                    NSLog(@"auth_token: %@",auth_token);
                    
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:auth_token forKey:@"auth_token"];
                    //TODO: Perform segue to Feed VC
                    [self performSegueToTabbar];
                    
                    
                }
            }
            else
            {
                NSLog(@"Error: %@", error.localizedDescription);
            }
        }];
        [postDataTask resume];
        
        
        
    }
    
    
}
@end
