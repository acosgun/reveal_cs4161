//
//  DummyPosts.m
//  Reveal
//
//  Created by Alexander Stephen Miller on 6/15/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//

#import "DummyPosts.h"
#import "RevealPost.h"

@implementation DummyPosts

- (id) initWithDummyData {
    
    RevealPost *post1 = [RevealPost postWithIDNumber:@1];
    post1.userName = @"Travis";
    post1.votes = @50;
    post1.thumbnail = @"https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xfp1/t1.0-1/p320x320/10176093_10201958858788756_229269747_n.jpg";
    post1.date = [[NSDate alloc] init];
    post1.body = @"Ohhhh I'm going to Escambia County tomorrow to inspect bridges, now whenever you visit home you'll be driving over bridges Murray inspected.";
    
    RevealPost *post2 = [RevealPost postWithIDNumber:@2];
    post1.userName = @"Margarett";
    post1.votes = @3;
    post1.thumbnail = @"https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xap1/t1.0-1/p320x320/9438_10201644950541120_1028851633_n.jpg";
    post1.date = [[NSDate alloc] init];
    post1.body = @"blue skies and delicious drinks at a rooftop bar in Philly? yes, please!";
    
    RevealPost *post3 = [RevealPost postWithIDNumber:@3];
    post1.userName = @"Matt";
    post1.votes = @3;
    post1.thumbnail = @"https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xap1/t1.0-1/p320x320/10462502_10152444987365266_1812757493745827010_n.jpg";
    post1.date = [[NSDate alloc] init];
    post1.body = @"Brand New tickets for Orlando in October go on sale today at noon. They will sell out extremely fast, probably before half an hour.";
    
    //self = [super initWithObjects:post1, post2, post3, nil];
    
    return self;
}

+ (id) arrayWithDummyData {
    return [[self alloc] initWithDummyData];
}

@end
