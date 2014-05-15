//
//  TouchAndHold.m
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/28/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "TouchAndHold.h"

@interface TouchAndHold ()

@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) NSUInteger index;
@property (nonatomic) BOOL changed;

@end

@implementation TouchAndHold

- (void)setDown:(BOOL)down
{
    if (_down != down) {
        _down = down;
        
        if (self.changed) {
            [self.delegate didChangeValue:self];
        }
        self.changed = NO;
        
        if (_down) {
            self.index = 1;
            [self startTimer];
        } else {
            [self.timer invalidate];
            self.timer = nil;
        }
    }
}

- (void)startTimer
{
    CGFloat duration = MAX((1.0f/self.index)-0.05f, 1.0f/30.0f);
    self.timer = [NSTimer scheduledTimerWithTimeInterval:duration
                                                  target:self
                                                selector:@selector(timerCallback:)
                                                userInfo:nil
                                                 repeats:NO];
}

- (void)timerCallback:(NSTimer *)timer
{
    self.increment = ceil(self.index*0.015f);
    [self.delegate valueChanged:self];
    self.changed = YES;
    self.index++;
    [self startTimer];
}

@end
