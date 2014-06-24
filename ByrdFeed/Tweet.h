//
//  Tweet.h
//  ByrdFeed
//
//  Created by Eddie Freeman on 6/22/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "Mantle.h"
#import "User.h"

@interface Tweet : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString *tweetID;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *profileImageURL;
@property (strong, nonatomic) NSString *location;
@property (nonatomic) NSInteger tweetCount;
@property (nonatomic) NSInteger followingCount;
@property (nonatomic) NSInteger followerCount;

+ (NSArray *)tweetsWithArray:(NSArray *)array;

@end
