//
//  ManyTalliesView.m
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/24/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "ManyTalliesView.h"
#import "Tallies.h"
#import "Tally.h"
#import "ManyTalliesCell.h"
#import "TallyView.h"
#import "Global.h"
#import "ManyTalliesHeaderView.h"
#import "UIViewController+Utility.h"
#import "UIColor+Utility.h"
#import "TouchThroughView.h"

@interface ManyTalliesView () <UITableViewDataSource, UITableViewDelegate, ManyTalliesHeaderViewDelegate>

@property (strong, nonatomic) ManyTalliesHeaderView *manyTalliesHeaderView;
@property (strong, nonatomic) UIView *headerView;
@property (weak, nonatomic) TallyView *tallyWithOpenDrawer;
@property (nonatomic) CGFloat manyTalliesCellHieght;
@property (strong, nonatomic) NSArray *tallies;
@property (strong, nonatomic) NSArray *searchResults;
@property (strong, nonatomic) TouchThroughView *noResultsView;
@property (strong, nonatomic) NSString *previousValue;
@property (strong, nonatomic) NSArray *previousTallies;

@property (strong, nonatomic) UITapGestureRecognizer *gestureRecognizer;

@end

@implementation ManyTalliesView

NSString *const ManyTalliesViewDidScroll = @"ManyTalliesViewDidScroll";

- (ManyTalliesView *)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.manyTalliesCellHieght = 148.0f;
        
        self.dataSource = self;
        self.delegate = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        self.noResultsView.alpha = 0.0f;
        self.noResultsView.hidden = YES;
        
        [self talliesChanged];
        
        [self addNotifications];
        [self addGestureRecognizer:self.gestureRecognizer];
    }
    return self;
}

- (void)reloadData:(BOOL)animated
{
    if ([self talliesChanged]) {
        
        BOOL showNoResults = !self.searchResults.count && self.manyTalliesHeaderView.text.length;
        self.noResultsView.hidden = NO;
        
        [UIView animateWithDuration:GlobalDuration animations:^{
            self.noResultsView.alpha = showNoResults ? 1.0f : 0.0f;
        } completion:^(BOOL finished) {
            self.noResultsView.hidden = !showNoResults;
        }];
        
        if (animated || self.manyTalliesHeaderView.text.length) {
            NSRange range = NSMakeRange(1, 1);
            NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
            [self reloadSections:section withRowAnimation:UITableViewRowAnimationTop];
        } else {
            [super reloadData];
            [self scrollToTop:NO];
            [self hideSearch];
        }
    }
}

- (BOOL)talliesChanged
{
    NSArray *currentTallies;
    if (self.manyTalliesHeaderView.text.length) {
        currentTallies = self.searchResults;
    } else {
        currentTallies = [Tallies sharedInstance].tallies;
    }
    
    BOOL changed = NO;
    
    if (self.previousTallies) {
        if (currentTallies.count == self.previousTallies.count) {
            for (NSInteger i = 0; i<currentTallies.count; i++) {
                if (![[currentTallies objectAtIndex:i] isEqual:[self.previousTallies objectAtIndex:i]]) {
                    changed = YES;
                    break;
                }
            }
        } else {
            changed = YES;
        }
    } else {
        changed = YES;
    }
    
    self.previousTallies = [currentTallies copy];
    
    return changed;
}

- (void)scrollToTop:(BOOL)animated
{
    [self showSearch];
    [self scrollRectToVisible:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f) animated:animated];
}

- (NSUInteger)currentIndex
{
    NSUInteger currentIndex = floor(self.contentOffset.y/self.manyTalliesCellHieght);
    
    return currentIndex;
}

- (void)setCurrentIndex:(NSUInteger)currentIndex
{
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:currentIndex inSection:1];
    [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop  animated:NO];
}

#pragma mark - Notification

- (void)addNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(talliesRemovedTally:)
                                                 name:TalliesRemovedTally
                                               object:[Tallies sharedInstance]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tallyEdited:)
                                                 name:TallyEdited
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(talliesSorted:)
                                                 name:TalliesSorted
                                               object:[Tallies sharedInstance]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(talliesAddedTally:)
                                                 name:TalliesAddedTally
                                               object:[Tallies sharedInstance]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(talliesRemovedAllTallies:)
                                                 name:TalliesRemovedAllTallies
                                               object:[Tallies sharedInstance]];
}

- (void)talliesSorted:(NSNotification *)notification
{
    [self reloadData:NO];
}

- (void)talliesAddedTally:(NSNotification *)notification
{
    // !!! SHOW SEARCH LIST
    [self.manyTalliesHeaderView.textFieldView empty];
    [self reloadData:NO];
    self.currentIndex = [Tallies sharedInstance].indexOfMostRecentlyCreatedTally;
}

- (void)talliesRemovedAllTallies:(NSNotification *)notification
{
    [self reloadData:NO];
}

- (void)tallyEdited:(NSNotification *)notification
{
    if (self.manyTalliesHeaderView.text.length) {
        Tally *mostRecentlyModifiedTally = [Tallies sharedInstance].mostRecentlyModifiedTally;
        NSArray *searchResults = self.searchResults;
        NSUInteger index = 0;
        
        for (Tally *tally in searchResults) {
            if ([tally isEqual:mostRecentlyModifiedTally]) {
                self.currentIndex = index;
                break;
            } else {
                index++;
            }
        }
    } else {
        self.currentIndex = [Tallies sharedInstance].indexOfMostRecentlyModifiedTally;
    }
}

- (void)talliesRemovedTally:(NSNotification *)notification
{
    if (self.manyTalliesHeaderView.text.length) {
        // !!! SHOW SEARCH LIST
        [self.manyTalliesHeaderView.textFieldView empty];
        [self reloadData:YES];
    } else {
        NSUInteger index = [Tallies sharedInstance].indexOfMostRecentlyRemovedTally;
        
        NSIndexPath *indexPathAbove = [NSIndexPath indexPathForRow:index-1 inSection:1];
        UITableViewCell *cellAbove = [self cellForRowAtIndexPath:indexPathAbove];
        
        if (cellAbove) [self bringSubviewToFront:cellAbove];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:1];
        
        UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
        [self sendSubviewToBack:cell];
        
        [UIView animateWithDuration:GlobalDuration*2 animations:^{
            [self beginUpdates];
            [self deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationTop];
            [self endUpdates];
        } completion:^(BOOL finished) {
            
        }];
        
        [self performSelector:@selector(talliesRemovedTallyCompletion) withObject:self afterDelay:(GlobalDuration*2)+0.02f];
    }
}

- (void)talliesRemovedTallyCompletion
{
    CGFloat contentOffsetY = self.contentOffset.y;
    
    [self reloadData:NO];
    
    self.contentOffset = CGPointMake(0.0f, contentOffsetY);
}

- (void)tallyDrawerOpened:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:GlobalFocusChanged object:self];
    
    TallyView *tallyView = notification.object;
    self.tallyWithOpenDrawer = tallyView;
}

- (void)tapBackground:(UIGestureRecognizer *)gesture
{
    [[NSNotificationCenter defaultCenter] postNotificationName:GlobalFocusChanged object:self];
}

- (UITapGestureRecognizer *)gestureRecognizer
{
    if (!_gestureRecognizer) {
        _gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackground:)];
    }
    return _gestureRecognizer;
}

#pragma mark - Drawing

- (UIView *)manyTalliesHeaderView
{
    if (!_manyTalliesHeaderView) {
        _manyTalliesHeaderView = [[ManyTalliesHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, 56.0f)];
        _manyTalliesHeaderView.delegate = self;
    }
    return _manyTalliesHeaderView;
}

- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, GlobalPadding)];
    }
    return _headerView;
}

#pragma mark - Search

- (TouchThroughView *)noResultsView
{
    if (!_noResultsView) {
        _noResultsView = [[TouchThroughView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height)];
        _noResultsView.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, (self.frame.size.height-25.0f)/2, 280.0f, 25.0f)];
        label.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:21.0f];
        label.textColor = [UIColor colorWithHexString:@"#7f7f7f"];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"No Results";
        
        [_noResultsView addSubview:label];
        [self insertSubview:_noResultsView atIndex:0];
    }
    return _noResultsView;
}


- (void)valueChanged:(ManyTalliesHeaderView *)sender
{
    NSString *currentValue = sender.textFieldView.text;
    if (![[currentValue lowercaseString] isEqualToString:[self.previousValue lowercaseString]]) [self reloadData:YES];
    self.previousValue = currentValue;
}

- (void)hideSearch
{
    self.contentInset = UIEdgeInsetsMake(-self.manyTalliesHeaderView.frame.size.height, 0.0f, 0.0f, 0.0f);
}

- (void)showSearch
{
    [UIView animateWithDuration:GlobalDuration animations:^{
        self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    } completion:^(BOOL finished) {
        
    }];
}

- (Tally *)tallyAtIndex:(NSIndexPath *)indexPath
{
    NSString *search = self.manyTalliesHeaderView.text;
    if (search.length) {
        return [self.searchResults objectAtIndex:indexPath.row];
    } else {
        return [[Tallies sharedInstance] tallyAtIndex:indexPath.row];
    }
}

- (NSUInteger)count
{
    NSString *search = self.manyTalliesHeaderView.text;
    if (search.length) {
        return self.searchResults.count;
    } else {
        return [Tallies sharedInstance].count;
    }
}

- (NSArray *)searchResults
{
    NSString *search = self.manyTalliesHeaderView.text;
    if (search.length) {
        NSArray *tallies = [Tallies sharedInstance].tallies;
        NSMutableArray *results = [[NSMutableArray alloc] init];
        for (Tally *tally in tallies) {
            if ([tally.title rangeOfString:search options:NSCaseInsensitiveSearch].location != NSNotFound) {
                [results addObject:tally];
            }
        }
        return results;
    } else {
        return [[NSArray alloc] init];
    }
}

#pragma mark - Table View Delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ManyTalliesViewDidScroll object:self];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.manyTalliesHeaderView;
    } else if (section == 1) {
        return nil;
    } else {
        return self.headerView;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.manyTalliesHeaderView.frame.size.height;
    } else if (section == 1) {
        return 0;
    } else {
        return self.headerView.frame.size.height;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self showSearch];
    [[NSNotificationCenter defaultCenter] postNotificationName:GlobalFocusChanged object:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 2) {
        return 0;
    } else {
        return self.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 2) {
        return 0;
    } else {
        return self.manyTalliesCellHieght;
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ManyTalliesCell *manyTalliesCell = (ManyTalliesCell *)cell;
    [manyTalliesCell destroy];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tally *tally = [self tallyAtIndex:indexPath];
    
    ManyTalliesCell *manyTalliesCell = (ManyTalliesCell *)cell;
    manyTalliesCell.tally = tally;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Many Tallies Cell";
    
    ManyTalliesCell *cell = [[ManyTalliesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    return cell;
}

@end
