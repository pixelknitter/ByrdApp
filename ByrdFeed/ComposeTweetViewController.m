//
//  ComposeTweetViewController.m
//  ByrdFeed
//
//  Created by Eddie Freeman on 6/22/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "ComposeTweetViewController.h"
#import "TwitterClient.h"
#import "Constants.h"
#import "Tweet.h"
#import "User.h"
#import "Utils.h"

@interface ComposeTweetViewController ()
@property (weak, nonatomic) IBOutlet UITextView *tweetTextField;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

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
  // Do any additional setup after loading the view from its nib.
  
  // Get Current User
  User *user = [[TwitterClient sharedInstance] getCurrentUser];
  
  // load user data
  [Utils loadImageUrl:user.profileImageURL inImageView:self.profileImageView withAnimation:YES];
  
  self.userLabel.text = user.realName;
  self.usernameLabel.text = [User getFormattedUserName:user.userName];
  
  // setup the navigation bar
  self.navigationItem.title = @"Compose Tweet";
  UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
  UIBarButtonItem *tweetButton = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStyleDone target:self action:@selector(sendTweet)];
  self.navigationItem.leftBarButtonItem = cancelButton;
  self.navigationItem.rightBarButtonItem = tweetButton;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)sendTweet {
  
}

- (void)cancel {
  [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return NO;
}

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//#warning if reply, add the reply signature here
//  return YES;
//}

@end
