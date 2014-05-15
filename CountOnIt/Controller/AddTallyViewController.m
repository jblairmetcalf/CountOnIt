//
//  AddTallyViewController.m
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/26/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "AddTallyViewController.h"
#import "TallyValueView.h"
#import "Global.h"

@interface AddTallyViewController ()

@property (strong, nonatomic) TallyValueView *tallyValueView;

@end

@implementation AddTallyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.screenName = @"Add Tally";
    
    [self.view addSubview:self.tallyValueView];
    
    self.tallyColorView.tallyColor = arc4random() % [[Backgrounds sharedInstance] backgrounds].count;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.tallyValueView destroy];
}

- (NSInteger)tallyValue
{
    return self.tallyValueView.tallyValue;
}

#pragma mark - Delegate

#pragma mark - Drawing

- (TallyValueView *)tallyValueView
{
    if (!_tallyValueView) {
        CGFloat innerPadding = 10.0f;
        
        _tallyValueView = [[TallyValueView alloc] initWithFrame:CGRectMake(GlobalPadding+innerPadding, GlobalPadding, 320.0f-(GlobalPadding*2), 133.0f)];
    }
    return _tallyValueView;
}


@end
