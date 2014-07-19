//
//  NotificationsCell.m
//  Reveal
//
//  Created by Alexander Stephen Miller on 7/18/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//

#import "NotificationsCell.h"
#import "RevealPost.h"

@interface NotificationsCell ()

@property (weak, nonatomic) IBOutlet UIButton *nameButton;
@property (weak, nonatomic) IBOutlet UILabel *revealedTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *image;


@end

@implementation NotificationsCell

+ (CGFloat)heightForPost:(RevealPost *)post {
    const CGFloat topMargin = 30.0f;
    const CGFloat bottomMargin = 35.0f;
    const CGFloat minHeight = 85.0f;
    
    UIFont *font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    CGRect boundingBox = [post.body boundingRectWithSize:CGSizeMake(200, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil];
    
    return MAX(minHeight, CGRectGetHeight(boundingBox) + topMargin + bottomMargin);
}

- (void) configureCellForPost:(RevealPost *)post {
    
    self.bodyLabel.text = post.body;
    [self.nameButton setTitle:post.userName forState:UIControlStateNormal];
    self.postWasViewed = post.viewed;
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        NSData *imageData = [NSData dataWithContentsOfURL:post.thumbnailURL];
        UIImage *image = [UIImage imageWithData:imageData];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            self.image.image = image;
        });
    });
    
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
