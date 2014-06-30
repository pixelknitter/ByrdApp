//
//  ProfileViewController.m
//  ByrdFeed
//
//  Created by Eddie Freeman on 6/26/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "ProfileViewController.h"
#import "Constants.h"
#import "Utils.h"
#import "Tweet.h"
#import "TweetCell.h"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) TweetCell *stubCell;
@property (strong, nonatomic) NSArray *tweets;

@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  
  // Background Color
  ////  self.profileHeaderView.backgroundColor = _user.profileBackgroundColor;
  //  [Utils loadImageUrl:_user.profileImageURL inImageView:self.profileImageView withAnimation:YES];
  //  if(_user.pbackImageURL) {
  //    [Utils loadImageUrl:_user.pbackImageURL inImageView:self.profileHeaderBackgroundImageView withAnimation:YES];
  //  }
  //
  //  // Set Stats
  //  self.followersButton.titleLabel.text = [NSString stringWithFormat:@"%d/nFOLLOWERS", _user.followerCount];
  //  self.followingButton.titleLabel.text = [NSString stringWithFormat:@"%d/nFOLLOWING", _user.followerCount];
  //  self.tweetsButton.titleLabel.text = [NSString stringWithFormat:@"%d/nTWEETS", _user.tweetCount];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  // Return the number of sections.
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  // Return the number of rows in the section.
  if (section == 2) {
    return self.tweets.count;
  }
  return 0;
}

- (void)configureCell:(TweetCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
  Tweet *tweet = self.tweets[indexPath.row];
  
  if (tweet.isFavorited) {
    [cell.favoriteButton setImage:[UIImage imageNamed:@"favorite_on.png"] forState:UIControlStateSelected];
    cell.favoriteButton.selected = YES;
  }
  
  if (tweet.isRetweeted) {
    [cell.retweetButton setImage:[UIImage imageNamed:@"retweet_on.png"] forState:UIControlStateSelected];
    cell.retweetButton.selected = YES;
  }
  
  cell.nameLabel.text = tweet.userName;
  cell.userLabel.text = [User getFormattedUserName:tweet.screenName];
  [Utils loadImageUrl:tweet.profileImageURL inImageView:cell.profileImage withAnimation:YES];
  cell.tweetLabel.text = tweet.text;
  cell.sinceLabel.text = tweet.createdAt;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  [self configureCell:self.stubCell atIndexPath:indexPath];
  [self.stubCell layoutSubviews];
  
  CGSize size = [self.stubCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
  return size.height + 1;
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//  return UITableViewAutomaticDimension;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
  [self configureCell:cell atIndexPath:indexPath];
  return cell;
}

@end
