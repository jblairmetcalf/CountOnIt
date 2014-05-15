//
//  PreferenceList.h
//  CountOnIt
//
//  Created by J. Blair Metcalf on 3/7/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PreferenceList : NSObject

- (PreferenceList *)initWithFileName:(NSString *)fileName;

- (void)saveDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)getDictionary;

- (void)saveArray:(NSArray *)array;
- (NSArray *)getArray;

@end
