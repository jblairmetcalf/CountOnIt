//
//  Hints.m
//  CountOnIt
//
//  Created by J. Blair Metcalf on 3/16/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "Hints.h"
#import "Global.h"
#import "UIColor+Utility.h"
#import <QuartzCore/QuartzCore.h>
#import "TouchThroughView.h"
#import "Tallies.h"
#import "ViewController.h"
#import "TallyView.h"
#import "TalliesView.h"
#import "SingleTalliesView.h"
#import "ManyTalliesView.h"
#import "HintsAddTally.h"
#import "HintsCard.h"

@interface Hints () <HintsCardDelegate>

@property (strong, nonatomic) HintsAddTally *addTally;
@property (strong, nonatomic) HintsCard *card;
@property (strong, nonatomic) NSString *state;
@property (nonatomic) BOOL addTallyComplete;
@property (nonatomic) BOOL complete;

@end

@implementation Hints

static Hints *sharedInstance;

+ (Hints *)sharedInstance {
    static BOOL initialized = NO;
    if (!initialized) {
        initialized = YES;
        sharedInstance = [[Hints alloc] init];
    }
    return sharedInstance;
}

- (Hints *)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)setView:(UIView *)view
{
    _view = view;
    
    if (!self.complete) {
        [self addNotifications];
    } else {
        [self destroy];
    }
}

- (BOOL)addTallyComplete
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"HintsAddTallyComplete"] isEqualToString:@"YES"] ? YES : NO;
}

- (BOOL)complete
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"HintsComplete"] isEqualToString:@"YES"] ? YES : NO;
}

- (void)setAddTallyComplete:(BOOL)complete
{
    [[NSUserDefaults standardUserDefaults] setObject:complete ? @"YES" : @"NO" forKey:@"HintsAddTallyComplete"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setComplete:(BOOL)complete
{
    [[NSUserDefaults standardUserDefaults] setObject:complete ? @"YES" : @"NO" forKey:@"HintsComplete"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)close:(HintsCard *)sender
{
    self.complete = YES;
    [self.card hideCompletely];
    [self destroy];
}

#pragma mark - Notification

- (void)addNotifications
{
    if (!self.addTallyComplete) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(welcomeComplete:)
                                                     name:WelcomeComplete
                                                   object:nil];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showAddTally:)
                                                 name:ShowAddTally
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(talliesAddedTally:)
                                                 name:TalliesAddedTally
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tallyOneTouch:)
                                                 name:TallyOneTouch
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tallyTwoTouches:)
                                                 name:TallyTwoTouches
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tallyThreeTouches:)
                                                 name:TallyThreeTouches
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tallyTouchAndHoldValueDidChangeValue:)
                                                 name:TallyTouchAndHoldValueDidChangeValue
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(talliesDidScroll:)
                                                 name:TalliesDidScroll
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tallyDrawerOpened:)
                                                 name:TallyDrawerOpened
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tallyDrawerOpened:)
                                                 name:TallyDrawerOpened
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(talliesViewDidScroll:)
                                                 name:SingleTalliesViewDidScroll
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(talliesViewDidScroll:)
                                                 name:ManyTalliesViewDidScroll
                                               object:nil];
}

- (void)destroy
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)welcomeComplete:(NSNotification *)notification
{
    if (!self.state) {
        self.state = @"welcomeComplete";
        [self.addTally show];
    }
}

- (void)showAddTally:(NSNotification *)notification
{
    if ([self.state isEqualToString:@"welcomeComplete"]) {
        self.state = @"showAddTally";
        
        self.addTallyComplete = YES;
    }
}

- (void)talliesAddedTally:(NSNotification *)notification
{
    if ([self.state isEqualToString:@"showAddTally"]) {
        self.state = @"talliesAddedTally-0";
        [self.addTally hide];
        [self.card show];
    } else if ([self.state isEqualToString:@"talliesDidScroll-1"]) {
        self.state = @"talliesAddedTally-1";
        self.card.index = 8;
    }
}

- (void)tallyOneTouch:(NSNotification *)notification
{
    if ([self.state isEqualToString:@"talliesAddedTally-0"]) {
        self.state = @"tallyOneTouch";
        self.card.index = 1;
    }
}

- (void)tallyTouchAndHoldValueDidChangeValue:(NSNotification *)notification
{
    if ([self.state isEqualToString:@"tallyOneTouch"]) {
        self.state = @"tallyTouchAndHoldValueDidChangeValue";
        self.card.index = 2;
    }
}

- (void)tallyTwoTouches:(NSNotification *)notification
{
    if ([self.state isEqualToString:@"tallyTouchAndHoldValueDidChangeValue"]) {
        self.state = @"tallyTwoTouches";
        self.card.index = 3;
    }
}

- (void)tallyThreeTouches:(NSNotification *)notification
{
    if ([self.state isEqualToString:@"tallyTwoTouches"]) {
        self.state = @"tallyThreeTouches";
        self.card.index = 4;
    }
}

- (void)talliesDidScroll:(NSNotification *)notification
{
    if ([self.state isEqualToString:@"tallyThreeTouches"]) {
        self.state = @"talliesDidScroll-0";
        self.card.index = 5;
    } else if ([self.state isEqualToString:@"tallyDrawerOpened"]) {
        self.state = @"talliesDidScroll-1";
        self.card.index = 7;
    }
}

- (void)tallyDrawerOpened:(NSNotification *)notification
{
    if ([self.state isEqualToString:@"talliesDidScroll-0"]) {
        self.state = @"tallyDrawerOpened";
        self.card.index = 6;
    }
}

- (void)talliesViewDidScroll:(NSNotification *)notification
{
    if ([self.state isEqualToString:@"talliesAddedTally-1"]) {
        self.state = @"talliesViewDidScroll";
        self.complete = YES;
        self.card.index = 9;
        [self.card hide];
        [self destroy];
    }
}

#pragma mark - Drawing

- (HintsAddTally *)addTally
{
    if (!_addTally) {
        _addTally = [[HintsAddTally alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
        [self.view addSubview:_addTally];
    }
    return _addTally;
}

- (HintsCard *)card
{
    if (!_card) {
        
        NSArray *pages = @[ @{ @"image" : @"Hints-Tap-One-Finger", @"text" : @"Tap one finger\nto count up." },
                            @{ @"image" : @"Hints-Tap-And-Hold", @"text" : @"Tap and hold\nto count fast." },
                            @{ @"image" : @"Hints-Tap-Two-Fingers", @"text" : @"Tap two fingers\nto count down." },
                            @{ @"image" : @"Hints-Tap-Three-Fingers", @"text" : @"Tap three fingers\nto reset." },
                            @{ @"image" : @"Hints-Scroll-Right", @"text" : @"Scroll right\nto view many." },
                            @{ @"image" : @"Hints-Swipe-Item", @"text" : @"Swipe an item to\nedit, export, or delete." },
                            @{ @"image" : @"Hints-Scroll-Left", @"text" : @"Scroll left\nto view full screen." },
                            @{ @"image" : @"Hints-Add-Another-Item", @"text" : @"Add another item." },
                            @{ @"image" : @"Hints-Scroll-Up-And_Down", @"text" : @"Scroll up and down\nto view more." },
                            @{ @"image" : @"Hints-Done", @"text" : @"Done!" }];
        
        _card = [[HintsCard alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height) pages:pages];
        _card.delegate = self;
        
        [self.view addSubview:_card];
    }
    return _card;
}

@end
