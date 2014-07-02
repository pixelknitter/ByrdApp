//
//  TimelineTableViewController.h
//  ByrdFeed
//
//  Created by Eddie Freeman on 6/22/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuPanelViewController.h"
#import "TwitterClient.h"

@protocol TimelineViewDelegate <NSObject>

@optional
- (void)movePanelLeft;
- (void)movePanelRight;

@required
- (void)movePanelToOriginalPosition;

@end

@interface TimelineTableViewController : UITableViewController

@property (nonatomic, assign) id<TimelineViewDelegate> delegate;
@property (nonatomic) TwitterClientEndpointType type;

@end

