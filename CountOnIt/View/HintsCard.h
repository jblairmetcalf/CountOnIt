//
//  HintsCard.h
//  CountOnIt
//
//  Created by J. Blair Metcalf on 3/18/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchThroughView.h"

@class HintsCard;

@protocol HintsCardDelegate

- (void)close:(HintsCard *)sender;

@end

@interface HintsCard : TouchThroughView

- (HintsCard *)initWithFrame:(CGRect)frame pages:(NSArray *)pages;
- (void)show;
- (void)hide;
- (void)hideCompletely;

@property (nonatomic) NSInteger index;
@property (nonatomic, weak) id <HintsCardDelegate> delegate;

@end