//
//  Sound.h
//  CountOnIt
//
//  Created by J. Blair Metcalf on 3/11/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface Sound : NSObject

- (Sound *)initWithPath:(NSString *)path;
- (void)play;

@end
