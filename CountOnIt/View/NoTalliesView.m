//
//  NoTalliesView.m
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/22/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "NoTalliesView.h"
#import "UIColor+Utility.h"
#import "Gradients.h"
#import "Backgrounds.h"
#import "Background.h"
#import "ViewController.h"
#import "Tallies.h"

@interface NoTalliesView ()

@property (strong, nonatomic) UIImageView *logoImageView;
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) Gradients *gradients;

@end

@implementation NoTalliesView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.gradients];
        [self addSubview:self.logoImageView];
        [self addSubview:self.label];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - Drawing

- (UIView *)gradients
{
    if (!_gradients) {
        _gradients = [[Gradients alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height) top:@"#96d4e0" bottom:@"#af4990" leftTop:NO];
    }
    return _gradients;
}

- (UIImageView *)logoImageView
{
    if (!_logoImageView) {
        CGFloat hieght = 245.0f;
        
        _logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Tallies-No-Tallies-Logo"]];
        _logoImageView.frame = CGRectMake(82.0f, (self.frame.size.height-hieght)/2.0f, 155.0f, 165.0f);
    }
    return _logoImageView;
}

- (UILabel *)label
{
    if (!_label) {
        NSInteger y = self.logoImageView.frame.origin.y+183.0f;
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, y, 280.0f, 25.0f)];
        _label.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:21.0f];
        _label.textColor = [UIColor colorWithHexString:@"#7f7f7f"];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.text = @"No Tallies";
    }
    return _label;
}

@end
