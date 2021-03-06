//
//  NewPostViewController.m
//  Reveal
//
//  Created by Akansel Cosgun on 6/16/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//

#import "NewPostViewController.h"
#import "JsonHandler.h"

@interface NewPostViewController () <UITextViewDelegate, JsonHandlerDelegate>

@end

@implementation NewPostViewController

DataHandler *data_handler;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    NSLog(@"viewDidLoad of NewPostViewController");
    
    self.json_handler = [[JsonHandler alloc] init];
    self.json_handler.delegate = self;
    
    data_handler = [DataHandler sharedInstance];
    data_handler.delegate = self;
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.textView becomeFirstResponder];
    
}

- (IBAction)postEntryButton:(id)sender {
    NSLog(@"Post Was Pressed");
    [self.textView resignFirstResponder];
    NSString *body = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    BOOL isRevealed = false;
    if (body.length > 0 & body.length <= 200) {
        //[self.json_handler createPostRequestWithContent:body isRevealed:isRevealed];
        [[DataHandler sharedInstance] createPostRequestWithContent:body isRevealed:isRevealed];
        
    } else {
        NSLog(@"ERROR: Post length is not within 1 and 200 characters");
    }
    //[self dismissSelf];
}


- (void) dismissSelf
{
    [[self presentingViewController] dismissViewControllerAnimated:NO completion:nil];
    //[self.navigationController popToRootViewControllerAnimated:YES];
    //[self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - Callbacks
- (void) createPostRequestCallback:(BOOL)success {

    NSLog(@"createPostRequestCallback in NewPostVC");
    if (success) {
        NSLog(@"New post was created!!!");
        [self dismissSelf];
    } else {
        NSLog(@"Error creating new post");
        //TODO: show error for creating post
    }
}

@end
