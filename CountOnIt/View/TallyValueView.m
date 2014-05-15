//
//  TallyValueView.m
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/23/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "TallyValueView.h"
#import "UIColor+Utility.h"
#import "TextFieldView.h"
#import "LabelShadowView.h"
#import "TouchAndHoldButton.h"
#import "Global.h"

@interface TallyValueView () <TouchAndHoldButtonDelegate>

@property (strong, nonatomic) TouchAndHoldButton *minusButton;
@property (strong, nonatomic) TouchAndHoldButton *plusButton;
@property (strong, nonatomic) LabelShadowView *labelShadowView;

@end

@implementation TallyValueView

- (TallyValueView *)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.minusButton];
        [self addSubview:self.plusButton];
        
        self.tallyValue = 0;
    }
    return self;
}

- (void)destroy
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Interaction

- (IBAction)incrementDown:(UIButton *)sender
{
    [self increment:-1];
}

- (IBAction)incrementUp:(UIButton *)sender
{
    [self increment:1];
}

- (void)increment:(NSInteger)value
{
    self.tallyValue += value;
    [[NSNotificationCenter defaultCenter] postNotificationName:GlobalFocusChanged object:self];
}

- (void)setTallyValue:(NSInteger)tallyValue
{
    _tallyValue = (int)tallyValue;
    self.labelShadowView.value = tallyValue;
}

#pragma mark - Delegate

- (void)valueChanged:(TouchAndHoldButton *)sender
{
    if (sender == self.minusButton) {
        [self increment:-1*sender.increment];
    } else if (sender == self.plusButton) {
        [self increment:sender.increment];
    }
}

#pragma mark - Drawing

- (UIButton *)minusButton
{
    if (!_minusButton) {
        _minusButton = [TouchAndHoldButton buttonWithType:UIButtonTypeCustom];
        _minusButton.frame = CGRectMake(0.0f, 28.0f, 75.0f, 75.0f);
        _minusButton.delegate = self;
        [_minusButton setImage:[UIImage imageNamed:@"Add-Tally-Minus"] forState:UIControlStateNormal];
        [_minusButton setImage:[UIImage imageNamed:@"Add-Tally-Minus-Highlighted"] forState:UIControlStateHighlighted];
        [_minusButton addTarget:self action:@selector(incrementDown:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _minusButton;
}

- (UIButton *)plusButton
{
    if (!_plusButton) {
        _plusButton = [TouchAndHoldButton buttonWithType:UIButtonTypeCustom];
        _plusButton.frame = CGRectMake(210.0f, 28.0f, 75.0f, 75.0f);
         _plusButton.delegate = self;
        [_plusButton setImage:[UIImage imageNamed:@"Add-Tally-Plus"] forState:UIControlStateNormal];
        [_plusButton setImage:[UIImage imageNamed:@"Add-Tally-Plus-Highlighted"] forState:UIControlStateHighlighted];
        [_plusButton addTarget:self action:@selector(incrementUp:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _plusButton;
}

- (LabelShadowView *)labelShadowView
{
    if (!_labelShadowView) {
        _labelShadowView = [[LabelShadowView alloc] initWithFrame:CGRectMake(76.0f, 0.0f, 135.0f, 120.0f)];
        [self addSubview:_labelShadowView];
    }
    return _labelShadowView;
}

@end
