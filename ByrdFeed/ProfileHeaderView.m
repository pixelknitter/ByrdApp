//
//  ProfileHeaderView.m
//  ByrdFeed
//
//  Created by Eddie Freeman on 7/1/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "ProfileHeaderView.h"

@interface ProfileHeaderView ()


@end

@implementation ProfileHeaderView

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    UINib *nib = [UINib nibWithNibName:@"ProfileHeaderView" bundle:nil];
    NSArray *objects = [nib instantiateWithOwner:self options:nil];
    
    UIView *subview = objects[0];
    self.frame = subview.frame;
    [self addSubview:objects[0]];
  }
  return self;
}

- (void)setUser:(User *)user {
  _user = user;
  [self reloadData];
}

- (void)reloadData {
  
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
