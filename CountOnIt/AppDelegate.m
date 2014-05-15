//
//  AppDelegate.m
//  CountOnIt
//
//  Created by J. Blair Metcalf on 3/22/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "AppDelegate.h"
#import "UIColor+Utility.h"
#import "Database.h"
#import "MBFingerTipWindow.h"
#import "Appirater.h"
#import "CountOnItInAppPurchases.h"
#import "GAI.h"

@implementation AppDelegate

NSString *const StatusBarTouched = @"StatusBarTouched";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // [TestFlight takeOff:@"77fc756b-5dc6-4efe-ad0c-879efbd9b211"];
    
    [CountOnItInAppPurchases sharedInstance];
    
    [self googleAnalytics];
    // [self avaiableFonts];
    // [self showFingerTips];
    // [self appiraterInit];// ALSO BELOW
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{ NSFontAttributeName: [UIFont fontWithName:@"SourceSansPro-Regular" size:20.0f], NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#4c4c4c"] }];
    
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithHexString:@"#ff2956"]];
    
    return YES;
}

- (void)googleAnalytics
{
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [[GAI sharedInstance].logger setLogLevel:kGAILogLevelNone];// kGAILogLevelVerbose,kGAILogLevelNone
    [GAI sharedInstance].dispatchInterval = 20;
    __unused id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-2920896-4"];
    // id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-2920896-4"];
}

- (void)avaiableFonts
{
    for (NSString* family in [UIFont familyNames]) {
        NSLog(@"%@", family);
        for (NSString* name in [UIFont fontNamesForFamilyName: family]) {
            NSLog(@"  %@", name);
        }
    }
}

- (void)appiraterInit
{
    [Appirater setAppId:@"289278734"];    // Change for your "Your APP ID"
    [Appirater setDaysUntilPrompt:3];     // Days from first entered the app until prompt
    [Appirater setUsesUntilPrompt:5];     // Number of uses until prompt
    [Appirater setTimeBeforeReminding:2]; // Days until reminding if the user taps "remind me"
    //[Appirater setDebug:YES];           // If you set this to YES it will display all the time
    [Appirater appLaunched:YES];
}

- (void)showFingerTips
{
    MBFingerTipWindow *fingerTipWindow = [[MBFingerTipWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    fingerTipWindow.touchImage = [UIImage imageNamed:@"Finger-Tip"];
    fingerTipWindow.touchAlpha = 1.0f;
    
    self.window = fingerTipWindow;
    self.window.backgroundColor = [UIColor whiteColor];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    self.window.rootViewController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"Root View Controller"];
    [self.window makeKeyAndVisible];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    CGPoint point = [[[event allTouches] anyObject] locationInView:[self window]];
    if(point.y > 0 && point.y < 20) {
        [[NSNotificationCenter defaultCenter] postNotificationName:StatusBarTouched object:self];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[Database sharedInstance] save];
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    application.applicationIconBadgeNumber = 0;
    
    // !!!
    // [Appirater appEnteredForeground:YES];
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
