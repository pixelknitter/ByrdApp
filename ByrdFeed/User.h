//
//  User.h
//  ByrdFeed
//
//  Created by Eddie Freeman on 6/22/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "Mantle.h"

@interface User : MTLModel <MTLJSONSerializing, NSCoding>

@property (strong, nonatomic) NSString *screenName;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) UIColor *backgroundColor;
@property (strong, nonatomic) NSURL *bannerImageURL;
@property (strong, nonatomic) NSURL *profileImageURL;
@property (nonatomic) NSInteger userID;
@property (nonatomic) NSInteger followerCount;
@property (nonatomic) NSInteger followingCount;
@property (nonatomic) NSInteger tweetCount;

+ (User *)currentUser;
+ (NSString *)getFormattedUserName:(NSString *)userName;

- (void)setAsCurrentUser;
+ (BOOL)resetCurrentUser;

+ (User*)initWithDictionary:(NSDictionary *)userDictionary;

@end
