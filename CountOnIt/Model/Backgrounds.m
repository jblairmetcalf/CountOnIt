//
//  Backgrounds.m
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/23/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "Backgrounds.h"

@implementation Backgrounds

static Backgrounds *sharedInstance;

+ (Backgrounds *)sharedInstance {
    static BOOL initialized = NO;
    if (!initialized) {
        initialized = YES;
        sharedInstance = [[Backgrounds alloc] init];
    }
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (Background *)randomBackground
{
    return [self background:arc4random() % self.backgrounds.count];
}

- (Background *)background:(NSUInteger)index
{
    if (index < [self.backgrounds count]) {
        return [self.backgrounds objectAtIndex:index];
    } else {
        return nil;
    }
}

- (NSArray *)backgrounds
{
    if (!_backgrounds) {
        Background *background0 = [[Background alloc] initWithBackground:@"#459ba8" top:@"#b6cc35" bottom:@"#e868a2" leftTop:YES];
        Background *background1 = [[Background alloc] initWithBackground:@"#5ab6cc" top:@"#f8e04c" bottom:@"#af4990" leftTop:NO];
        Background *background2 = [[Background alloc] initWithBackground:@"#79c267" top:@"#f8e04c" bottom:@"#af4990" leftTop:YES];
        Background *background3 = [[Background alloc] initWithBackground:@"#b6cc35" top:@"#f28c33" bottom:@"#459ba8" leftTop:NO];
        Background *background4 = [[Background alloc] initWithBackground:@"#f2cc2e" top:@"#f28c33" bottom:@"#79c267" leftTop:YES];
        Background *background5 = [[Background alloc] initWithBackground:@"#f28c33" top:@"#f2cc2e" bottom:@"#bf62a6" leftTop:NO];
        Background *background6 = [[Background alloc] initWithBackground:@"#e868a2" top:@"#f28c33" bottom:@"#af4990" leftTop:YES];
        Background *background7 = [[Background alloc] initWithBackground:@"#bf62a6" top:@"#f8e04c" bottom:@"#459ba8" leftTop:NO];
        
        _backgrounds = [[NSArray alloc] initWithObjects:background0, background1, background2, background3, background4, background5, background6, background7, nil];
    }
    return _backgrounds;
}

@end
