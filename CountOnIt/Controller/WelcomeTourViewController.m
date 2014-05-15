//
//  ModalViewController.m
//  CountOnIt
//
//  Created by J. Blair Metcalf on 3/12/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "WelcomeTourViewController.h"
#import "UIColor+Utility.h"
#import "ModalScrollView.h"
#import "ModalPageControl.h"
#import "Gradients.h"

@interface WelcomeTourViewController () <ModalScrollViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) Gradients *gradients;
@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;

@property (strong, nonatomic) ModalScrollView *scrollView;
@property (strong, nonatomic) ModalPageControl *pageControl;

@end

@implementation WelcomeTourViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    
    [self.view addSubview:self.gradients];
    [self.view addGestureRecognizer:self.tapGesture];
    [self.view addSubview:self.pageControl];
    [self.view addSubview:self.scrollView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.screenName = @"Welcome/Tour";
}

- (void)dismissView:(ModalScrollView *)sender
{
    [self.delegate dismissModal:self];
}

- (void)tap:(UITapGestureRecognizer *)gestureRecognizer
{
    NSInteger page = 1 + ceil(self.scrollView.currentPageFraction);
    
    self.scrollView.currentPage = page;
    self.pageControl.currentPage = page;
}

- (void)currentPageChanged:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = self.scrollView.currentPage;
}

- (void)currentPageFractionChanged:(UIScrollView *)scrollView
{
    CGFloat index = self.scrollView.currentPageFraction;
    CGFloat max = self.view.frame.size.height-168.0f;
    CGFloat y;
    
    if (index >= 0.0f && index <= 1.0f) {
        
        y = MAX(((1-index)*max), 0);
        [self pageControlY:y];
        
    } else if (index >= self.numberOfPages-2 && index <= self.numberOfPages-1) {
        
        y = MAX(((1-(self.numberOfPages-1-index))*max), 0);
        [self pageControlY:y];
    }
}

- (NSInteger)numberOfPages
{
    return self.views.count+1;
}

- (void)pageControlY:(CGFloat)y
{
    CGRect frame = CGRectMake(0.0f, y, self.pageControl.frame.size.width, self.pageControl.frame.size.height);
    self.pageControl.frame = frame;
}

#pragma mark - Drawing

- (NSArray *)views{
    NSMutableArray *views = [[NSMutableArray alloc] init];
    
    return [NSArray arrayWithArray:views];
}

- (NSArray *)pages
{
    return [[NSArray alloc] init];
}

- (ModalScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[ModalScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height) views:[self views]];
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (ModalPageControl *)pageControl
{
    if (!_pageControl) {
        CGFloat y = self.view.frame.size.height-168.0f;
        _pageControl = [[ModalPageControl alloc] initWithFrame:CGRectMake(0.0f, y, self.view.frame.size.width, self.view.frame.size.height) pages:[self pages]];
        
    }
    return _pageControl;
}

- (UIView *)gradients
{
    if (!_gradients) {
        _gradients = [[Gradients alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height) top:@"#96d4e0" bottom:@"#af4990" leftTop:NO];
    }
    return _gradients;
}

- (UITapGestureRecognizer *)tapGesture
{
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        _tapGesture.numberOfTouchesRequired = 1;
        _tapGesture.delegate = self;
    }
    return _tapGesture;
}

@end
