//
//  TalliesManager.h
//  CountOnIt
//
//  Created by J. Blair Metcalf on 3/8/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Database : NSObject

+ (Database *)sharedInstance;
- (void)reset;
- (void)populate;
- (void)save;

@end
