//
//  TimelineTableViewController.m
//  ByrdFeed
//
//  Created by Eddie Freeman on 6/22/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "TimelineTableViewController.h"
#import "TweetViewController.h"
#import "ComposeTweetViewController.h"
#import "MBProgressHUD.h"
#import "TweetCell.h"
#import "TSMessage.h"
#import "TwitterClient.h"
#import "Utils.h"
#import "Constants.h"

@interface TimelineTableViewController ()

@property (weak, nonatomic) IBOutlet UITableView *timelineTableView;
@property (strong, nonatomic) TweetCell *stubCell;

@property (strong, nonatomic) NSArray *tweets;

@end

@implementation TimelineTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Set up Subscriptions
    
    
    // Set up data storage
    
    // Set up TSMessage Defaults
    [TSMessage setDefaultViewController:self];
    [TSMessage iOS7StyleEnabled];
  }
  return self;
}

- (void)viewWillAppear:(BOOL)state {
  [super viewWillAppear:state];
  
  // TODO update when refresh or data retrieval event fires
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  if (self.tweets.count == 0){
    self.timelineTableView.hidden = true;
  }

  // Set Sign Out Button
  UIBarButtonItem *signOutButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(signOutClicked)];
  
  self.navigationItem.leftBarButtonItem = signOutButton;
  
  /* allow refresh on swipe down */
  UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
  [refreshControl addTarget:self action:@selector(fetchTweets) forControlEvents:UIControlEventValueChanged];
//  [self.timelineTableView addSubview:refreshControl];
  self.refreshControl = refreshControl;
  // Set Title
  self.title = @"Home";
  
  // Add Compose Button
  UIBarButtonItem *composeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(onComposeButton)];
  
  self.navigationItem.rightBarButtonItem = composeButton;
  
  // Set delegates and data source
  self.timelineTableView.dataSource = self;
  self.tableView.delegate = self;
  
  // instantiate the stub cell
  UINib *cellNib = [UINib nibWithNibName:@"TweetCell" bundle:nil];
  [self.timelineTableView registerNib:cellNib forCellReuseIdentifier:@"TweetCell"];
  
  self.stubCell = [cellNib instantiateWithOwner:nil options:nil][0];
  
  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;
  
  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

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
  Tweet *tweet = self.tweets[indexPath.row];
  cell.nameLabel.text = tweet.userName;
  cell.userLabel.text = [User getFormattedUserName:tweet.userName];
  [Utils loadImageUrl:[[NSURL alloc] initWithString:tweet.profileImageURL] inImageView:cell.profileImage withAnimation:YES];
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

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
  // Return NO if you do not want the item to be re-orderable.
  return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  // Create the next view controller.
  TweetViewController *tweetViewController = [[TweetViewController alloc] initWithNibName:nil bundle:nil];
  
  // Pass the selected object to the new view controller.
  [[NSNotificationCenter defaultCenter] postNotificationName:TweetClicked object:nil userInfo:[NSDictionary dictionaryWithObject:self.tweets[indexPath.row] forKey:@"tweet"]];
  
  // Push the view controller.
  [self.navigationController pushViewController:tweetViewController animated:YES];
}


#pragma mark - Data
- (void)fetchTweets {
  if(!self.refreshControl.isRefreshing) {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  }
  
  [[TwitterClient sharedInstance] getWithEndpointType:TwitterClientEndpointTimeline success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSLog(@"%@", responseObject);
    
    self.tweets = [Tweet tweetsWithArray:responseObject];
    
    if(![self.tweets count]) { // If no length
      [TSMessage showNotificationInViewController:self
                                            title:@"Oops, No Data"
                                         subtitle:@"Try sending a tweet!"
                                             type:TSMessageNotificationTypeWarning
                                         duration:1.f];
    }
    
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
                                       duration:1.f];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
  }];
  
  // Go back to Top of TableView
  [self.timelineTableView scrollRectToVisible:CGRectMake(0, 0, self.tableView.frame.size.width, 10) animated:NO];
}


#pragma mark - Button Selectors
- (void)signOutClicked {
  [[TwitterClient sharedInstance].requestSerializer removeAccessToken];
  
#warning TODO remove NSUserDefaults
#warning TODO remove currentUser
  
  [[NSNotificationCenter defaultCenter] postNotificationName:UserSignOutNotification object:nil userInfo:nil];
}

- (void)onComposeButton {
  [self onComposeButtonWithReply:nil];
}

- (void)onComposeButtonWithReply:(Tweet *)tweet {
  NSLog(@"Reply clicked");
  ComposeTweetViewController *composeViewController = [[ComposeTweetViewController alloc] initWithNibName:nil bundle:nil];
  NSDictionary *params = nil;
  
//  if (tweet != nil){
//    params = [NSDictionary dictionaryWithObject:@{
//                                                  @"replyIdStr": tweet.tweetIdStr,
//                                                  @"replyTo": tweet.user.screenName
//                                                  } forKey:@"compose"];
//  }
  
  [[NSNotificationCenter defaultCenter] postNotificationName:ComposeClicked object:nil userInfo:params];
  
  [self.navigationController pushViewController:composeViewController animated:YES];
}

@end

