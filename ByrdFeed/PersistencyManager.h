//
//  PersistencyManager.h
//  ByrdFeed
//
//  Created by Eddie Freeman on 6/22/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tweet.h"
#import "User.h"

@interface PersistencyManager : NSObject

- (NSArray*)getTweets;
- (void)addTweet:(Tweet*)album atIndex:(int)index;
- (void)deleteTweetAtIndex:(int)index;

@end
