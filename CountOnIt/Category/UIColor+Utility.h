//
//  UIColor+Utility.h
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/22/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Utility)

+ (CGFloat) colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length;
+ (UIColor *)colorWithHexString:(NSString *)hexString;

@end
