//
//  ExportChartViewController.m
//  CountOnIt
//
//  Created by J. Blair Metcalf on 3/3/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "ExportChartViewController.h"
#import "ViewCell.h"
#import "Tallies.h"
#import "Tally.h"
#import "Backgrounds.h"
#import "Background.h"
#import "UIImage+Utility.h"
#import "UIColor+Utility.h"
#import <QuartzCore/QuartzCore.h>
#import "ReviewChartViewController.h"
#import "Global.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@interface ExportChartViewController () <UITableViewDataSource, UITableViewDelegate, ViewCellDelegate>

@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, strong) UIAlertView *alertView;
@property (nonatomic, strong) NSString *chartTitle;

@end

@implementation ExportChartViewController
    
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0.0f, 15.0f, 0.0f, 0.0f);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Export Chart"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    ViewCell *cell = (ViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell destroy];
}

- (NSArray *)sections
{
    if (!_sections) {
        NSMutableArray *rows0 = [[NSMutableArray alloc] initWithArray:@[
  @{ @"identifier" : @"Export Disclosure Cell", @"title" : @"Select All", @"selected" : @"NO" },
  @{ @"identifier" : @"Export Disclosure Cell", @"title" : @"Deselect All", @"selected" : @"YES" } ]];
        
        NSMutableArray *rows1 = [[NSMutableArray alloc] init];
        NSArray *tallies = [Tallies sharedInstance].tallies;
        
        for (Tally *tally in tallies) {
            Background *background = [[Backgrounds sharedInstance] background:tally.color];
            CGSize size = CGSizeMake(29.0f, 29.0f);
            UIImage *image = [UIImage roundedRectangleWithSize:size fill:background.background stroke:[UIColor clearColor] radius:6.0f width:0];
            
            [rows1 addObject: @{ @"identifier" : @"Export Checkmark Cell", @"tally" : tally, @"selected" : @"YES" , @"image" : image } ];
        }
        
        self.chartTitle = @"";
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ChartTitle"]) {
            self.chartTitle = [[NSUserDefaults standardUserDefaults] objectForKey:@"ChartTitle"];
        }
        
        _sections = @[
                      @{ @"header" : @"Chart Title", @"rows" :
                             @[ @{ @"identifier" : @"Export TextField Cell", @"text" : self.chartTitle, @"emptyText" : @"Enter a Title...", @"enabled" : @"YES"} ]},
                      @{ @"header" : @"Select Tallies to Export", @"rows" :  rows0},
                      @{ @"header" : @"", @"rows" : rows1 } ];
    }
    return _sections;
}

#pragma mark - Navigation

- (void)saveTitle
{
    [[NSUserDefaults standardUserDefaults] setObject:[self chartTitle] forKey:@"ChartTitle"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Review Chart"]) {
        ReviewChartViewController *reviewChartViewController = segue.destinationViewController;
        
        [self saveTitle];
        
        reviewChartViewController.chartTitle = [self chartTitle];
        reviewChartViewController.chartTallies = [self selectedTallies];
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:GlobalFocusChanged object:self];
    
    if ([identifier isEqualToString:@"Show Review Chart"]) {
        if ([self selectedTallies].count && [self chartTitle].length) {
            return YES;
        } else {
            if ([self selectedTallies].count) {
                [self alert:@"Please enter a title."];
                return NO;
            } else if (self.chartTitle.length) {
                [self alert:@"Please select a tally to export."];
                return NO;
            } else {
                [self alert:@"Please enter a title and select a tally to export."];
                return NO;
            }
        }
    } else {
        if ([identifier isEqualToString:@"Canceled Export Chart"]) {
            [self saveTitle];
        }
        
        return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
    }
}

- (IBAction)canceledReviewChart:(UIStoryboardSegue *)segue
{
    if ([segue.identifier isEqualToString:@"Canceled Review Chart"]) {
        NSLog(@"SettingsViewController: canceledExportTallies: Canceled Review Chart");
    }
}

- (void)alert:(NSString *)message
{
    [[[UIAlertView alloc] initWithTitle:@"Export Tallies"
                                message:message
                               delegate:nil
                      cancelButtonTitle:nil
                      otherButtonTitles:@"OK", nil] show];
}

- (void)valueChanged:(ViewCell *)sender
{
    self.chartTitle = sender.text;
}

- (void)switchButtonChanged:(ViewCell *)sender {}

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
    
    ViewCell *cell = (ViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    [cell destroy];
    
    BOOL selected = [[index valueForKey:@"selected"] isEqualToString:@"YES"] ? YES : NO;
    
    if ([index valueForKey:@"tally"]) {
        Tally *tally = [[Tallies sharedInstance] tallyAtIndex:indexPath.row];
        
        cell.image = [index valueForKey:@"image"];
        cell.checked = selected;
        cell.title = tally.title;
    } else {
        cell.title = [index valueForKey:@"title"];
        cell.enabled = selected;
    }
    
    if ([[index valueForKey:@"identifier"] isEqualToString:@"Export TextField Cell"]) {
        cell.enabled = [[index valueForKey:@"enabled"] isEqualToString:@"YES"] ? YES : NO;
        cell.text = [index valueForKey:@"text"];
        cell.emptyText = [index valueForKey:@"emptyText"];
        cell.delegate = self;
    }
    
    return cell;
}

#pragma mark - Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 || indexPath.section == 2) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GlobalFocusChanged object:self];
        
        NSDictionary *index = [[[self.sections objectAtIndex:indexPath.section] objectForKey:@"rows"] objectAtIndex:indexPath.row];
        
        BOOL selected = [[index valueForKey:@"selected"] isEqualToString:@"YES"];
        
        ViewCell *cell = (ViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        
        [self rowSelectedAtSection:indexPath.section row:indexPath.row selected:!selected];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                [self selectionOfAll:YES];
            } else {
                [self selectionOfAll:NO];
            }
        } else {
            cell.accessoryType = !selected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        }
        
        [self selectorsSelection];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:GlobalFocusChanged object:self];
    }
}

- (void)selectionOfAll:(BOOL)selected
{
    NSArray *rows = [[self.sections objectAtIndex:2] objectForKey:@"rows"];
                           
    for (NSInteger i = 0; i < rows.count; i++) {
        [self rowSelectedAtSection:2 row:i selected:selected];
        
        ViewCell *cell = (ViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:2]];
        
        cell.accessoryType = selected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }
}

- (void)selectorsSelection
{
    NSArray *rows = [[self.sections objectAtIndex:2] objectForKey:@"rows"];
    
    NSInteger selected = 0;
    
    for (NSDictionary *dictionary in rows) {
        if ([[dictionary valueForKey:@"selected"] isEqualToString:@"YES"]) selected++;
    }
    
    BOOL selectAllEnabled = selected != rows.count;
    BOOL deselectAllEnabled = selected != 0;
    
    [self rowSelectedAtSection:1 row:0 selected:selectAllEnabled];
    [self rowSelectedAtSection:1 row:1 selected:deselectAllEnabled];
    
    ViewCell *selectAllCell = (ViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    ViewCell *deselectAllCell = (ViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    
    selectAllCell.enabled = selectAllEnabled;
    deselectAllCell.enabled = deselectAllEnabled;
}

- (NSArray *)selectedTallies
{
    NSMutableArray *tallies = [[NSMutableArray alloc] init];
    NSArray *rows = [[self.sections objectAtIndex:2] objectForKey:@"rows"];
    
    for (NSDictionary *dictionary in rows) {
        if ([[dictionary valueForKey:@"selected"] isEqualToString:@"YES"]) {
            [tallies addObject:[dictionary valueForKey:@"tally"]];
        };
    }
    
    return [[NSArray alloc] initWithArray:tallies];
}

- (void)rowSelectedAtSection:(NSUInteger)section row:(NSUInteger)row selected:(BOOL)selected
{
    NSDictionary *dictionary = [[[self.sections objectAtIndex:section] objectForKey:@"rows"] objectAtIndex:row];
    
    NSMutableDictionary *newDictionary = [[NSMutableDictionary alloc] init];
    
    for (NSString *property in dictionary) {
        if ([property isEqualToString:@"selected"]) {
            [newDictionary setValue:selected ? @"YES" : @"NO" forKey:property];
        } else {
            [newDictionary setValue:[dictionary valueForKey:property] forKey:property];
        }
    }
    
    [[[self.sections objectAtIndex:section] objectForKey:@"rows"] replaceObjectAtIndex:row withObject:newDictionary];
}

@end
