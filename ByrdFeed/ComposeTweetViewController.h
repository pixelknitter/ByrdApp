//
//  ComposeTweetViewController.h
//  ByrdFeed
//
//  Created by Eddie Freeman on 6/22/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@protocol ComposeTweetDelegate <NSObject>

@required
- (void)didPostTweet:(Tweet *)tweet;

@end

@interface ComposeTweetViewController : UIViewController <UITextViewDelegate>

@property (strong, nonatomic) Tweet *tweet;

@property (strong, nonatomic) NSString *replyTo;
@property (strong, nonatomic) NSString *replyIdStr;

@end
