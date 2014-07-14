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
    [self.textField setKeyboardType:UIKeyboardTypeNumberPad];
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
    //NSString *newRadius = [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSNumberFormatter *numberFormat = [[NSNumberFormatter alloc] init];
    [numberFormat setNumberStyle:NSNumberFormatterNoStyle];
    NSNumber *newRadius = [numberFormat numberFromString:self.textField.text];
    

    if ([newRadius intValue] > 0 & [newRadius intValue] <= 1000) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:newRadius forKey:@"location_radius"];
        
    } else {
        NSLog(@"ERROR: New radius is not between 0 and 1000 miles");
    }
    [self dismissSelf];
}



@end
