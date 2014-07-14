//
//  MeFeedTableViewController.m
//  Reveal
//
//  Created by Alexander Stephen Miller on 6/16/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//

#import "MeFeedTableViewController.h"
#import "DetailedPostTableViewController.h"
#import "RevealPost.h"
#import "EntryCell.h"
#import "MeDetailedPostViewController.h"
#import "DataHandler.h"

@interface MeFeedTableViewController ()

@property (strong, nonatomic) NSString *thumbnail;

@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIButton *followersButton;
@property (weak, nonatomic) IBOutlet UIButton *followingButton;


@end


@implementation MeFeedTableViewController

DataHandler *data_handler;

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSURL *) thumbnailURL {
    return [NSURL URLWithString:self.thumbnail];
}

- (IBAction)logoutButtonPressed:(id)sender {
    
    
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     [defaults setObject:nil forKey:@"auth_token"];
     NSLog(@"TODO: Perform segue to login VC");
     [self performSegueWithIdentifier:@"me_login" sender: self];
     
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(updateFeeds) forControlEvents:UIControlEventValueChanged];
    
    data_handler = [DataHandler sharedInstance];
    data_handler.delegate = self;
    //[data_handler updateFeedsWithIdentifier:@"MeFeedTableViewController" postClass:self.revealPost];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.profileImage.image = [UIImage imageWithData:[defaults objectForKey:@"avatar_data"]];
    self.nameLabel.text = [defaults objectForKey:@"username"];
    
    [self setupFollowButtons];
}

-(void) setupFollowButtons
{
    self.followersButton.titleLabel.numberOfLines = 2;
    //self.followers_button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    self.followingButton.titleLabel.numberOfLines = 2;
    //self.followers_button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
}

-(void) viewWillAppear:(BOOL)animated
{
    data_handler.delegate = self;
    [self updateFeeds];
    [self getUserInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSMutableArray *displayedPosts = [[NSMutableArray alloc] init];
    if (self.hiddenRevealedSelector.selectedSegmentIndex == 0) {
        displayedPosts = self.hiddenFeed;
    } else if (self.hiddenRevealedSelector.selectedSegmentIndex == 1) {
        displayedPosts = self.publicFeed;
    }
    
    //NSLog(@"COUNT: %d", [displayedPosts count]);
    //return [displayedPosts count];
    return [self.displayedData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"mainCell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    EntryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    /*
    NSMutableArray *displayedPosts = [[NSMutableArray alloc] init];
    if (self.hiddenRevealedSelector.selectedSegmentIndex == 0) {
        displayedPosts = self.hiddenFeed;
    } else if (self.hiddenRevealedSelector.selectedSegmentIndex == 1) {
        displayedPosts = self.publicFeed;
    } */
    //cell.textLabel.text = [self.titles objectAtIndex:indexPath.row];
    //RevealPost *revealPost = [displayedPosts objectAtIndex:indexPath.row];
    RevealPost *revealPost = [self.displayedData objectAtIndex:indexPath.row];
    
    
    //cell.textLabel.text = revealPost.body; replaced because of custom cell configuration method
    [cell configureCellForPost:revealPost];
    //NSLog(@"text label: %@", revealPost.IDNumber);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    RevealPost *revealPost = [self.displayedData objectAtIndex:indexPath.row];
    return [EntryCell heightForPost:revealPost];
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    /*
    NSLog(@"Preparing for segue: %@", segue.identifier);
    if( [segue.identifier isEqualToString:@"showDetailedPost"])
    {
        NSLog(@"inside showDetailedPost");
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        RevealPost *revealPost = [self.feed objectAtIndex:indexPath.row];
        NSString *str = revealPost.body;
        //NSString *str = [self.titles objectAtIndex:indexPath.row];
        //[segue.destinationViewController setTempString:str];
    }
     */
    
    if ([segue.identifier isEqualToString:@"meFeedDetailPost"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        RevealPost *revealPost = [self.displayedData objectAtIndex:indexPath.row];
        MeDetailedPostViewController *vc = [segue destinationViewController];
        vc.revealPost = revealPost;
        
        /*
         UITableViewCell *cell = sender;
         NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
         UINavigationController *navigationController = segue.destinationViewController;
         EntryViewController *entryViewController = (EntryViewController *)navigationController.topViewController;
         entryViewController.entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
         */
    }
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)pubSelSwitch {
    if(self.hiddenRevealedSelector.selectedSegmentIndex == 0){
        //self.view.backgroundColor = [UIColor redColor];
        NSLog(@"hidden selected \n");
        self.displayedData = self.hiddenFeed;
	}
	if(self.hiddenRevealedSelector.selectedSegmentIndex == 1){
        //self.view.backgroundColor = [UIColor blueColor];
        NSLog(@"public selected \n");
        self.displayedData = self.publicFeed;
	}
    
    [self.tableView reloadData];
}



#pragma mark - Callbacks
- (void) feedUpdatedCallback:(DataHandler *)dataHandlerClass addingPosts:(BOOL)addingPosts {
    NSLog(@"feedUpdatedCallback in MeFeedTableController.m");
    self.feed = dataHandlerClass.feed;
    self.publicFeed = [[NSMutableArray alloc] init];
    self.hiddenFeed = [[NSMutableArray alloc] init];
    for (RevealPost *rp in self.feed)
    {
        if (rp.revealed)
        {
            [self.publicFeed addObject:rp];
        } else
        {
            [self.hiddenFeed addObject:rp];
        }
    }
    
     self.displayedData = [[NSMutableArray alloc] init];
     if (self.hiddenRevealedSelector.selectedSegmentIndex == 0) {
     self.displayedData = self.hiddenFeed;
     } else if (self.hiddenRevealedSelector.selectedSegmentIndex == 1) {
     self.displayedData = self.publicFeed;
     }
    
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
    
    NSLog(@"callback complete");
    
    /*
     NSLog(@"feedUpdatedCallback in TableController.m");
     self.feed = dataHandlerClass.nearby_feed;
     //NSLog(@"callback from dataHandler to TAbleViewController (in Table VC)");
     
     //NSLog(@"nearby_feed count: %d",self.feed.count);
     [self.tableView reloadData];
     
     if([self.refreshControl isRefreshing])
     {
     NSLog(@"Refreshing");
     [self.refreshControl endRefreshing];
     }
     */
}

#pragma mark - Pull to Refresh Data

- (void) updateFeeds
{
    //NSLog(@"updateFeeds");
    [[DataHandler sharedInstance] updateFeedsWithIdentifier:@"MeFeedTableViewController" postClass:self.revealPost];
}

#pragma mark - methods for follow buttons

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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger user_id = [[defaults objectForKey:@"user_id"] integerValue];
    data_handler.delegate = self;
    [[DataHandler sharedInstance] getUserInfo:&user_id includeAuthToken:TRUE];
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
        
        self.followersButton.enabled = FALSE;
        [self.followersButton setTitle:str_followers forState:UIControlStateNormal];
        [self.followersButton setTitle:str_followers forState:UIControlStateHighlighted];
        [self.followersButton setTitle:str_followers forState:UIControlStateDisabled];
        [self.followersButton setTitle:str_followers forState:UIControlStateSelected];
        self.followersButton.enabled = TRUE;
        
        
        self.followingButton.enabled = FALSE;
        [self.followingButton setTitle:str_following forState:UIControlStateNormal];
        [self.followingButton setTitle:str_following forState:UIControlStateHighlighted];
        [self.followingButton setTitle:str_following forState:UIControlStateDisabled];
        [self.followingButton setTitle:str_following forState:UIControlStateSelected];
        self.followingButton.enabled = TRUE;
    });
    
    [self.tableView reloadData];
    
}


@end
