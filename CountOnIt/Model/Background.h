//
//  Background.h
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/23/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Background : NSObject

@property (strong, nonatomic) UIColor *background;
@property (strong, nonatomic) UIColor *top;
@property (strong, nonatomic) UIColor *bottom;
@property (nonatomic) BOOL leftTop;

- (Background *)initWithBackground:(NSString *)background top:(NSString *)top bottom:(NSString *)bottom leftTop:(BOOL)leftTop;

@end
