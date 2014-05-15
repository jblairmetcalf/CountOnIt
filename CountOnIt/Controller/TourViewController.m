//
//  TourViewController.m
//  CountOnIt
//
//  Created by J. Blair Metcalf on 3/12/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "TourViewController.h"

@interface TourViewController ()

@property (strong, nonatomic) UIButton *closeButton;

@end

@implementation TourViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view addSubview:self.closeButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.screenName = @"Tour";
}

- (NSArray *)views
{
    NSMutableArray *views = [[NSMutableArray alloc] init];
    
    [views addObject: @{ @"introduction" : @"CountOnIt tour", @"attributedString" : @"CountOnIt" } ];
    
    [views addObject: @{ @"string" : @"Add items to keep track of.\nTap and hold to count fast.", @"substrings" : @[ @"Add", @"Tap and hold" ] } ];
    
    [views addObject: @{ @"string" : @"Tap one finger to count up.\nTwo fingers to count down.\nThree to reset.", @"substrings" : @[ @"Tap one finger", @"count up", @"Two fingers", @"count down", @"Three", @"reset" ] } ];
    
    [views addObject: @{ @"string" : @"Swipe up and down\nto view more.", @"substrings" : @[ @"Swipe up and down", @"view more" ] } ];
    
    [views addObject: @{ @"string" : @"Swipe left and right\nto view one or many.", @"substrings" : @[ @"Swipe left and right", @"view one or many" ] } ];
    
    [views addObject: @{ @"string" : @"Swipe items\nto edit, export, and delete.", @"substrings" : @[ @"Swipe items", @"edit, export, and delete" ] } ];
    
    [views addObject: @{ @"string" : @"Under settings,\nexport a chart of your tallies.", @"substrings" : @[ @"export a chart of your tallies" ] } ];
    
    return [NSArray arrayWithArray:views];
}

- (NSArray *)pages
{
    return [[NSArray alloc] initWithObjects:@"Tour-0", @"Tour-1", @"Tour-2", @"Tour-3", @"Tour-4", @"Tour-5", nil];
}

- (IBAction)close:(UIButton *)button
{
    [self.delegate dismissModal:self];
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        CGRect frame = CGRectMake(self.view.frame.size.width-35.0f, 20.0f, 35.0f, 35.0f);
        
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.frame = frame;
        
        [_closeButton setImage:[UIImage imageNamed:@"Tour-Close"] forState:UIControlStateNormal];
        [_closeButton setImage:[UIImage imageNamed:@"Tour-Close-Highlighted"] forState:UIControlStateHighlighted];
        [_closeButton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

@end
