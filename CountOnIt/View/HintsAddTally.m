//
//  HintAddTally.m
//  CountOnIt
//
//  Created by J. Blair Metcalf on 3/18/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "HintsAddTally.h"
#import "Global.h"

@interface HintsAddTally ()

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation HintsAddTally

- (HintsAddTally *)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)show
{
    CGRect frame = self.imageView.frame;
    CGFloat y = frame.origin.y;
    frame.origin.y += 15.0f;
    self.imageView.frame = frame;
    self.imageView.alpha = 0.0f;
    frame.origin.y = y;
    
    [UIView animateWithDuration:1.0f
                          delay:0.0f
                        options:(UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat)
                     animations:^{
                         self.imageView.frame = frame;
                         self.imageView.alpha = 1.0f;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (void)hide
{
    [UIView animateWithDuration:GlobalDuration
                     animations:^{
                         self.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         [self destroy];
                     }];
}

- (void)destroy
{
    [self removeFromSuperview];
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Hints-Add-Item"]];
        _imageView.frame = CGRectMake(285.0f, 14.0f, 20.0f, 35.0f);
        [self addSubview:_imageView];
    }
    return _imageView;
}

@end
