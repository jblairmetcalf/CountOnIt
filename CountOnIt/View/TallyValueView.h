//
//  TallyValueView.h
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/23/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TallyValueView : UIView

@property (nonatomic) NSInteger tallyValue;

- (void)destroy;

@end