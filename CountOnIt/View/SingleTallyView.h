//
//  SingleTallyView.h
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/24/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tally.h"

@interface SingleTallyView : UIView

- (id)initWithFrame:(CGRect)frame tally:(Tally *)tally;
- (void)destroy;
- (void)removed;

@end
