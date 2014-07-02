//
//  ContentViewController.h
//  ByrdFeed
//
//  Created by Eddie Freeman on 7/1/14.
//  Copyright (c) 2014 NinjaSudo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContentViewController;

@protocol ContentViewControllerDelegate <NSObject>

- (void)showSlideout:(ContentViewController *)vc;
- (void)hideSlideout:(ContentViewController *)vc;

@end

@interface ContentViewController : UINavigationController <UIGestureRecognizerDelegate>

@property (nonatomic, weak) id <ContentViewControllerDelegate> slideoutDelegate;
@property (nonatomic) BOOL slideoutShowing;

@end