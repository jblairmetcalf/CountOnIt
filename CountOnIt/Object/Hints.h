//
//  Hints.h
//  CountOnIt
//
//  Created by J. Blair Metcalf on 3/16/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Hints : NSObject

@property (strong, nonatomic) UIView *view;

+ (Hints *)sharedInstance;

@end
