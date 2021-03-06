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

#import "UIScrollView+SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"

@interface TableViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *feedSelector;

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
    NSLog(@"ViewDidLoad is called");
    [super viewDidLoad];
    self.popularFeedPageNumber = 0;
    
    self.feed = [[NSMutableArray alloc] init];
    self.popularFeed = [[NSMutableArray alloc] init];
    self.nearbyFeed = [[NSMutableArray alloc] init];
    self.followedFeed = [[NSMutableArray alloc] init];
    self.displayedFeed = [[NSMutableArray alloc] init];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(updateFeeds) forControlEvents:UIControlEventValueChanged];
    
    data_handler = [DataHandler sharedInstance];
    [self updateFeeds];
    
    self.feedSelector.selectedSegmentIndex = 0;
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        NSLog(@"infinite scroll is on");
        [weakSelf addPostsToDisplayedFeed];
    }];
    /*
    
    self.tabBarController.tabBar.tintColor = [[UIColor alloc] initWithRed:0.90
                                                                    green:0.02
                                                                     blue:0.13
                                                                    alpha:1.0];
    
    self.tabBarController.tabBar.backgroundColor = [[UIColor alloc] initWithRed:0.0
                                                                          green:0.92
                                                                           blue:0.1
                                                                          alpha:1.0];
     
     */
}

-(void) viewWillAppear:(BOOL)animated
{
    self.tableView.showsInfiniteScrolling = YES;
    NSLog(@"ViewWillAppear is called: presenting view controller: %@", self.navigationController.presentingViewController);
    data_handler.delegate = self;
    
    //[self updateFeeds];
    [self reloadDataInTableView];
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
    //NSLog(@"COUNT: %d", [self.feed count]);
    return [self.displayedFeed count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"mainCell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    EntryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    RevealPost *revealPost = [self.displayedFeed objectAtIndex:indexPath.row];
    
    [cell configureCellForPost:revealPost];
    //NSLog(@"text label: %@", cell.textLabel.text);
    //NSLog(@"post body: %@", revealPost.body);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    RevealPost *revealPost = [self.displayedFeed objectAtIndex:indexPath.row];
    return [EntryCell heightForPost:revealPost];
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.tableView.showsInfiniteScrolling = NO;
    NSLog(@"Preparing for segue: %@", segue.identifier);
    if( [segue.identifier isEqualToString:@"FeedPostToDetailedView"])
    {
        //NSLog(@"inside DetailedPostTableViewController");
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        RevealPost *revealPost = [self.displayedFeed objectAtIndex:indexPath.row];
        
        [segue.destinationViewController setPost:revealPost];
        //NSString *str = [self.titles objectAtIndex:indexPath.row];
        //[segue.destinationViewController setTempString:str];
    }
    
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - IB Actions

- (IBAction)feedSelectorWasPressed:(id)sender {
    
    //[self.displayedFeed removeAllObjects];
    
    /*  removed Recent Feed
    if (self.feedSelector.selectedSegmentIndex == 0) {
        NSLog(@"feed was selected. Feed: %@", self.feed);
        self.displayedFeed = self.feed;
     */
        
    if (self.feedSelector.selectedSegmentIndex == 0) {
        NSLog(@"popular feed was selected. Pop Feed: %@", self.popularFeed);
        self.displayedFeed = self.popularFeed;
        
    } else if (self.feedSelector.selectedSegmentIndex == 1) {
        NSLog(@"nearby feed was selected");
        self.displayedFeed = self.nearbyFeed;
        
    } else if (self.feedSelector.selectedSegmentIndex == 2) {
        NSLog(@"followed feed was selected");
        self.displayedFeed = self.followedFeed;
    }
    
    [self reloadDataInTableView];
}


#pragma mark - Data portal

/*  Removed Recent Feed
- (void) feedUpdatedCallback:(DataHandler *)dataHandlerClass addingPosts:(BOOL)addingPosts {
    NSLog(@"feedUpdatedCallback in TableController.m");
    
    if (addingPosts == false) {
        self.feed = dataHandlerClass.feed;
    } else {
        [self.feed addObjectsFromArray:dataHandlerClass.feed];
    }
    
    if (self.feedSelector.selectedSegmentIndex == 0) {
        self.displayedFeed = self.feed;
    }
    
    if( ([self.refreshControl isRefreshing]) && (self.feedSelector.selectedSegmentIndex == 0) )
    {
        NSLog(@"Refreshing (feed updated callback)");
        [self.refreshControl endRefreshing];
        //[self.tableView.infiniteScrollingView stopAnimating];
        [self reloadDataInTableView];
        // call [tableView.infiniteScrollingView stopAnimating] when done
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView.infiniteScrollingView stopAnimating];
    });
    
}
 */

- (void) popularFeedUpdatedCallback:(DataHandler *)dataHandlerClass addingPosts:(BOOL)addingPosts {
    
    if (addingPosts == false) {
        self.popularFeed = dataHandlerClass.popularFeed;
    } else {
        [self.popularFeed addObjectsFromArray:dataHandlerClass.popularFeed];
    }
    
    if (self.feedSelector.selectedSegmentIndex == 0) {
        self.displayedFeed = self.popularFeed;
    }
    
    if( ([self.refreshControl isRefreshing]) && (self.feedSelector.selectedSegmentIndex == 0))
    {
        NSLog(@"Refreshing (pop feed updated callback)");
        [self.refreshControl endRefreshing];
        [self reloadDataInTableView];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView.infiniteScrollingView stopAnimating];
    });
}

- (void) nearbyFeedUpdatedCallback:(DataHandler *)dataHandlerClass addingPosts:(BOOL)addingPosts {
    
    if (addingPosts == false) {
        self.nearbyFeed = dataHandlerClass.nearby_feed;
    } else {
        [self.nearbyFeed addObjectsFromArray:dataHandlerClass.nearby_feed];
    }
    
    if (self.feedSelector.selectedSegmentIndex == 1) {
        self.displayedFeed = self.nearbyFeed;
    }
    
    if( ([self.refreshControl isRefreshing]) && (self.feedSelector.selectedSegmentIndex == 1))
    {
        NSLog(@"Refreshing (nearby feed updated callback)");
        [self.refreshControl endRefreshing];
        [self reloadDataInTableView];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView.infiniteScrollingView stopAnimating];
    });
}

- (void) followedFeedUpdatedCallback:(DataHandler *)dataHandlerClass addingPosts:(BOOL)addingPosts {
    
    if (addingPosts == false) {
        self.followedFeed = dataHandlerClass.followedFeed;
    } else {
        [self.followedFeed addObjectsFromArray:dataHandlerClass.followedFeed];
    }
    
    if (self.feedSelector.selectedSegmentIndex == 2) {
        self.displayedFeed = self.followedFeed;
    }
    
    if( ([self.refreshControl isRefreshing]) && (self.feedSelector.selectedSegmentIndex == 2))
    {
        NSLog(@"Refreshing (popular feed updated callback)");
        [self.refreshControl endRefreshing];
        [self reloadDataInTableView];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView.infiniteScrollingView stopAnimating];
    });
}

- (void) reloadDataInTableView {
    [self.tableView reloadData];
    NSLog(@"first reload of tableView (before dispatch)");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    NSLog(@"second reload of tableview (after dispatch)");
}

#pragma mark - Get Feed Posts

- (void) updateFeeds
{

    [self.refreshControl beginRefreshing];
    /*  THESE REMOVE ALL OBJECTS CALLS CAUSED THE APP TO CRASH!!!
    [self.displayedFeed removeAllObjects];
    [self.feed removeAllObjects];
    [self.popularFeed removeAllObjects];
    [self reloadDataInTableView];
     */
    //NSLog(@"updateFeeds");
    
    self.popularFeedPageNumber = 0;
    
    [[DataHandler sharedInstance] updateFeedsWithIdentifier:@"TableViewController"];
}

- (void) addPostsToDisplayedFeed {
    [self.refreshControl beginRefreshing];
    
    /*  Removed Recent Feed
    if (self.feedSelector.selectedSegmentIndex == 0) {
        RevealPost *lastPost = [self.feed lastObject];
        NSNumber *lastPostID = lastPost.IDNumber;
        [[DataHandler sharedInstance] getRecentPosts:lastPostID];
        NSLog(@"sent request to datahandler");
     */
        
    if (self.feedSelector.selectedSegmentIndex == 0) {
        self.popularFeedPageNumber = self.popularFeedPageNumber + 1;
        NSLog(@"popular feed page number: int value: %d", self.popularFeedPageNumber);
        [[DataHandler sharedInstance] getPopularPosts:self.popularFeedPageNumber];
        
    } else if (self.feedSelector.selectedSegmentIndex == 1) {
        RevealPost *lastPost = [self.nearbyFeed lastObject];
        NSNumber *lastPostID = lastPost.IDNumber;
        [[DataHandler sharedInstance] getNearbyPosts:lastPostID];
        NSLog(@"adding nearby posts: sending request to datahandler");
        
    } else if (self.feedSelector.selectedSegmentIndex == 2) {
        RevealPost *lastPost = [self.followedFeed lastObject];
        [[DataHandler sharedInstance] getFollowedPosts:lastPost];
        NSLog(@"adding followed posts: sending request to datahandler");
    }
}


@end
