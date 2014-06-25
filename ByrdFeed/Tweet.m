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
           @"userName"          : @"user.name",
           @"screenName"        : @"user.screen_name",
           @"createdAt"         : @"created_at",
//           @"retweeted"         : @"retweeted",
//           @"favorited"         : @"favorited",
//           @"retweetCount"      : @"retweet_count",
//           @"favoritesCount"    : @"favourites_count",
           @"profileImageURL"   : @"user.profile_image_url"
           };
}

+ (NSDateFormatter *)dateFormatter {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
  dateFormatter.dateFormat = @"EEE MMM d HH:mm:ss ZZZZ yyyy";
  return dateFormatter;
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



//- (NSString *)getTimeSinceString {
//  NSDate *todayDate = [NSDate date];
//  double ti = [self.createdAt timeIntervalSinceDate:todayDate];
//  ti = ti * -1;
//  if(ti < 1) {
//    return @"bt";
//  } else 	if (ti < 60) {
//    int diff = round(ti);
//    return [NSString stringWithFormat:@"%ds", diff];
//  } else if (ti < 3600) {
//    int diff = round(ti / 60);
//    return [NSString stringWithFormat:@"%dm", diff];
//  } else if (ti < 86400) {
//    int diff = round(ti / 60 / 60);
//    return[NSString stringWithFormat:@"%dh", diff];
//  } else if (ti < 2629743) {
//    int diff = round(ti / 60 / 60 / 24);
//    return[NSString stringWithFormat:@"%dd", diff];
//  } else {
//    return @"a while";
//  }
//}

@end
