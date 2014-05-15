//
//  InAppPurchases.m
//  CountOnIt
//
//  Created by J. Blair Metcalf on 3/24/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "InAppPurchases.h"
#import <StoreKit/StoreKit.h>

@interface  InAppPurchases () <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (strong, nonatomic) SKProductsRequest *productsRequest;
@property (strong, nonatomic) RequestProductsCompletionHandler completionHandler;
@property (strong, nonatomic) NSSet *productIdentifiers;
@property (strong, nonatomic) NSMutableSet *purchasedProductIdentifiers;
@property (strong, nonatomic) NSArray *products;

@end

@implementation InAppPurchases

NSString *const InAppPurchasesProductPurchasedNotification = @"InAppPurchasesProductPurchasedNotification";
NSString *const InAppPurchasesProductPurchaseFailedNotification = @"InAppPurchasesProductPurchaseFailedNotification";
NSString *const InAppPurchasesProductPurchaseCanceledNotification = @"InAppPurchasesProductPurchaseCanceledNotification";

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers
{
    self = [super init];
    
    if (self) {
        self.productIdentifiers = productIdentifiers;
        
        self.purchasedProductIdentifiers = [NSMutableSet set];
        for (NSString *productIdentifier in self.productIdentifiers) {
            BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
            if (productPurchased) {
                NSLog(@"InAppPurchases: purchased: %@", productIdentifier);
                
                [self.purchasedProductIdentifiers addObject:productIdentifier];
            } else {
                NSLog(@"InAppPurchases: not purchased: %@", productIdentifier);
            }
        }
    }
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    return self;
}

- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler
{
    NSLog(@"InAppPurchases: requestProductsWithCompletionHandler: ");
    
    self.completionHandler = [completionHandler copy];
    
    self.productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:self.productIdentifiers];
    self.productsRequest.delegate = self;
    [self.productsRequest start];
}

#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSLog(@"InAppPurchases: productsRequest:");
    self.productsRequest = nil;
    
    self.products = response.products;
    for (SKProduct *product in self.products) {
        NSLog(@"InAppPurchases: productsRequest: product: %@ %@ %0.2f",
              product.productIdentifier,
              product.localizedTitle,
              product.price.floatValue);
    }
    
    self.completionHandler(YES, self.products);
    self.completionHandler = nil;
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"InAppPurchases: request: didFailWithError:");
    
    self.productsRequest = nil;
    self.completionHandler(NO, nil);
    self.completionHandler = nil;
}

- (BOOL)productPurchased:(NSString *)productIdentifier
{
    return [_purchasedProductIdentifiers containsObject:productIdentifier];
}

- (void)buyProduct:(SKProduct *)product
{
    NSLog(@"InAppPurchases: buyProduct: %@", product.productIdentifier);
    
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)buyProductIdentifier:(NSString *)productIdentifier
{
    NSLog(@"InAppPurchases: buyProductIdentifier: %@", productIdentifier);
    
    SKProduct *product = [self productWithIdentifier:productIdentifier];
    if (product) [self buyProduct:product];
}

- (SKProduct *)productWithIdentifier:(NSString *)productIdentifier
{
    NSLog(@"InAppPurchases: productWithIdentifier: %@", productIdentifier);
    
    for (SKProduct *product in self.products) {
        NSLog(@"product.productIdentifier: %@", product.productIdentifier);
        if ([product.productIdentifier isEqualToString:productIdentifier]) {
            return product;
        }
    }
    return nil;
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    NSLog(@"InAppPurchases: paymentQueue:");
    
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    };
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"InAppPurchases: completeTransaction:");
    
    [self provideContentForProductIdentifier:transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"InAppPurchases: restoreTransaction:");
    
    [self provideContentForProductIdentifier:transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"InAppPurchases: failedTransaction:");
    if (transaction.error.code != SKErrorPaymentCancelled) {
        NSLog(@"InAppPurchases: failedTransaction: transaction.error.code: %@", transaction.error.localizedDescription);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:InAppPurchasesProductPurchaseFailedNotification object:self userInfo:nil];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:InAppPurchasesProductPurchaseCanceledNotification object:self userInfo:nil];
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)provideContentForProductIdentifier:(NSString *)productIdentifier
{
    NSLog(@"InAppPurchases: provideContentForProductIdentifier: productIdentifier: %@", productIdentifier);
    
    [self.purchasedProductIdentifiers addObject:productIdentifier];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:InAppPurchasesProductPurchasedNotification object:productIdentifier userInfo:nil];
}

- (void)restoreCompletedTransactions
{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

@end
