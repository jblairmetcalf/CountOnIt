//
//  SettingsViewController.m
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/22/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "SettingsViewController.h"
#import "ViewCell.h"
#import "Tallies.h"
#import "UIViewController+Utility.h"
#import "TourViewController.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "Global.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"
#import "CountOnItInAppPurchases.h"
#import "UnlimitedInAppPurchaseViewController.h"

@interface SettingsViewController () <UITableViewDataSource, UITableViewDelegate, ViewCellDelegate, WelcomeTourViewControllerDelegate, MFMailComposeViewControllerDelegate, UnlimitedInAppPurchaseViewControllerDelegate>

@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, strong) UIAlertView *resetAlertView;
@property (nonatomic, strong) UIAlertView *deleteAlertView;
@property (nonatomic, strong) UIAlertView *restoredAlertView;

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addNotifications];
    
    [UIViewController backgroundColors:self];
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0.0f, 15.0f, 0.0f, 0.0f);
    
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{ NSFontAttributeName: [UIFont fontWithName:@"SourceSansPro-Regular" size:17.0f]} forState:UIControlStateNormal];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Settings"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self removeNotifications];
}

- (NSArray *)sections
{
    if (!_sections) {
        NSString *talliesEnabled = [Tallies sharedInstance].tallies.count ? @"YES" : @"NO";
        
        NSDictionary *reminder;
        if ([CountOnItInAppPurchases sharedInstance].unlimitedPurchased) {
            reminder = @{  @"identifier" : @"Settings Switch Cell", @"title" : @"Remind Daily", @"image" : [UIImage imageNamed:@"Settings-Remind"] , @"key" : @"PreferenceEnableReminder" , @"enabled" : @"YES" };
        } else {
            reminder = @{  @"identifier" : @"Settings Disclosure Cell", @"title" : @"Remind Daily", @"image" : [UIImage imageNamed:@"Settings-Remind"] , @"enabled" : @"YES" };
        }
        
        NSDictionary *tallies = @{ @"header" : @"Tallies", @"rows" : @[
                                           @{ @"identifier" : @"Settings Disclosure Cell", @"title" : @"Export Chart", @"image" : [UIImage imageNamed:@"Settings-Export"] , @"enabled" : talliesEnabled },
                                           @{ @"identifier" : @"Settings Disclosure Cell", @"title" : @"Reset All Tallies", @"image" : [UIImage imageNamed:@"Settings-Reset"] , @"enabled" : talliesEnabled },
                                           @{ @"identifier" : @"Settings Disclosure Cell", @"title" : @"Delete All Tallies", @"image" : [UIImage imageNamed:@"Settings-Delete"] , @"enabled" : talliesEnabled }
                                           ] };
        
        NSDictionary *preferences = @{ @"header" : @"Preferences", @"rows" : @[
                                               reminder,
                                               @{  @"identifier" : @"Settings Switch Cell", @"title" : @"Sort Alphabetically", @"image" : [UIImage imageNamed:@"Settings-Sort"] , @"key" : @"PreferenceSortAlphabetically" , @"enabled" : @"YES" },
                                               @{  @"identifier" : @"Settings Switch Cell", @"title" : @"Enable Sound", @"image" : [UIImage imageNamed:@"Settings-Sound"] , @"key" : @"PreferenceEnableSound" , @"enabled" : @"YES" }
                                               ] };
        
        NSDictionary *help = @{ @"header" : @"Help", @"rows" : @[
                                        @{  @"identifier" : @"Settings Disclosure Cell", @"title" : @"Rate App", @"image" : [UIImage imageNamed:@"Settings-Rate"] , @"enabled" : @"YES"},
                                        @{  @"identifier" : @"Settings Disclosure Cell", @"title" : @"View Tour", @"image" : [UIImage imageNamed:@"Settings-Tour"] , @"enabled" : @"YES"},
                                        @{  @"identifier" : @"Settings Disclosure Cell", @"title" : @"Contact Support", @"image" : [UIImage imageNamed:@"Settings-Support"] , @"enabled" : @"YES"}
                                        ] };
        
        if ([CountOnItInAppPurchases sharedInstance].unlimitedPurchased) {
            _sections = @[ tallies, preferences, help];
        } else {
            NSDictionary *inAppPurchases = @{ @"header" : @"In-App Purchases", @"rows" : @[
                                                      @{  @"identifier" : @"Settings Disclosure Cell", @"title" : @"Restore Purchases", @"image" : [UIImage imageNamed:@"Settings-Restore"] , @"enabled" : @"YES"} ] };
            
            _sections = @[ tallies, preferences, help, inAppPurchases];
        }
        
    }
    return _sections;
}

- (void)showTour
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    
    TourViewController *tourViewController = (TourViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Tour"];
    tourViewController.delegate = self;
    
    [self presentViewController:tourViewController animated:YES completion:nil];
}

- (void)dismissModal:(id)sender
{
    if ([sender isKindOfClass:[WelcomeTourViewController class]]) {
        NSLog(@"SettingsViewController: dismissModal: WelcomeTourViewController");
    } else if ([sender isKindOfClass:[UnlimitedInAppPurchaseViewController class]]) {
        NSLog(@"SettingsViewController: dismissModal: UnlimitedInAppPurchaseViewController");
        
        [self reloadData];
    }
    
    [self.presentedViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)reloadData
{
    self.sections = nil;
    [self.tableView reloadData];
}

#pragma mark - Notifications

- (void)addNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inAppPurchasesProductPurchasedNotification:)
                                                 name:InAppPurchasesProductPurchasedNotification
                                               object:nil];
}

- (void)removeNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)inAppPurchasesProductPurchasedNotification:(NSNotification *)notification
{
    [self reloadData];
    
    [self.restoredAlertView show];
    [self performSelector:@selector(hideRestoredAlertView) withObject:nil afterDelay:2.0];
    
}

- (void)hideRestoredAlertView
{
    [self.restoredAlertView dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark - Unlimited In App Purchase

- (void)showUnlimitedInApPurchase
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    
    UnlimitedInAppPurchaseViewController *unlimitedInAppPurchaseViewController = (UnlimitedInAppPurchaseViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Unlimited In App Purchase"];
    unlimitedInAppPurchaseViewController.delegate = self;
    
    [self presentViewController:unlimitedInAppPurchaseViewController animated:YES completion:nil];
}

#pragma mark - Navigation

- (IBAction)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Settings Done"]) {
        NSLog(@"SettingsViewController: prepareForSegue: Settings Done");
    } else if ([segue.identifier isEqualToString:@"Show Export Chart"]) {
        NSLog(@"SettingsViewController: prepareForSegue: Show Export Chart");
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"Settings Done"]) {
        return YES;
    } else {
        return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
    }
}

- (void)exportChart
{
    [self performSegueWithIdentifier:@"Show Export Chart" sender:self];
}

- (IBAction)canceledExportChart:(UIStoryboardSegue *)segue
{
    if ([segue.identifier isEqualToString:@"Canceled Export Chart"]) {
        NSLog(@"SettingsViewController: canceledExportChart: Canceled Export Chart");
        
        [self reloadData];
    }
}

- (IBAction)exportChart:(UIStoryboardSegue *)segue
{
    if ([segue.identifier isEqualToString:@"Do Export Chart"]) {
        NSLog(@"SettingsViewController: exportChart: Do Export Chart");
    }
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sections.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *header = [[self.sections objectAtIndex:section] objectForKey:@"header"];
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *rows = [[self.sections objectAtIndex:section] objectForKey:@"rows"];
    return rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *index = [[[self.sections objectAtIndex:indexPath.section] objectForKey:@"rows"] objectAtIndex:indexPath.row];
    
    NSString *cellIdentifier = [index valueForKey:@"identifier"];
    ViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.title = [index valueForKey:@"title"];
    
    if ([index valueForKey:@"image"]) {
        cell.image = [index valueForKey:@"image"];
    }
    
    cell.enabled = [[index valueForKey:@"enabled"] isEqualToString:@"YES"] ? YES : NO;
    
    if ([index valueForKey:@"key"]) {
        cell.key = [index valueForKey:@"key"];
        cell.delegate = self;
    }
    
    return cell;
}

#pragma mark - Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) [self exportChart];
    
    if (indexPath.section == 0 && indexPath.row == 1) [self.resetAlertView show];
    
    if (indexPath.section == 0 && indexPath.row == 2) [self.deleteAlertView show];
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        if (![CountOnItInAppPurchases sharedInstance].unlimitedPurchased) {
            [self remindDaily];
            [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] animated:YES];
        }
    }
    
    if (indexPath.section == 2 && indexPath.row == 0) {
        [self rateApp];
        [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] animated:YES];
    }
    
    if (indexPath.section == 2 && indexPath.row == 1) [self showTour];
    
    if (indexPath.section == 2 && indexPath.row == 2) [self contactSupport];
    
    if (indexPath.section == 3 && indexPath.row == 0) {
        [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3] animated:YES];
        
        [[CountOnItInAppPurchases sharedInstance] restoreCompletedTransactions];
    }
}

- (void)remindDaily
{
    [self showUnlimitedInApPurchase];
}

- (void)contactSupport
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
        mailComposeViewController.mailComposeDelegate = self;
        mailComposeViewController.subject = @"CountOnIt Support";
        [mailComposeViewController setMessageBody:@"Hello, CountOnIt!" isHTML:NO];
        mailComposeViewController.toRecipients = @[@"support@counton.it"];
        
        [self presentViewController:mailComposeViewController animated:YES completion:nil];
    }
}

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rateApp
{
    NSString *string = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", GlobalAppId];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.resetAlertView == alertView) {
        [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:YES];
        if (buttonIndex == 0) [[Tallies sharedInstance] resetAllTallies];
    } else if (self.deleteAlertView == alertView) {
        [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] animated:YES];
        if (buttonIndex == 0) {
            [[Tallies sharedInstance] removeAllTallies];
            self.sections = nil;
            [self.tableView reloadData];
        }
    }
}

- (void)switchButtonChanged:(ViewCell *)sender
{
    if ([sender.key isEqualToString:@"PreferenceSortAlphabetically"]) {
        [self sortAlphabetically];
    }
    if ([sender.key isEqualToString:@"PreferenceEnableReminder"]) {
        self.enableReminderChanged = YES;
    }
}

- (void)sortAlphabetically
{
    BOOL sortAlpabetically = [[[NSUserDefaults standardUserDefaults] objectForKey:@"PreferenceSortAlphabetically"] isEqualToString:@"YES"] ? YES : NO;
    
    [Tallies sharedInstance].sortAlpabetically = sortAlpabetically;
}

- (void)valueChanged:(ViewCell *)sender {}

#pragma mark - Drawing

- (UIAlertView *)restoredAlertView
{
    if (!_restoredAlertView) {
        _restoredAlertView = [[UIAlertView alloc] initWithTitle:@"Restore Purchases"
                                                     message:@"All purchases have been restored."
                                                    delegate:self
                                           cancelButtonTitle:nil
                                           otherButtonTitles:nil];
    }
    return _restoredAlertView;
}

- (UIAlertView *)resetAlertView
{
    if (!_resetAlertView) {
        _resetAlertView = [[UIAlertView alloc] initWithTitle:@"Reset all tallies?"
                                                     message:@"You will not be able to undo this."
                                                    delegate:self
                                           cancelButtonTitle:@"Reset"
                                           otherButtonTitles:@"Cancel", nil];
    }
    return _resetAlertView;
}

- (UIAlertView *)deleteAlertView
{
    if (!_deleteAlertView) {
        _deleteAlertView = [[UIAlertView alloc] initWithTitle:@"Delete all tallies?"
                                                      message:@"You will not be able to undo this."
                                                     delegate:self
                                            cancelButtonTitle:@"Delete"
                                            otherButtonTitles:@"Cancel", nil];
    }
    return _deleteAlertView;
}

@end
