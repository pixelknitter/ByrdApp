//
//  TimelineTableViewController.m
//  ByrdFeed
//
//  Created by Eddie Freeman on 6/22/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "TimelineTableViewController.h"
#import "LoginViewController.h"
#import "TweetViewController.h"
#import "ProfileViewController.h"
#import "ComposeTweetViewController.h"
#import "MBProgressHUD.h"
#import "TweetCell.h"
#import "TSMessage.h"
#import "TwitterClient.h"
#import "Utils.h"
#import "Constants.h"

@interface TimelineTableViewController () <TweetCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *timelineTableView;
@property (strong, nonatomic) TweetCell *stubCell;

@property (strong, nonatomic) NSArray *tweets;

@end

@implementation TimelineTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Set up TSMessage Defaults
    [TSMessage setDefaultViewController:self];
    [TSMessage iOS7StyleEnabled];
    
  }
  return self;
}

- (void)viewWillAppear:(BOOL)state {
  [super viewWillAppear:state];
  [self.tableView reloadData];
  // TODO update when refresh or data retrieval event fires
  
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  /* allow refresh on swipe down */
  UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
  [refreshControl addTarget:self action:@selector(fetchTweets) forControlEvents:UIControlEventValueChanged];
//  [self.timelineTableView addSubview:refreshControl];
  self.refreshControl = refreshControl;
  // Set Title
  
  
  
  // Add Compose Button
  UIBarButtonItem *composeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(onComposeButton)];
  composeButton.tintColor = [UIColor whiteColor];
  self.navigationItem.rightBarButtonItem = composeButton;
  
  // Set Inset for divider
  [self.timelineTableView setSeparatorInset:UIEdgeInsetsZero];
  
  // Set delegates and data source
  self.timelineTableView.dataSource = self;
  self.tableView.delegate = self;
  
  // instantiate the stub cell
  UINib *cellNib = [UINib nibWithNibName:@"TweetCell" bundle:nil];
  [self.timelineTableView registerNib:cellNib forCellReuseIdentifier:@"TweetCell"];
  
  self.stubCell = [cellNib instantiateWithOwner:nil options:nil][0];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)setType:(TwitterClientEndpointType)type {
  _type = type;
  
  // fetch tweets
  if([[TwitterClient sharedInstance] isLoggedIn]) {
    [self fetchTweets];
  }
  else {
    [TSMessage showNotificationInViewController:self title:@"" subtitle:@"" type:TSMessageNotificationTypeWarning duration:2.0 canBeDismissedByUser:YES];
#warning Add TSMessage that lets them reload without a tableview visible
  }
  
  // set title
  switch (_type) {
    case TwitterClientEndpointTimeline:
      self.title = @"Home";
      break;
    case TwitterClientEndpointMentions:
      self.title = @"My Mentions";
      break;
    default:
      self.title = @"Home";
      break;
  }
}

#pragma mark - Table View Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  // Return the number of rows in the section.
  return self.tweets.count;
}

- (void)configureCell:(TweetCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
  cell.tweet = self.tweets[indexPath.row];
  cell.delegate = self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  [self configureCell:self.stubCell atIndexPath:indexPath];
  [self.stubCell layoutSubviews];
  
  CGSize size = [self.stubCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
  return size.height + 1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 112;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
  [self configureCell:cell atIndexPath:indexPath];
  return cell;
}

#pragma mark - TweetCell Delegate

- (void)didTapProfileImage:(TweetCell *)cell {
  ProfileViewController *vc = [[ProfileViewController alloc] init];
  vc.user = cell.tweet.user;
  [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ComposeTweetViewController Delegate

- (void)didPostTweet:(Tweet *)tweet {
  NSArray *temp = @[tweet];
  self.tweets = [temp arrayByAddingObjectsFromArray:self.tweets];
  [self.timelineTableView reloadData];
}

#pragma mark - TableView Delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  // Create the next view controller.
  TweetViewController *tweetViewController = [[TweetViewController alloc] initWithNibName:nil bundle:nil];
  tweetViewController.tweet = self.tweets[indexPath.row];
  
  // Pass the selected object to the new view controller.
//  [[NSNotificationCenter defaultCenter] postNotificationName:TweetClicked object:self.tweets[indexPath.row] userInfo:[NSDictionary dictionaryWithObject:self.tweets[indexPath.row] forKey:@"tweet"]];
#warning this doesn't work
  
  // Push the view controller.
  [self.navigationController pushViewController:tweetViewController animated:YES];
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//  if (indexPath.row == self.tweets.count -1) {
//    Tweet *tweet = self.tweets[indexPath.row];
//    [self refreshTweets:tweet.tweetID];
//  }
//}

#pragma mark - Data
- (void)fetchTweets {
  NSLog(@"Fetching Tweets...");
  if(!self.refreshControl.isRefreshing) {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  }
  
  [[TwitterClient sharedInstance] getWithEndpointType:self.type parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    [self.timelineTableView scrollRectToVisible:CGRectMake(0, 0, self.tableView.frame.size.width, 10) animated:NO];
    
    [self.timelineTableView reloadData];
    // hide HUD
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.refreshControl endRefreshing];
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
  
//  if (self.tweets.count == 0){
//    self.timelineTableView.hidden = true;
//    // Add retry button
//  }
}

#pragma mark - Button Selectors
- (void)signOutClicked {
  // Deauthorize and more
  [[TwitterClient sharedInstance] deauthorize];
  [User resetCurrentUser];
  [[NSNotificationCenter defaultCenter] postNotificationName:UserSignOutNotification object:nil userInfo:nil];
  // Pop View Controller
  LoginViewController *loginViewController = [[LoginViewController alloc] init];
  [self presentViewController:loginViewController animated:YES completion:nil];
}

- (void)onComposeButton {
  NSLog(@"Compose a new Tweet clicked");
  [Crittercism leaveBreadcrumb:@""];
  [self onComposeButtonWithReply:nil];
}

- (void)onComposeButtonWithReply:(Tweet *)tweet {
  ComposeTweetViewController *composeViewController = [[ComposeTweetViewController alloc] initWithNibName:nil bundle:nil];
  NSDictionary *params = nil;
  
  if (tweet != nil) {
    [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"Compose w/ Reply to: %@@", tweet.user.screenName]];
    params = [NSDictionary dictionaryWithObject:@{
                                                  @"replyIdStr": tweet.tweetID,
                                                  @"replyTo": tweet.user.screenName
                                                  } forKey:@"compose"];
  }
  
  [[NSNotificationCenter defaultCenter] postNotificationName:ComposeClicked object:nil userInfo:params];
  
  [self.navigationController pushViewController:composeViewController animated:YES];
}

@end

