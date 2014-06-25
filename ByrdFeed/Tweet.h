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
@property (strong, nonatomic) NSString *createdAt;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *screenName;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSURL *profileImageURL;
@property (nonatomic, assign) NSInteger followerCount;
@property (nonatomic, assign) NSInteger favoritesCount;
@property (nonatomic, assign) NSInteger retweetCount;
@property (nonatomic, assign) NSInteger isRetweeted;
@property (nonatomic, assign) NSInteger isFavorited;

+ (NSArray *)tweetsWithArray:(NSArray *)array;
- (Tweet *)initWithDictionary:(NSDictionary *)tweetDictionary;

@end
