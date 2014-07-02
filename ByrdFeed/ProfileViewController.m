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
//#import "UserStatsCell.h"
#import "TwitterClient.h"
#import "TweetViewController.h"
#import <MBProgressHud.h>
#import <TSMessage.h>

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate, TweetCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *profileTableView;

@property (strong, nonatomic) TweetCell *stubCell;
//@property (strong, nonatomic) UserStatsCell *prototypeStatsCell;
@property (strong, nonatomic) NSArray *tweets;

@property (strong, nonatomic) UIView *profileHeaderView;

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

  self.title = @"Profile";
  
  // Init Table View
  self.profileTableView.delegate = self;
  self.profileTableView.dataSource = self;
  
  UINib *tweetCellNib = [UINib nibWithNibName:@"TweetCell" bundle:nil];
  [self.profileTableView registerNib:tweetCellNib forCellReuseIdentifier:@"TweetCell"];
  self.stubCell = [self.profileTableView dequeueReusableCellWithIdentifier:@"TweetCell"];
//  UINib *userStatsCellNib = [UINib nibWithNibName:@"UserStatsCell" bundle:nil];
//  [self.profileTableView registerNib:userStatsCellNib forCellReuseIdentifier:@"UserStatsCell"];
//  self.prototypeStatsCell = [self.profileTableView dequeueReusableCellWithIdentifier:@"UserStatsCell"];
  
  
  // init the header views
  
  
  // populate the header views
//  UIImageView *bannerImageView = self.bannerImageView;
//  [bannerImageView setImageWithURLRequest:[NSURLRequest requestWithURL:self.user.profileBannerUrl] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//    self.bannerImage = image;
//    self.bannerImageView.image = image;
//  } failure:nil];
//  [profileImage setImageWithURL:self.user.profileImageUrl];
//  userNameLabel.text = self.user.name;
//  userScreenNameLabel.text = [NSString stringWithFormat:@"@%@", self.user.screenName];
//  self.tableView.tableHeaderView = self.headerView;
  
  
  // fetch the tweets
  [self fetchTweets:TwitterClientEndpointMyTweets];
  
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

#warning refactor to use the timeline view
#pragma mark - Table View Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  // Return the number of rows in the section.
//  if (section == 1) {
//    return self.tweets.count;
//  }
  return self.tweets.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 112;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  CGSize size;
//  if (indexPath.row == 0) {
//    self.prototypeUserStatsCell.user = self.user;
//    [self.prototypeUserStatsCell layoutSubviews];
//    CGSize size = [self.prototypeUserStatsCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//  }
//  else {
    self.stubCell.tweet = self.tweets[indexPath.row];
    [self.stubCell layoutSubviews];
    size = [self.stubCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//  }
  
  return size.height + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
  if (self.tweets.count > 0) {
    cell.tweet = self.tweets[indexPath.row];
  }
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  
  TweetViewController *vc = [[TweetViewController alloc] init];
  vc.tweet = self.tweets[indexPath.row];
  [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - TweetCellDelegate

- (void)didTapProfileImage:(TweetCell *)cell {
  ProfileViewController *vc = [[ProfileViewController alloc] init];
  vc.user = cell.tweet.user;
  [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - data loading functions
- (void)fetchTweets:(TwitterClientEndpointType)type {
    NSLog(@"Fetching Tweets...");
      [[TwitterClient sharedInstance] getWithEndpointType:type
                                               parameters:nil
                                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
      //    NSLog(@"%@", responseObject);
      
      self.tweets = [Tweet tweetsWithArray:responseObject];
      
      if(![self.tweets count]) { // If no length
        [TSMessage showNotificationInViewController:self
                                              title:@"Oops, No Data"
                                           subtitle:@"Try sending a tweet!"
                                               type:TSMessageNotificationTypeWarning
                                           duration:1.f];
      }
      
      // Go back to Top of TableView
      [self.profileTableView scrollRectToVisible:CGRectMake(0, 0, self.profileTableView.frame.size.width, 10) animated:NO];
      
      [self.profileTableView reloadData];
      // hide HUD
      [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      NSLog(@"error: %@", [error description]);
      // Add Network Error
      [TSMessage showNotificationInViewController:self
                                            title:@"Network Error!"
                                         subtitle:@"Please try again in a few..."
                                             type:TSMessageNotificationTypeError
                                         duration:1.0f];
      
      [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
  
}

// Add expanding profile header
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//  CGFloat offset = self.profileTableView.contentOffset.y;
//  if (offset < 0) {
//    // enlarge and blur the header image
//    self.headerView.frame = CGRectMake(0, offset, 320, 150 - offset);
//    self.bannerImageView.frame = CGRectMake(0, offset, 320, 150 - offset);
//    CGFloat blurRadius = -offset/8;
//    CGFloat tintAlpha = MIN(-offset/800, 1);
//    self.bannerImageView.image = [self.bannerImage applyBlurWithRadius:blurRadius tintColor:[UIColor colorWithWhite:0.97 alpha:tintAlpha] saturationDeltaFactor:1 maskImage:nil];
//  } else {
//    // restore the header to normal
//    self.headerView.frame = CGRectMake(0, 0, 320, 150);
//    self.bannerImageView.frame = CGRectMake(0, 0, 320, 150);
//    self.bannerImageView.image = self.bannerImage;
//  }
//}

@end
