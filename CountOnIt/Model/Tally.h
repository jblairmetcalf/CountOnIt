//
//  Tally.h
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/22/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tally : NSObject

extern NSString *const TallyValueChanged;
extern NSString *const TallyPinnedChanged;
extern NSString *const TallyEdited;

@property (strong, nonatomic) NSString *title;
@property (nonatomic) NSUInteger color;
@property (nonatomic) BOOL pinned;
@property (nonatomic) BOOL locked;
@property (nonatomic) NSInteger value;
@property (strong, nonatomic) NSString *valueString;
@property (strong, nonatomic) NSDate *creationDate;
@property (strong, nonatomic) NSDate *modificationDate;

- (Tally *)initWithTitle:(NSString *)title color:(NSUInteger *)color pinned:(BOOL)pinned locked:(BOOL)locked value:(NSInteger)value;

- (Tally *)initWithDictionary:(NSDictionary *)dictionary;

- (void)editWithTitle:(NSString *)title pinned:(BOOL)pinned locked:(BOOL)locked color:(NSUInteger)color;

- (void)increment:(NSInteger)increment;
- (void)reset;
- (NSString *)asSentence;
- (NSDictionary *)dictionary;

@end
