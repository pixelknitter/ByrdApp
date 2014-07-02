//
//  PersistencyManager.m
//  ByrdFeed
//
//  Created by Eddie Freeman on 6/22/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "PersistencyManager.h"
#import "Constants.h"
#import "Utils.h"

@interface PersistencyManager()

@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, strong) NSMutableArray *users; // for multiple users
@property (nonatomic, strong) User *currentUser;

@end

@implementation PersistencyManager

- (id)init
{
  self = [super init];
  if (self) {
    // a dummy list of tweets
    _tweets = [NSMutableArray arrayWithArray:
               @[[[Tweet alloc] init] // TODO add actual init
                 ]
               ];
    _users = [NSMutableArray arrayWithArray:
              @[[[User alloc] init] // TODO add actual init
                ]
              ];
#warning TODO implement init of Persistency Manager
  }
  return self;
}

- (NSArray*)getTweets {
  return self.tweets;
}

- (void)addTweet:(Tweet*)tweet atIndex:(int)index {
  [self.tweets insertObject:tweet atIndex:index];
}

- (void)deleteTweetAtIndex:(int)index {
  [self.tweets removeObjectAtIndex:index];
}

- (NSArray*)getUsers {
  return self.users;
}

- (void)addUser:(User*)user atIndex:(int)index {
  [self.users insertObject:user atIndex:index];
}

- (void)deleteUserAtIndex:(int)index {
  [self.users removeObjectAtIndex:index];
}

- (User *)getCurrentUser {
  return [User currentUser];
}

- (void)setAsCurrentUser {
	self.currentUser = [User currentUser];
	/* save to user defaults */
  NSData *archivedObject = [NSKeyedArchiver archivedDataWithRootObject:self.currentUser];
  [[NSUserDefaults standardUserDefaults] setObject:archivedObject forKey:CURRENT_USER_KEY];
  /* notify others */
  [[NSNotificationCenter defaultCenter] postNotificationName:UserLoggedInNotification object:nil];
}



@end
