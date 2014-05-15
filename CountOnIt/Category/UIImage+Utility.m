//
//  UIImage+Utility.m
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/22/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "UIImage+Utility.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIImage (Utility)

+ (UIImage *)roundedImageWithImage:(UIImage *)image {
    if (image) {
        CGContextRef context = CGBitmapContextCreate(NULL, image.size.width, image.size.height, CGImageGetBitsPerComponent(image.CGImage), 0, CGImageGetColorSpace(image.CGImage), CGImageGetBitmapInfo(image.CGImage));
        CGContextBeginPath(context);
        CGRect pathRect = CGRectMake(0, 0, image.size.width, image.size.height);
        CGContextAddEllipseInRect(context, pathRect);
        CGContextClosePath(context);
        CGContextClip(context);
        CGContextDrawImage(context, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);
        CGImageRef clippedImage = CGBitmapContextCreateImage(context);
        CGContextRelease(context);
        UIImage *roundedImage = [UIImage imageWithCGImage:clippedImage];
        CGImageRelease(clippedImage);
        return roundedImage;
    }
    return nil;
}

+ (UIImage *)roundedRectangleWithSize:(CGSize)size fill:(UIColor *)fill stroke:(UIColor *)stroke radius:(CGFloat)radius width:(CGFloat)width
{
    const CGFloat *fillComponents = CGColorGetComponents(fill.CGColor);
    CGFloat fillAlpha = CGColorGetAlpha(fill.CGColor);
    
    const CGFloat *strokeComponents = CGColorGetComponents(stroke.CGColor);
    CGFloat strokeAlpha = CGColorGetAlpha(stroke.CGColor);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, strokeComponents[0], strokeComponents[1], strokeComponents[2], strokeAlpha);
    CGContextSetRGBFillColor(context, fillComponents[0], fillComponents[1], fillComponents[2], fillAlpha);
    CGContextSetLineWidth(context, 2.0f);
    
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    CGFloat minx = CGRectGetMinX(rect), midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect);
    CGFloat miny = CGRectGetMinY(rect), midy = CGRectGetMidY(rect), maxy = CGRectGetMaxY(rect);
    
    CGContextMoveToPoint(context, minx, midy);
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

/*
+ (UIImage *)radialGradientWithColor:(UIColor *)color
{
    CGSize size = CGSizeMake(16.0f, 16.0f);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
	
    CGFloat locations[2] = { 0.0f, 1.0f };
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    NSArray *colors = @[(id)color.CGColor,
                        (id)[UIColor colorWithRed:components[0] green:components[1] blue:components[2] alpha:0.0f].CGColor];
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(colorspace, (CFArrayRef)colors, locations);
    
    CGPoint center = CGPointMake(size.width/2.0f, size.height/2.0f);
    CGFloat radius = size.width/2.0f;
    CGContextDrawRadialGradient (context, gradient, center, 0, center, radius, 0);
    
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    CGColorSpaceRelease(colorspace);
    CGGradientRelease(gradient);
	UIGraphicsEndImageContext();
    
	return image;
}

- (UIImageView *)strokeImageView
{
    if (!_strokeImageView) {
        CGFloat radius = 5.0f;
        float padding = 10.0f;
        
        CGSize size = CGSizeMake(self.frame.size.width-(padding*2), self.frame.size.height);
        CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
        
        UIImage *image = [UIImage roundedRectangleWithSize:size fill:[UIColor clearColor] stroke:[UIColor colorWithHexString:@"#ffffff"] radius:radius width:2.0f];
        
        rect.origin.x = padding;
        
        _strokeImageView = [[UIImageView alloc] initWithImage:image];
        _strokeImageView.frame = rect;
        _strokeImageView.contentMode = UIViewContentModeScaleAspectFit;
        _strokeImageView.alpha = 0.5f;
    }
    return _strokeImageView;
}
*/

@end
