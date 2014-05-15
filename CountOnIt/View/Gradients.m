//
//  Gradients.m
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/23/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "Gradients.h"
#import "UIImage+Utility.h"
#import "Global.h"

@interface Gradients ()

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation Gradients

- (Gradients *)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.alpha = 0.4f;
        [self addSubview:self.imageView];
    }
    return self;
}

- (Gradients *)initWithFrame:(CGRect)frame background:(Background *)background
{
    self = [self initWithFrame:frame];
    if (self) {
        self.background = background;
    }
    return self;
}

- (Gradients *)initWithFrame:(CGRect)frame top:(NSString *)top bottom:(NSString *)bottom leftTop:(BOOL)leftTop
{
    self = [self initWithFrame:frame];
    if (self) {
        self.background = [[Background alloc] initWithBackground:@"#000000" top:top bottom:bottom leftTop:leftTop];
    }
    return self;
}

- (void)setBackground:(Background *)background
{
    BOOL noAnimation = !_background;
    
    _background = background;
    
    UIImage *image = [self radialGradient];
    
    if (noAnimation) {
        self.imageView.image = image;
    } else {
        [UIView transitionWithView:self
                          duration:GlobalDuration
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            self.imageView.image = image;
                        } completion:^(BOOL finished) {
                            
                        }];
    }
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height)];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

- (UIImage *)radialGradient
{
    UIColor *color0 = self.background.top;
    UIColor *color1 = self.background.bottom;
    
    if (color0 && color1) {
        CGFloat scale = 16.0f;
        
        CGSize size = CGSizeMake(self.frame.size.width/scale, self.frame.size.height/scale);
        
        CGFloat multiplier = 1.21359223300971;
        CGFloat radius = (size.width+size.height)*multiplier/2;
        
        
        
        
        UIGraphicsBeginImageContextWithOptions(size, NO, 1);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
        CGFloat locations[2] = { 0.0f, 1.0f };
        
        const CGFloat *components0 = CGColorGetComponents(color0.CGColor);
        const CGFloat *components1 = CGColorGetComponents(color1.CGColor);
        
        NSArray *colors0 = @[(id)color0.CGColor,
                             (id)[UIColor colorWithRed:components0[0]
                                                 green:components0[1]
                                                  blue:components0[2]
                                                 alpha:0.0f].CGColor];
        NSArray *colors1 = @[(id)color1.CGColor,
                             (id)[UIColor colorWithRed:components1[0]
                                                 green:components1[1]
                                                  blue:components1[2]
                                                 alpha:0.0f].CGColor];
        
        CGGradientRef gradient0 = CGGradientCreateWithColors(colorspace, (CFArrayRef)colors0, locations);
        CGGradientRef gradient1 = CGGradientCreateWithColors(colorspace, (CFArrayRef)colors1, locations);
        
        CGPoint center0, center1;
        
        if (self.background.leftTop) {
            center0 = CGPointMake(0.0f, 0.0f);
            center1 = CGPointMake(size.width, size.height);
        } else {
            center0 = CGPointMake(size.width, 0.0f);
            center1 = CGPointMake(0.0f, size.height);
        }
        
        CGContextDrawRadialGradient (context, gradient0, center0, 0, center0, radius, 0);
        CGContextDrawRadialGradient (context, gradient1, center1, 0, center1, radius, 0);
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        
        CGGradientRelease(gradient0);
        CGGradientRelease(gradient1);
        
        CGColorSpaceRelease(colorspace);
        UIGraphicsEndImageContext();
        
        return image;
    } else {
        return nil;
    }
}

@end
