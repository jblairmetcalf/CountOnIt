//
//  WelcomeViewController.m
//  CountOnIt
//
//  Created by J. Blair Metcalf on 3/12/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "WelcomeViewController.h"

@implementation WelcomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.screenName = @"Welcome";
}

- (NSArray *)views
{
    NSMutableArray *views = [[NSMutableArray alloc] init];
    
    [views addObject: @{ @"introduction" : @"Welcome to CountOnIt", @"attributedString" : @"CountOnIt" } ];
    
    [views addObject: @{ @"string" : @"Add items to keep track of.\nGive them color.", @"substrings" : @[ @"Add items", @"color" ] } ];
    
    [views addObject: @{ @"string" : @"Tap tallies\nto count up and down.", @"substrings" : @[ @"Tap tallies", @"count up and down" ] } ];
    
    [views addObject: @{ @"string" : @"Under settings,\nexport a chart of your tallies.", @"substrings" : @[ @"export a chart of your tallies" ] } ];
    
    return [NSArray arrayWithArray:views];
}

- (NSArray *)pages
{
    return [[NSArray alloc] initWithObjects:@"Welcome-0", @"Welcome-1", @"Welcome-2", nil];
}

@end
