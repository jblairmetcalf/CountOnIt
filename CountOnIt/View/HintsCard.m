//
//  HintsCard.m
//  CountOnIt
//
//  Created by J. Blair Metcalf on 3/18/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "HintsCard.h"
#import "Global.h"
#import "TouchThroughView.h"
#import "UIColor+Utility.h"

@interface HintsCard ()

@property (nonatomic, strong) TouchThroughView *background;
@property (nonatomic, strong) TouchThroughView *scrollView;
@property (nonatomic, strong) NSMutableArray *imageViews;
@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation HintsCard

- (HintsCard *)initWithFrame:(CGRect)frame pages:(NSArray *)pages
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageViews = [[NSMutableArray alloc] init];
        
        NSInteger index = 0;
        for (NSDictionary *page in pages) {
            [self pageWithImageNamed:[page valueForKey:@"image"] text:[page valueForKey:@"text"] index:index];
            index++;
        }
        
        [self.background addSubview:self.closeButton];
    }
    return self;
}

- (void)show
{
    CGRect frame = CGRectMake(self.background.frame.origin.x, self.background.frame.origin.y, self.background.frame.size.width, self.background.frame.size.height);
    
    self.background.frame = CGRectMake(self.background.frame.origin.x, -self.background.frame.size.height, self.background.frame.size.width, self.background.frame.size.height);
    
    [UIView animateWithDuration:GlobalDuration*2
                          delay:1.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.background.frame = frame;
                     } completion:^(BOOL finished) {
                         
                     }];
    
    for (UIImageView *imageView in self.imageViews) {
        [self animateImageView:imageView];
    }
}

- (void)animateImageView:(UIImageView *)imageView
{
    CGFloat padding = 4.0f;
    
    CGRect frame = CGRectMake(imageView.frame.origin.x-padding, imageView.frame.origin.y-padding, imageView.frame.size.width+(padding*2), imageView.frame.size.height+(padding*2));
    
    [UIView animateWithDuration:1.0f
                          delay:0.0f
                        options:(UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat)
                     animations:^{
                         imageView.alpha = 0.4f;
                         imageView.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (void)hide
{
    CGRect frame = CGRectMake(self.background.frame.origin.x, (self.frame.size.height-self.background.frame.size.height)/2, self.background.frame.size.width, self.background.frame.size.height);
    
    [UIView animateWithDuration:GlobalDuration
                     animations:^{
                         self.background.frame = frame;
                     } completion:^(BOOL finished) {
                         [self performSelector:@selector(hideCompletely) withObject:self afterDelay:1.5f];
                     }];
}

- (void)hideCompletely
{
    CGRect frame = CGRectMake(self.background.frame.origin.x, -self.frame.size.height, self.background.frame.size.width, self.background.frame.size.height);
    
    [UIView animateWithDuration:GlobalDuration
                     animations:^{
                         self.background.frame = frame;
                     } completion:^(BOOL finished) {
                         [self destroy];
                     }];
}

- (void)destroy
{
    [self removeFromSuperview];
}

- (void)setIndex:(NSInteger)index
{
    CGRect frame = CGRectMake(0.0f, -index*self.scrollView.frame.size.height, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    
    [UIView animateWithDuration:GlobalDuration
                     animations:^{
                         self.scrollView.frame = frame;
                     } completion:^(BOOL finished) {
                         
                     }];
}

- (IBAction)close:(UIButton *)button
{
    [self.delegate close:self];
}

#pragma mark - Drawing

- (TouchThroughView *)background
{
    if (!_background) {
        CGFloat height = self.scrollView.frame.size.height;
        
        CGRect frame = CGRectMake(-GlobalCornerRadius, self.frame.size.height-GlobalPadding-GlobalInset-(GlobalShadowDistance*2)-height, self.frame.size.width+GlobalCornerRadius-GlobalPadding-GlobalInset, height+GlobalShadowDistance);
        
        _background = [[TouchThroughView alloc] initWithFrame:frame];
        
        TouchThroughView *fill = [[TouchThroughView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _background.frame.size.width, _background.frame.size.height-GlobalShadowDistance)];
        fill.backgroundColor = [UIColor colorWithHexString:@"#ff2956"];
        fill.layer.cornerRadius  = GlobalCornerRadius;
        fill.layer.masksToBounds = YES;
        
        TouchThroughView *shadow = [[TouchThroughView alloc] initWithFrame:CGRectMake(0.0f, GlobalShadowDistance, _background.frame.size.width, _background.frame.size.height-GlobalShadowDistance)];
        shadow.backgroundColor = [UIColor colorWithHexString:@"#4c4c4c"];
        shadow.layer.cornerRadius  = GlobalCornerRadius;
        shadow.layer.masksToBounds = YES;
        
        TouchThroughView *mask = [[TouchThroughView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _background.frame.size.width, _background.frame.size.height-GlobalShadowDistance)];
        mask.layer.cornerRadius  = GlobalCornerRadius;
        mask.layer.masksToBounds = YES;
        
        [_background addSubview:shadow];
        [_background addSubview:fill];
        [mask addSubview:self.scrollView];
        [_background addSubview:mask];
        
        [self addSubview:_background];
    }
    return _background;
}

- (TouchThroughView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[TouchThroughView alloc] initWithFrame:CGRectMake(GlobalCornerRadius, 0.0f, self.frame.size.width-GlobalPadding-GlobalInset, 70.0f)];
    }
    return _scrollView;
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        CGRect frame = CGRectMake(self.background.frame.size.width-35.0f, 0.0f, 35.0f, 35.0f);
        
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.frame = frame;
        
        [_closeButton setImage:[UIImage imageNamed:@"Hints-Close"] forState:UIControlStateNormal];
        [_closeButton setImage:[UIImage imageNamed:@"Hints-Close-Highlighted"] forState:UIControlStateHighlighted];
        [_closeButton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (void)pageWithImageNamed:(NSString *)imageNamed text:(NSString *)text index:(NSInteger)index
{
    UIView *view = [[TouchThroughView alloc] initWithFrame:CGRectMake(0.0f, self.scrollView.frame.size.height*index, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
    
    UIImage *image = [UIImage imageNamed:imageNamed];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(23.0f, 10.0f, 50.0f, 50.0f);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(93.0f, 0.0f, self.scrollView.frame.size.width-90.0f, self.scrollView.frame.size.height-2.0f)];
    label.font = [UIFont fontWithName:@"SourceSansPro-It" size:21.0f];
    label.textColor = [UIColor whiteColor];
    label.text = text;
    label.numberOfLines = 2;
    
    [view addSubview:imageView];
    [view addSubview:label];
    
    [self.imageViews addObject:imageView];
    
    [self.scrollView addSubview:view];
}

@end
