//
//  DetailedPostTableViewController.m
//  Reveal
//
//  Created by Alexander Stephen Miller on 6/28/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//

#import "DetailedPostTableViewController.h"
#import "RevealPost.h"
#import "DetailedPostSubView.h"
#import "UserProfileTableViewController.h"
#import "JsonHandler.h"
#import "DataHandler.h"

@interface DetailedPostTableViewController ()

@property (weak, nonatomic) IBOutlet DetailedPostSubView *postSubView;
@property (weak, nonatomic) IBOutlet UIButton *watchButton;


@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UILabel *postBody;
@property (weak, nonatomic) IBOutlet UIButton *postName;

@end

@implementation DetailedPostTableViewController

DataHandler *data_handler;

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
    
    data_handler = [DataHandler sharedInstance];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger user_id = [[defaults objectForKey:@"user_id"] integerValue];

    if([self.post.userID integerValue] != user_id)
    {
        self.deleteButton.hidden = TRUE;
    }
    else
    {
        self.watchButton.hidden = TRUE;
    }
    
    
    
    //self.postSubView.frame.size.height = [self.postSubView setFrameHeight:self.post];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) viewWillAppear:(BOOL)animated {
    
    data_handler.delegate = self;
    
    [self.postSubView setFrameHeight:self.post];
    
    self.postImage.image = [self.post imageForThumbnail:self.post.thumbnail];
    //self.postName.text = self.post.userName;
    [self.postName setTitle:self.post.userName forState:UIControlStateNormal];
    self.postBody.text = self.post.body;
    //NSLog(@"post_id (detailedPostVC): %@", self.post.IDNumber);
    //NSLog(@"user_id (detailedPostVC): %@", self.post.userID);
    
    [self setWatchButtonBackgroundColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Segue to User VC

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"FeedToUserProfile"]) {
        NSLog(@"Inside prepareForSegue: DetailedPostVC");
        //call info on the user
        
        
        UserProfileTableViewController *vc = [segue destinationViewController];
        vc.revealPost = self.post;
        }
}




#pragma mark - IB Actions
- (IBAction)pressedShareButton:(id)sender {
    NSLog(@"share button was pressed");
    
    self.json_handler = [[JsonHandler alloc] init];
    self.json_handler.delegate = self;
    
    [self.json_handler createSharePost:self.post];
}

- (IBAction)pressedPostName:(id)sender {
    NSLog(@"Post name button was pressed");
}

- (IBAction)pressedWatchButton:(id)sender {
    NSLog(@"watch button was pressed");
    NSLog(@"current_user_vote = %@", self.post.current_user_vote);
    NSInteger post_id =[self.post.IDNumber intValue];
    
    if ([self.post.current_user_vote isEqualToString:@""]) {
        [self promptForWatch];
    } else if ([self.post.current_user_vote isEqualToString:@"watch"]) {
        [data_handler ignorePost:&post_id HTTMethod:@"PUT"];
    } else if ([self.post.current_user_vote isEqualToString:@"ignore"]) {
        [data_handler watchPost:&post_id HTTMethod:@"PUT"];
    }
}

- (void) setWatchButtonBackgroundColor {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.post.current_user_vote isEqualToString:@"watch"]) {
            self.watchButton.backgroundColor = [UIColor greenColor];
            //self.watchButton.imageView.image = nil;
            [self.watchButton setImage:nil forState:UIControlStateNormal];
            self.watchButton.titleLabel.text = @"W";
        } else if ([self.post.current_user_vote isEqualToString:@"ignore"]) {
            self.watchButton.backgroundColor = [UIColor grayColor];
            //self.watchButton.imageView.image = nil;
            [self.watchButton setImage:nil forState:UIControlStateNormal];
            self.watchButton.titleLabel.text = @"I";

        }
    });
}

- (IBAction)deleteButtonPressed:(id)sender
{
    NSInteger post_id = [self.post.IDNumber intValue];
    [[DataHandler sharedInstance] deletePost:&post_id];
}

- (IBAction)facebookButtonPressed:(id)sender {

    NSString *content_str = [NSString stringWithFormat:@"%@ says:\"%@\" on Reveal", self.post.userName, self.post.body];
    [[DataHandler sharedInstance] postToFacebook:content_str viewController:self];
}


- (IBAction)twitterButtonPressed:(id)sender {
    NSString *content_str = [NSString stringWithFormat:@"%@ says:\"%@\" on Reveal", self.post.userName, self.post.body];

    [[DataHandler sharedInstance] postToTwitter:content_str viewController:self];
}

- (void) dismissSelf
{
    [[self presentingViewController] dismissViewControllerAnimated:NO completion:nil];
    //[self.navigationController popToRootViewControllerAnimated:YES];
    //[self.navigationController popViewControllerAnimated:NO];
}



#pragma mark - Action Sheet
- (void) promptForWatch {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Watch Screen" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Watch", @"Ignore", nil];
    
    [actionSheet showInView:self.view];
    NSLog(@"action view should appear");
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSInteger post_id =[self.post.IDNumber intValue];
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        NSString *method = @"POST";
        if (buttonIndex != actionSheet.firstOtherButtonIndex) {
            [data_handler ignorePost:&post_id HTTMethod:method];
        } else {
            [data_handler watchPost:&post_id HTTMethod:method];
        }
    }
}




#pragma mark - Callbacks
- (void) createSharePostCallback:(BOOL)success {
    if (success) {
        NSLog(@"post was successfully shared");
    } else {
        NSLog(@"ERROR: post not successfully shared");
    }
}

- (void) watchPostCallback:(BOOL)success {
    if (success) {
        NSLog(@"I am watching post");
        //[self.watchButton adjustsImageWhenHighlighted];
        self.post.current_user_vote = @"watch";
        [self setWatchButtonBackgroundColor];
    }
}

- (void) ignorePostCallbackL:(BOOL)success {
    if (success) {
        NSLog(@"I am ignoring post");
        //[self.watchButton adjustsImageWhenDisabled];
        self.post.current_user_vote = @"ignore";
        //[self setWatchButtonBackgroundColor];
        [self setWatchButtonBackgroundColor];
        [self.tableView setNeedsDisplay];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView setNeedsDisplay];
        });
        
    }
}

-(void)revealStatusCallback:(BOOL)success action:(NSInteger)action_id
{
    NSLog(@"revealStatusCallback in DetailedPostTVC.m");
    NSLog(@"action_id: %d",action_id);
    if(success && (action_id == 2))
    {
        NSLog(@"dismiss DetailedPostTVC");
        [self dismissSelf];
        
    }
}




@end
