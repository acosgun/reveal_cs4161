//
//  TableViewController.m
//  Reveal
//
//  Created by Akansel Cosgun on 6/14/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//

#import "TableViewController.h"
#import "DetailedPostTableViewController.h"
#import "RevealPost.h"
#import "EntryCell.h"
#import "DataHandler.h"

@interface TableViewController ()

@end

@implementation TableViewController

DataHandler *data_handler;

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    data_handler = [DataHandler sharedInstance];
    data_handler.delegate = self;
    
    //[[DataHandler sharedInstance] updateFeeds];
    [data_handler updateFeedsWithIdentifier:@"TableViewController"];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //NSLog(@"COUNT: %d", [self.feed count]);
    return [self.feed count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"mainCell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    EntryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    //cell.textLabel.text = [self.titles objectAtIndex:indexPath.row];
    RevealPost *revealPost = [self.feed objectAtIndex:indexPath.row];
    
    
    //cell.textLabel.text = revealPost.body; replaced because of custom cell configuration method
    [cell configureCellForPost:revealPost];
    //NSLog(@"text label: %@", cell.textLabel.text);
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
    if( [segue.identifier isEqualToString:@"FeedPostToDetailedView"])
    {
        NSLog(@"inside DetailedPostTableViewController");
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        RevealPost *revealPost = [self.feed objectAtIndex:indexPath.row];
        [segue.destinationViewController setPost:revealPost];
        //NSString *str = [self.titles objectAtIndex:indexPath.row];
        //[segue.destinationViewController setTempString:str];
    }
    
    if ([segue.identifier isEqualToString:@"meFeed"])
    {
                
        
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

#pragma mark - Data portal
- (void)feedUpdatedCallback:(DataHandler *)dataHandlerClass {
    NSLog(@"feedUpdatedCallback in TableController.m");
    self.feed = dataHandlerClass.nearby_feed;
    NSLog(@"callback from dataHandler to TAbleViewController (in Table VC)");
    
    //[self viewDidLoad];
    [self.tableView reloadData];
}

@end
