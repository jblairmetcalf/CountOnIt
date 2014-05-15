//
//  Backgrounds.h
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/23/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Background.h"

@interface Backgrounds : NSObject

@property (strong, nonatomic) NSArray *backgrounds; // of Background

+ (Backgrounds *)sharedInstance;
- (Background *)randomBackground;
- (Background *)background:(NSUInteger)index;
- (NSArray *)backgrounds;

@end
