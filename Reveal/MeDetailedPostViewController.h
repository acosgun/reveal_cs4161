//
//  MeDetailedPostViewController.h
//  Reveal
//
//  Created by Alexander Stephen Miller on 6/16/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RevealPost;

@interface MeDetailedPostViewController : UIViewController {
    RevealPost *_revealPost;
}

@property (strong, nonatomic) RevealPost *revealPost;

@end
