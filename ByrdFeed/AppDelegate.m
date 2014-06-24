//
//  AppDelegate.m
//  ByrdFeed
//
//  Created by Eddie Freeman on 6/18/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TimelineTableViewController.h"
#import "Constants.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

  /* check if we have a current user, if not login */
  if (![[TwitterClient sharedInstance] getCurrentUser]){
    [[TwitterClient sharedInstance] login];
  }
  else {
    [self showTimeline];
  }
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTimeline) name:UserLoggedInNotification object:nil];
  
  self.window.backgroundColor = [UIColor whiteColor];
  [self.window makeKeyAndVisible];
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  return [[TwitterClient sharedInstance] processAuthResponseURL:url onSuccess:^{
    /* get user */
    [[TwitterClient sharedInstance] getWithEndpointType:TwitterClientEndpointUser success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
      [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(showTimeline)
                                                   name:UserLoggedInNotification object:nil];
      NSLog(@"Response: %@", responseObject);
      [[User initWithDictionary:responseObject] setAsCurrentUser];
      
      
      
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
      NSLog(@"Failure: %@", error);
    }];
  }];
}

- (void) showTimeline {
  TimelineTableViewController *tvc = [[TimelineTableViewController alloc] init];

  UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tvc];
  
  self.window.backgroundColor = tvc.view.backgroundColor;

  /* add the tweet colors to things */
  [nav.navigationBar setBarTintColor:tvc.view.backgroundColor];
  [nav.navigationBar setTranslucent:YES];
  [nav.navigationBar setBarStyle:UIBarStyleBlack];
  
  NSLog(@"Add TimeLine to View");
  self.window.rootViewController = nav;
}

@end
