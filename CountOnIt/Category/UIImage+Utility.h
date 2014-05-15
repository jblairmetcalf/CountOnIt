//
//  UIImage+Utility.h
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/22/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Utility)

+ (UIImage *)roundedImageWithImage:(UIImage *)image;

+ (UIImage *)roundedRectangleWithSize:(CGSize)size fill:(UIColor *)fill stroke:(UIColor *)stroke radius:(CGFloat)radius width:(CGFloat)width;

+ (UIImage *)imageWithView:(UIView *)view;

// + (UIImage *)radialGradientWithColor:(UIColor *)color;

@end
