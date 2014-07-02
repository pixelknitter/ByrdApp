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

@protocol MenuPanelDelegate <NSObject>

@required
- (void)menuItemSelected:(MenuItem)menuItem;

@end

@interface MenuPanelViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) id<MenuPanelDelegate> delegate;

@end
