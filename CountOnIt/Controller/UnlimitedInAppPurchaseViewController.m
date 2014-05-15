//
//  UnlimitedInAppPurchaseViewController.m
//  CountOnIt
//
//  Created by J. Blair Metcalf on 3/25/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "UnlimitedInAppPurchaseViewController.h"
#import "Global.h"
#import "UIColor+Utility.h"
#import "CountOnItInAppPurchases.h"
#import <StoreKit/StoreKit.h>
#import "Gradients.h"

@interface UnlimitedInAppPurchaseViewController ()

@property (strong, nonatomic) Gradients *gradients;
@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) UILabel *buyLabel;
@property (strong, nonatomic) UIButton *buyButton;
@property (strong, nonatomic) UIImageView *buyImageView;
@property (strong, nonatomic) SKProduct *product;
@property (strong, nonatomic) UIView *availableView;
@property (strong, nonatomic) UILabel *unavailableLabel;
@property (strong, nonatomic) UILabel *completeLabel;
@property (strong, nonatomic) UIAlertView *alertView;

@end

@implementation UnlimitedInAppPurchaseViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    
    [self.view addSubview:self.gradients];
    
    if (self.product) {
        [self.view addSubview:self.availableView];
        
        [self addNotifications];
    } else {
        [self.view addSubview:self.unavailableLabel];
    }
    
    [self.view addSubview:self.closeButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.screenName = @"Unlimited In App Purchase";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self removeNotifications];
}

- (SKProduct *)product
{
    return [[CountOnItInAppPurchases sharedInstance] productWithIdentifier:CountOnItInUnlimitedIdentifier];
}

#pragma mark - Interaction

- (IBAction)close:(UIButton *)button
{
    [self.delegate dismissModal:self];
}

- (IBAction)buyTouched:(UIButton *)sender
{
    self.buyButton.enabled = NO;
    
    [[CountOnItInAppPurchases sharedInstance] purchaseUnlimited];
}

#pragma mark - Notifications

- (void)addNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:InAppPurchasesProductPurchasedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseFailed:) name:InAppPurchasesProductPurchaseFailedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseCanceled:) name:InAppPurchasesProductPurchaseCanceledNotification object:nil];
}

- (void)removeNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)productPurchased:(NSNotification *)notification
{
    NSLog(@"UnlimitedInAppPurchaseViewController: productPurchased:");
    
    NSString *productIdentifier = notification.object;
    
    if ([productIdentifier isEqualToString:CountOnItInUnlimitedIdentifier]) [self purchaseComplete];
}

- (void)purchaseFailed:(NSNotification *)notification
{
    NSLog(@"UnlimitedInAppPurchaseViewController: purchaseFailed:");
    
    self.buyButton.enabled = YES;
    
    [self.alertView show];
}

- (void)purchaseCanceled:(NSNotification *)notification
{
    NSLog(@"UnlimitedInAppPurchaseViewController: purchaseCanceled:");
    
    self.buyButton.enabled = YES;
}

- (void)purchaseComplete
{
    self.purchased = YES;
    self.completeLabel.alpha = 0.0f;
    
    [UIView animateWithDuration:GlobalDuration animations:^{
        self.completeLabel.alpha = 1.0f;
        self.availableView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self.availableView.hidden = YES;
    }];
    
    [self performSelector:@selector(close) withObject:self afterDelay:2.0f];
}

- (void)close
{
    [self.delegate dismissModal:self];
}

#pragma mark - Drawing

- (UIAlertView *)alertView
{
    if (!_alertView) {
        _alertView = [[UIAlertView alloc] initWithTitle:@"Purchase Failed"
                                                message:@"Please try again."
                                               delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
    }
    return _alertView;
}

- (UIView *)availableView
{
    if (!_availableView) {
        _availableView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
        
        [_availableView addSubview:self.buyLabel];
        [_availableView addSubview:self.buyButton];
        [_availableView addSubview:self.buyImageView];
    }
    return _availableView;
}

- (UIColor *)textColor
{
    return [UIColor colorWithHexString:@"#4c4c4c"];
}

- (UIFont *)lightFont
{
    return [UIFont fontWithName:@"SourceSansPro-Light" size:20.0f];
}

- (UIFont *)regularFont
{
    return [UIFont fontWithName:@"SourceSansPro-Regular" size:20.0f];
}

- (UILabel *)buyLabel
{
    if (!_buyLabel) {
        _buyLabel = [[UILabel alloc] initWithFrame:CGRectMake(GlobalPadding, 44.0f, 320.0f-(GlobalPadding*2), 80.0f)];
        _buyLabel.font = self.lightFont;
        _buyLabel.textColor = self.textColor;
        _buyLabel.textAlignment = NSTextAlignmentCenter;
        _buyLabel.numberOfLines = 3;
        
        NSNumberFormatter *priceFormatter = [[NSNumberFormatter alloc] init];
        [priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        
        SKProduct *product = [[CountOnItInAppPurchases sharedInstance] productWithIdentifier:CountOnItInUnlimitedIdentifier];
        
        NSString *price = @"";
        
        if (product) {
            [priceFormatter setLocale:product.priceLocale];
            price = [priceFormatter stringFromNumber:product.price];
        }
        
        NSString *string = [NSString stringWithFormat:@"For only %@ you can add\nunlimited tallies and exports\nand daily reminders.", price];
        NSArray *substrings = @[[NSString stringWithFormat:@"For only %@", price], @"unlimited tallies", @"exports", @"daily reminders"];
        
        _buyLabel.attributedText = [self attributedTextWithString:string substrings:substrings];
    }
    return _buyLabel;
}

- (UILabel *)unavailableLabel
{
    if (!_unavailableLabel) {
        CGFloat height = 160.0f;
        
        _unavailableLabel = [[UILabel alloc] initWithFrame:CGRectMake(GlobalPadding, (self.view.frame.size.height-height)/2, 320.0f-(GlobalPadding*2), height)];
        _unavailableLabel.font = self.lightFont;
        _unavailableLabel.textColor = self.textColor;
        _unavailableLabel.textAlignment = NSTextAlignmentCenter;
        _unavailableLabel.numberOfLines = 6;
        
        NSString *string = @"The App Store is unavailable.\nCheck your connection.\n\nThe app will be limited to\nthree tallies, one export,\nand no daily reminders.";
        NSArray *substrings = @[@"Check your connection", @"The app will be limited", @"three tallies", @"one export", @"no daily reminders"];
        
        _unavailableLabel.attributedText = [self attributedTextWithString:string substrings:substrings];
    }
    return _unavailableLabel;
}

- (UILabel *)completeLabel
{
    if (!_completeLabel) {
        CGFloat height = 80.0f;
        
        _completeLabel = [[UILabel alloc] initWithFrame:CGRectMake(GlobalPadding, (self.view.frame.size.height-height)/2, 320.0f-(GlobalPadding*2), height)];
        _completeLabel.font = self.lightFont;
        _completeLabel.textColor = self.textColor;
        _completeLabel.textAlignment = NSTextAlignmentCenter;
        _completeLabel.numberOfLines = 3;
        
        NSString *string = @"Thank you!";
        NSArray *substrings = @[string];
        
        _completeLabel.attributedText = [self attributedTextWithString:string substrings:substrings];
        
        [self.view addSubview:_completeLabel];
    }
    return _completeLabel;
}

- (NSMutableAttributedString *)attributedTextWithString:(NSString *)string substrings:(NSArray *)substrings
{
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:string];
    
    for (NSString *substring in substrings) {
        [attributedText addAttribute:NSFontAttributeName value:self.regularFont range:[string rangeOfString:substring]];
    }
    
    return attributedText;
}

- (UIView *)gradients
{
    if (!_gradients) {
        _gradients = [[Gradients alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height) top:@"#96d4e0" bottom:@"#af4990" leftTop:NO];
    }
    return _gradients;
}

- (UIView *)buyButton
{
    if (!_buyButton) {
        CGFloat height = 100.0f;
        
        _buyButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _buyButton.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:29.0f];
        _buyButton.frame = CGRectMake(GlobalPadding, 105.0f, 320.0f-(GlobalPadding*2), height);
        [_buyButton setTitle:@"Buy" forState:UIControlStateNormal];
        [_buyButton setTitleColor:[UIColor colorWithHexString:@"#ff2956"] forState:UIControlStateNormal];
        [_buyButton addTarget:self action:@selector(buyTouched:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buyButton;
}

- (UIImageView *)buyImageView
{
    if (!_buyImageView) {
        UIImage *image = [UIImage imageNamed:@"Unlimited"];
        
        _buyImageView = [[UIImageView alloc] initWithImage:image];
        _buyImageView.frame = CGRectMake(34.0f, 195.0f, 251.0f, 373.0f);
    }
    return _buyImageView;
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        CGRect frame = CGRectMake(self.view.frame.size.width-35.0f, 20.0f, 35.0f, 35.0f);
        
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.frame = frame;
        
        [_closeButton setImage:[UIImage imageNamed:@"Tour-Close"] forState:UIControlStateNormal];
        [_closeButton setImage:[UIImage imageNamed:@"Tour-Close-Highlighted"] forState:UIControlStateHighlighted];
        [_closeButton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

@end
