//
//  Tallies.m
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/22/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "Tallies.h"

@implementation Tallies

static Tallies *sharedInstance;

NSString *const TalliesAddedTally = @"TalliesAddedTally";
NSString *const TalliesRemovedTally = @"TalliesRemovedTally";
NSString *const TalliesRemovedAllTallies = @"TalliesRemovedAllTallies";
NSString *const TalliesSorted = @"TalliesSorted";

+ (Tallies *)sharedInstance {
    static BOOL initialized = NO;
    if (!initialized) {
        initialized = YES;
        sharedInstance = [[Tallies alloc] init];
    }
    return sharedInstance;
}

- (Tallies *)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(tallyPinnedChanged:)
                                                     name:TallyPinnedChanged
                                                   object:nil];
    }
    return self;
}

- (void)resetAllTallies
{
    for (Tally *tally in self.tallies) {
        if (!tally.locked) [tally reset];
    }
}

- (void)removeAllTallies
{
    BOOL removed = NO;
    
    NSMutableArray *copy = [self.tallies copy];
    
    for (Tally *tally in copy) {
        if (!tally.locked) {
            removed = YES;
            
            self.indexOfMostRecentlyRemovedTally = [self.tallies indexOfObject:tally];
            // self.mostRecentlyRemovedTally = tally;
            [self.tallies removeObject:tally];
        }
    }
    
    if (removed) [[NSNotificationCenter defaultCenter] postNotificationName:TalliesRemovedAllTallies object:self];
}

- (NSUInteger)indexOfMostRecentlyCreatedTally
{
    NSUInteger mostRecent = 0;
    // NSUInteger index = 0;
    
    // for (Tally *tally in self.tallies) {
    for (NSInteger i = 1; i<self.tallies.count; i++) {
        Tally *tally0 = [self.tallies objectAtIndex:mostRecent];
        Tally *tally1 = [self.tallies objectAtIndex:i];
        
        if ([tally0.creationDate compare:tally1.creationDate] == NSOrderedAscending) {
            mostRecent = i;
        }
        /*
        // if (index) {
            Tally *tally0 = [self.tallies objectAtIndex:mostRecent];
            Tally *tally1 = [self.tallies objectAtIndex:index];
            
            if ([tally0.creationDate compare:tally1.creationDate] == NSOrderedAscending) {
                mostRecent = i;
            }
        }
        // index++;
         */
    }
    
    return mostRecent;
}

- (NSUInteger)indexOfMostRecentlyModifiedTally
{
    NSUInteger mostRecent = 0;
    NSUInteger index = 0;
    
    for (Tally *tally in self.tallies) {
        if (index) {
            Tally *tally0 = [self.tallies objectAtIndex:mostRecent];
            Tally *tally1 = [self.tallies objectAtIndex:index];
            
            if ([tally0.modificationDate compare:tally1.modificationDate] == NSOrderedAscending) {
                mostRecent = index;
                self.mostRecentlyModifiedTally = tally;
            }
        }
        index++;
    }
    
    return mostRecent;
}

- (NSUInteger)count
{
    return self.tallies.count;
}

- (void)tallyPinnedChanged:(NSNotification *)notification
{
    [self sort];
    [[NSNotificationCenter defaultCenter] postNotificationName:TalliesSorted object:self];
}

- (void)addTally:(Tally *)tally
{
    self.mostRecentlyAddedTally = tally;//[self.tallies indexOfObject:tally];
    
    [self.tallies addObject:tally];
    [self sort];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TalliesAddedTally object:self];
}

- (void)removeTally:(Tally *)tally
{
    self.indexOfMostRecentlyRemovedTally = [self.tallies indexOfObject:tally];
    // self.mostRecentlyRemovedTally = tally;
    [self.tallies removeObject:tally];
    [[NSNotificationCenter defaultCenter] postNotificationName:TalliesRemovedTally object:self];
}

- (void)setSortAlpabetically:(BOOL)sortAlpabetically
{
    _sortAlpabetically = sortAlpabetically;
    
    [self sort];
    [[NSNotificationCenter defaultCenter] postNotificationName:TalliesSorted object:self];
}

- (void)sort
{
    if (_tallies.count) {
        NSArray *sortedArray = [_tallies sortedArrayUsingComparator:^(Tally *tally1, Tally *tally2) {
            if (tally1.pinned && !tally2.pinned) {
                return (NSComparisonResult)NSOrderedAscending;
            } else if (!tally1.pinned && tally2.pinned) {
                return (NSComparisonResult)NSOrderedDescending;
            } else if (self.sortAlpabetically) {
                NSComparisonResult title = [tally1.title compare:tally2.title];
                if (title == (NSComparisonResult)NSOrderedSame) {
                    return [tally1.creationDate compare:tally2.creationDate];
                } else {
                    return title;
                }
            } else {
                return [tally1.creationDate compare:tally2.creationDate];
            }
        }];
        
        self.tallies = [sortedArray mutableCopy];
    }
}

- (Tally *)tallyAtIndex:(NSUInteger)index
{
    return [self.tallies objectAtIndex:index];
}

- (NSUInteger)indexOfTally:(Tally *)tally
{
    return [self.tallies indexOfObject:tally];
}

- (NSMutableArray *)tallies
{
    if (!_tallies) {
        _tallies = [[NSMutableArray alloc] init];
    }
    return _tallies;
}

- (void)populateWithTallies:(NSArray *)tallies
{
    for (Tally *tally in tallies) {
        [self.tallies addObject:tally];
    }
    [self sort];
}

#pragma mark - Development

- (void)addFakeData
{
    /*
     [self.tallies addObject:[[Tally alloc] initWithTitle:@"WWWWWWWWWWWWWWWW" color:(NSUInteger *)6 pinned:YES locked:NO value:-10000]];
     [self.tallies addObject:[[Tally alloc] initWithTitle:@"WWWWWWWWWWWWWWWW" color:(NSUInteger *)6 pinned:YES locked:NO value:-1000]];
     [self.tallies addObject:[[Tally alloc] initWithTitle:@"88888888888888888888888888" color:(NSUInteger *)0 pinned:YES locked:NO value:1000]];
     [self.tallies addObject:[[Tally alloc] initWithTitle:@"88888888888888888888888888" color:(NSUInteger *)0 pinned:YES locked:NO value:10000]];
     */
    
    /*
     [self.tallies addObject:[[Tally alloc] initWithTitle:@"J" color:(NSUInteger *)1 pinned:NO locked:NO value:-11]];
     [self.tallies addObject:[[Tally alloc] initWithTitle:@"B" color:(NSUInteger *)2 pinned:NO locked:NO value:88]];
     [self.tallies addObject:[[Tally alloc] initWithTitle:@"Q" color:(NSUInteger *)3 pinned:NO locked:NO value:888]];
     [self.tallies addObject:[[Tally alloc] initWithTitle:@"L" color:(NSUInteger *)4 pinned:NO locked:NO value:34]];
     [self.tallies addObject:[[Tally alloc] initWithTitle:@"O" color:(NSUInteger *)5 pinned:NO locked:YES value:255]];
     [self.tallies addObject:[[Tally alloc] initWithTitle:@"Z" color:(NSUInteger *)6 pinned:NO locked:NO value:2]];
     [self.tallies addObject:[[Tally alloc] initWithTitle:@"A" color:(NSUInteger *)7 pinned:NO locked:NO value:45]];
     [self.tallies addObject:[[Tally alloc] initWithTitle:@"R" color:(NSUInteger *)0 pinned:NO locked:YES value:167]];
     */
    
    /*
    [self.tallies addObject:[[Tally alloc] initWithTitle:@"Walks on the Beach with Kate" color:(NSUInteger *)1 pinned:YES locked:NO value:11]];
    [self.tallies addObject:[[Tally alloc] initWithTitle:@"Evenings Spent Reading" color:(NSUInteger *)0 pinned:YES locked:NO value:57]];
    [self.tallies addObject:[[Tally alloc] initWithTitle:@"Full Nights of Rest" color:(NSUInteger *)3 pinned:YES locked:NO value:-7453]];
    [self.tallies addObject:[[Tally alloc] initWithTitle:@"Days Biking to Work" color:(NSUInteger *)5 pinned:YES locked:NO value:34]];
    [self.tallies addObject:[[Tally alloc] initWithTitle:@"Dinners with Family" color:(NSUInteger *)2 pinned:YES locked:NO value:-25]];
    */
    
    /*
    [self.tallies addObject:[[Tally alloc] initWithTitle:@"Walks on the Beach with Kate" color:(NSUInteger *)1 pinned:YES locked:NO value:0]];
    [self.tallies addObject:[[Tally alloc] initWithTitle:@"Evenings Spent Reading" color:(NSUInteger *)0 pinned:YES locked:NO value:0]];
    [self.tallies addObject:[[Tally alloc] initWithTitle:@"Full Nights of Rest" color:(NSUInteger *)3 pinned:YES locked:NO value:0]];
    */
    
    [self.tallies addObject:[[Tally alloc] initWithTitle:@"Walks on the Beach with Kate" color:(NSUInteger *)1 pinned:YES locked:NO value:11]];
    [self.tallies addObject:[[Tally alloc] initWithTitle:@"Evenings Spent Reading" color:(NSUInteger *)0 pinned:YES locked:NO value:-57]];
    [self.tallies addObject:[[Tally alloc] initWithTitle:@"Full Nights of Rest" color:(NSUInteger *)3 pinned:YES locked:NO value:31]];
    [self.tallies addObject:[[Tally alloc] initWithTitle:@"Days Biking to Work" color:(NSUInteger *)5 pinned:YES locked:NO value:-34]];
    [self.tallies addObject:[[Tally alloc] initWithTitle:@"Dinners with Family" color:(NSUInteger *)2 pinned:YES locked:YES value:25]];
    [self.tallies addObject:[[Tally alloc] initWithTitle:@"Classic Films Watched" color:(NSUInteger *)6 pinned:YES locked:NO value:-2]];
    [self.tallies addObject:[[Tally alloc] initWithTitle:@"Cups of Coffee" color:(NSUInteger *)5 pinned:NO locked:NO value:45]];
    [self.tallies addObject:[[Tally alloc] initWithTitle:@"Books Read" color:(NSUInteger *)0 pinned:NO locked:YES value:-12]];
    [self.tallies addObject:[[Tally alloc] initWithTitle:@"Strolls at Sunset" color:(NSUInteger *)7 pinned:NO locked:NO value:16]];
    [self.tallies addObject:[[Tally alloc] initWithTitle:@"Hearts Stolen" color:(NSUInteger *)2 pinned:NO locked:NO value:6]];
    [self.tallies addObject:[[Tally alloc] initWithTitle:@"Grey Hairs Found" color:(NSUInteger *)3 pinned:NO locked:YES value:-90]];
    [self.tallies addObject:[[Tally alloc] initWithTitle:@"Hi-Fives to Strangers" color:(NSUInteger *)1 pinned:NO locked:NO value:8]];
    [self.tallies addObject:[[Tally alloc] initWithTitle:@"Beers I Owe Noah" color:(NSUInteger *)4 pinned:NO locked:YES value:75]];
    [self.tallies addObject:[[Tally alloc] initWithTitle:@"Kisses Given" color:(NSUInteger *)5 pinned:NO locked:NO value:56]];
    
    [self sort];
}

@end
