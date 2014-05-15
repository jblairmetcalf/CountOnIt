//
//  Card.m
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/23/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "Card.h"
#import "UIColor+Utility.h"
#import <QuartzCore/QuartzCore.h>
#import "Gradients.h"
#import "UIImage+Utility.h"
#import "Backgrounds.h"
#import "Global.h"

@interface Card ()

@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIView *shadowView;
@property (strong, nonatomic) Gradients *gradients;

@end

@implementation Card

- (Card *)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.shadowView];
        [self addSubview:self.backgroundView];
        [self.backgroundView addSubview:self.gradients];
    }
    return self;
}

- (Card *)initWithFrame:(CGRect)frame background:(Background *)background
{
    self = [super initWithFrame:frame];
    if (self) {
        self.background = background;
    }
    return self;
}

- (void)setBackgroundIndex:(NSUInteger)backgroundIndex
{
    Backgrounds *backgrounds = [Backgrounds sharedInstance];
    Background *background = [backgrounds background:backgroundIndex];
    
    self.background = background;
}

- (void)setBackground:(Background *)background
{
    BOOL noAnimation = !_background;
    
    _background = background;
    
    self.gradients.background = self.background;
    
    if (noAnimation) {
        self.backgroundView.backgroundColor = self.background.background;
    } else {
        [UIView animateWithDuration:GlobalDuration animations:^{
            self.backgroundView.backgroundColor = self.background.background;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (Gradients *)gradients
{
    if (!_gradients) {
        CGFloat width = self.frame.size.width;
        CGFloat height = self.frame.size.height;
        
        CGRect frame = CGRectMake(0.0f, 0.0f, width, height-GlobalShadowDistance);
        
        _gradients = [[Gradients alloc] initWithFrame:frame];
    }
    return _gradients;
}

- (UIView *)backgroundView
{
    if (!_backgroundView) {
        CGFloat width = self.frame.size.width;
        CGFloat height = self.frame.size.height;
        
        CGRect frame = CGRectMake(0.0f, 0.0f, width, height-GlobalShadowDistance);
        
        _backgroundView = [[UIView alloc] initWithFrame:frame];
        _backgroundView.layer.cornerRadius  = GlobalCornerRadius;
        _backgroundView.layer.masksToBounds = YES;
    }
    return _backgroundView;
}

- (UIView *)shadowView
{
    if (!_shadowView) {
        CGFloat width = self.frame.size.width;
        CGFloat height = self.frame.size.height;
        
        CGRect frame = CGRectMake(0.0f, GlobalShadowDistance, width, height-GlobalShadowDistance);
        
        _shadowView = [[UIView alloc] initWithFrame:frame];
        _shadowView.backgroundColor = [UIColor colorWithHexString:@"#4c4c4c"];
        _shadowView.layer.cornerRadius  = GlobalCornerRadius;
        _shadowView.layer.masksToBounds = YES;
    }
    return _shadowView;
}

@end
