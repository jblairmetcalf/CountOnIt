//
//  Tallies.h
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/22/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tally.h"

@interface Tallies : NSObject

extern NSString *const TalliesAddedTally;
extern NSString *const TalliesRemovedTally;
extern NSString *const TalliesRemovedAllTallies;
extern NSString *const TalliesSorted;

@property (strong, nonatomic) NSMutableArray *tallies;
@property (nonatomic) BOOL sortAlpabetically;

@property (nonatomic) NSUInteger indexOfMostRecentlyCreatedTally;
@property (nonatomic) NSUInteger indexOfMostRecentlyModifiedTally;
@property (nonatomic) NSUInteger indexOfMostRecentlyRemovedTally;

@property (nonatomic, strong) Tally *mostRecentlyAddedTally;
@property (nonatomic, strong) Tally *mostRecentlyModifiedTally;
// @property (nonatomic, strong) Tally *mostRecentlyRemovedTally;

@property (nonatomic) NSUInteger count;

+ (Tallies *)sharedInstance;
- (void)resetAllTallies;
- (void)removeAllTallies;
- (void)addTally:(Tally *)tally;
- (void)removeTally:(Tally *)tally;
- (Tally *)tallyAtIndex:(NSUInteger)index;
- (void)populateWithTallies:(NSArray *)tallies;
- (void)addFakeData;

@end
