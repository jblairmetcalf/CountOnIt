//
//  TallyColorView.m
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/23/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "TallyColorView.h"
#import "InlaidView.h"
#import "Backgrounds.h"
#import "Background.h"
#import "UIImage+Utility.h"
#import "UIColor+Utility.h"
#import <QuartzCore/QuartzCore.h>
#import "TextFieldView.h"
#import "Global.h"

@interface TallyColorView ()

@property (strong, nonatomic) InlaidView *inlaidView;
@property (strong, nonatomic) UIView *buttonsView;
@property (strong, nonatomic) UIView *highlightView;
@property (strong, nonatomic) NSArray *buttons;

@end

@implementation TallyColorView

- (TallyColorView *)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.buttonsView];
        [self addSubview:self.inlaidView];
    }
    return self;
}

- (void)setTallyColor:(NSUInteger)tallyColor
{
    _tallyColor = tallyColor;
    
    [self.delegate colorChanged:self];
    
    BOOL animate = _highlightView != NULL;
    UIButton *button = [self.buttons objectAtIndex:_tallyColor];
    CGFloat x = button.frame.origin.x;
    CGRect rect = CGRectMake(x, self.highlightView.frame.origin.y, self.highlightView.frame.size.width, self.highlightView.frame.size.height);
    
    if (!animate) {
        self.highlightView.frame = rect;
    } else {
        [UIView animateWithDuration:GlobalDuration
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.highlightView.frame = rect;
                         } completion:^(BOOL finished) {
                             
                         }];
    }
}

- (void)destroy
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Interaction

- (IBAction)colorTouched:(UIButton *)sender
{
    self.tallyColor = sender.tag;
    [[NSNotificationCenter defaultCenter] postNotificationName:GlobalFocusChanged object:self];
}

#pragma mark - Drawing

- (UIView *)buttonsView
{
    if (!_buttonsView) {
        Backgrounds *backgrounds = [Backgrounds sharedInstance];
        
        CGFloat height = 38.0f;
        CGRect rect = CGRectMake(0.0f, 0.0f, self.frame.size.width/[backgrounds backgrounds].count, height);
        
        _buttonsView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, height)];
        _buttonsView.layer.cornerRadius  = GlobalCornerRadius;
        _buttonsView.layer.masksToBounds = YES;
        
        NSInteger index = 0;
        
        NSMutableArray *buttonsTemp = [[NSMutableArray alloc] init];
        
        for (Background *background in [backgrounds backgrounds]) {
            rect.origin.x = rect.size.width*index;
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = rect;
            button.tag = index;
            
            [buttonsTemp addObject:button];
            
            UIView *normalView = [[UIView alloc] initWithFrame:rect];
            normalView.backgroundColor = background.background;
            UIImage *normalImage = [UIImage imageWithView:normalView];
            
            UIView *highlightView = [[UIView alloc] initWithFrame:rect];
            highlightView.backgroundColor = background.background;
            highlightView.alpha = 0.5f;
            UIImage *highlightImage = [UIImage imageWithView:highlightView];
            
            [button setImage:normalImage forState:UIControlStateNormal];
            [button setImage:highlightImage forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(colorTouched:) forControlEvents:UIControlEventTouchUpInside];
            
            [_buttonsView addSubview:button];
            
            index++;
        }
        
        self.buttons = [NSArray arrayWithArray:buttonsTemp];
    }
    return _buttonsView;
}

- (UIView *)highlightView
{
    if (!_highlightView) {
        Backgrounds *backgrounds = [Backgrounds sharedInstance];
        
        CGRect highlightRect = CGRectMake(0.0f, 44.0f, self.frame.size.width/[backgrounds backgrounds].count, 4.0f);
        CGRect barRect = CGRectMake(1.0f, 0.0f, highlightRect.size.width-2.0f, highlightRect.size.height);
        
        UIView *barView = [[UIView alloc] initWithFrame:barRect];
        barView.backgroundColor = [UIColor whiteColor];
        
        _highlightView = [[UIView alloc] initWithFrame:highlightRect];

        [_highlightView addSubview:barView];
        [self addSubview:_highlightView];
    }
    return _highlightView;
}

- (InlaidView *)inlaidView
{
    if (!_inlaidView) {
        CGFloat height = 38.0f;
        
        CGSize size = CGSizeMake(self.frame.size.width, height);
        CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
        
        _inlaidView = [[InlaidView alloc] initWithFrame:rect];
    }
    return _inlaidView;
}

@end
