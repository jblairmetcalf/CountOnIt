//
//  UnlimitedInAppPurchaseViewController.h
//  CountOnIt
//
//  Created by J. Blair Metcalf on 3/25/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@class UnlimitedInAppPurchaseViewController;

@protocol UnlimitedInAppPurchaseViewControllerDelegate

- (void)dismissModal:(UnlimitedInAppPurchaseViewController *)sender;

@end

@interface UnlimitedInAppPurchaseViewController : GAITrackedViewController

@property (nonatomic, weak) id <UnlimitedInAppPurchaseViewControllerDelegate> delegate;

@property (nonatomic) BOOL purchased;

@end