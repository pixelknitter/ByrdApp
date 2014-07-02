//
//  TweetCell.m
//  ByrdFeed
//
//  Created by Eddie Freeman on 6/22/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "TweetCell.h"

@interface TweetCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *sinceLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;

@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@end

@implementation TweetCell

- (void)awakeFromNib
{
  
  UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapProfileImage)];
  [self.profileImage addGestureRecognizer:tapGestureRecognizer];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)tweet {
  _tweet = tweet;
  [self reloadData];
}

- (void)reloadData {
  self.profileImage.image = nil;
  
  if (self.tweet.isFavorited) {
    [self.favoriteButton setImage:[UIImage imageNamed:@"favorite_on.png"] forState:UIControlStateSelected];
    self.favoriteButton.selected = YES;
  }
  
  if (self.tweet.isRetweeted) {
    [self.retweetButton setImage:[UIImage imageNamed:@"retweet_on.png"] forState:UIControlStateSelected];
    self.retweetButton.selected = YES;
  }
  
  [Utils loadImageUrl:self.tweet.user.profileImageURL inImageView:self.profileImage withAnimation:YES];
  self.nameLabel.text = self.tweet.user.name;
  self.userLabel.text = [User getFormattedUserName:self.tweet.user.screenName];
  self.sinceLabel.text = self.tweet.createdAt;
  self.tweetLabel.text = self.tweet.text;
}

- (IBAction)retweetButton:(id)sender {
  [self.delegate retweetButton:sender];
}

- (IBAction)favoriteButton:(id)sender {
  [self.delegate favoriteButton:sender];
}

- (IBAction)replyButton:(id)sender {
  [self.delegate replyButton:sender];
}

- (void)onTapProfileImage {
  [self.delegate onTapProfileImage:self.tweet.user];
}

@end
