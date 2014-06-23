//
//  User.m
//  ByrdFeed
//
//  Created by Eddie Freeman on 6/22/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "User.h"

@implementation User

static User *currentUser = nil;

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{
           @"identifier"      : @"id",
           @"realName"        : @"name",
           @"userName"        : @"screen_name",
           @"tweetCount"      : @"tweet_count",
           @"imageURL"        : @"image_url",
           @"location"        : @"location"
           };
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
    NSData *archivedObject = [[NSUserDefaults standardUserDefaults] objectForKey:@"current_user"];
    currentUser = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:archivedObject];
	}
  
	return currentUser;
}

+ (NSString *)getFormattedUserName:(NSString *)userName {
	return [@"@" stringByAppendingString:userName];
}

- (void)setAsCurrentUser {
	currentUser = self;
	/* save to user defaults */
  NSData *archivedObject = [NSKeyedArchiver archivedDataWithRootObject:currentUser];
  [[NSUserDefaults standardUserDefaults] setObject:archivedObject forKey:@"current_user"];
  /* notify others */
//  [[NSNotificationCenter defaultCenter] postNotificationName:UserLoggedInNotification object:nil];
}

#pragma mark - Encoding/Decoding methods

- (id)initWithCoder:(NSCoder *)decoder {
  self = [super init];
  if(self) {
//    self.name = [decoder decodeObjectForKey:<key_for_property_name>];
//    // as height is a pointer
//    *self.height = [decoder decodeFloatForKey:<key_for_property_height>];
//    self.age = [decoder decodeIntForKey:<key_for_property_age>];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
//  [encoder encodeObject:self.name forKey:<key_for_property_name>];
//  //as height is a pointer
//  [encoder encodeFloat:*self.height forKey:<key_for_property_height>]
//  [encoder encodeInt:self.age forKey:<key_for_property_age>];
}

@end