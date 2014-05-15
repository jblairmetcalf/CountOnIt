//
//  LoadingView.m
//  CountOnIt
//
//  Created by J. Blair Metcalf on 3/4/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "LoadingView.h"
#import <QuartzCore/QuartzCore.h>
#import "Global.h"

@interface LoadingView ()

@property (strong, nonatomic) UIView *loadingView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic) BOOL shown;
@property (nonatomic) BOOL hid;

@end

@implementation LoadingView

- (LoadingView *)init
{
    self = [super init];
    if (self) {
        UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
        
        self.frame = CGRectMake(0.0f, 0.0f, window.frame.size.width, window.frame.size.height);
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
        
        [self addSubview:self.activityIndicatorView];
        
        [window addSubview:self];
        
        self.alpha = 0.0f;
    }
    return self;
}

- (void)reset
{
    self.shown = NO;
    self.hid = NO;
}

- (void)show
{
    if (!self.shown) {
        self.shown = YES;
        
        [self.activityIndicatorView startAnimating];
        
        [UIView animateWithDuration:GlobalDuration animations:^{
            self.alpha = 1.0f;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)hide
{
    if (!self.hid) {
        self.hid = YES;
        
        [self.activityIndicatorView stopAnimating];
        
        [UIView animateWithDuration:GlobalDuration animations:^{
            self.alpha = 0.0f;
        } completion:^(BOOL finished) {
            
        }];
    }
}

#pragma mark - Drawing

- (UIActivityIndicatorView *)activityIndicatorView
{
    if (!_activityIndicatorView) {
        CGSize size = CGSizeMake(50.0f, 50.0f);
        CGPoint origin = CGPointMake((self.frame.size.width-size.width)/2, (self.frame.size.height-size.height)/2);
        CGRect frame = CGRectMake(origin.x, origin.y, size.width, size.height);
        
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:frame];
        _activityIndicatorView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
        _activityIndicatorView.layer.cornerRadius  = GlobalCornerRadius;
        _activityIndicatorView.layer.masksToBounds = YES;
    }
    return _activityIndicatorView;
}

@end
