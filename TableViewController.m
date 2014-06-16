//
//  TableViewController.m
//  Reveal
//
//  Created by Akansel Cosgun on 6/14/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//

#import "TableViewController.h"
#import "DetailedPostViewController.h"
#import "RevealPost.h"
#import "DummyPosts.h"
#import "EntryCell.h"

@interface TableViewController ()

@end

@implementation TableViewController

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
    
    RevealPost *post1 = [RevealPost postWithIDNumber:@1];
    post1.userName = @"Travis";
    post1.votes = @50;
    post1.thumbnail = @"https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xfp1/t1.0-1/p320x320/10176093_10201958858788756_229269747_n.jpg";
    post1.date = [NSDate dateWithTimeIntervalSinceNow:-60*2];
    post1.body = @"Ohhhh I'm going to Escambia County tomorrow to inspect bridges, now whenever you visit home you'll be driving over bridges Murray inspected.";
    post1.revealed = true;
    
    RevealPost *post2 = [RevealPost postWithIDNumber:@2];
    post2.userName = @"Margarett";
    post2.votes = @3;
    post2.thumbnail = @"https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xap1/t1.0-1/p320x320/9438_10201644950541120_1028851633_n.jpg";
    post2.date = [NSDate dateWithTimeIntervalSinceNow:-60*5];
    post2.body = @"blue skies and delicious drinks at a rooftop bar in Philly? yes, please!";
    
    RevealPost *post3 = [RevealPost postWithIDNumber:@3];
    post3.userName = @"Matt";
    post3.votes = @-4;
    post3.thumbnail = @"https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xap1/t1.0-1/p320x320/10462502_10152444987365266_1812757493745827010_n.jpg";
    post3.date = [NSDate dateWithTimeIntervalSinceNow:-60*20];
    post3.body = @"Brand New tickets for Orlando in October go on sale today at noon. They will sell out extremely fast, probably before half an hour.";
    
    self.feed = [NSMutableArray arrayWithObjects:post1, post2, post3, nil];
    //DummyPosts *feed = [DummyPosts arrayWithDummyData];
    NSLog(@"dummy data: %@", self.feed);
    self.titles = [NSMutableArray arrayWithObjects:@"item1",@"item2",@"item3",nil];
    
    NSLog(@"post1 body: %@", post1.body);
    NSLog(@"post2 body: %@", post2.body);
    NSLog(@"post3 body: %@", post3.body);
    
    
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
    NSLog(@"COUNT: %d", [self.feed count]);
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
    NSLog(@"text label: %@", cell.textLabel.text);
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
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
