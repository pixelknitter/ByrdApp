//
//  ComposeTweetViewController.m
//  ByrdFeed
//
//  Created by Eddie Freeman on 6/22/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#define TWEET_CHARACTER_COUNT 140

#import "ComposeTweetViewController.h"
#import "TSMessage.h"
#import "TwitterClient.h"
#import "Constants.h"
#import "User.h"
#import "Utils.h"

@interface ComposeTweetViewController ()
@property (weak, nonatomic) IBOutlet UITextView *tweetTextField;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@property (strong, nonatomic) UIBarButtonItem *characterCount;

@end

@implementation ComposeTweetViewController

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
  self.tweetTextField.delegate = self;
  
  UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
  cancelButton.tintColor = [UIColor whiteColor];
  
  self.navigationItem.leftBarButtonItem = cancelButton;
  
  UIBarButtonItem *tweetButton = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(sendTweet)];
  tweetButton.enabled = false;
  tweetButton.tintColor = [UIColor whiteColor];
  
  self.characterCount = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"%d", TWEET_CHARACTER_COUNT - _replyTo.length] style:UIBarButtonItemStylePlain target:self action:nil];
  self.characterCount.enabled = false;
  self.characterCount.tintColor = [UIColor whiteColor];

  // setup the navigation bar
  self.navigationItem.title = @"Compose Tweet";
  self.navigationItem.leftBarButtonItem = cancelButton;
  self.navigationItem.rightBarButtonItem = tweetButton;
  
  self.navigationItem.rightBarButtonItems = @[tweetButton, self.characterCount];
  
  if (_replyTo != nil){
    self.tweetTextField.text = [_replyTo stringByAppendingString:@" "];
  }else{
    self.tweetTextField.text = @"";
  }
  
  // Get Current User
  User *user = [[TwitterClient sharedInstance] getCurrentUser];
  
  // load user data
  [Utils loadImageUrl:user.profileImageURL inImageView:self.profileImageView withAnimation:YES];
  
  self.userLabel.text = user.name;
  self.usernameLabel.text = [User getFormattedUserName:user.screenName];
  
  [self.tweetTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)textViewDidChange:(UITextView *)textView {
  
  self.characterCount.title = [@(140 - textView.text.length) stringValue];
  
  if (textView.text.length > 140 || textView.text.length == 0){
    self.navigationItem.rightBarButtonItem.enabled = false;
  }
  self.navigationItem.rightBarButtonItem.enabled = true;
  
}

- (void)sendTweet {
  [[TwitterClient sharedInstance] postWithEndpointType:TwitterClientEndpointAddTweet
                                            parameters:@{
                                                         @"status": self.tweetTextField.text,
                                                         @"in_reply_to_status_id": _replyIdStr ? _replyIdStr : @""
                                                         }
                                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                 Tweet *newTweet = [[Tweet alloc] initWithDictionary:responseObject error:nil];
                                                 /* notify observers */
                                                 [[NSNotificationCenter defaultCenter] postNotificationName:NewTweetCreatedNotification object:self userInfo:[NSDictionary dictionaryWithObject:newTweet forKey:@"tweet"]];
                                                 [UIView animateWithDuration:0.75 animations:^{
                                                   [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
                                                   [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
                                                   [self.navigationController popViewControllerAnimated:NO];
                                                 } completion:nil];

                                               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                 [TSMessage showNotificationInViewController:self title:@"Tweet Failed!" subtitle:@"Try again later" type:TSMessageNotificationTypeError duration:1.0];
  }];
}

- (void)cancel {
  [UIView animateWithDuration:0.75 animations:^{
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
    [self.navigationController popViewControllerAnimated:NO];
  } completion:nil];
}

#pragma UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
  if (textView.text.length + text.length > 140){
    self.navigationItem.rightBarButtonItem.enabled = false;
    return NO;
  }
  
  self.navigationItem.rightBarButtonItem.enabled = true;
  return YES;
}

- (BOOL)automaticallyAdjustsScrollViewInsets {
  return NO;
}

@end
