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
#import "DummyPosts.h"
#import "EntryCell.h"
#import "MeDetailedPostViewController.h"
#import "DataHandler.h"

@interface MeFeedTableViewController ()

@property (strong, nonatomic) NSString *thumbnail;

@property (strong, nonatomic) IBOutlet UIImageView *profileImage;

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
    
    data_handler = [DataHandler sharedInstance];
    data_handler.delegate = self;
    [data_handler updateFeedsWithIdentifier:@"MeFeedTableViewController" postClass:self.revealPost];
}

-(void) viewWillAppear:(BOOL)animated
{
    data_handler.delegate = self;
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
    
    NSMutableArray *displayedPosts = [[NSMutableArray alloc] init];
    if (self.hiddenRevealedSelector.selectedSegmentIndex == 0) {
        displayedPosts = self.hiddenFeed;
    } else if (self.hiddenRevealedSelector.selectedSegmentIndex == 1) {
        displayedPosts = self.publicFeed;
    }
    //cell.textLabel.text = [self.titles objectAtIndex:indexPath.row];
    //RevealPost *revealPost = [displayedPosts objectAtIndex:indexPath.row];
    RevealPost *revealPost = [self.displayedData objectAtIndex:indexPath.row];
    
    
    //cell.textLabel.text = revealPost.body; replaced because of custom cell configuration method
    [cell configureCellForPost:revealPost];
    //NSLog(@"text label: %@", revealPost.IDNumber);
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
	}
	if(self.hiddenRevealedSelector.selectedSegmentIndex == 1){
        //self.view.backgroundColor = [UIColor blueColor];
        NSLog(@"public selected \n");
	}
    [self viewDidLoad];
    [self.tableView reloadData];
    
}

#pragma mark - Callbacks
- (void) feedUpdatedCallback:(DataHandler *)dataHandlerClass {
    NSLog(@"feedUpdatedCallback in MeFeedTableController.m");
    self.feed = dataHandlerClass.nearby_feed;
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
    
    //[self viewDidLoad];
    [self.tableView reloadData];
}

@end
