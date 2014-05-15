//
//  Tally.m
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/22/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "Tally.h"
#import "NSDate+Utility.h"

@interface Tally ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation Tally

NSString *const TallyValueChanged = @"TallyValueChanged";
NSString *const TallyPinnedChanged = @"TallyPinnedChanged";
NSString *const TallyEdited = @"TallyEdited";

- (Tally *)initWithTitle:(NSString *)title color:(NSUInteger *)color pinned:(BOOL)pinned locked:(BOOL)locked value:(NSInteger)value
{
    self = [self init];
    if (self) {
        self.title = title;
        self.color = (NSUInteger)color;
        self.pinned = pinned;
        self.value = value;
        self.locked = locked;
        
        self.creationDate = [NSDate date];
        // self.creationDate = [[NSDate alloc] initWithYear:arc4random()%10+2004 month:arc4random()%12 day:arc4random()%30];
        self.modificationDate = [[NSDate alloc] initWithTimeInterval:0 sinceDate:self.creationDate];
    }
    return self;
}

- (Tally *)initWithTitle:(NSString *)title color:(NSUInteger *)color pinned:(BOOL)pinned locked:(BOOL)locked value:(NSInteger)value creationDate:(NSDate *)creationDate modificationDate:(NSDate *)modificationDate
{
    self = [self initWithTitle:title color:color pinned:pinned locked:locked value:value];
    if (self) {
        _creationDate = creationDate;
        _modificationDate = modificationDate;
    }
    return self;
}

- (Tally *)initWithDictionary:(NSDictionary *)dictionary
{
    self = [self initWithTitle:[dictionary valueForKey:@"title"]
                         color:(NSUInteger *)[[dictionary valueForKey:@"color"] integerValue]
                        pinned:[[dictionary valueForKey:@"pinned"] isEqualToString:@"YES"] ? YES : NO
                        locked:[[dictionary valueForKey:@"locked"] isEqualToString:@"YES"] ? YES : NO
                         value:[[dictionary valueForKey:@"value"] integerValue]
                  creationDate:[self.dateFormatter dateFromString:[dictionary valueForKey:@"creationDate"]]
              modificationDate:[self.dateFormatter dateFromString:[dictionary valueForKey:@"modificationDate"]]];
    if (self) {
        
    }
    return self;
}

- (void)increment:(NSInteger)increment
{
    self.value += increment;
    self.modificationDate = [NSDate date];
    [self valueChanged];
}

- (void)reset
{
    self.value = 0;
    self.modificationDate = [NSDate date];
    [self valueChanged];
}

- (NSString *)valueString
{
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    return [numberFormatter stringFromNumber:[NSNumber numberWithInteger:self.value]];
}

- (void)editWithTitle:(NSString *)title pinned:(BOOL)pinned locked:(BOOL)locked color:(NSUInteger)color
{
    BOOL pinnedChange = _pinned != pinned;
    
    _title = title;
    _pinned = pinned;
    _locked = locked;
    _color = color;
    
    self.modificationDate = [NSDate date];
    
    if (pinnedChange) [[NSNotificationCenter defaultCenter] postNotificationName:TallyPinnedChanged object:self];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TallyEdited object:self];
    
    /*
    if (pinnedChange) {
        [[NSNotificationCenter defaultCenter] postNotificationName:TallyPinnedChanged object:self];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:TallyEdited object:self];
    }
    */
}

- (void)valueChanged
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TallyValueChanged object:self];
}

- (NSString *)asSentence
{
    return [NSString stringWithFormat:@"%d \"%@\" since %@.", (int)self.value, self.title, [self.creationDate longPrettyDate]];
}

/*
- (NSString *)asSentence
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterSpellOutStyle];
    NSString *numberString = [numberFormatter stringFromNumber:[NSNumber numberWithInt:(int)self.value]];
    
    numberString = [numberString stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[numberString substringToIndex:1] uppercaseString]];
    
    return [NSString stringWithFormat:@"%@ %@ since %@.", numberString, self.title, [self.creationDate longPrettyDate]];
}
*/

- (NSString *)description
{
    return [NSString stringWithFormat:@"title: %@, value: %ld, color: %d, pinned: %d, date: %@", self.title, (long)self.value, (int)self.color, self.pinned, self.creationDate];
}

- (NSDictionary *)dictionary
{
    NSDictionary *dictionary = @{ @"title" : self.title,
                                  @"color" : [NSString stringWithFormat:@"%d", (int)self.color],
                                  @"pinned" : self.pinned ? @"YES" : @"NO",
                                  @"locked" : self.locked ? @"YES" : @"NO",
                                  @"value" : [NSString stringWithFormat:@"%d", (int)self.value],
                                  @"creationDate" : [self.dateFormatter stringFromDate:self.creationDate],
                                  @"modificationDate" : [self.dateFormatter stringFromDate:self.modificationDate] };
    return dictionary;
}

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    }
    return _dateFormatter;
}

@end
