//
//  ViewController.m
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/22/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "ViewController.h"
#import "SettingsViewController.h"
#import "AddTallyViewController.h"
#import "EditTallyViewController.h"
#import "NoTalliesView.h"
#import "TalliesView.h"
#import "Tallies.h"
#import "Tally.h"
#import "UIColor+Utility.h"
#import "UIViewController+Utility.h"
#import "TallyView.h"
#import "TallyDrawerView.h"
#import "AppDelegate.h"
#import "Global.h"
#import "LoadingView.h"
#import "WelcomeViewController.h"
#import "Database.h"
#import "Hints.h"
#import "CountOnItInAppPurchases.h"
#import "UnlimitedInAppPurchaseViewController.h"

@interface ViewController () <WelcomeTourViewControllerDelegate, UnlimitedInAppPurchaseViewControllerDelegate>

@property (strong, nonatomic) UIBarButtonItem *settingsBarButton;
@property (strong, nonatomic) UIBarButtonItem *addBarButton;
@property (strong, nonatomic) NoTalliesView *noTalliesView;
@property (strong, nonatomic) TalliesView *talliesView;
@property (strong, nonatomic) LoadingView *loadingView;

@end

@implementation ViewController

NSString *const WelcomeComplete = @"WelcomeComplete";
NSString *const ShowAddTally = @"ShowAddTally";

- (void)viewDidLoad
{
    // [self resetUserDefaults];
    
    [self version];
    
    // [[Database sharedInstance] reset];
    [[Database sharedInstance] populate];
    
    // [[Tallies sharedInstance] addFakeData];
    
    [self sortAlphabetically];
    
    // == == == == ==
    
    [super viewDidLoad];
    
    self.screenName = @"View Controller";
    
    [UIViewController backgroundColors:self];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [Hints sharedInstance].view = self.view;
     
    [self navigationBarGesture];
    [self addNotifications];
    
    if (self.welcomeDisplayed) {
        [self welcomeComplete];
    } else {
        [self performSelector:@selector(showWelcome) withObject:self afterDelay:0.75f];
    }
    
    [self toggleViews];
}

- (void)version
{
    [[NSUserDefaults standardUserDefaults] setObject:@"CountOnIt1.0" forKey:@"version"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)addNavigationItems
{
    [self.navigationItem setLeftBarButtonItem:self.settingsBarButton];
    [self.navigationItem setRightBarButtonItem:self.addBarButton];
}

- (void)resetUserDefaults
{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}

- (void)toggleViews
{
    BOOL tallies = [Tallies sharedInstance].count != 0;
    
    self.noTalliesView.hidden = NO;
    self.talliesView.hidden = NO;
    
    [UIView animateWithDuration:GlobalDuration*2
                     animations:^{
                         self.noTalliesView.alpha = tallies ? 0.0f : 1.0f;
                         self.talliesView.alpha = tallies ? 1.0f : 0.0f;
                     } completion:^(BOOL finished) {
                         self.noTalliesView.hidden = tallies;
                         self.talliesView.hidden = !self.noTalliesView.hidden;
                     }];
}

- (void)welcomeComplete
{
    [self addNavigationItems];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:WelcomeComplete object:self];
}

#pragma mark - Welcome

- (BOOL)welcomeDisplayed
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"WelcomeDisplayedKey"] isEqualToString:@"YES"] ? YES : NO;
}

- (void)showWelcome
{
    [self performSegueWithIdentifier:@"Show Welcome" sender:self];
}

- (void)dismissModal:(WelcomeTourViewController *)sender
{
    if ([sender isKindOfClass:[WelcomeTourViewController class]]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"WelcomeDisplayedKey"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self welcomeComplete];
    } else if ([sender isKindOfClass:[UnlimitedInAppPurchaseViewController class]]) {
        NSLog(@"ViewController: dismissModal: UnlimitedInAppPurchaseViewController");
    }
    
    [self.presentedViewController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Unlimited In App Purchase

- (void)showUnlimitedInApPurchase
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    
    UnlimitedInAppPurchaseViewController *unlimitedInAppPurchaseViewController = (UnlimitedInAppPurchaseViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Unlimited In App Purchase"];
    unlimitedInAppPurchaseViewController.delegate = self;
    
    [self presentViewController:unlimitedInAppPurchaseViewController animated:YES completion:nil];
}

#pragma mark - Notification

- (void)addNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(talliesAddedTally:)
                                                 name:TalliesAddedTally
                                               object:[Tallies sharedInstance]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tallyEdit:)
                                                 name:TallyEdit
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(statusBarTouched:)
                                                 name:StatusBarTouched
                                               object:[[UIApplication sharedApplication] delegate]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(talliesRemovedTally:)
                                                 name:TalliesRemovedTally
                                               object:[Tallies sharedInstance]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(talliesRemovedAllTallies:)
                                                 name:TalliesRemovedAllTallies
                                               object:[Tallies sharedInstance]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tallyExport:)
                                                 name:TallyExport
                                               object:nil];
}

- (void)tallyExport:(NSNotification *)notification
{
    [self.loadingView show];
    
    TallyView *tallyView = notification.object;
    Tally *tally = tallyView.tally;
    
    [self performSelector:@selector(shareTally:) withObject:tally afterDelay:GlobalDuration];
}

- (void)shareTally:(Tally *)tally
{
    NSString *textToShare = tally.asSentence;
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[ textToShare ] applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[ UIActivityTypeAssignToContact ];
    [activityViewController setCompletionHandler:^(NSString *activityType, BOOL completed) {
        NSLog(@"ViewController: activityViewController: setCompletionHandler");
    }];
    
    [self presentViewController:activityViewController animated:YES completion:nil];
    [self.loadingView hide];
}

- (void)tallyEdit:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:GlobalFocusChanged object:self];
    
    TallyDrawerView *tallyDrawerView = notification.object;
    
    [self performSegueWithIdentifier:@"Show Edit Tally" sender:tallyDrawerView];
}

- (void)talliesAddedTally:(NSNotification *)notification
{
    [self toggleViews];
}

- (void)statusBarTouched:(NSNotification *)notification
{
    [self scrollToTop];
}

- (void)talliesRemovedTally:(NSNotification *)notification
{
    [self toggleViews];
}

- (void)talliesRemovedAllTallies:(NSNotification *)notification
{
    [self toggleViews];
}

#pragma mark - Interaction

- (void)navigationBarGesture
{
    UITapGestureRecognizer *navigationTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(navigationBarTouch:)];
    navigationTapGesture.numberOfTapsRequired = 1;
    [[self.navigationController.navigationBar.subviews objectAtIndex:1] setUserInteractionEnabled:YES];
    [[self.navigationController.navigationBar.subviews objectAtIndex:1] addGestureRecognizer:navigationTapGesture];
}

- (void)navigationBarTouch:(UITapGestureRecognizer *)gestureRecognizer
{
    [self scrollToTop];
}

- (void)scrollToTop
{
    [self.talliesView scrollToTop];
}

#pragma mark - Navigation

- (IBAction)showSettings:(UIBarButtonItem *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:GlobalFocusChanged object:self];
    
    [self performSegueWithIdentifier:@"Show Settings" sender:self];
}

- (IBAction)showAddTally:(UIBarButtonItem *)sender
{
    // [self showUnlimitedInApPurchase];
    
    if ([CountOnItInAppPurchases sharedInstance].unlimitedPurchased || [Tallies sharedInstance].count < 3) {
        [self presentAddTally];
    } else {
        [self showUnlimitedInApPurchase];
    }
}

- (IBAction)presentAddTally
{
    [[NSNotificationCenter defaultCenter] postNotificationName:GlobalFocusChanged object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:ShowAddTally object:self];
    
    [self performSegueWithIdentifier:@"Show Add Tally" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Welcome"]) {
        WelcomeViewController *welcomeViewController = (WelcomeViewController *)segue.destinationViewController;
        welcomeViewController.delegate = self;
    } else if ([segue.identifier isEqualToString:@"Show Settings"]) {
        NSLog(@"ViewController: prepareForSegue: Show Settings");
    } else if ([segue.identifier isEqualToString:@"Show Add Tally"]) {
        NSLog(@"ViewController: prepareForSegue: Show Add Tally");
    } else if ([segue.identifier isEqualToString:@"Show Edit Tally"]) {
        NSLog(@"ViewController: prepareForSegue: Show Edit Tally");
        
        EditTallyViewController *editTallyViewController = (EditTallyViewController *)segue.destinationViewController;
        TallyDrawerView *tallyDrawerView = (TallyDrawerView *)sender;
        
        editTallyViewController.tally = tallyDrawerView.tally;
    }
}

- (IBAction)settingsDone:(UIStoryboardSegue *)segue
{
    if ([segue.sourceViewController isKindOfClass:[SettingsViewController class]]) {
        NSLog(@"ViewController: settingsDone:");
        
        SettingsViewController *settingsViewController = segue.sourceViewController;
        
        if (settingsViewController.enableReminderChanged) {
            [self enableReminder];
        }
    }
}

- (void)sortAlphabetically
{
    BOOL sortAlpabetically = [[[NSUserDefaults standardUserDefaults] objectForKey:@"PreferenceSortAlphabetically"] isEqualToString:@"YES"] ? YES : NO;
    
    [Tallies sharedInstance].sortAlpabetically = sortAlpabetically;
}

- (void)enableReminder
{
    BOOL enableReminder = [[[NSUserDefaults standardUserDefaults] objectForKey:@"PreferenceEnableReminder"] isEqualToString:@"YES"] ? YES : NO;
    
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
    [application cancelAllLocalNotifications];
    
    if (enableReminder) {
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24];
        
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = date;
        localNotification.alertBody = @"Your friendly reminder to enter today's tallies.";
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.repeatInterval = NSDayCalendarUnit;
        localNotification.applicationIconBadgeNumber = 1;
        [application scheduleLocalNotification:localNotification];
    }
}

- (IBAction)addedTally:(UIStoryboardSegue *)segue
{
    if ([segue.identifier isEqualToString:@"Do Add Tally"]) {
        AddTallyViewController *addTallyViewController = segue.sourceViewController;
        
        Tally *tally = [[Tally alloc] initWithTitle:addTallyViewController.tallyTitle
                                              color:(NSUInteger *)addTallyViewController.tallyColor
                                             pinned:addTallyViewController.tallyPinned
                                             locked:addTallyViewController.tallyLocked
                                              value:addTallyViewController.tallyValue];
        
        [[Tallies sharedInstance] addTally:tally];
    }
}

- (IBAction)canceledAddTally:(UIStoryboardSegue *)segue
{
    if ([segue.identifier isEqualToString:@"Do Not Add Tally"]) {
        // NSLog(@"ViewController: canceledAddTally:");
    }
}

- (IBAction)editedTally:(UIStoryboardSegue *)segue
{
    if ([segue.identifier isEqualToString:@"Do Edit Tally"]) {
        EditTallyViewController *editTallyViewController = segue.sourceViewController;
        
        Tally *tally = editTallyViewController.tally;
        [tally editWithTitle:editTallyViewController.tallyTitle pinned:editTallyViewController.tallyPinned locked:editTallyViewController.tallyLocked color:editTallyViewController.tallyColor];
    }
}

- (IBAction)canceledEditTally:(UIStoryboardSegue *)segue
{
    if ([segue.identifier isEqualToString:@"Do Not Edit Tally"]) {
        NSLog(@"ViewController: canceledEditTally:");
    }
}

#pragma mark - Drawing

- (LoadingView *)loadingView
{
    if (!_loadingView) {
        _loadingView = [[LoadingView alloc] init];
    }
    return _loadingView;
}

- (UIBarButtonItem *)settingsBarButton
{
    if (!_settingsBarButton) {
        _settingsBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Navigation-Settings"] style:UIBarButtonItemStylePlain target:self action:@selector(showSettings:)];
    }
    return _settingsBarButton;
}

- (UIBarButtonItem *)addBarButton
{
    if (!_addBarButton) {
        _addBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showAddTally:)];
    }
    return _addBarButton;
}

- (NoTalliesView *)noTalliesView
{
    if (!_noTalliesView) {
        _noTalliesView = [[NoTalliesView alloc] initWithFrame:[UIViewController frame:self]];
        [self.view addSubview:_noTalliesView];
    }
    return _noTalliesView;
}

- (TalliesView *)talliesView
{
    if (!_talliesView) {
        _talliesView = [[TalliesView alloc] initWithFrame:[UIViewController frame:self]];
        [self.view addSubview:_talliesView];
    }
    return _talliesView;
}

@end
