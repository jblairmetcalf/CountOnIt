//
//  InlaidView.m
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/23/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "InlaidView.h"
#import "UIColor+Utility.h"
#import "UIImage+Utility.h"
#import <QuartzCore/QuartzCore.h>
#import "Global.h"

@interface InlaidView ()

@property (strong, nonatomic) UIView *highlightView;
@property (strong, nonatomic) UIView *shadowView;

@end

@implementation InlaidView

- (InlaidView *)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        [self addSubview:self.shadowView];
        [self addSubview:self.highlightView];
    }
    return self;
}

#pragma mark - Drawing

- (UIView *)shadowView
{
    if (!_shadowView) {
        CGSize size = CGSizeMake(self.frame.size.width, self.frame.size.height);
        CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
        
        UIImage *image = [UIImage roundedRectangleWithSize:size fill:[UIColor clearColor] stroke:[UIColor colorWithHexString:@"#4c4c4c"] radius:GlobalCornerRadius width:GlobalStroke*2];
        
        rect.origin.x = -GlobalStroke;
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = rect;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        rect.origin.x = GlobalStroke;
        rect.size.width = rect.size.width-(GlobalStroke*2);
        rect.size.height = GlobalCornerRadius*2;
        
        _shadowView = [[UIView alloc] initWithFrame:rect];
        _shadowView.layer.cornerRadius = GlobalCornerRadius;
        _shadowView.layer.masksToBounds = YES;
        [_shadowView addSubview:imageView];
    }
    return _shadowView;
}

- (UIView *)highlightView
{
    if (!_highlightView) {
        CGSize size = CGSizeMake(self.frame.size.width, self.frame.size.height);
        CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
        
        UIImage *image = [UIImage roundedRectangleWithSize:size fill:[UIColor clearColor] stroke:[UIColor colorWithHexString:@"#ffffff"] radius:GlobalCornerRadius width:GlobalStroke*2];
        
        rect.origin.y = -GlobalStroke;
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = rect;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        rect.origin.y = GlobalStroke;
        rect.size.width = rect.size.width;
        
        _highlightView = [[UIView alloc] initWithFrame:rect];
        _highlightView.layer.cornerRadius = GlobalCornerRadius;
        _highlightView.layer.masksToBounds = YES;
        _highlightView.alpha = 0.5f;
        [_highlightView addSubview:imageView];
    }
    return _highlightView;
}

@end
