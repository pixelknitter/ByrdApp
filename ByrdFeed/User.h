//
//  User.h
//  ByrdFeed
//
//  Created by Eddie Freeman on 6/22/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "Mantle.h"

@interface User : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *realName;
@property (strong, nonatomic) NSString *location;
//@property (strong, nonatomic) NSString *profileBackgroundColor;
//@property (strong, nonatomic) NSString *profileBackgroundImageURL;
@property (strong, nonatomic) NSString *profileImageURL;
@property (nonatomic, assign) NSInteger userID;
//@property (nonatomic, assign) NSInteger followingCount;
@property (nonatomic, assign) NSInteger followersCount;
@property (nonatomic, assign) NSInteger tweetCount;

+ (User *)currentUser;
+ (NSString *)getFormattedUserName:(NSString *)userName;

- (void)setAsCurrentUser;

+ (User*)initWithDictionary:(NSDictionary *)userDictionary;

@end
