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
           @"followerCount"   : @"follower_count",
//           @"followingCount"  : @"following_count",
           @"pbackImageURL"   : @"profile_background_image_url",
           @"profileImageURL" : @"profile_image_url",
           @"location"        : @"location",
           @"description"     : @"description"
           };
}

+ (NSValueTransformer *)profileImageURLJSONTransformer {
  return [MTLValueTransformer reversibleTransformerWithBlock:^id(NSString *str) {
    return [NSURL URLWithString:[str stringByReplacingOccurrencesOfString:@"normal" withString:@"bigger"]];
  }];
}

+ (NSValueTransformer *)pbackImageURLURLJSONTransformer {
  return [MTLValueTransformer reversibleTransformerWithBlock:^id(NSString *str) {
    return [NSURL URLWithString:[str stringByReplacingOccurrencesOfString:@"normal" withString:@"bigger"]];
  }];
}

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
