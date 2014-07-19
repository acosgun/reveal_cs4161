//
//  CustomUITabBarController.m
//  Reveal
//
//  Created by Akansel Cosgun on 7/14/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//

#import "CustomUITabBarController.h"

@interface CustomUITabBarController () <UITabBarControllerDelegate>

@end

@implementation CustomUITabBarController

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
    
    UIImage* tabBarBackground = [UIImage imageNamed:@"tabbar.png"];
    //[[UITabBar appearance] setBackgroundImage:tabBarBackground];
    [self.tabBar setBackgroundImage:tabBarBackground];
    //[self.tabBar setTintColor:[UIColor whiteColor]];
    [self.tabBar setTintColor:[UIColor colorWithRed:(127.0/255.0) green:(163.0/255.0) blue:(76.0/255.0) alpha:1.0]];
    
    [self.tabBar setBarTintColor:[UIColor colorWithRed:(123.0/255.0) green:(47.0/255.0) blue:(85.0/255.0) alpha:1.0]];
    
    self.tabBar.autoresizesSubviews = NO;
    self.tabBar.clipsToBounds = YES;
    
    [self.tabBar setTranslucent:NO];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor whiteColor], UITextAttributeTextColor,
                                                       nil] forState:UIControlStateNormal];
    
    
    





    

    //[self.tabBar setBackgroundColor:[UIColor redColor]];
    

    // Do any additional setup after loading the view.
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
