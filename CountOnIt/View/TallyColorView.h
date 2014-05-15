//
//  TallyColorView.h
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/23/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TallyColorView;

@protocol TallyColorViewDelegate

- (void)colorChanged:(TallyColorView *)sender;

@end

@interface TallyColorView : UIView

@property (nonatomic, weak) id <TallyColorViewDelegate> delegate;
@property (nonatomic) NSUInteger tallyColor;

- (void)destroy;

@end