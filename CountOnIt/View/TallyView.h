//
//  TallyView.h
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/24/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tally.h"

@interface TallyView : UIView

extern NSString *const TallySwipeGesture;
extern NSString *const TallyOneTouch;
extern NSString *const TallyTwoTouches;
extern NSString *const TallyThreeTouches;
extern NSString *const TallyTouchAndHoldValueDidChangeValue;
extern NSString *const TallyDrawerOpened;

@property (strong, nonatomic) Tally *tally;
@property (nonatomic) BOOL isLarge;

@property (strong, nonatomic) UISwipeGestureRecognizer *swipeGesture;

- (id)initWithFrame:(CGRect)frame isLarge:(BOOL)isLarge;
- (void)destroy;

@end
