//
//  TallyTitleValue.m
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/23/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "TextFieldView.h"
#import "InlaidView.h"
#import "Global.h"
#import "UIColor+Utility.h"
#import <QuartzCore/QuartzCore.h>

@interface TextFieldView () <UITextFieldDelegate>

@property (strong, nonatomic) InlaidView *inlaidView;
@property (strong, nonatomic) UILabel *emptyLabel;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UIView *textFieldView;
@property (strong, nonatomic) UIButton *emptyButton;
@property (strong, nonatomic) UIView *emptyView;
@property (strong, nonatomic) UIImageView *emptyImageView;
@property (strong, nonatomic) UIView *background;

@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) NSString *emptyImageName;
@property (strong, nonatomic) NSString *emptyHighlightedImageName;
@property (nonatomic) BOOL isSearch;
@property (nonatomic) BOOL hasBorder;
@property (nonatomic) CGFloat fontSize;

@end

@implementation TextFieldView

- (TextFieldView *)initWithFrame:(CGRect)frame textColor:(UIColor *)textColor emptyImageName:(NSString *)emptyImageName emptyHighlightedImageName:(NSString *)emptyHighlightedImageName isSearch:(BOOL)isSearch hasBorder:(BOOL)hasBorder fontSize:(CGFloat)fontSize emptyText:(NSString *)emptyText
{
    self = [super initWithFrame:frame];
    if (self) {
        _textColor = textColor;
        _emptyImageName = emptyImageName;
        _emptyHighlightedImageName = emptyHighlightedImageName;
        _isSearch = isSearch;
        _hasBorder = hasBorder;
        _fontSize = fontSize;
        _emptyText = emptyText;
        
        if (self.hasBorder) {
            [self addSubview:self.background];
            [self addSubview:self.inlaidView];
        }
        [self addSubview:self.emptyView];
        [self addSubview:self.textFieldView];
        [self addSubview:self.emptyButton];
        
        self.textField.tintColor = [UIColor colorWithHexString:@"#e868a2"];
        
        self.textField.returnKeyType = UIReturnKeyDone;
        self.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        
        [self.textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        
        self.emptyButton.hidden = YES;
        
        [self showEmpty];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(globalFocusChanged:)
                                                     name:GlobalFocusChanged
                                                   object:nil];
    }
    return self;
}

- (void)destroy
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)globalFocusChanged:(NSNotification *)notification
{
    if (notification.object != self) [self.textField resignFirstResponder];
}

- (void)empty
{
    self.text = @"";
    [self showLabel];
    [self showEmpty];
}

- (NSString *)text
{
    return self.textField.text;
}

- (void)setText:(NSString *)text
{
    self.textField.text = text;
    if (self.textField.text.length) self.emptyView.hidden = YES;
    
    [self showEmpty];
}

- (void)setEmptyText:(NSString *)emptyText
{
    self.emptyLabel.text = emptyText;
}

#pragma mark - Text Field Delegate

- (void)textFieldChanged:(UITextField *)textField
{
    [self showEmpty];
    [self.delegate valueChanged:self];
    [self scrollHorizontally];
}

- (void)scrollHorizontally
{
    CGSize size = [self.textField.text sizeWithAttributes: @{ NSFontAttributeName: self.textField.font } ];
    
    CGFloat width = self.textFieldView.frame.size.width;
    CGRect frame = self.textField.frame;
    
    frame.origin.x = -MAX(width, size.width)+width;
    frame.size.width = MAX(width, size.width);
    
    if (size.width > 0) {
        [UIView animateWithDuration:GlobalDuration animations:^{
            self.textField.frame = frame;
        } completion:^(BOOL finished) {
            
        }];
    } else {
        self.textField.frame = frame;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [[NSNotificationCenter defaultCenter] postNotificationName:GlobalFocusChanged object:self];
    
    [self scrollHorizontally];
    
    [UIView animateWithDuration:GlobalDuration animations:^{
        self.emptyView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self.emptyView.hidden = YES;
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect frame = self.textField.frame;
    frame.origin.x = 0;
    
    [UIView animateWithDuration:GlobalDuration animations:^{
        self.textField.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
    
    [self showLabel];
    [self showEmpty];
}

- (void)showLabel
{
    if (!self.textField.text.length && ![self.textField isEditing]) {
        self.emptyView.hidden = NO;
        [UIView animateWithDuration:GlobalDuration animations:^{
            self.emptyView.alpha = 1.0f;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)showEmpty
{
    if (self.emptyButton.hidden && self.textField.text.length) {
        self.emptyButton.hidden = NO;
        [UIView animateWithDuration:GlobalDuration animations:^{
            self.emptyButton.alpha = 1.0f;
        } completion:^(BOOL finished) {
            
        }];
    } else if (!self.emptyButton.hidden && !self.textField.text.length) {
        [UIView animateWithDuration:GlobalDuration animations:^{
            self.emptyButton.alpha = 0.0f;
        } completion:^(BOOL finished) {
            self.emptyButton.hidden = YES;
        }];
    }
}

#pragma mark - Interaction

- (IBAction)empty:(UIButton *)sender
{
    self.text = @"";
    [self showEmpty];
    [self.textField becomeFirstResponder];
    [self.delegate valueChanged:self];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (CGRectContainsPoint(self.bounds, point) || CGRectContainsPoint(self.emptyButton.frame, point)) {
        return YES;
    }
    return NO;
}

#pragma mark - Drawing

- (UIView *)textFieldView
{
    if (!_textFieldView) {
        CGRect frame;
        
        if (self.hasBorder) {
            CGFloat padding = 10.0f;
            CGFloat inset = 0.6f;
            frame = CGRectMake(padding, padding*inset, self.frame.size.width-(padding*(inset+2.0f))-20.0f, 25.0f);
        } else {
            frame = CGRectMake(0.0f, 0.0f, self.frame.size.width-18.0f, self.frame.size.height);
        }
        
        _textFieldView = [[UIView alloc] initWithFrame:frame];
        _textFieldView.clipsToBounds = YES;
    }
    return _textFieldView;
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.textFieldView.frame.size.width, self.textFieldView.frame.size.height)];
        _textField.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:self.fontSize];
        _textField.textColor = self.textColor;
        _textField.delegate = self;
        
        [self.textFieldView addSubview:_textField];
    }
    return _textField;
}

- (UIView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height)];
        
        if (self.isSearch) {
            [_emptyView addSubview:self.emptyImageView];
        } else {
            [_emptyView addSubview:self.emptyLabel];
        }
    }
    return _emptyView;
}

- (UIImageView *)emptyImageView
{
    if (!_emptyImageView) {
        UIImage *image = [UIImage imageNamed:@"Textfield-Empty-Dark-Image"];
        _emptyImageView = [[UIImageView alloc] initWithImage:image];
        _emptyImageView.frame = CGRectMake((self.frame.size.width-image.size.width)/2, (self.frame.size.height-image.size.height)/2, image.size.width, image.size.height);
    }
    return _emptyImageView;
}

- (UILabel *)emptyLabel
{
    if (!_emptyLabel) {
        _emptyLabel = [[UILabel alloc] initWithFrame:self.textFieldView.frame];
        _emptyLabel.font = self.textField.font;
        _emptyLabel.textColor = self.textField.textColor;
        _emptyLabel.alpha = 0.5f;
        _emptyLabel.text = self.emptyText;
    }
    return _emptyLabel;
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

- (UIButton *)emptyButton
{
    if (!_emptyButton) {
        CGRect frame;
        if (self.hasBorder) {
            frame = CGRectMake(self.frame.size.width-36.0f, 2.0f, 35.0f, 35.0f);
        } else {
            frame = CGRectMake(self.frame.size.width-20.0f, -3.0f, 35.0f, 35.0f);
        }
        
        _emptyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _emptyButton.frame = frame;
        
        [_emptyButton setImage:[UIImage imageNamed:self.emptyImageName] forState:UIControlStateNormal];
        [_emptyButton setImage:[UIImage imageNamed:self.emptyHighlightedImageName] forState:UIControlStateHighlighted];
        [_emptyButton addTarget:self action:@selector(empty:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _emptyButton;
}

- (UIView *)background
{
    if (!_background) {
        _background = [[UIView alloc] initWithFrame:self.inlaidView.frame];
        _background.backgroundColor = self.isSearch ? [UIColor colorWithHexString:@"#f6f6f6"] : [[UIColor colorWithHexString:@"#4c4c4c"] colorWithAlphaComponent:0.1f];
        _background.layer.cornerRadius = GlobalCornerRadius;
        _background.layer.masksToBounds = YES;
    }
    return _background;
}

@end
