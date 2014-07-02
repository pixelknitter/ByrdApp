//
//  User.m
//  ByrdFeed
//
//  Created by Eddie Freeman on 6/22/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "User.h"
#import "Constants.h"

@implementation User



static __strong User *currentUser = nil;

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{
           @"userID"          : @"id",
           @"name"            : @"name",
           @"screenName"      : @"screen_name",
           @"tweetCount"      : @"statuses_count",
           @"followerCount"   : @"followers_count",
           @"followingCount"  : @"friends_count",
           @"bannerImageURL"  : @"profile_background_image_url",
           @"profileImageURL" : @"profile_image_url",
           @"location"        : @"location",
           @"backgroundColor" : @"profile_background_color",
           @"description"     : @"description"
           };
}

+ (NSValueTransformer *)profileImageURLJSONTransformer {
  return [MTLValueTransformer reversibleTransformerWithBlock:^id(NSString *str) {
    return [NSURL URLWithString:[str stringByReplacingOccurrencesOfString:@"normal" withString:@"bigger"]];
  }];
}

+ (NSValueTransformer *)bannerImageURLJSONTransformer {
  return [MTLValueTransformer reversibleTransformerWithBlock:^id(NSString *str) {
    return [NSURL URLWithString:[str stringByReplacingOccurrencesOfString:@"normal" withString:@"bigger"]];
  }];
}

+ (NSValueTransformer *)backgroundColorJSONTransformer {
  return [MTLValueTransformer reversibleTransformerWithBlock:^id(NSString *str) {
    return [self colorWithHexString:str];
  }];
}

#warning TODO convert saved BG color to UIColor

+ (User*)initWithDictionary:(NSDictionary *)userDictionary {
  NSError *error = nil;
  
  User *user = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:userDictionary error:&error];
  if(!error) {
    
    return user;
  } else {
    NSLog(@"%@", error);
  }
  
  return nil;
}

+ (NSArray *)usersWithArray:(NSArray *)array {
  NSError *error = nil;
  
  NSMutableArray *users = [[NSMutableArray alloc] init];
  for (NSDictionary *dictionary in array) {
    User *user = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:dictionary error:&error];
    if(!error) {
      [users addObject:user];
    } else {
      NSLog(@"%@", error);
    }
  }
  
  return users;
}

+ (UIColor*)colorWithHexString:(NSString*)hex
{
  NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
  
  // String should be 6 or 8 characters
  if ([cString length] < 6) return [UIColor grayColor];
  
  // strip 0X if it appears
  if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
  
  if ([cString length] != 6) return  [UIColor grayColor];
  
  // Separate into r, g, b substrings
  NSRange range;
  range.location = 0;
  range.length = 2;
  NSString *rString = [cString substringWithRange:range];
  
  range.location = 2;
  NSString *gString = [cString substringWithRange:range];
  
  range.location = 4;
  NSString *bString = [cString substringWithRange:range];
  
  // Scan values
  unsigned int r, g, b;
  [[NSScanner scannerWithString:rString] scanHexInt:&r];
  [[NSScanner scannerWithString:gString] scanHexInt:&g];
  [[NSScanner scannerWithString:bString] scanHexInt:&b];
  
  return [UIColor colorWithRed:((float) r / 255.0f)
                         green:((float) g / 255.0f)
                          blue:((float) b / 255.0f)
                         alpha:1.0f];
}


+ (User *)currentUser {
  if (currentUser == nil){
      NSData *archivedObject = [[NSUserDefaults standardUserDefaults] objectForKey:CURRENT_USER_KEY];
      currentUser = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:archivedObject];
      NSLog(@"User Grabbed: %@", currentUser.screenName);
	}
  [[NSUserDefaults standardUserDefaults] synchronize];
	return currentUser;
}

+ (BOOL)resetCurrentUser {
  if (currentUser != nil) {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:CURRENT_USER_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    currentUser = nil;
    [[NSUserDefaults standardUserDefaults] synchronize];
  }
  return YES;
}

+ (NSString *)getFormattedUserName:(NSString *)userName {
	return [@"@" stringByAppendingString:userName];
}

- (void)setAsCurrentUser {
	currentUser = self;
	/* save to user defaults */
  NSData *archivedObject = [NSKeyedArchiver archivedDataWithRootObject:currentUser];
  [[NSUserDefaults standardUserDefaults] setObject:archivedObject forKey:CURRENT_USER_KEY];
  /* notify others */
  [[NSNotificationCenter defaultCenter] postNotificationName:UserLoggedInNotification object:nil];
}

@end
