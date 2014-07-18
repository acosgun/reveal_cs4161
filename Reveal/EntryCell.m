//
//  EntryCell.m
//  Reveal
//
//  Created by Alexander Stephen Miller on 6/15/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//

#import "EntryCell.h"
#import "RevealPost.h"

@interface EntryCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *votesLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *ignoreLabel;

@property (weak, nonatomic) IBOutlet UIButton *watchIcon;
@property (weak, nonatomic) IBOutlet UIButton *ignoreIcon;

@property (weak, nonatomic) IBOutlet UIImageView *mainImageLabel;

@end

@implementation EntryCell

+ (CGFloat)heightForPost:(RevealPost *)revealPost {
    const CGFloat topMargin = 30.0f;
    const CGFloat bottomMargin = 35.0f;
    const CGFloat minHeight = 85.0f;
    
    // [[self titleLabel] setFont:[UIFont systemFontOfSize:36]];
    // UIFont *font = [UIFont systemFontOfSize:15.0];
    // UIFont *font = [UIFont fontWithName:@"System" size:12.0];
    UIFont *font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    CGRect boundingBox = [revealPost.body boundingRectWithSize:CGSizeMake(200, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil];
    
    return MAX(minHeight, CGRectGetHeight(boundingBox) + topMargin + bottomMargin);
}

- (void) configureCellForPost:(RevealPost *)revealPost {
    self.bodyLabel.text = revealPost.body;
    
    NSString *voteText;
    if([revealPost.votes intValue]> 0)
    {
        voteText = [NSString stringWithFormat:@"+%@",revealPost.votes];
    }
    else
    {
        voteText = [revealPost.votes stringValue];
    }
    self.votesLabel.text = [revealPost.votes stringValue];
    self.ignoreLabel.text = [revealPost.downVotes stringValue];
    
    //revealPost.date
    
    //NSLog(@"intElapsedTime: %d",intElapsedTime);
    
    //self.elapsedTimeLabel.text = [NSString stringWithFormat:@"%dm", intElapsedTime];
    self.dateLabel.text = revealPost.dateString;
    self.nameLabel.text = revealPost.userName;
    
    /*
    NSData *imageData = [NSData dataWithContentsOfURL:revealPost.thumbnailURL];
    UIImage *image = [UIImage imageWithData:imageData];
    self.mainImageLabel.image = image;
     */
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        NSData *imageData = [NSData dataWithContentsOfURL:revealPost.thumbnailURL];
        UIImage *image = [UIImage imageWithData:imageData];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            self.mainImageLabel.image = image;
        });
    });
   
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"my username: %@    post username: %@", [defaults objectForKey:@"username"], revealPost.userName);
    
    if ([revealPost.current_user_vote isEqualToString:@"watch"]) {
        self.watchIcon.imageView.highlightedImage = [UIImage imageNamed:@"watch_blue"];
        self.watchIcon.imageView.highlighted = YES;
        self.ignoreIcon.imageView.highlighted = NO;
    } else if ([revealPost.current_user_vote isEqualToString:@"ignore"]) {
        self.ignoreIcon.imageView.highlightedImage = [UIImage imageNamed:@"thumb_blue"];
        self.ignoreIcon.imageView.highlighted = YES;
        self.watchIcon.imageView.highlighted = NO;
    } else {
        self.watchIcon.imageView.highlighted = NO;
        self.ignoreIcon.imageView.highlighted = NO;
    }
}

@end
