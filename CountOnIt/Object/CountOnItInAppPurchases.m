//
//  CountOnItInAppPurchases.m
//  CountOnIt
//
//  Created by J. Blair Metcalf on 3/24/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "CountOnItInAppPurchases.h"

@implementation CountOnItInAppPurchases

static CountOnItInAppPurchases *sharedInstance;

NSString *const CountOnItInUnlimitedIdentifier = @"com.jblairmetcalf.CountOnIt.Unlimited";

+ (CountOnItInAppPurchases *)sharedInstance {
    static BOOL initialized = NO;
    if (!initialized) {
        initialized = YES;
        sharedInstance = [[CountOnItInAppPurchases alloc] init];
    }
    return sharedInstance;
}

- (CountOnItInAppPurchases *)init
{
    // do not hardcode paths?
    
    NSSet *productIdentifiers = [NSSet setWithObjects:CountOnItInUnlimitedIdentifier, nil];
    self = [super initWithProductIdentifiers:productIdentifiers];
    
    if (self) {
        [self requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
            NSLog(@"CountOnItInAppPurchases: requestProductsWithCompletionHandler: %i, products: %@", success, products);
        }];
    }
    return self;
}

- (BOOL)unlimitedPurchased
{
    return [[CountOnItInAppPurchases sharedInstance] productPurchased:CountOnItInUnlimitedIdentifier];
}

- (void)purchaseUnlimited
{
    return [self buyProductIdentifier:CountOnItInUnlimitedIdentifier];
}

@end
