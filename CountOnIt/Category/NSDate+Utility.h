//
//  NSDate+Utility.h
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/28/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Utility)

- (NSString *)prettyDate;
- (NSString *)longPrettyDate;
- (NSDate *)initWithYear:(NSInteger)year month:(NSUInteger)month day:(NSUInteger)day;

@end
