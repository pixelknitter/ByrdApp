//
//  UserBoxView.m
//  ByrdFeed
//
//  Created by Eddie Freeman on 7/1/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "UserBoxView.h"
#import "Utils.h"

@interface UserBoxView ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;

@end


@implementation UserBoxView

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapProfileImage)];
    [self.profileImageView addGestureRecognizer:tapGestureRecognizer];
    
    // Initialization code
    self = [[[NSBundle mainBundle] loadNibNamed:@"UserBoxView" owner:self options:nil] lastObject];
  }
  return self;
}

- (void)setUser:(User *)user {
  _user = user;
  [self reloadData];
}

- (void)reloadData {
  _profileImageView = nil;
  
#warning TODO convert saved BG color to UIColor
  [Utils loadImageUrl:_user.profileImageURL inImageView:self.profileImageView withAnimation:YES];
  _nameLabel.text = _user.name;
  _screenNameLabel.text = [User getFormattedUserName:_user.screenName];
}

- (void)onTapProfileImage {
  [self.delegate onTapProfileImage:self.user];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
