//
//  ProfileHeaderView.m
//  ByrdFeed
//
//  Created by Eddie Freeman on 7/1/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "ProfileHeaderView.h"
#import "Utils.h"

@interface ProfileHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;

@end

@implementation ProfileHeaderView

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapProfileImage)];
    [self.profileImageView addGestureRecognizer:tapGestureRecognizer];
    
    // Initialization code
    UINib *nib = [UINib nibWithNibName:@"ProfileHeaderView" bundle:nil];
    NSArray *objects = [nib instantiateWithOwner:self options:nil];
    
    self.profileImageView.layer.cornerRadius = 5;
    
    UIView *subview = objects[0];
    self.frame = subview.frame;
    [self addSubview:objects[0]];
  }
  return self;
}

- (void)setUser:(User *)user {
  _user = user;
  NSLog(@"Setting User");
  [self reloadData];
}

- (void)reloadData {
  self.bannerImageView = nil;
  self.profileImageView = nil;
  
  // populate the header views
  if (_user.bannerImageURL) {
    [Utils loadImageUrl:_user.bannerImageURL inImageView:self.bannerImageView withAnimation:YES success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
      self.bannerImageView.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
      NSLog(@"%@", error);
    }];
  }
  else {
    self.bannerImageView.backgroundColor = [UIColor darkGrayColor];
  }
  NSLog(@"Loading data");
#warning TODO convert saved BG color to UIColor
  [Utils loadImageUrl:_user.profileImageURL inImageView:self.profileImageView withAnimation:YES];
  self.nameLabel.text = _user.name;
  self.screenNameLabel.text = [User getFormattedUserName:_user.screenName];
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
