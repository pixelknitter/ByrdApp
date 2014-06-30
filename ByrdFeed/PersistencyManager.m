//
//  PersistencyManager.m
//  ByrdFeed
//
//  Created by Eddie Freeman on 6/22/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "PersistencyManager.h"

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
  }
  return self;
}

- (NSArray*)getTweets {
  NSArray *tweets;
  
  return tweets;
}

- (void)addTweet:(Tweet*)tweet atIndex:(int)index {
  
}

- (void)deleteTweetAtIndex:(int)index {
  
}

@end
