//
//  SingleTalliesView.m
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/24/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "SingleTalliesView.h"
#import "SingleTallyView.h"
#import "Tallies.h"
#import "TallyView.h"
#import "Global.h"

@interface SingleTalliesView () <UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray *singleTallyViews; // of SingleTallyView
@property (weak, nonatomic) TallyView *tallyWithOpenDrawer;

@end

@implementation SingleTalliesView

NSString *const SingleTalliesViewDidScroll = @"SingleTalliesViewDidScroll";

- (SingleTalliesView *)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showsVerticalScrollIndicator = YES;
        self.pagingEnabled = YES;
        self.scrollEnabled = YES;
        self.delegate = self;
        
        [self addNotifications];
        
        [self reloadData];
    }
    return self;
}

- (void)scrollToTop:(BOOL)animated
{
    [self setContentOffset:CGPointZero animated:animated];
}

- (NSUInteger)currentIndex
{
    CGFloat height = self.frame.size.height;
    return (NSInteger)floor((self.contentOffset.y * 2.0f + height) / (height * 2.0f));
}

- (void)setCurrentIndex:(NSUInteger)currentIndex
{
    CGRect frame = self.frame;
    frame.origin.y = frame.size.height * currentIndex;
    [self scrollRectToVisible:frame animated:NO];
}

#pragma mark - Notification

- (void)addNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tallyEdited:)
                                                 name:TallyEdited
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(talliesRemovedAllTallies:)
                                                 name:TalliesRemovedAllTallies
                                               object:[Tallies sharedInstance]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(talliesRemovedTally:)
                                                 name:TalliesRemovedTally
                                               object:[Tallies sharedInstance]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(talliesSorted:)
                                                 name:TalliesSorted
                                               object:[Tallies sharedInstance]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(talliesAddedTally:)
                                                 name:TalliesAddedTally
                                               object:[Tallies sharedInstance]];
}

- (void)talliesSorted:(NSNotification *)notification
{
    [self reloadData];
}

- (void)talliesAddedTally:(NSNotification *)notification
{
    [self reloadData];
    self.currentIndex = [Tallies sharedInstance].indexOfMostRecentlyCreatedTally;
}

- (void)talliesRemovedAllTallies:(NSNotification *)notification
{
    [self reloadData];
}

- (void)tallyEdited:(NSNotification *)notification
{
    self.currentIndex = [Tallies sharedInstance].indexOfMostRecentlyModifiedTally;
}

- (void)talliesRemovedTally:(NSNotification *)notification
{
    NSUInteger index = [Tallies sharedInstance].indexOfMostRecentlyRemovedTally;
    NSUInteger count = [Tallies sharedInstance].count;
    
    CGSize contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height*count);
    
    [UIView animateWithDuration:GlobalDuration*2 animations:^{
        
        if ([self.singleTallyViews objectAtIndex:index] != [NSNull null]) {
            SingleTallyView *removedSingleTallyView = [self.singleTallyViews objectAtIndex:index];
            [removedSingleTallyView removed];
            [self sendSubviewToBack:removedSingleTallyView];
        }
        
        for (NSUInteger i = 0; i < self.singleTallyViews.count; i++) {
            if (i > index && [self.singleTallyViews objectAtIndex:i] != [NSNull null]) {
                SingleTalliesView *singleTallyView = [self.singleTallyViews objectAtIndex:i];
                CGRect frame = singleTallyView.frame;
                frame.origin.y = self.frame.size.height * (i-1);
                singleTallyView.frame = frame;
            }
        }
        
        self.contentSize = contentSize;
        
    } completion:^(BOOL finished) {
        
    }];
    
    [self performSelector:@selector(talliesRemovedTallyCompletion) withObject:self afterDelay:(GlobalDuration*2)+0.02f];
}

- (void)talliesRemovedTallyCompletion
{
    CGFloat contentOffsetY = self.contentOffset.y;
    
    [self reloadData];
    
    self.contentOffset = CGPointMake(0.0f, contentOffsetY);
}

#pragma mark - Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:GlobalFocusChanged object:self];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self loadVisibleViews];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [[NSNotificationCenter defaultCenter] postNotificationName:SingleTalliesViewDidScroll object:self];
}

#pragma mark - Drawing

- (void)reloadData
{
    for (NSInteger i = 0; i < self.singleTallyViews.count; i++) {
        [self removeView:i];
    }
    
    self.singleTallyViews = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < [Tallies sharedInstance].tallies.count; ++i) {
        [self.singleTallyViews addObject:[NSNull null]];
    }
    
    self.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height * self.singleTallyViews.count);
    
    [self loadVisibleViews];
    [self scrollToTop:NO];
}

- (void)loadVisibleViews
{
    NSInteger index = self.currentIndex;
    
    for (NSInteger i = 0; i < index - 1; i++) {
        [self removeView:i];
    }
    for (NSInteger i = index - 1; i <= index + 1; i++) {
        [self loadPage:i];
    }
    for (NSInteger i = index + 1 + 1; i < self.singleTallyViews.count; i++) {
        [self removeView:i];
    }
}

- (void)loadPage:(NSInteger)index
{
    if (index < 0 || index >= self.singleTallyViews.count) {
        return;
    }
    
    UIView *singleTallyView = [self.singleTallyViews objectAtIndex:index];
    if ((NSNull *)singleTallyView == [NSNull null]) {
        CGRect frame = self.frame;
        frame.origin.x = 0.0f;
        frame.origin.y = frame.size.height * index;
        
        Tallies *tallies = [Tallies sharedInstance];
        Tally *tally = [tallies tallyAtIndex:index];
        
        SingleTallyView *singleTallyViews = [[SingleTallyView alloc] initWithFrame:frame tally:tally];
        
        [self addSubview:singleTallyViews];
        [self.singleTallyViews replaceObjectAtIndex:index withObject:singleTallyViews];
    }
}

- (void)removeView:(NSInteger)index
{
    if (index < 0 || index >= [self.singleTallyViews count]) {
        return;
    }
    
    UIView *singleTallyView = [self.singleTallyViews objectAtIndex:index];
    if ((NSNull *)singleTallyView != [NSNull null]) {
        [(SingleTallyView *)singleTallyView destroy];
        [singleTallyView removeFromSuperview];
        [self.singleTallyViews replaceObjectAtIndex:index withObject:[NSNull null]];
    }
}

@end
