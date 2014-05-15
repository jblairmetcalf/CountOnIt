//
//  CountOnItInAppPurchases.h
//  CountOnIt
//
//  Created by J. Blair Metcalf on 3/24/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "InAppPurchases.h"

@interface CountOnItInAppPurchases : InAppPurchases

extern NSString *const CountOnItInUnlimitedIdentifier;

@property (nonatomic) BOOL unlimitedPurchased;

+ (CountOnItInAppPurchases *)sharedInstance;
- (void)purchaseUnlimited;

@end
