//
//  TouchAndHoldButton.m
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/28/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "TouchAndHoldButton.h"
#import "TouchAndHold.h"

@interface TouchAndHoldButton () <TouchAndHoldDelegate>

@property (strong, nonatomic) TouchAndHold *touchAndHold;

@end

@implementation TouchAndHoldButton

- (TouchAndHoldButton *)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(buttonUp:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    }
    return self;
}

- (void)valueChanged:(TouchAndHold *)sender
{
    [self.delegate valueChanged:self];
}

- (void)didChangeValue:(TouchAndHold *)sender {}

- (IBAction)buttonDown:(UIButton *)sender
{
    self.touchAndHold.down = YES;
}

- (IBAction)buttonUp:(UIButton *)sender
{
    self.touchAndHold.down = NO;
}

- (NSUInteger)increment
{
    return self.touchAndHold.increment;
}

- (TouchAndHold *)touchAndHold
{
    if (!_touchAndHold) {
        _touchAndHold = [[TouchAndHold alloc] init];
        _touchAndHold.delegate = self;
    }
    return _touchAndHold;
}

@end
