//
//  DetailedPostSubView.m
//  Reveal
//
//  Created by Alexander Stephen Miller on 6/28/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//

#import "DetailedPostSubView.h"
#import "RevealPost.h"

@implementation DetailedPostSubView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) setFrameHeight:(RevealPost *)revealPost {
    const CGFloat topMargin = 35.0f;
    const CGFloat bottomMargin = 40.0f;
    const CGFloat minHeight = 150.0f;
    
    UIFont *font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    CGRect boundingBox = [revealPost.body boundingRectWithSize:CGSizeMake(225, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil];
    
    CGRect frame = [self frame];
    frame.size.height = MAX(minHeight, CGRectGetHeight(boundingBox) + topMargin + bottomMargin);
    [self setFrame:frame];
    //self.frame.size.height = MAX(minHeight, CGRectGetHeight(boundingBox) + topMargin + bottomMargin);
    //return MAX(minHeight, CGRectGetHeight(boundingBox) + topMargin + bottomMargin);
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
