//
//  ManyTalliesView.h
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/24/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManyTalliesView : UITableView

extern NSString *const ManyTalliesViewDidScroll;

@property (nonatomic) NSUInteger currentIndex;

- (void)scrollToTop:(BOOL)animated;

@end
