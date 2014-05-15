//
//  ModalViewController.h
//  CountOnIt
//
//  Created by J. Blair Metcalf on 3/12/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "GAITrackedViewController.h"

@class WelcomeTourViewController;

@protocol WelcomeTourViewControllerDelegate

- (void)dismissModal:(WelcomeTourViewController *)sender;

@end

@interface WelcomeTourViewController : GAITrackedViewController

@property (nonatomic, weak) id <WelcomeTourViewControllerDelegate> delegate;

@end