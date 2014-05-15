//
//  PreferenceList.m
//  CountOnIt
//
//  Created by J. Blair Metcalf on 3/7/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "PreferenceList.h"

@interface PreferenceList ()

@property (strong, nonatomic) NSString *fileName;

@end

@implementation PreferenceList

// NSPropertyListSerialization
// serialization
// https://developer.apple.com/Library/ios/documentation/Cocoa/Conceptual/PropertyLists/QuickStartPlist/QuickStartPlist.html
// NSString *filePath = [[NSBundle mainBundle] pathForResource:@"CountOnIt" ofType:@"plist"];

- (PreferenceList *)initWithFileName:(NSString *)fileName
{
    self = [super init];
    if (self) {
        _fileName = fileName;
    }
    return self;
}

- (void)saveDictionary:(NSDictionary *)dictionary
{
    [self saveObject:dictionary inFile:self.fileName];
}

- (NSDictionary *)getDictionary
{
    return [self getDictionaryFromFile:self.fileName];
}

- (void)saveArray:(NSArray *)array
{
    [self saveObject:array inFile:self.fileName];
}

- (NSArray *)getArray
{
    return [self getArrayFromFile:self.fileName];
}

- (void)saveObject:(id)object inFile:(NSString *)fileName
{
    NSString *filePath = [self createPathWithFileName:fileName];
    [object writeToFile:filePath atomically:YES];
}

- (id)getDictionaryFromFile:(NSString *)fileName
{
    NSString *filePath = [self createPathWithFileName:fileName];
    return [[NSDictionary alloc] initWithContentsOfFile:filePath];
}

- (id)getArrayFromFile:(NSString *)fileName
{
    NSString *filePath = [self createPathWithFileName:fileName];
    return [[NSArray alloc] initWithContentsOfFile:filePath];
}

- (NSString *)createPathWithFileName:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *path = [documents stringByAppendingPathComponent:fileName];
    return path;
}

@end
