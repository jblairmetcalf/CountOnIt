//
//  Background.m
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/23/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "Background.h"
#import "UIColor+Utility.h"

@implementation Background

- (Background *)initWithBackground:(NSString *)background top:(NSString *)top bottom:(NSString *)bottom leftTop:(BOOL)leftTop
{
    self = [super init];
    if (self) {
        self.background = [UIColor colorWithHexString:background];
        self.top = [UIColor colorWithHexString:top];
        self.bottom = [UIColor colorWithHexString:bottom];
        self.leftTop = leftTop;
    }
    return self;
}

@end
