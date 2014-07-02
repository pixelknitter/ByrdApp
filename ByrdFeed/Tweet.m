//
//  Tweet.m
//  ByrdFeed
//
//  Created by Eddie Freeman on 6/22/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "Tweet.h"
#import "MHPrettyDate.h"

@implementation Tweet

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{
           @"tweetID"           : @"id_str",
           @"text"              : @"text",
           @"user"              : @"user",
           @"createdAt"         : @"created_at",
           @"isRetweeted"       : @"retweeted",
           @"isFavorited"       : @"favorited",
           @"retweetCount"      : @"retweet_count",
           @"favoritesCount"    : @"favorite_count"
           };
}

+ (NSDateFormatter *)dateFormatter {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
  dateFormatter.dateFormat = @"EEE MMM d HH:mm:ss ZZZZ yyyy";
  return dateFormatter;
}

+ (NSValueTransformer *)userJSONTransformer
{
  return [MTLValueTransformer transformerWithBlock:^(NSDictionary *dict) {
    return [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:dict error:nil];
  }];
}

+ (NSValueTransformer *)createdAtJSONTransformer {
  return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
    NSDate *date = [[Tweet dateFormatter] dateFromString:str];
    return [MHPrettyDate prettyDateFromDate:date withFormat:MHPrettyDateShortRelativeTime];
  } reverseBlock:^(NSDate *date) {
    return [[Tweet dateFormatter] stringFromDate:date];
  }];
}

+ (NSValueTransformer *)profileImageURLJSONTransformer {
  return [MTLValueTransformer reversibleTransformerWithBlock:^id(NSString *str) {
    return [NSURL URLWithString:[str stringByReplacingOccurrencesOfString:@"normal" withString:@"bigger"]];
  }];
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

- (Tweet *)initWithDictionary:(NSDictionary *)tweetDictionary {
  NSError *error = nil;
  
  Tweet *tweet = [MTLJSONAdapter modelOfClass:[Tweet class] fromJSONDictionary:tweetDictionary error:&error];
  if(!error) {
    return tweet;
  } else {
    NSLog(@"%@", error);
  }
  
  return nil;
}

@end
