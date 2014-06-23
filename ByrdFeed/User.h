//
//  User.h
//  ByrdFeed
//
//  Created by Eddie Freeman on 6/22/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "Mantle.h"

@interface User : MTLModel <NSCoding>

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, assign) NSInteger followersCount;
@property (nonatomic, strong) NSString *realName;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *profileBackgroundColor;
@property (nonatomic, strong) NSString *profileBackgroundImageURL;
@property (nonatomic, strong) NSString *profileImageURL;
@property (nonatomic, assign) NSInteger followingCount;
@property (nonatomic, assign) NSInteger tweetCount;

+ (User *)currentUser;
+ (NSString *)getFormattedUserName:(NSString *)userName;

- (void)setAsCurrentUser;

@end
