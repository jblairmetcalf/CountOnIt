//
//  ModalPageControl.m
//  CountOnIt
//
//  Created by J. Blair Metcalf on 3/11/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "ModalPageControl.h"
#import "Global.h"
#import "UIColor+Utility.h"

@interface ModalPageControl ()


@property (nonatomic, strong) UIPageControl *pageControl;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic) NSUInteger numberOfPages;

@end

@implementation ModalPageControl

- (id)initWithFrame:(CGRect)frame pages:(NSArray *)pages
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.numberOfPages = pages.count+2;
        
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
        
        for (NSInteger i = 0; i < pages.count; i++) {
            [self.scrollView addSubview:[self viewWithImageNamed:[pages objectAtIndex:i] index:i]];
        }
    }
    return self;
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    self.pageControl.currentPage = currentPage;
    
    NSUInteger scrollViewCurrentPage = MAX(MIN(currentPage - 1, 5), 0);
    
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * scrollViewCurrentPage;
    [self.scrollView scrollRectToVisible:frame animated:YES];
}

#pragma mark - Drawing

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 146.0f, self.frame.size.width, 7.0f)];
        _pageControl.numberOfPages = self.numberOfPages;
        _pageControl.currentPage = 0;
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"#4c4c4c"];
        _pageControl.pageIndicatorTintColor = [[UIColor colorWithHexString:@"#4c4c4c"] colorWithAlphaComponent:0.5f];
    }
    return _pageControl;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height)];
        _scrollView.contentSize = CGSizeMake(self.frame.size.width*self.numberOfPages, self.frame.size.height);
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.pagingEnabled = YES;
        _scrollView.userInteractionEnabled = NO;
    }
    return _scrollView;
}

- (UIView *)viewWithImageNamed:(NSString *)imageNamed index:(NSUInteger)index
{
    CGSize size = CGSizeMake(self.frame.size.width, self.frame.size.height);
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(size.width*index, 0.0f, size.width, size.height)];
    
    UIImage *image = [UIImage imageNamed:imageNamed];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(34.0f, 180.0f, 251.0f, 388.0f);
    
    [view addSubview:imageView];
    
    return view;
}

@end
