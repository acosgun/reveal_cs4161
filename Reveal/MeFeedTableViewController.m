//
//  MeFeedTableViewController.m
//  Reveal
//
//  Created by Alexander Stephen Miller on 6/16/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//

#import "MeFeedTableViewController.h"
#import "DetailedPostViewController.h"
#import "RevealPost.h"
#import "DummyPosts.h"
#import "EntryCell.h"
#import "MeDetailedPostViewController.h"

@interface MeFeedTableViewController ()
@property (strong, nonatomic) NSString *thumbnail;

@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UISegmentedControl *publicSelector;

- (IBAction)pubSelSwitch;

@end

@implementation MeFeedTableViewController





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
    
    //self.publicSelector.selectedSegmentIndex = 1;
    //self.publicSelector.selectedSegmentIndex = 0;
    
    self.thumbnail =@"https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xfp1/t1.0-1/p320x320/10176093_10201958858788756_229269747_n.jpg";
    RevealPost *rp = [RevealPost postWithIDNumber:nil];
    self.profileImage.image = [rp imageForThumbnail:self.thumbnail];
    /* added this functionality to RevealPost class (call shown above). Is there a better way to do this without having to create rp instance?
    NSData *imageData = [NSData dataWithContentsOfURL:self.thumbnailURL];
    UIImage *image = [UIImage imageWithData:imageData];
    self.profileImage.image = image;
     */
    if (self.feed == nil) {
        RevealPost *post1 = [RevealPost postWithIDNumber:@1];
        post1.userName = @"Travis";
        post1.votes = @50;
        post1.thumbnail = @"https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xfp1/t1.0-1/p320x320/10176093_10201958858788756_229269747_n.jpg";
        post1.date = [NSDate dateWithTimeIntervalSinceNow:-60*2];
        post1.body = @"Ohhhh I'm going to Escambia County tomorrow to inspect bridges, now whenever you visit home you'll be driving over bridges Murray inspected.";
        post1.revealed = true;
        
        RevealPost *post2 = [RevealPost postWithIDNumber:@2];
        post2.userName = @"Travis";
        post2.votes = @3;
        post2.thumbnail = @"https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xfp1/t1.0-1/p320x320/10176093_10201958858788756_229269747_n.jpg";
        post2.date = [NSDate dateWithTimeIntervalSinceNow:-60*5];
        post2.body = @"blue skies and delicious drinks at a rooftop bar in Philly? yes, please!";
        post2.revealed = false;
        
        RevealPost *post3 = [RevealPost postWithIDNumber:@3];
        post3.userName = @"Travis";
        post3.votes = @-4;
        post3.thumbnail = @"https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xfp1/t1.0-1/p320x320/10176093_10201958858788756_229269747_n.jpg";
        post3.date = [NSDate dateWithTimeIntervalSinceNow:-60*20];
        post3.body = @"Brand New tickets for Orlando in October go on sale today at noon. They will sell out extremely fast, probably before half an hour.";
        post3.revealed = true;
        
        self.feed = [NSMutableArray arrayWithObjects:post1, post2, post3, nil];
        //DummyPosts *feed = [DummyPosts arrayWithDummyData];
        NSLog(@"dummy data: %@", self.feed);
        self.titles = [NSMutableArray arrayWithObjects:@"item1",@"item2",@"item3",nil];
        
        NSLog(@"post1 body: %@", post1.body);
        NSLog(@"post2 body: %@", post2.body);
        NSLog(@"post3 body: %@", post3.body);
    }

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
    if (_publicSelector.selectedSegmentIndex == 0) {
        self.displayedData = self.hiddenFeed;
    } else if (_publicSelector.selectedSegmentIndex == 1) {
        self.displayedData = self.publicFeed;
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    if (_publicSelector.selectedSegmentIndex == 0) {
        displayedPosts = self.hiddenFeed;
    } else if (_publicSelector.selectedSegmentIndex == 1) {
        displayedPosts = self.publicFeed;
    }
    
    NSLog(@"COUNT: %d", [displayedPosts count]);
    //return [displayedPosts count];
    return [self.displayedData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"mainCell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    EntryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSMutableArray *displayedPosts = [[NSMutableArray alloc] init];
    if (_publicSelector.selectedSegmentIndex == 0) {
        displayedPosts = self.hiddenFeed;
    } else if (_publicSelector.selectedSegmentIndex == 1) {
        displayedPosts = self.publicFeed;
    }
    //cell.textLabel.text = [self.titles objectAtIndex:indexPath.row];
    //RevealPost *revealPost = [displayedPosts objectAtIndex:indexPath.row];
    RevealPost *revealPost = [self.displayedData objectAtIndex:indexPath.row];
    
    
    //cell.textLabel.text = revealPost.body; replaced because of custom cell configuration method
    [cell configureCellForPost:revealPost];
    NSLog(@"text label: %@", revealPost.IDNumber);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    RevealPost *revealPost = [self.feed objectAtIndex:indexPath.row];
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
    NSLog(@"Preparing for segue: %@", segue.identifier);
    if( [segue.identifier isEqualToString:@"showDetailedPost"])
    {
        NSLog(@"inside showDetailedPost");
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        RevealPost *revealPost = [self.feed objectAtIndex:indexPath.row];
        NSString *str = revealPost.body;
        //NSString *str = [self.titles objectAtIndex:indexPath.row];
        [segue.destinationViewController setTempString:str];
    }
    
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
    if(_publicSelector.selectedSegmentIndex == 0){
        self.view.backgroundColor = [UIColor redColor];
        NSLog(@"hidden selected \n");
	}
	if(_publicSelector.selectedSegmentIndex == 1){
        self.view.backgroundColor = [UIColor blueColor];
        NSLog(@"public selected \n");
	}
    [self viewDidLoad];
    [self.tableView reloadData];
    
}
@end
