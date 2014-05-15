//
//  TalliesView.m
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/24/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "TalliesView.h"
#import "SingleTalliesView.h"
#import "ManyTalliesView.h"
#import "TallyView.h"
#import "TallyDrawerView.h"
#import "Tallies.h"
#import "Global.h"

@interface TalliesView () <UIScrollViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) SingleTalliesView *singleTalliesView;
@property (strong, nonatomic) ManyTalliesView *manyTalliesView;
@property (strong, nonatomic) UIPageControl *pageControl;

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation TalliesView

NSString *const TalliesUpdateDate = @"TalliesUpdateDate";
NSString *const TalliesDidScroll = @"TalliesDidScroll";

- (TalliesView *)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addNotifications];
        
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
        
        [self startTimer];
    }
    return self;
}

- (NSInteger)currentPage
{
    CGFloat width = self.scrollView.frame.size.width;
    return self.scrollView.contentOffset.x/width;
}

- (void)scrollToTop
{
    switch ([self currentPage]) {
        case 0 :
            [self.singleTalliesView scrollToTop:YES];
            break;
        case 1 :
            [self.manyTalliesView scrollToTop:YES];
            break;
    }
}

#pragma mark - Notification

- (void)addNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tallySwipeGesture:)
                                                 name:TallySwipeGesture
                                               object:nil];
}

- (void)tallySwipeGesture:(NSNotification *)notification
{
    TallyView *tallyView = notification.object;
    [self.scrollView.panGestureRecognizer requireGestureRecognizerToFail:tallyView.swipeGesture];
}

#pragma mark - Timer

- (void)startTimer
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:30
                                                  target:self
                                                selector:@selector(timerCallback:)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)timerCallback:(NSTimer *)timer
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TalliesUpdateDate object:self];
}

#pragma mark - Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:GlobalFocusChanged object:self];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger pageControlCurrentPage = self.pageControl.currentPage;
    
    self.pageControl.currentPage = [self currentPage];
    
    if ([self currentPage] != pageControlCurrentPage) [[NSNotificationCenter defaultCenter] postNotificationName:TalliesDidScroll object:self];
}

#pragma mark - Drawing

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height)];
        _scrollView.contentSize = CGSizeMake(self.frame.size.width*2, self.frame.size.height);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollEnabled = YES;
        _scrollView.delegate = self;
        
        [_scrollView addSubview:self.singleTalliesView];
        [_scrollView addSubview:self.manyTalliesView];
    }
    return _scrollView;
}

- (SingleTalliesView *)singleTalliesView
{
    if (!_singleTalliesView) {
        CGRect frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
        _singleTalliesView = [[SingleTalliesView alloc] initWithFrame:frame];
    }
    return _singleTalliesView;
}

- (ManyTalliesView *)manyTalliesView
{
    if (!_manyTalliesView) {
        CGRect frame = CGRectMake(self.frame.size.width, 0.0f, self.frame.size.width, self.frame.size.height);
        _manyTalliesView = [[ManyTalliesView alloc] initWithFrame:frame];
    }
    return _manyTalliesView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        CGFloat width = 23.0f;
        
        CGRect frame = CGRectMake((self.frame.size.width-width)/2, self.frame.size.height-26.0f, width, 7.0f);
        _pageControl = [[UIPageControl alloc] initWithFrame:frame];
        _pageControl.currentPage = 0;
        _pageControl.numberOfPages = 2;
    }
    return _pageControl;
}

@end
