//
//  DetailedPostViewController.m
//  Reveal
//
//  Created by Akansel Cosgun on 6/14/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//

#import "DetailedPostViewController.h"

@interface DetailedPostViewController ()

@end

@implementation DetailedPostViewController

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
    NSLog(@"viewDidLoad");
    //[[self.tempString alloc] init];
    // Do any additional setup after loading the view.
    
    self.tempLabel.text = self.tempString;
    
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

@end
