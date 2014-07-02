//
//  TweetViewController.m
//  ByrdFeed
//
//  Created by Eddie Freeman on 6/22/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "Constants.h"
#import "Utils.h"
#import "TweetViewController.h"
#import "TwitterClient.h"
#import "ComposeTweetViewController.h"

@interface TweetViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoritesCountLabel;

@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@property (nonatomic, assign) BOOL showStatus;

- (IBAction)replyButton:(id)sender;
- (IBAction)retweetButton:(id)sender;
- (IBAction)favoriteButton:(id)sender;
@end

@implementation TweetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTweet:) name:UserLoggedInNotification object:_tweet];
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  
//  self.navigationItem.backBarButtonItem.tintColor = [UIColor whiteColor];
  
  self.title = @"Tweet";
  
  if (_tweet.retweetCount > 0 || _tweet.favoritesCount > 0){
    self.showStatus = true;
  }
  else{
    self.showStatus = false;
  }
  
  if (_tweet.isFavorited) {
    [self.favoriteButton setImage:[UIImage imageNamed:@"favorite_on.png"] forState:UIControlStateSelected];
    self.favoriteButton.selected = YES;
  }
  
  if (_tweet.isRetweeted) {
    [self.retweetButton setImage:[UIImage imageNamed:@"retweet_on.png"] forState:UIControlStateSelected];
    self.retweetButton.selected = YES;
  }
  
  self.usernameLabel.text = _tweet.user.screenName;
  self.userLabel.text = _tweet.user.name;
  self.tweetLabel.text = _tweet.text;
  self.retweetsCountLabel.text = [NSString stringWithFormat:@"%d", _tweet.retweetCount];
  self.favoritesCountLabel.text = [NSString stringWithFormat:@"%d", _tweet.favoritesCount];
  [Utils loadImageUrl:_tweet.user.profileImageURL inImageView:self.profileImageView withAnimation:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)replyButton:(id)sender {
  [self onComposeButton];
}

- (IBAction)retweetButton:(id)sender {
  if (![sender isSelected]) {
    [sender setImage:[UIImage imageNamed:@"retweet_on.png"] forState:UIControlStateSelected];
    [sender setSelected:YES];
    [self didClickRetweet];
  }
}

- (IBAction)favoriteButton:(id)sender {
  if ([sender isSelected]) {
    [sender setImage:[UIImage imageNamed:@"favorite.png"] forState:UIControlStateNormal];
    [sender setSelected:NO];
  } else {
    [sender setImage:[UIImage imageNamed:@"favorite_on.png"] forState:UIControlStateSelected];
    [sender setSelected:YES];
  }
  [self didClickFavorite];
}

- (void) didClickRetweet {
  
  [[TwitterClient sharedInstance] postWithEndpointType:TwitterClientEndpointRetweet parameters:
   @{
     @"id": _tweet.tweetID
     } success:^(AFHTTPRequestOperation *operation, id responseObject){
       // Togggle
//       _tweet.isRetweeted = !_tweet.isRetweeted;
       _tweet.isRetweeted = YES;
       _tweet.retweetCount++;
//       if (_tweet.isRetweeted) {
//         _tweet.retweetCount++;
//         self.showStatus = YES;
//       }
//       else {
//         _tweet.isRetweeted--;
//         if (_tweet.retweetCount == 0){
//           self.showStatus = YES;
//         }
//       }
       
       /* update retweet icon */
       self.retweetsCountLabel.text = [NSString stringWithFormat:@"%d", _tweet.retweetCount];
       self.showStatus = YES;
     } failure:^(AFHTTPRequestOperation *operation, NSError *error){
       NSLog(@"Error tweeting: %@", error);
       
     }];
  
}

- (void) didClickFavorite {
  
  TwitterClientEndpointType type = _tweet.isFavorited ? TwitterClientEndpointUnfavorite : TwitterClientEndpointFavorite;

  [[TwitterClient sharedInstance] postWithEndpointType:type parameters:
   @{
     @"id": _tweet.tweetID
     } success:^(AFHTTPRequestOperation *operation, id responseObject){
       _tweet.isFavorited = !_tweet.isFavorited;
       if (_tweet.isFavorited) {
         _tweet.favoritesCount++;
         self.showStatus = YES;
       }
       else {
         _tweet.favoritesCount--;
         if (_tweet.favoritesCount == 0){
           self.showStatus = YES;
         }
       }
       
       /* update favorites icon */
       self.favoritesCountLabel.text = [NSString stringWithFormat:@"%d", _tweet.favoritesCount];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error){
       NSLog(@"Error tweeting: %@", error);
     }];
}

#pragma mark - private

- (void) onComposeButton {
  ComposeTweetViewController *composeView = [[ComposeTweetViewController alloc] init];
#warning TODO Refactor to not use properties
  composeView.replyTo = [User getFormattedUserName:_tweet.user.screenName];
  composeView.replyIdStr = self.tweet.tweetID;
  
  [UIView  beginAnimations:@"ShowCompose" context: nil];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
  [UIView setAnimationDuration:0.75];
  [self.navigationController pushViewController:composeView animated:NO];
  [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
  [UIView commitAnimations];
}

@end
