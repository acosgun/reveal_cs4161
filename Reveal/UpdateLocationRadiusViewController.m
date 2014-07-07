//
//  UpdateLocationRadiusViewController.m
//  Reveal
//
//  Created by Alexander Stephen Miller on 7/7/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//

#import "UpdateLocationRadiusViewController.h"

@interface UpdateLocationRadiusViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation UpdateLocationRadiusViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.textField becomeFirstResponder];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dismissSelf
{
    [[self presentingViewController] dismissViewControllerAnimated:NO completion:nil];
    //[self.navigationController popToRootViewControllerAnimated:YES];
    //[self.navigationController popViewControllerAnimated:NO];
}


- (IBAction)doneWasPressed:(id)sender {
    NSLog(@"Done Was Pressed");
    [self.textField resignFirstResponder];
    NSString *newRadius = [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if (newRadius.length > 0 & newRadius.length <= 200) {
        //[self.json_handler createPostRequestWithContent:body isRevealed:isRevealed];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        
        
        [defaults setObject:newRadius forKey:@"location_radius"];

        
    } else {
        NSLog(@"ERROR: Post length is not within 1 and 200 characters");
    }
    //[self dismissSelf];
}



@end
