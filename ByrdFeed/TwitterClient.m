//
//  TwitterClient.m
//  ByrdFeed
//
//  Created by Eddie Freeman on 6/22/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "TwitterClient.h"
#import "PersistencyManager.h"

#define TWITTER_BASE_URL @"https://api.twitter.com/"
#define TWITTER_CONSUMER_KEY @"6lZcSvOp60e0OX4an76Af3QpG"
#define TWITTER_CONSUMER_SECRET @"4zT4Wb6JkhXnoi4zJu9CBu7iaFuyssb4kJhMuKYBaphmGVRsM5"

#define TOKEN_REQUEST_PATH @"oauth/request_token"
#define TOKEN_ACCESS_PATH @"oauth/access_token"
#define APP_SCHEME @"nstwitter"
#define TOKEN_CALLBACK_PATH @"oauth"
#define TOKEN_AUTH_URL @"oauth/authorize?oauth_token=%@"

#define GET_USER_URL @"1.1/account/verify_credentials.json"
#define GET_TIMELINE_URL @"1.1/statuses/home_timeline.json"
#define POST_STATUS_UPDATE_URL @"1.1/statuses/update.json"
#define POST_STATUS_RETWEET_URL @"1.1/statuses/retweet/%@.json"
#define POST_STATUS_FAVORITE_URL @"1.1/favorites/create.json"
#define POST_STATUS_UNFAVORITE_URL @"1.1/favorites/destroy.json"
#define GET_MENTIONS_URL @"1.1/statuses/mentions_timeline.json"
#define GET_MY_TWEETS_URL @"1.1/statuses/user_timeline.json"

static NSString *TWITTER_API_KEY;
static NSString *TWITTER_API_SECRET;
static NSString *TWITTER_ACCESS_TOKEN;
static NSString *TWITTER_ACCESS_TOKEN_SECRET;

@implementation NSURL (dictionaryFromQueryString)
-(NSDictionary *) dictionaryFromQueryString{
  
  NSString *query = [self query];
  NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
  NSArray *pairs = [query componentsSeparatedByString:@"&"];
  
  for (NSString *pair in pairs) {
    NSArray *elements = [pair componentsSeparatedByString:@"="];
    NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [dict setObject:val forKey:key];
  }
  return dict;
}
@end

@interface TwitterClient()

@property (nonatomic, strong) PersistencyManager *persistencyManager;
@property (nonatomic, strong) TwitterClient *client;
//@property (nonatomic) BOOL isOnline;

@property (nonatomic, copy, readonly) BDBOAuthToken *accessToken;

//#pragma mark AccessToken
//- (BOOL)saveAccessToken:(BDBOAuthToken *)accessToken;
//- (BOOL)removeAccessToken;

@end

@implementation TwitterClient

- (id)init
{
  self = [super init];
  if (self) {
    _persistencyManager = [[PersistencyManager alloc] init];
//    _isOnline = NO;
  }
  return self;
}

+ (TwitterClient*)sharedInstance
{
  static TwitterClient *_sharedInstance = nil;
  static dispatch_once_t oncePredicate;
  
  dispatch_once(&oncePredicate, ^{
    
    /* read in api config from plist */
//    NSString *errorDesc = nil;
//    NSPropertyListFormat format;
//    NSString *plistPath;
//    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
//                                                              NSUserDomainMask, YES) objectAtIndex:0];
//    plistPath = [rootPath stringByAppendingPathComponent:@"TwitterAPI.plist"];
//    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
//      plistPath = [[NSBundle mainBundle] pathForResource:@"TwitterAPI" ofType:@"plist"];
//    }
//    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
//    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization
//                                          propertyListFromData:plistXML
//                                          mutabilityOption:NSPropertyListMutableContainersAndLeaves
//                                          format:&format
//                                          errorDescription:&errorDesc];
//    if (!temp) {
//      NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
//    }
//    
//    
//    TWITTER_API_KEY = [temp objectForKey:@"TWITTER_API_KEY"];
//    TWITTER_API_SECRET = [temp objectForKey:@"TWITTER_API_SECRET"];
//    TWITTER_ACCESS_TOKEN = [temp objectForKey:@"TWITTER_ACCESS_TOKEN"];
//    TWITTER_ACCESS_TOKEN_SECRET = [temp objectForKey:@"TWITTER_ACCESS_TOKEN_SECRET"];
    
    /* now create the instance */
    _sharedInstance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:TWITTER_BASE_URL] consumerKey:TWITTER_CONSUMER_KEY consumerSecret:TWITTER_CONSUMER_SECRET];
  });
  return _sharedInstance;
}

- (NSArray*)getTweets
{
  return [_persistencyManager getTweets];
}

- (void) login {
  /* remove any existing auth tokens */
	[self.requestSerializer removeAccessToken];
  
  NSURL *tokenCallbackURL = [NSURL URLWithString:[[APP_SCHEME stringByAppendingString:@"://"] stringByAppendingString:TOKEN_CALLBACK_PATH]];
  
  NSLog(@"Fetching Request Token...");
  [self fetchRequestTokenWithPath:TOKEN_REQUEST_PATH
                              method:@"POST"
                              callbackURL:tokenCallbackURL
                              scope:nil
                              success:^(BDBOAuthToken *requestToken) {
    NSLog(@"Success! Request Token received!");
                                
    NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:[TWITTER_BASE_URL stringByAppendingString:TOKEN_AUTH_URL], requestToken.token]];
    [[UIApplication sharedApplication] openURL:authURL];
  } failure:^(NSError *error) {
    NSLog(@"Failure: %@", error);
  }];
}

- (BOOL)processAuthResponseURL:(NSURL *)url onSuccess:(void (^)(void))success{
  if ([url.scheme  isEqual: APP_SCHEME]){
    if ([url.host  isEqual: TOKEN_CALLBACK_PATH]){
      NSDictionary *parameters = [url dictionaryFromQueryString];
      if (parameters[@"oauth_token"] && parameters[@"oauth_verifier"]) {
        [self fetchAccessTokenWithPath:TOKEN_ACCESS_PATH
                                method:@"POST"
                          requestToken:[BDBOAuthToken tokenWithQueryString:url.query]
                               success:^(BDBOAuthToken *accessToken) {
                                 // Save our access token
                                 [self.requestSerializer saveAccessToken:accessToken];
                                 
                                 // Call any subsequent success blocks
                                 success();
                               }
                               failure:^(NSError *error) {
                                 NSLog(@"Error: %@", error);
                               }];
        
      }
      return YES;
    }
  }
  return NO;
}

- (AFHTTPRequestOperation *)getWithEndpointType:(TwitterClientEndpointType)endpointType success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
  // TODO

//  NSString *endpointTypeStr = [[NSString alloc] init];
//  NSDictionary *parameters = nil;
//  
//  if (endpointType == ASTwitterAPIEndpointUser){
//    endpointTypeStr = GET_USER_URL;
//  } else if (endpointType == ASTwitterAPIEndpointTimeline){
//    endpointTypeStr = GET_TIMELINE_URL;
//    
//    parameters = @{
//                   @"count": @(20)
//                   };
//  } else if (endpointType == ASTwitterAPIEndpointMentions){
//    endpointTypeStr = GET_MENTIONS_URL;
//  } else if (endpointType == ASTwitterAPIEndpointMyTweets){
//    endpointTypeStr = GET_MY_TWEETS_URL;
//    parameters = @{ @"screen_name": [ASUser currentUser].screenName };
//  }
//  
//  return [self GET:endpointTypeStr parameters:parameters success:success failure:failure];

  return nil;
}
- (AFHTTPRequestOperation *)postWithEndpointType:(TwitterClientEndpointType)endpointType parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
  // TODO
  
//  NSString *endpointTypeStr = [[NSString alloc] init];
//  
//  if (endpointType == ASTwitterAPIEndpointAddTweet){
//    endpointTypeStr = POST_STATUS_UPDATE_URL;
//  } else if (endpointType == ASTwitterAPIEndpointReply){
//    endpointTypeStr = POST_STATUS_UPDATE_URL;
//  } else if (endpointType == ASTwitterAPIEndpointRetweet){
//    NSString *tweetId = parameters[@"id"];
//    
//    endpointTypeStr = [NSString stringWithFormat:POST_STATUS_RETWEET_URL, tweetId ];
//  } else if (endpointType == ASTwitterAPIEndpointFavorite) {
//    endpointTypeStr = POST_STATUS_FAVORITE_URL;
//  } else if (endpointType == ASTwitterAPIEndpointUnfavorite) {
//    endpointTypeStr = POST_STATUS_UNFAVORITE_URL;
//  }
//  
//  return [self POST:endpointTypeStr parameters:parameters success:success failure:failure];
  
  return nil;
}

- (User *)getCurrentUser {
  return User.currentUser;
}

@end
