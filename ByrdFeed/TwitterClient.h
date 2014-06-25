//
//  TwitterClient.h
//  ByrdFeed
//
//  Takes care of HTTP/HTTPS requests
//
//  Created by Eddie Freeman on 6/22/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"

typedef enum  {
  TwitterClientEndpointUser,
  TwitterClientEndpointTimeline,
  TwitterClientEndpointAddTweet,
  TwitterClientEndpointReply,
  TwitterClientEndpointRetweet,
  TwitterClientEndpointFavorite,
  TwitterClientEndpointUnfavorite,
  TwitterClientEndpointMentions,
  TwitterClientEndpointMyTweets
} TwitterClientEndpointType;

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *)sharedInstance;

- (BOOL)processAuthResponseURL:(NSURL *)url onSuccess:(void (^)(void))success;
- (AFHTTPRequestOperation *)getWithEndpointType:(TwitterClientEndpointType)endpointType success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (AFHTTPRequestOperation *)postWithEndpointType:(TwitterClientEndpointType)endpointType parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)login;
- (BOOL)isLoggedIn;
- (User *)getCurrentUser;

@end