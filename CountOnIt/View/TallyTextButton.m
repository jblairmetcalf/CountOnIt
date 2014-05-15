//
//  TallyTextButton.m
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/27/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "TallyTextButton.h"
#import "UIImage+Utility.h"
#import <QuartzCore/QuartzCore.h>
#import "TextFieldView.h"
#import "Global.h"

@interface TallyTextButton ()

@property (strong, nonatomic) UIButton *button;

@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIView *sideView;
@property (strong, nonatomic) UIView *deselectedView;
@property (strong, nonatomic) UIView *selectedView;

@property (strong, nonatomic) UIImage *deselectedNormalImage;
@property (strong, nonatomic) UIImage *deselectedHighlightedImage;
@property (strong, nonatomic) UIImage *selectedNormalImage;
@property (strong, nonatomic) UIImage *selectedHighlightedImage;

@property (strong, nonatomic) NSString *deselectedTitle;
@property (strong, nonatomic) NSString *deselectedImage;
@property (strong, nonatomic) NSString *selectedTitle;
@property (strong, nonatomic) NSString *selectedImage;

@end

@implementation TallyTextButton

- (TallyTextButton *)initWithFrame:(CGRect)frame deselectedTitle:(NSString *)deselectedTitle deselectedImage:(NSString *)deselectedImage selectedTitle:(NSString *)selectedTitle selectedImage:(NSString *)selectedImage
{
    self = [super initWithFrame:frame];
    if (self) {
        self.deselectedTitle = deselectedTitle;
        self.deselectedImage = deselectedImage;
        self.selectedTitle = selectedTitle;
        self.selectedImage = selectedImage;
        
        [self.button setImage:self.deselectedNormalImage forState:UIControlStateNormal];
        [self.button setImage:self.deselectedHighlightedImage forState:UIControlStateNormal | UIControlStateHighlighted];
        [self.button setImage:self.selectedNormalImage forState:UIControlStateSelected];
        [self.button setImage:self.selectedHighlightedImage forState:UIControlStateSelected | UIControlStateHighlighted];
        
        [self.button addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.button];
    }
    return self;
}

- (void)destroy
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)selected
{
    return self.button.selected;
}

- (void)setSelected:(BOOL)selected
{
    self.button.selected = selected;
}

#pragma mark - Interaction

- (IBAction)buttonTouched:(UIButton *)sender
{
    self.button.selected = !self.button.selected;
    [[NSNotificationCenter defaultCenter] postNotificationName:GlobalFocusChanged object:self];
}

#pragma mark - Drawing

- (UIButton *)button
{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = [self rect];
    }
    return _button;
}

- (UIView *)sideView
{
    if (!_sideView) {
        _sideView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.height, self.frame.size.height)];
        _sideView.backgroundColor = [UIColor whiteColor];
        _sideView.layer.cornerRadius  = GlobalCornerRadius;
        _sideView.layer.masksToBounds = YES;
        _sideView.alpha = 0.3f;
    }
    return _sideView;
}

- (UIView *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:[self rect]];
        _backgroundView.backgroundColor = [UIColor whiteColor];
        _backgroundView.layer.cornerRadius  = GlobalCornerRadius;
        _backgroundView.layer.masksToBounds = YES;
        _backgroundView.alpha = 0.2f;
    }
    return _backgroundView;
}

- (UIView *)deselectedView
{
    if (!_deselectedView) {
        _deselectedView = [[UIView alloc] initWithFrame:[self rect]];
        
        UIView *normal = [[UIView alloc] initWithFrame:[self rect]];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.deselectedImage]];
        imageView.frame = CGRectMake(9.0f, 9.0f, 21.0f, 21.f);
        
        UILabel *label = [self labelWithString:self.deselectedTitle];
        
        [_deselectedView addSubview:normal];
        [_deselectedView addSubview:imageView];
        [_deselectedView addSubview:label];
    }
    return _deselectedView;
}

- (UIView *)selectedView
{
    if (!_selectedView) {
        _selectedView = [[UIView alloc] initWithFrame:[self rect]];
        
        UIView *selected = [[UIView alloc] initWithFrame:[self rect]];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.selectedImage]];
        imageView.frame = CGRectMake(9.0f, 9.0f, 21.0f, 21.f);
        
        UILabel *label = [self labelWithString:self.selectedTitle];
        
        [_selectedView addSubview:selected];
        [_selectedView addSubview:imageView];
        [_selectedView addSubview:label];
    }
    return _selectedView;
}

- (UIImage *)deselectedNormalImage
{
    if (!_deselectedNormalImage) {
        UIView *view = [[UIView alloc] initWithFrame:[self rect]];
        [view addSubview:self.backgroundView];
        [view addSubview:self.sideView];
        [view addSubview:self.deselectedView];
        
        _deselectedNormalImage = [UIImage imageWithView:view];
    }
    return _deselectedNormalImage;
}

- (UIImage *)selectedNormalImage
{
    if (!_selectedNormalImage) {
        UIView *view = [[UIView alloc] initWithFrame:[self rect]];
        [view addSubview:self.backgroundView];
        [view addSubview:self.sideView];
        [view addSubview:self.selectedView];
        
        _selectedNormalImage = [UIImage imageWithView:view];
    }
    return _selectedNormalImage;
}

- (UIImage *)deselectedHighlightedImage
{
    if (!_deselectedHighlightedImage) {
        UIView *view = [[UIView alloc] initWithFrame:[self rect]];
        [view addSubview:self.backgroundView];
        [view addSubview:self.deselectedView];
        
        _deselectedHighlightedImage = [UIImage imageWithView:view];
    }
    return _deselectedHighlightedImage;
}

- (UIImage *)selectedHighlightedImage
{
    if (!_selectedHighlightedImage) {
        UIView *view = [[UIView alloc] initWithFrame:[self rect]];
        [view addSubview:self.backgroundView];
        [view addSubview:self.selectedView];
        
        _selectedHighlightedImage = [UIImage imageWithView:view];
    }
    return _selectedHighlightedImage;
}

#pragma mark - Utilities

- (UILabel *)labelWithString:(NSString *)string
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50.0f, 6.0f, 200.0f, 25.f)];
    label.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:20.0f];
    label.textColor = [UIColor whiteColor];
    label.text = string;
    return label;
}

- (CGRect)rect
{
    return CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
}

@end
