//
//  UserBoxView.h
//  ByrdFeed
//
//  Created by Eddie Freeman on 7/1/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@protocol UserBoxViewDelegate <NSObject>

@required
- (void)didTapProfileImage;

@end

@interface UserBoxView : UIView

@property (strong, nonatomic) User *user;

@end
