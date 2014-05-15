//
//  ModalPageControl.h
//  CountOnIt
//
//  Created by J. Blair Metcalf on 3/11/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModalPageControl : UIView

@property (nonatomic) NSInteger currentPage;

- (id)initWithFrame:(CGRect)frame pages:(NSArray *)pages;

@end
