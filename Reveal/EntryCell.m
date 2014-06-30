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
@property (weak, nonatomic) IBOutlet UILabel *elapsedTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *votesLabel;

@property (weak, nonatomic) IBOutlet UIImageView *mainImageLabel;

@end

@implementation EntryCell

+ (CGFloat)heightForPost:(RevealPost *)revealPost {
    const CGFloat topMargin = 21.0f;
    const CGFloat bottomMargin = 21.0f;
    const CGFloat minHeight = 85.0f;
    
    UIFont *font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    CGRect boundingBox = [revealPost.body boundingRectWithSize:CGSizeMake(211, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil];
    
    return MAX(minHeight, CGRectGetHeight(boundingBox) + topMargin + bottomMargin);
}

- (void) configureCellForPost:(RevealPost *)revealPost {
    self.bodyLabel.text = revealPost.body;
    
    NSString *voteText;
    if(revealPost.votes > 0)
    {
        voteText = [NSString stringWithFormat:@"+%@",revealPost.votes];
    }
    else
    {
        voteText = [revealPost.votes stringValue];
    }
    self.votesLabel.text = voteText;
    
    //revealPost.date
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"mm"];
    NSTimeInterval elapsedTime = [revealPost.date timeIntervalSinceNow];
    
    int intElapsedTime = (int)elapsedTime/60 * -1;
    
    NSLog(@"intElapsedTime: %d",intElapsedTime);
    
    self.elapsedTimeLabel.text = [NSString stringWithFormat:@"%dm", intElapsedTime];
    self.nameLabel.text = revealPost.userName;
    
    NSData *imageData = [NSData dataWithContentsOfURL:revealPost.thumbnailURL];
    UIImage *image = [UIImage imageWithData:imageData];
    self.mainImageLabel.image = image;
    /*
    if ([revealPost isRevealed]) {
        self.nameLabel.text = revealPost.userName;
        
        NSData *imageData = [NSData dataWithContentsOfURL:revealPost.thumbnailURL];
        UIImage *image = [UIImage imageWithData:imageData];
        self.mainImageLabel.image = image;
    } else {
        self.nameLabel.text = @"Anonymous";
        self.mainImageLabel.image = [UIImage imageNamed:@"anonymous_thumbnail.png"];
    }
     */
}

@end
