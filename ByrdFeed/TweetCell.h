//
//  TweetCell.h
//  ByrdFeed
//
//  Created by Eddie Freeman on 6/22/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"
#import "Tweet.h"

@class TweetCell;

@protocol TweetCellDelegate <NSObject>

@optional
- (IBAction)replyButton:(id)sender;
- (IBAction)retweetButton:(id)sender;
- (IBAction)favoriteButton:(id)sender;

@required
- (void)didTapProfileImage:(TweetCell *)cell;

@end

@interface TweetCell : UITableViewCell

@property (nonatomic, weak) id <TweetCellDelegate> delegate;
@property (strong, nonatomic) Tweet *tweet;

@end
