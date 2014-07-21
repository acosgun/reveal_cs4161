//
//  NotificationsTableViewController.m
//  Reveal
//
//  Created by Akansel Cosgun on 6/16/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//

#import "NotificationsTableViewController.h"
#import "DataHandler.h"
#import "NotificationsCell.h"
#import "RevealPost.h"
#import "UserProfileTableViewController.h"

@interface NotificationsTableViewController () <DataHandlerDelegate>




@end

@implementation NotificationsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
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
}

- (void) viewWillAppear:(BOOL)animated {
    [self getNotifications];
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
    return self.notifications.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotificationsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"notificationsCell" forIndexPath:indexPath];
    
    RevealPost *post = [self.notifications objectAtIndex:indexPath.row];
    
    [cell configureCellForPost:post];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(NotificationsCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (cell.postWasViewed == false) {
        //[cell setBackgroundColor:[UIColor grayColor]];
        //cell.backgroundColor = [UIColor colorWithRed:0.027 green:0.471 blue:0.373 alpha:0.2];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    RevealPost *post = [self.notifications objectAtIndex:indexPath.row];
    return [NotificationsCell heightForPost:post];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [segue.identifier isEqualToString:@"NotificationToUserProfile"]) {
        NSLog(@"seque to user profile VC from notifications VC");
        
        UserProfileTableViewController *vc = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        RevealPost *post = [self.notifications objectAtIndex:indexPath.row];
        vc.revealPost = post;
    }
}

#pragma mark - Get Data
- (void) getNotifications {
    DataHandler *data_handler = [DataHandler sharedInstance];
    data_handler.delegate = self;
    [data_handler getNotificationsDH];
}

- (void) viewedNewNotifications {
    DataHandler *data_handler = [DataHandler sharedInstance];
    data_handler.delegate = self;
    [data_handler viewedNewNotifications];
}

#pragma mark - Callbacks
- (void) getNotificationsCallbackDH:(NSArray *)notifications {
    self.notifications = [[NSMutableArray alloc] init];
    [self.notifications addObjectsFromArray:notifications];
    
    [self reloadTableViewData];
    
    //[self viewedNewNotifications];
}

- (void) viewedNewPostsCallback:(BOOL)success {
    NSLog(@"Hooray!!!");
}

- (void) reloadTableViewData {
    
    [self.tableView reloadData];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

@end
