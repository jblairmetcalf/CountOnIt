//
//  ManyTalliesHeaderView.h
//  CountOnIt
//
//  Created by J. Blair Metcalf on 3/5/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldView.h"

@class ManyTalliesHeaderView;

@protocol ManyTalliesHeaderViewDelegate

- (void)valueChanged:(ManyTalliesHeaderView *)sender;

@end

@interface ManyTalliesHeaderView : UIView

@property (nonatomic, weak) id <ManyTalliesHeaderViewDelegate> delegate;

@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) TextFieldView *textFieldView;

@end