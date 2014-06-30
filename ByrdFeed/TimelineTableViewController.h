//
//  TimelineTableViewController.h
//  ByrdFeed
//
//  Created by Eddie Freeman on 6/22/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuPanelViewController.h"

@protocol TimelineTableViewControllerDelegate <NSObject>

@optional
- (void)movePanelLeft;
- (void)movePanelRight;

@required
- (void)movePanelToOriginalPosition;

@end

@interface TimelineTableViewController : UITableViewController <MenuPanelViewControllerDelegate>

@property (nonatomic, assign) id<TimelineTableViewControllerDelegate> delegate;

@end

