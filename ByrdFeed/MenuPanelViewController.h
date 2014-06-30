//
//  MenuPanelViewController.h
//  ByrdFeed
//
//  Created by Eddie Freeman on 6/29/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum  {
  Profile,
  Timeline,
  Mentions,
  Logout
} MenuItem;

@protocol MenuPanelViewControllerDelegate <NSObject>

@optional

@required
- (void)selectedMenuItem:(MenuItem *)menuItem;

@end

@interface MenuPanelViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) id<MenuPanelViewControllerDelegate> delegate;

@end
