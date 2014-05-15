//
//  TouchAndHoldButton.h
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/28/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TouchAndHoldButton;

@protocol TouchAndHoldButtonDelegate

- (void)valueChanged:(TouchAndHoldButton *)sender;

@end

@interface TouchAndHoldButton : UIButton

@property (nonatomic, weak) id <TouchAndHoldButtonDelegate> delegate;

@property (nonatomic) NSUInteger increment;

@end