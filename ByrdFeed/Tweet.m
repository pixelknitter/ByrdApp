//
//  Tweet.m
//  ByrdFeed
//
//  Created by Eddie Freeman on 6/22/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{
           @"tweetID"         : @"id",
           @"text"            : @"text",
           @"user"            : @"user",
           @"createdAt"       : @"created_at",
           @"retweeted"       : @"retweeted",
           @"retweetCount"    : @"retweet_count",
           @"favoritesCount"  : @"favourites_count"
           };
}

+ (NSValueTransformer *)userJSONTransformer {
  return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[User class]];
}

+ (NSArray *)tweetsWithArray:(NSArray *)array {
  NSError *error = nil;
  
  NSMutableArray *tweets = [[NSMutableArray alloc] init];
  for (NSDictionary *dictionary in array) {
    Tweet *tweet = [MTLJSONAdapter modelOfClass:[Tweet class] fromJSONDictionary:dictionary error:&error];
    if(!error) {
      [tweets addObject:tweet];
    } else {
      NSLog(@"%@", error);
    }
  }
  
  return tweets;
}

@end
