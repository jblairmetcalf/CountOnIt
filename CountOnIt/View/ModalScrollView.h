//
//  ModalScrollView.h
//  CountOnIt
//
//  Created by J. Blair Metcalf on 3/11/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ModalScrollView;

@protocol ModalScrollViewDelegate

- (void)dismissView:(ModalScrollView *)sender;
- (void)currentPageChanged:(ModalScrollView *)sender;
- (void)currentPageFractionChanged:(ModalScrollView *)sender;

@end

@interface ModalScrollView : UIView

@property (nonatomic, weak) id <ModalScrollViewDelegate> delegate;

- (ModalScrollView *)initWithFrame:(CGRect)frame views:(NSArray *)views;

@property (nonatomic) NSInteger currentPage;
@property (nonatomic) CGFloat currentPageFraction;

@end