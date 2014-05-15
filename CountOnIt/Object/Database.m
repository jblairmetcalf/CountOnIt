//
//  TalliesManager.m
//  CountOnIt
//
//  Created by J. Blair Metcalf on 3/8/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "Database.h"
#import "PreferenceList.h"
#import "Tallies.h"
#import "Tally.h"

@interface Database ()

@property (strong, nonatomic) PreferenceList *preferenceList;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation Database

static Database *sharedInstance;

+ (Database *)sharedInstance {
    static BOOL initialized = NO;
    if (!initialized) {
        initialized = YES;
        sharedInstance = [[Database alloc] init];
    }
    return sharedInstance;
}

- (Database *)init
{
    self = [super init];
    if (self) {
        self.preferenceList = [[PreferenceList alloc] initWithFileName:@"Database_v1_0.plist"];
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:60.0f
                                                  target:self
                                                selector:@selector(timerInterval:)
                                                userInfo:nil
                                                 repeats:YES];
    }
    return self;
}

- (void)talliesChanged:(NSNotification *)notification
{
    [self save];
}

- (void)reset
{
    [self.preferenceList saveDictionary:[[NSDictionary alloc] init]];
}

- (void)save
{
    [self.preferenceList saveDictionary:[self unsavedDatabase]];
}

- (void)populate
{
    [[Tallies sharedInstance] populateWithTallies:[[self savedDatabase] valueForKey:@"tallies"]];
}

- (void)timerInterval:(NSTimer *)timer
{
    [self save];
}

- (NSDictionary *)unsavedDatabase
{
    NSArray *tallies = [Tallies sharedInstance].tallies;
    NSMutableArray *dictionaries = [[NSMutableArray alloc] init];
    for (Tally *tally in tallies) {
        [dictionaries addObject:tally.dictionary];
    }
    return @{ @"tallies" : dictionaries };
}

- (NSDictionary *)savedDatabase
{
    NSArray *savedTallies = [[self.preferenceList getDictionary] valueForKey:@"tallies"];
    NSMutableArray *tallies = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dictionary in savedTallies) {
        Tally *tally = [[Tally alloc] initWithDictionary:dictionary];
        [tallies addObject:tally];
    }
    
    return @{ @"tallies" : tallies };
}

@end
