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

@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UILabel *postBody;
@property (weak, nonatomic) IBOutlet UIButton *postName;

@property (weak, nonatomic) IBOutlet UIButton *watchIcon;
@property (weak, nonatomic) IBOutlet UILabel *watchLabel;
@property (weak, nonatomic) IBOutlet UIButton *ignoreIcon;
@property (weak, nonatomic) IBOutlet UILabel *ignoreLabel;


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
    } else {
        self.deleteButton.hidden = false;
    }
    
    self.watchLabel.text = [self.post.votes stringValue];
    self.ignoreLabel.text = [self.post.downVotes stringValue];
    
    self.watchIcon.imageView.highlightedImage = [UIImage imageNamed:@"watch_blue"];
    self.ignoreIcon.imageView.highlightedImage = [UIImage imageNamed:@"thumb_blue"];
    [self setWatchButtonBackgroundColor];
    
    
    
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}


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

- (IBAction)pressedPostName:(id)sender {
    NSLog(@"Post name button was pressed");
}

- (IBAction)pressedWatchIcon:(id)sender {
    NSInteger post_id =[self.post.IDNumber intValue];

    if ([self.post.current_user_vote isEqualToString:@""]) {
        [data_handler watchPost:&post_id HTTMethod:@"POST"];
    } else {
        [data_handler watchPost:&post_id HTTMethod:@"PUT"];
    }
}

- (IBAction)pressedIgnoreIcon:(id)sender {
    NSInteger post_id =[self.post.IDNumber intValue];
    
    if ([self.post.current_user_vote isEqualToString:@""]) {
        [data_handler ignorePost:&post_id HTTMethod:@"POST"];
    } else {
        [data_handler ignorePost:&post_id HTTMethod:@"PUT"];
    }
}

- (void) setWatchButtonBackgroundColor {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.post.current_user_vote isEqualToString:@"watch"]) {
            self.watchIcon.imageView.highlighted = YES;
            self.ignoreIcon.imageView.highlighted = NO;
        } else if ([self.post.current_user_vote isEqualToString:@"ignore"]) {
            self.watchIcon.imageView.highlighted = NO;
            self.ignoreIcon.imageView.highlighted = YES;
        } else {
            self.watchIcon.imageView.highlighted = NO;
            self.ignoreIcon.imageView.highlighted = NO;
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

- (NSNumber *) addVote:(BOOL)addVote number:(NSNumber *)votes {
    int votes_int = [votes intValue];
    
    if (addVote == true) {
        votes_int = votes_int + 1;
    } else {
        votes_int = votes_int - 1;
    }
    
    NSNumber *newNumber = [NSNumber numberWithInt:votes_int];
    
    return newNumber;
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
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.post.votes= [self addVote:true number:self.post.votes];
            self.watchLabel.text = [self.post.votes stringValue];
            
            if ([self.post.current_user_vote isEqualToString:@""] == false) {
                self.post.downVotes = [self addVote:false number:self.post.downVotes];
                self.ignoreLabel.text = [self.post.downVotes stringValue];
            }
        });
        
        self.post.current_user_vote = @"watch";
        [self setWatchButtonBackgroundColor];
    }
}

- (void) ignorePostCallbackL:(BOOL)success {
    if (success) {
        NSLog(@"I am ignoring post");
        //[self.watchButton adjustsImageWhenDisabled];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.post.downVotes = [self addVote:true number:self.post.downVotes];
            self.ignoreLabel.text = [self.post.downVotes stringValue];
            
            if ([self.post.current_user_vote isEqualToString:@""] == false) {
                self.post.votes = [self addVote:false number:self.post.votes];
                self.watchLabel.text = [self.post.votes stringValue];
            }
        });
        
        
        self.post.current_user_vote = @"ignore";
        //[self setWatchButtonBackgroundColor];
        [self setWatchButtonBackgroundColor];
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
