//
//  MeDetailedPostViewController.m
//  Reveal
//
//  Created by Alexander Stephen Miller on 6/16/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//

#import "MeDetailedPostViewController.h"
#import "RevealPost.h"

@interface MeDetailedPostViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *meDetailPostImage;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;

@property (weak, nonatomic) IBOutlet UISwitch *revealSwitch;

- (IBAction)revealToggleAction:(id)sender;

@end

@implementation MeDetailedPostViewController

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
    /*
    self.bodyLabel.text = _revealPost.body;
    self.revealSwitch.on = _revealPost.isRevealed;
     */
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



- (IBAction)revealToggleAction:(id)sender {
    _revealPost.revealed = self.revealSwitch.on;
}

@end
