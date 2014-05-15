//
//  InAppPurchases.h
//  CountOnIt
//
//  Created by J. Blair Metcalf on 3/24/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StoreKit/StoreKit.h"

extern NSString *const InAppPurchasesProductPurchasedNotification;
extern NSString *const InAppPurchasesProductPurchaseFailedNotification;
extern NSString *const InAppPurchasesProductPurchaseCanceledNotification;

typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);

@interface InAppPurchases : NSObject

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler;
- (void)buyProduct:(SKProduct *)product;
- (void)buyProductIdentifier:(NSString *)productIdentifier;
- (BOOL)productPurchased:(NSString *)productIdentifier;
- (void)restoreCompletedTransactions;
- (SKProduct *)productWithIdentifier:(NSString *)productIdentifier;

@end