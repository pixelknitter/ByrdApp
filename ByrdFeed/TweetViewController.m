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
  
  if (_tweet.retweetCount > 0 || _tweet.favoritesCount > 0){
    self.showStatus = true;
  }else{
    self.showStatus = false;
  }
  
  self.usernameLabel.text = _tweet.screenName;
  self.userLabel.text = _tweet.userName;
  self.tweetLabel.text = _tweet.text;
  self.retweetsCountLabel.text = [NSString stringWithFormat:@"%d", _tweet.retweetCount];
  self.favoritesCountLabel.text = [NSString stringWithFormat:@"%d", _tweet.favoritesCount];
  [Utils loadImageUrl:_tweet.profileImageURL inImageView:self.profileImageView withAnimation:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)replyButton:(id)sender {
}

- (IBAction)retweetButton:(id)sender {
}

- (IBAction)favoriteButton:(id)sender {
}


- (void) didClickReply:(Tweet *)replyCell {
  [self onComposeButton];
}

- (void) didClickRetweet:(Tweet *)tweet {
  
  [[TwitterClient sharedInstance] postWithEndpointType:TwitterClientEndpointRetweet parameters:
   @{
     @"id": _tweet.tweetID
     } success:^(AFHTTPRequestOperation *operation, id responseObject){
       _tweet.isRetweeted = true;
       _tweet.retweetCount++;
       
       self.showStatus = true;
//       [self.tweetTable reloadData];
       
       /* update retweet icon */
     } failure:^(AFHTTPRequestOperation *operation, NSError *error){
       NSLog(@"Error tweeting: %@", error);
       
     }];
  
}

- (void) didClickFavorite:(Tweet *)tweet {
  
  TwitterClientEndpointType type = tweet.isFavorited ? TwitterClientEndpointUnfavorite : TwitterClientEndpointFavorite;
  
  _tweet.isFavorited = !tweet.isFavorited;
  if (_tweet.isFavorited){
    _tweet.favoritesCount++;
    self.showStatus = true;
  }else{
    _tweet.favoritesCount--;
    if (_tweet.favoritesCount == 0){
      self.showStatus = false;
    }
  }
  
  [[TwitterClient sharedInstance] postWithEndpointType:type parameters:
   @{
     @"id": tweet.tweetID
     } success:^(AFHTTPRequestOperation *operation, id responseObject){
       
       
       /* update retweet icon */
     } failure:^(AFHTTPRequestOperation *operation, NSError *error){
       
       _tweet.isFavorited = !tweet.isFavorited;
       if (_tweet.isFavorited){
         _tweet.favoritesCount++;
         self.showStatus = true;
       }else{
         _tweet.favoritesCount--;
         if (_tweet.favoritesCount == 0){
           self.showStatus = false;
         }
       }
       NSLog(@"Error tweeting: %@", error);
     }];
  
}


#pragma mark - private

- (void) onComposeButton {
  ComposeTweetViewController *composeView = [[ComposeTweetViewController alloc] init];
//  composeView.replyTo = [ASUser getFormattedScreenName:self.tweet.user.screenName];
//  composeView.replyIdStr = self.tweet.tweetIdStr;
  
  [UIView  beginAnimations: @"ShowCompose"context: nil];
  [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
  [UIView setAnimationDuration:0.75];
  [self.navigationController pushViewController: composeView animated:NO];
  [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
  [UIView commitAnimations];
}

@end
