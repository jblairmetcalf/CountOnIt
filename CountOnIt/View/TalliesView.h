//
//  TalliesView.h
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/24/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TalliesView : UIView

extern NSString *const TalliesUpdateDate;
extern NSString *const TalliesDidScroll;

- (void)scrollToTop;

@end
