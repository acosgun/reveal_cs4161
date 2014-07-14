//
//  UserProfileTableViewController.m
//  Reveal
//
//  Created by Alexander Stephen Miller on 7/1/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//

#import "UserProfileTableViewController.h"
#import "RevealPost.h"
#import "EntryCell.h"
#import "DataHandler.h"

@interface UserProfileTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;

@end

@implementation UserProfileTableViewController

DataHandler *data_handler;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    //NSLog(@"viewDidLoad: UserProfileVC");
    [super viewDidLoad];
    
    self.feed = [[NSMutableArray alloc] init];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(updateFeeds) forControlEvents:UIControlEventValueChanged];
    
    data_handler = [DataHandler sharedInstance];
    data_handler.delegate = self;
 
    [self setupFollowButtons];
}

-(void) setupFollowButtons
{
    self.followers_button.titleLabel.numberOfLines = 2;
    //self.followers_button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;

    self.following_button.titleLabel.numberOfLines = 2;
    //self.followers_button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;    
}

-(void) updateFollowButtons:(BOOL)current_user_follows follower_stat:(NSInteger)follower_stat followed_stat:(NSInteger)followed_stat
{
    NSLog(@"updateFollowButtons");
    NSString *str_follow;
    if(current_user_follows) {
        str_follow = @"UNFOLLOW";
    }
    else {
        str_follow = @"FOLLOW";
    }
    
    NSString *str_followers = [NSString stringWithFormat:@"%ld \nFollowers",(long)follower_stat];
    NSString *str_following = [NSString stringWithFormat:@"%ld \nFollowing",(long)followed_stat];
    
    dispatch_async(dispatch_get_main_queue(), ^{
    self.follow_button.enabled = FALSE;
    [self.follow_button setTitle:str_follow forState:UIControlStateNormal];
    [self.follow_button setTitle:str_follow forState:UIControlStateHighlighted];
    [self.follow_button setTitle:str_follow forState:UIControlStateDisabled];
    [self.follow_button setTitle:str_follow forState:UIControlStateSelected];
    self.follow_button.enabled = TRUE;

    self.followers_button.enabled = FALSE;
    [self.followers_button setTitle:str_followers forState:UIControlStateNormal];
    [self.followers_button setTitle:str_followers forState:UIControlStateHighlighted];
    [self.followers_button setTitle:str_followers forState:UIControlStateDisabled];
    [self.followers_button setTitle:str_followers forState:UIControlStateSelected];
    self.followers_button.enabled = TRUE;
    
    
    self.following_button.enabled = FALSE;
    [self.following_button setTitle:str_following forState:UIControlStateNormal];
    [self.following_button setTitle:str_following forState:UIControlStateHighlighted];
    [self.following_button setTitle:str_following forState:UIControlStateDisabled];
    [self.following_button setTitle:str_following forState:UIControlStateSelected];
    self.following_button.enabled = TRUE;
    });
   
}

-(void) viewWillAppear:(BOOL)animated
{
    //[self.feed removeAllObjects];
    [DataHandler sharedInstance].delegate = self;
    
    
    [self updateFeeds];
    
    [self getUserInfo];
    
    
    self.nameLabel.text = self.revealPost.userName;
    self.profileImage.image = [self.revealPost imageForThumbnail:self.revealPost.thumbnail];
    //NSLog(@"reveal post passed in: %@    %@", self.revealPost.userID, self.revealPost.userName);
}

-(void) viewWillDisappear:(BOOL)animated {
    //NSLog(@"ViewWillDissappear UserProfileTVC");
    //[self.feed removeAllObjects];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.feed count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"mainCell";
    
    EntryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    RevealPost *revealPost = [self.feed objectAtIndex:indexPath.row];
    
    [cell configureCellForPost:revealPost];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    RevealPost *revealPost = [self.feed objectAtIndex:indexPath.row];
    return [EntryCell heightForPost:revealPost];
}


#pragma mark - Callbacks
- (void) feedUpdatedCallback:(DataHandler *)dataHandlerClass addingPosts:(BOOL)addingPosts {
    //NSLog(@"feedUpdatedCallback UserProfileTVC.m");
    
    if ([self.revealPost.userID isEqual:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]]) {

        for (RevealPost *post in dataHandlerClass.feed) {
            if (post.revealed == true) {
                [self.feed removeAllObjects];
                [self.feed addObject:post];
            }
        }
    } else {
        self.feed = dataHandlerClass.feed;
    }
    
    //NSLog(@"feed is : %@", self.feed);
    
    //[self viewDidAppear:YES];
    
    if([self.refreshControl isRefreshing])
    {
        NSLog(@"Refreshing");
        [self.refreshControl endRefreshing];
    }
    
    
    [self.tableView reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}


#pragma mark - Pull to Refresh Data

- (void) updateFeeds
{
    //NSLog(@"updateFeeds");
    [[DataHandler sharedInstance] updateFeedsWithIdentifier:@"UserProfileTableViewController" postClass:self.revealPost];
}

-(void) getUserInformationCallback:(NSDictionary *)userInformation {
    //NSLog(@"userInformation: %@",userInformation);
    
    NSNumber *c_u_follows = [userInformation objectForKey:@"current_user_follows"];        
    self.current_user_follows = [c_u_follows boolValue];
    NSNumber *followed_stat = [userInformation objectForKey:@"followed_stat"];
    NSNumber *follower_stat = [userInformation objectForKey:@"follower_stat"];
    NSInteger int_followed_stat = [followed_stat integerValue];
    NSInteger int_follower_stat = [follower_stat integerValue];
    
    [self updateFollowButtons:self.current_user_follows follower_stat:int_follower_stat followed_stat:int_followed_stat];
}

- (void) getUserInfo
{
    NSInteger user_id = [self.revealPost.userID integerValue];
    data_handler.delegate = self;
    [[DataHandler sharedInstance] getUserInfo:&user_id includeAuthToken:TRUE];
}


- (IBAction)followButtonPressed:(id)sender {
    
    //NSLog(@"followButtonPressed");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger user_id = [[defaults objectForKey:@"user_id"] integerValue];
    NSInteger followed_user_id = [self.revealPost.userID integerValue];
    if(self.current_user_follows)
    {
        //UnFollow
        [[DataHandler sharedInstance] unfollowUser:&user_id followedUserID:&followed_user_id];
    }
    else
    {   //Follow
        [[DataHandler sharedInstance] followUser:&user_id followedUserID:&followed_user_id];
        
    }
}

#pragma mark - Callbacks
-(void) followUnfollowConfirmCallback:(BOOL)follow success:(BOOL)success
{
//    NSLog(@"followUnfollowConfirmCallback in UserProfileTVC.m");
//    NSLog(@"follow: %d, success: %d",follow,success);
    if(success)
    {
        [self getUserInfo];
    }
}

@end
