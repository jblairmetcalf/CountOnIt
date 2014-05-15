//
//  UIViewController+Utility.m
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/23/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "UIViewController+Utility.h"
#import "UIColor+Utility.h"

@implementation UIViewController (Utility)

+ (void)backgroundColors:(UIViewController *)viewController
{
    UINavigationBar *navigationBar = viewController.navigationController.navigationBar;
    navigationBar.barTintColor = [UIColor colorWithHexString:@"#f6f6f6"];
    navigationBar.translucent = NO;
    
    // viewController.view.backgroundColor = [UIColor whiteColor];
}

+ (CGRect)frame:(UIViewController *)viewController
{
    CGSize size = [UIViewController size:viewController];
    return CGRectMake(0, 0, size.width, size.height);
}

+ (CGSize)size:(UIViewController *)viewController
{
    CGRect statusBarRect = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat statusBarHieght = statusBarRect.size.height;
    CGFloat navigationBarHieght = viewController.navigationController.navigationBar.frame.size.height;
    
    return CGSizeMake(viewController.view.frame.size.width, viewController.view.frame.size.height-(statusBarHieght+navigationBarHieght));
}

@end
