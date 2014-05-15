//
//  ModalScrollView.m
//  CountOnIt
//
//  Created by J. Blair Metcalf on 3/11/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "ModalScrollView.h"
#import "Global.h"
#import "UIColor+Utility.h"

@interface ModalScrollView () <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic) NSInteger numberOfPages;
@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) UIFont *lightFont;
@property (strong, nonatomic) UIFont *regularFont;

@end

@implementation ModalScrollView

- (ModalScrollView *)initWithFrame:(CGRect)frame views:(NSArray *)views
{
    self = [super initWithFrame:frame];
    if (self) {
        self.numberOfPages = views.count+1;
        
        [self addSubview:self.scrollView];
        
        [self.scrollView addSubview:[self introductionWithString:[[views objectAtIndex:0] valueForKey:@"introduction"] attributedString:[[views objectAtIndex:0] valueForKey:@"attributedString"]]];
        
        for (NSInteger i = 1; i < views.count; i++) {
            [self.scrollView addSubview:[self viewWithIndex:i string:[[views objectAtIndex:i] valueForKey:@"string"]  substrings:[[views objectAtIndex:i] valueForKey:@"substrings"] ]];
        }
        
        [self.scrollView addSubview:[self getStarted]];
    }
    return self;
}

- (NSInteger)currentPage
{
    return (NSInteger)floor([self currentPageFraction]);
}

- (void)setCurrentPage:(NSInteger)page
{
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * page;
    [self.scrollView scrollRectToVisible:frame animated:YES];
}

- (CGFloat)currentPageFraction
{
    CGFloat width = self.scrollView.frame.size.width;
    return self.scrollView.contentOffset.x/width;
}

#pragma mark - Interaction

- (IBAction)getStartedTouched:(UIButton *)sender
{
    [self.delegate dismissView:self];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.delegate currentPageChanged:self];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.delegate currentPageFractionChanged:self];
}

#pragma mark - Drawing

- (UIColor *)textColor
{
    return [UIColor colorWithHexString:@"#4c4c4c"];
}

- (UIFont *)lightFont
{
    return [UIFont fontWithName:@"SourceSansPro-Light" size:20.0f];
}

- (UIFont *)regularFont
{
    return [UIFont fontWithName:@"SourceSansPro-Regular" size:20.0f];
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height)];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(self.frame.size.width*self.numberOfPages, self.frame.size.height);
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.pagingEnabled = YES;
        _scrollView.delaysContentTouches = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

#pragma mark - Drawing

- (UILabel *)labelWithString:(NSString *)string substrings:(NSArray *)substrings
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(GlobalPadding, 44.0f, 320.0f-(GlobalPadding*2), 80.0f)];
    label.font = self.lightFont;
    label.textColor = self.textColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 3;
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:string];
    
    for (NSString *substring in substrings) {
        [attributedText addAttribute:NSFontAttributeName value:self.regularFont range:[string rangeOfString:substring]];
    }
    
    label.attributedText = attributedText;
    
    return label;
}

- (UIView *)viewWithIndex:(NSUInteger)index string:(NSString *)string substrings:(NSArray *)substrings
{
    CGSize size = CGSizeMake(self.frame.size.width, self.frame.size.height);
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(size.width*index, 0.0f, size.width, size.height)];
    
    UILabel *label = [self labelWithString:string substrings:substrings];
    
    [view addSubview:label];
    
    return view;
}

- (UIView *)introductionWithString:(NSString *)string attributedString:(NSString *)attributedString
{
    CGSize size = CGSizeMake(self.frame.size.width, self.frame.size.height);
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    
    
    CGFloat y = (size.height-80.0f)/2;
    
    
    UILabel *label0 = [[UILabel alloc] initWithFrame:CGRectMake(GlobalPadding, y, 320.0f-(GlobalPadding*2), 35.0f)];
    label0.font = [UIFont fontWithName:@"SourceSansPro-Light" size:29.0f];
    label0.textColor = self.textColor;
    label0.textAlignment = NSTextAlignmentCenter;
    
    NSString *text0 = string;
    NSMutableAttributedString *attributedText0 = [[NSMutableAttributedString alloc] initWithString:text0];
    UIFont *font0 = [UIFont fontWithName:@"SourceSansPro-Regular" size:29.0f];
    [attributedText0 addAttribute:NSFontAttributeName value:font0 range:[text0 rangeOfString:attributedString]];
    
    label0.attributedText = attributedText0;
    
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(GlobalPadding, y+55.0f, 320.0f-(GlobalPadding*2), 25.0f)];
    label1.font = self.lightFont;
    label1.textColor = self.textColor;
    label1.textAlignment = NSTextAlignmentCenter;
    
    NSString *text1 = @"Tap or swipe to begin.";
    NSMutableAttributedString *attributedText1 = [[NSMutableAttributedString alloc] initWithString:text1];
    [attributedText1 addAttribute:NSFontAttributeName value:self.regularFont range:[text1 rangeOfString:@"Tap or swipe"]];
    
    label1.attributedText = attributedText1;
    
    
    [view addSubview:label0];
    [view addSubview:label1];
    
    return view;
}

- (UIView *)getStarted
{
    CGSize size = CGSizeMake(self.frame.size.width, self.frame.size.height);
    CGFloat x = size.width*(self.numberOfPages-1);
    CGFloat height = 100.0f;
    CGFloat y = (size.height-height)/2;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(x, 0.0f, size.width, size.height)];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:29.0f];
    // button.frame = CGRectMake(0.0f, 0.0f, size.width, size.height);
    button.frame = CGRectMake(GlobalPadding, y, 320.0f-(GlobalPadding*2), height);
    [button setTitle:@"Get Started" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"#ff2956"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(getStartedTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:button];
    
    return view;
}

@end
