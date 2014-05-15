//
//  LabelShadowView.m
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/24/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "LabelShadowView.h"
#import "UIColor+Utility.h"
#import "Global.h"

@interface LabelShadowView ()

@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UILabel *shadow;
@property (nonatomic) NSUInteger initialFontSize;

@end

@implementation LabelShadowView

- (LabelShadowView *)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.initialFontSize = 50.0f;
        _value = 0;
        
        [self addSubview:self.shadow];
        [self addSubview:self.label];
    }
    return self;
}

- (void)setValue:(NSInteger)value
{
    _value = value;
    
    CGFloat widthScale = 1.0f;
    if ((self.value < -999 || self.value > 999) && !self.isLarge) {
        if (self.value > 9999) {
            widthScale = 0.63f;
        } else if (self.value > 999) {
            widthScale = 0.77f;
        } else if (self.value < -9999) {
            widthScale = 0.5f;
        } else if (self.value < -999) {
            widthScale = 0.6f;
        }
    }

    CGFloat hieghtScale = 1.6f;
    
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSString *text = [numberFormatter stringFromNumber:[NSNumber numberWithInteger:self.value]];
    
    CGSize constrainToSize = self.frame.size;
    UIFont *font = [UIFont fontWithName:self.label.font.fontName size:self.initialFontSize];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, text.length)];
    
    CGRect rect = [attributedString boundingRectWithSize:constrainToSize options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
    
    CGFloat fontPointByWidth = constrainToSize.width/rect.size.width*self.initialFontSize*widthScale;
    CGFloat fontPointByHeight = constrainToSize.height/rect.size.height*self.initialFontSize*hieghtScale;
    CGFloat fontPoint = MIN(fontPointByWidth, fontPointByHeight);
    
    UIFont *resizedFont = [UIFont fontWithName:self.label.font.fontName size:fontPoint];
    
    self.label.text = text;
    self.shadow.text = text;
    
    self.label.font = resizedFont;
    self.shadow.font = resizedFont;
}

- (void)setLocked:(BOOL)locked
{
    _locked = locked;
    self.label.hidden = self.locked;
}

#pragma mark - Drawing

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height)];
        _label.font = [UIFont fontWithName:@"SourceSansPro-Light" size:self.initialFontSize];
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

- (UILabel *)shadow
{
    if (!_shadow) {
        CGRect frame = self.label.frame;
        frame = CGRectMake(frame.origin.x, frame.origin.y+GlobalShadowDistance, frame.size.width, frame.size.height);
        
        _shadow = [[UILabel alloc] initWithFrame:frame];
        _shadow.font = self.label.font;
        _shadow.textColor = [UIColor colorWithHexString:@"#4c4c4c"];
        _shadow.textAlignment = self.label.textAlignment;
    }
    return _shadow;
}

@end
