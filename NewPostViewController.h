//
//  NewPostViewController.h
//  Reveal
//
//  Created by Akansel Cosgun on 6/16/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JsonHandler;

@interface NewPostViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) JsonHandler *json_handler;

@end
