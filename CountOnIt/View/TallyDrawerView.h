//
//  TallyDrawerView.h
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/25/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tally.h"

@interface TallyDrawerView : UIView

extern NSString *const TallyEdit;
extern NSString *const TallyExport;

@property (weak, nonatomic) Tally *tally;
@property (nonatomic) BOOL locked;

- (id)initWithFrame:(CGRect)frame isLarge:(BOOL)isLarge;

@end
