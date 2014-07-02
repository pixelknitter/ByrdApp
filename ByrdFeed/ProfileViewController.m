//
//  ProfileViewController.m
//  ByrdFeed
//
//  Created by Eddie Freeman on 6/26/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileHeaderView.h"
#import "Constants.h"
#import "Utils.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "UserStatsCell.h"
#import "TwitterClient.h"
#import "TweetViewController.h"
#import <MBProgressHud.h>
#import <TSMessage.h>

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate, TweetCellDelegate, ProfileHeaderViewDelegate>

@property (strong, nonatomic) NSArray *tweets;

@property (weak, nonatomic) IBOutlet UITableView *profileTableView;
@property (strong, nonatomic) TweetCell *stubTweetCell;
@property (strong, nonatomic) UserStatsCell *stubStatsCell;

@property (strong, nonatomic) ProfileHeaderView *profileHeaderView;
@property (nonatomic, strong) UIImageView *bannerImageView;
@property (nonatomic, strong) UIImage *bannerImage;

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
  self.stubTweetCell = [self.profileTableView dequeueReusableCellWithIdentifier:@"TweetCell"];
  UINib *userStatsCellNib = [UINib nibWithNibName:@"UserStatsCell" bundle:nil];
  [self.profileTableView registerNib:userStatsCellNib forCellReuseIdentifier:@"UserStatsCell"];
  self.stubStatsCell = [self.profileTableView dequeueReusableCellWithIdentifier:@"UserStatsCell"];
  // Set Inset for divider
  [self.profileTableView setSeparatorInset:UIEdgeInsetsZero];
  
  // init the header views
  self.profileHeaderView = [[ProfileHeaderView alloc] init];
  self.profileHeaderView.clipsToBounds = YES;
  self.profileHeaderView.user = self.user;
//  
//  CGRect frame = self.profileTableView.frame;
//  frame.size.height = 150;
//  self.profileHeaderView = [[UIView alloc] initWithFrame:frame];
//  self.profileHeaderView.clipsToBounds = YES;
//  self.bannerImageView = [[UIImageView alloc] initWithFrame:frame];
//  self.bannerImageView.contentMode = UIViewContentModeScaleAspectFill;
//  [self.profileHeaderView addSubview:self.bannerImageView];
//  UIView *profileImageContainer = [[UIView alloc] initWithFrame:CGRectMake(128, 20, 64, 64)];
//  profileImageContainer.backgroundColor = [UIColor whiteColor];
//  profileImageContainer.layer.cornerRadius = 5;
//  [self.profileHeaderView addSubview:profileImageContainer];
//  UIImageView *profileImage = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, 56, 56)];
//  profileImage.layer.cornerRadius = 3;
//  profileImage.clipsToBounds = YES;
//  [profileImageContainer addSubview:profileImage];
//  UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, 320, 20)];
//  userNameLabel.textColor = [UIColor whiteColor];
//  userNameLabel.font = [UIFont boldSystemFontOfSize:16];
//  userNameLabel.textAlignment = NSTextAlignmentCenter;
//  [self.profileHeaderView addSubview:userNameLabel];
//  UILabel *userScreenNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 108, 320, 20)];
//  userScreenNameLabel.textColor = [UIColor whiteColor];
//  userScreenNameLabel.font = [UIFont systemFontOfSize:13];
//  userScreenNameLabel.textAlignment = NSTextAlignmentCenter;
//  [self.profileHeaderView addSubview:userScreenNameLabel];
  
//  // populate the header views
//  if (self.user.bannerImageURL) {
//    UIImageView *bannerImageView = self.bannerImageView;
//    [Utils loadImageUrl:self.user.bannerImageURL inImageView:bannerImageView withAnimation:YES success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//      self.bannerImage = image;
//      self.bannerImageView.image = image;
//    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
//      NSLog(@"%@", error);
//    }];
//  }
//  else {
//    self.bannerImageView.backgroundColor = [UIColor darkGrayColor];
//  }
//
//#warning TODO convert saved BG color to UIColor  
//  [Utils loadImageUrl:self.user.profileImageURL inImageView:profileImage withAnimation:YES];
//  userNameLabel.text = self.user.name;
//  userScreenNameLabel.text = [NSString stringWithFormat:@"@%@", self.user.screenName];
  self.profileTableView.tableHeaderView = self.profileHeaderView;
  
  // fetch the tweets
  [self fetchTweets:TwitterClientEndpointMyTweets];
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
  return self.tweets.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 112;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  CGSize size;
  if (indexPath.row == 0) {
    self.stubStatsCell.user = self.user;
    [self.stubStatsCell layoutSubviews];
    size = [self.stubStatsCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
  }
  else {
    self.stubTweetCell.tweet = self.tweets[indexPath.row];
    [self.stubTweetCell layoutSubviews];
    size = [self.stubTweetCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
  }
  
  return size.height + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 0) {
    UserStatsCell *userStatsCell = [tableView dequeueReusableCellWithIdentifier:@"UserStatsCell" forIndexPath:indexPath];
    userStatsCell.user = self.user;
    return userStatsCell;
  }
  
  TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
  cell.tweet = self.tweets[indexPath.row - 1];
  cell.delegate = self;
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  if (indexPath.row != 0) {
    TweetViewController *vc = [[TweetViewController alloc] init];
    vc.tweet = self.tweets[indexPath.row - 1];
    [self.navigationController pushViewController:vc animated:YES];
  }
}

#pragma mark - TweetCell & ProfileHeaderView Delegate

- (void)onTapProfileImage:(User *)user {
  ProfileViewController *vc = [[ProfileViewController alloc] init];
  vc.user = user;
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

@end
