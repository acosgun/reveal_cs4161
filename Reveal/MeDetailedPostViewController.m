//
//  MeDetailedPostViewController.m
//  Reveal
//
//  Created by Alexander Stephen Miller on 6/16/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//

#import "MeDetailedPostViewController.h"
#import "DetailedPostSubView.h"
#import "RevealPost.h"
#import "JsonHandler.h"

@interface MeDetailedPostViewController ()

@property (weak, nonatomic) IBOutlet DetailedPostSubView *postSubView;
@property (weak, nonatomic) IBOutlet UIView *revealSubview;

@property (weak, nonatomic) IBOutlet UIImageView *meDetailPostImage;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UIButton *nameLabel;

@property (weak, nonatomic) IBOutlet UISwitch *revealSwitch;
@property (weak, nonatomic) IBOutlet UIButton *watchIcon;
@property (weak, nonatomic) IBOutlet UILabel *watchVotesLabel;
@property (weak, nonatomic) IBOutlet UIButton *ignoreIcon;
@property (weak, nonatomic) IBOutlet UILabel *ignoreLabel;


- (IBAction)revealToggleAction:(id)sender;

@end

@implementation MeDetailedPostViewController

DataHandler *data_handler;
NSInteger post_action_id;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.meDetailPostImage.image = [_revealPost imageForThumbnail:_revealPost.thumbnail];
    self.meDetailPostImage.image = [self.revealPost imageForThumbnail:self.revealPost.thumbnail];

    /*
    NSData *imageData = [NSData dataWithContentsOfURL:_revealPost.thumbnailURL];
    UIImage *image = [UIImage imageWithData:imageData];
    self.meDetailPostImage.image = image;
     */
    self.bodyLabel.text = self.revealPost.body;
    self.revealSwitch.on = self.revealPost.isRevealed;
    //self.nameLabel.titleLabel.text = self.revealPost.userName;
    [self.nameLabel setTitle:self.revealPost.userName forState:UIControlStateNormal];
    
    
    data_handler = [DataHandler sharedInstance];
    self.json_handler = [[JsonHandler alloc] init];
    self.json_handler.delegate = self;
    self.ignoreIcon.titleLabel.text = [self.revealPost.downVotes stringValue];
    self.watchIcon.titleLabel.text = [self.revealPost.votes stringValue];
    
}

-(void) viewWillAppear:(BOOL)animated
{
    data_handler.delegate = self;
    
    [self.postSubView setFrameHeight:self.revealPost];
    [self setRevealSubviewFrameOrigin];
}

- (void) setRevealSubviewFrameOrigin {
    CGRect middleSubviewFrame = self.revealSubview.frame;
    const CGRect topSubviewFrame = self.postSubView.frame;
    
    CGFloat newYOrigin = middleSubviewFrame.origin.y + topSubviewFrame.size.height - 135.0;
    middleSubviewFrame.origin.y = newYOrigin;
    self.revealSubview.frame = middleSubviewFrame;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    //RevealPost *revealPost = [self.displayedData objectAtIndex:indexPath.row];
    MeDetailedPostViewController *vc = [segue destinationViewController];
    vc.revealPost = _revealPost;
}
- (void) dismissSelf
{
    [self dismissViewControllerAnimated:NO completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Reveal post methods


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"alterView");
    if (buttonIndex == 0)
    {
        NSLog(@"user pressed CANCEL");
    }
    else
    {
        NSLog(@"user pressed GO");
        
        self.json_handler.delegate = self;
        if(post_action_id == 0) //now reveal
        {
            NSInteger post_id =[self.revealPost.IDNumber intValue];
            [[DataHandler sharedInstance] revealPost:&post_id];
        }
        else if(post_action_id == 1)//now hide
        {
            NSInteger post_id =[self.revealPost.IDNumber intValue];
            [[DataHandler sharedInstance] hidePost:&post_id];
        }
        else if(post_action_id == 2)//now delete
        {
            NSInteger post_id =[self.revealPost.IDNumber intValue];
            [[DataHandler sharedInstance] deletePost:&post_id];
        }
    }
}

- (IBAction)revealToggleAction:(id)sender
{
    if(self.revealSwitch.on) //Reveal post
    {
        post_action_id = 0;
        UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"Confirmation" message:@"Are you sure you want to REVEAL this post?" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"GO",nil];
        alertView.delegate = self;
        [alertView show];
        
    }
    else //Hide post
    {
        post_action_id = 1;
        UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"Confirmation" message:@"Are you sure you want to HIDE this post?" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"GO", nil];
        alertView.delegate = self;
        [alertView show];
    }
    //_revealPost.revealed = self.revealSwitch.on;
}


#pragma mark - Callbacks


-(void)revealStatusCallback:(BOOL)success action:(NSInteger)action_id
{    
    NSLog(@"revealStatusCallback in MeDetailedPostVC");
    NSLog(@"action_id: %d",action_id);
    
    
    if(success)
    {
     if(action_id == 0)
     {
         NSLog(@"Post Successfully Revealed");
     }
     else if(action_id == 1)
     {
         NSLog(@"Post Successfully Hidden");
     }
     else if(action_id == 2)
     {
         NSLog(@"Post Successfully Deleted");
     }
        
        [self dismissSelf];
    }
    else
    {
        if(self.revealSwitch.on)
        {
            NSLog(@"Post Could Not Be Revealed");
            self.revealSwitch.on = FALSE;
        }
        else
        {
            NSLog(@"Post Could Not Be Hidden");
            self.revealSwitch.on = TRUE;
        }
    }
}

- (IBAction)deleteButtonPressed:(id)sender {
    post_action_id = 2;
    UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"Confirmation" message:@"Are you sure you want to DELETE this post?" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"GO", nil];
    alertView.delegate = self;
    [alertView show];
}
@end
