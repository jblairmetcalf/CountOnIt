//
//  TallyView.m
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/24/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "TallyView.h"
#import "Backgrounds.h"
#import "Background.h"
#import "Card.h"
#import "UIColor+Utility.h"
#import "LabelShadowView.h"
#import "TallyDrawerView.h"
#import "TouchThroughView.h"
#import <QuartzCore/QuartzCore.h>
#import "Global.h"
#import "NSDate+Utility.h"
#import <AudioToolbox/AudioToolbox.h>
#import "TouchAndHold.h"
#import "TalliesView.h"
#import "Sound.h"

@interface TallyView () <UIGestureRecognizerDelegate, UIActionSheetDelegate, TouchAndHoldDelegate>

@property (strong, nonatomic) TallyDrawerView *tallyDrawerView;
@property (strong, nonatomic) TouchThroughView *mask;
@property (strong, nonatomic) Card *card;
@property (strong, nonatomic) UIImage *pinnedImage;
@property (strong, nonatomic) UIImageView *pinnedImageView;
@property (strong, nonatomic) UIImageView *lockedImageView;
@property (strong, nonatomic) LabelShadowView *labelShadowView;
@property (strong, nonatomic) UILabel *titleLabel;

@property (nonatomic) BOOL drawerIsOpen;
@property (nonatomic) BOOL pinned;
@property (nonatomic) BOOL locked;

@property (strong, nonatomic) Sound *upSound;
@property (strong, nonatomic) Sound *downSound;
@property (strong, nonatomic) Sound *resetSound;

@property (nonatomic) NSInteger soundIndex;

@property (strong, nonatomic) UITapGestureRecognizer *oneTouchGesture;
@property (strong, nonatomic) UITapGestureRecognizer *twoTouchesGesture;
@property (strong, nonatomic) UITapGestureRecognizer *threeTouchesGesture;

@property (strong, nonatomic) TouchAndHold *oneTouchAndHold;
@property (strong, nonatomic) TouchAndHold *twoTouchAndHold;

@property (nonatomic) BOOL soundEnabled;

@end

@implementation TallyView

NSString *const TallySwipeGesture = @"TallySwipeGesture";
NSString *const TallyOneTouch = @"TallyOneTouch";
NSString *const TallyTwoTouches = @"TallyTwoTouches";
NSString *const TallyThreeTouches = @"TallyThreeTouches";
NSString *const TallyTouchAndHoldValueDidChangeValue = @"TallyTouchAndHoldValueDidChangeValue";
NSString *const TallyDrawerOpened = @"TallyDrawerOpened";

- (id)initWithFrame:(CGRect)frame isLarge:(BOOL)isLarge
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isLarge = isLarge;
        
        self.soundIndex = 0;
        
        [self.card addSubview:self.labelShadowView];
        [self.card addSubview:self.titleLabel];
        
        [self.card addGestureRecognizer:self.oneTouchGesture];
        [self.card addGestureRecognizer:self.twoTouchesGesture];
        [self.card addGestureRecognizer:self.threeTouchesGesture];
        [self.card addGestureRecognizer:self.swipeGesture];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:TallySwipeGesture object:self];
        
        self.multipleTouchEnabled = YES;
    }
    return self;
}

- (void)destroy
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setTally:(Tally *)tally
{
    if (_tally) [self destroy];
    _tally = tally;
    
    [self addNotifications];
    [self setTitle];
    
    self.pinned = self.tally.pinned;
    self.locked = self.tally.locked;
    
    Background *background = [[Backgrounds sharedInstance] background:self.tally.color];
    
    self.card.background = background;
    self.labelShadowView.value = self.tally.value;
}

- (void)addNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tallyValueChanged:)
                                                 name:TallyValueChanged
                                               object:self.tally];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tallyEdited:)
                                                 name:TallyEdited
                                               object:self.tally];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(talliesUpdateDate:)
                                                 name:TalliesUpdateDate
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(globalFocusChanged:)
                                                 name:GlobalFocusChanged
                                               object:nil];
}

- (void)openDrawer
{
    if (![self drawerIsOpen]) {
        self.tallyDrawerView.hidden = NO;
        
        [self drawerX:self.isLarge ? 50.0f : -240.0f];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:TallyDrawerOpened object:self];
    }
}

- (void)closeDrawer
{
    if (self.drawerIsOpen) {
        self.drawerIsOpen = NO;
        [self drawerX:0.0f];
    }
}

- (void)drawerX:(CGFloat)x
{
    CGRect frame = self.card.frame;
    frame.origin.x = x;
    
    [UIView animateWithDuration:GlobalDuration animations:^{
        self.card.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)setTitle
{
    NSUInteger maximum = 27;// 16 with W
    NSUInteger appendLength = 1;
    NSString *append = @"...";
    NSString *title = self.tally.title;
    
    if (title.length + appendLength > maximum) {
        title = [self.tally.title substringWithRange:NSMakeRange(0, maximum-appendLength)];
        title = [title stringByAppendingString:append];
    }
    
    NSString *since = [self.tally.creationDate prettyDate];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", title, since]];
    
    NSRange wholeRange = NSMakeRange(0, attributedText.length);
    UIColor *wholeColor = self.locked ? [UIColor colorWithHexString:@"4c4c4c"] : [UIColor whiteColor];
    [attributedText addAttribute:NSForegroundColorAttributeName value:wholeColor range:wholeRange];
    
    CGFloat size = self.isLarge ? 24.0f : 18.0f;
    UIFont *font = [UIFont fontWithName:@"SourceSansPro-Light" size:size];
    NSRange range = NSMakeRange(title.length, attributedText.length-title.length);
    [attributedText addAttribute:NSFontAttributeName value:font range:range];
    if (!self.locked) [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"4c4c4c"] range:range];
    
    self.titleLabel.attributedText = attributedText;
}

- (BOOL)drawerIsOpen
{
    return self.card.frame.origin.x != 0.0f;
}

- (void)setPinned:(BOOL)pinned
{
    self.pinnedImageView.hidden = !pinned;
    [self setLockedX];
}

- (void)setLocked:(BOOL)locked
{
    _locked = locked;
    
    self.tallyDrawerView.locked = self.locked;
    self.lockedImageView.hidden = !self.locked;
    self.labelShadowView.locked = self.locked;
    
    self.pinnedImageView.image = [UIImage imageNamed:!self.locked ? @"Tally-Pinned" : @"Tally-Pinned-Locked"];
    
    [self setTitle];
    [self setLockedX];
}

- (void)setLockedX
{
    CGRect lockedImageViewFrame = self.lockedImageView.frame;
    
    lockedImageViewFrame.origin.x = self.tally.pinned ? GlobalInset+15.0f : GlobalInset;
    
    self.lockedImageView.frame = lockedImageViewFrame;
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.tally.locked) {
        if ([[event allTouches] count] == 1) {
            self.oneTouchAndHold.down = YES;
            self.twoTouchAndHold.down = NO;
        } else if ([[event allTouches] count] == 2) {
            self.twoTouchAndHold.down = YES;
            self.oneTouchAndHold.down = NO;
        }
    }
    
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.tally.locked) [self touchesCancelled];
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.tally.locked) [self touchesCancelled];
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled
{
    self.oneTouchAndHold.down = NO;
    self.twoTouchAndHold.down = NO;
}

- (void)valueChanged:(TouchAndHold *)sender
{
    if (!self.tally.locked) {
        if (sender == self.oneTouchAndHold) {
            [self.tally increment:self.oneTouchAndHold.increment];
        } else {
            [self.tally increment:-self.twoTouchAndHold.increment];
        }
    }
}

- (void)didChangeValue:(TouchAndHold *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TallyTouchAndHoldValueDidChangeValue object:self];
}

- (TouchAndHold *)oneTouchAndHold
{
    if (!_oneTouchAndHold) {
        _oneTouchAndHold = [[TouchAndHold alloc] init];
        _oneTouchAndHold.delegate = self;
    }
    return _oneTouchAndHold;
}

- (TouchAndHold *)twoTouchAndHold
{
    if (!_twoTouchAndHold) {
        _twoTouchAndHold = [[TouchAndHold alloc] init];
        _twoTouchAndHold.delegate = self;
    }
    return _twoTouchAndHold;
}

#pragma mark - Notification

- (void)tallyValueChanged:(NSNotification *)notification
{
    self.labelShadowView.value = self.tally.value;
}

- (void)tallyEdited:(NSNotification *)notification
{
    [self setTitle];
    self.pinned = self.tally.pinned;
    self.locked = self.tally.locked;
    self.card.backgroundIndex = self.tally.color;
}

- (void)talliesUpdateDate:(NSNotification *)notification
{
    [self setTitle];
}

- (void)globalFocusChanged:(NSNotification *)notification
{
    [self closeDrawer];
}

#pragma mark - Sound

- (BOOL)soundEnabled
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"PreferenceEnableSound"] isEqualToString:@"YES"];
}

#pragma mark - Interaction

- (void)oneTouch:(UITapGestureRecognizer *)gestureRecognizer
{
    if (![self drawerIsOpen] && !self.tally.locked) {
        [self.tally increment:1];
        if (self.soundEnabled) [self.upSound play];
        [[NSNotificationCenter defaultCenter] postNotificationName:TallyOneTouch object:self];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:GlobalFocusChanged object:self];
}

- (void)twoTouches:(UITapGestureRecognizer *)gestureRecognizer
{
    if (![self drawerIsOpen] && !self.tally.locked){
        [self.tally increment:-1];
        if (self.soundEnabled) [self.downSound play];
        [[NSNotificationCenter defaultCenter] postNotificationName:TallyTwoTouches object:self];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:GlobalFocusChanged object:self];
}

- (void)threeTouches:(UITapGestureRecognizer *)gestureRecognizer
{
    if (![self drawerIsOpen] && !self.tally.locked && self.tally.value != 0){
        [self alert:@"You will not be able to undo this."];
        if (self.soundEnabled) [self.resetSound play];
        [[NSNotificationCenter defaultCenter] postNotificationName:TallyThreeTouches object:self];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:GlobalFocusChanged object:self];
}

- (void)swipe:(UISwipeGestureRecognizer *)gestureRecognizer
{
    if (![self drawerIsOpen]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GlobalFocusChanged object:self];
        [self openDrawer];
    }
}

- (void)alert:(NSString *)message
{
    [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Reset \"%@\"?", self.tally.title]
                                message:message
                               delegate:self
                      cancelButtonTitle:@"Cancel"
                      otherButtonTitles:@"Reset", nil] show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
            [self.tally reset];
            break;
        default:
            break;
    }
}

#pragma mark - Gestures

- (UITapGestureRecognizer *)oneTouchGesture
{
    if (!_oneTouchGesture) {
        _oneTouchGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneTouch:)];
        _oneTouchGesture.numberOfTouchesRequired = 1;
        _oneTouchGesture.delegate = self;
    }
    return _oneTouchGesture;
}

- (UITapGestureRecognizer *)twoTouchesGesture
{
    if (!_twoTouchesGesture) {
        _twoTouchesGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twoTouches:)];
        _twoTouchesGesture.numberOfTouchesRequired = 2;
        _twoTouchesGesture.delegate = self;
    }
    return _twoTouchesGesture;
}

- (UITapGestureRecognizer *)threeTouchesGesture
{
    if (!_threeTouchesGesture) {
        _threeTouchesGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(threeTouches:)];
        _threeTouchesGesture.numberOfTouchesRequired = 3;
        _threeTouchesGesture.delegate = self;
    }
    return _threeTouchesGesture;
}

- (UISwipeGestureRecognizer *)swipeGesture
{
    if (!_swipeGesture) {
        _swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
        _swipeGesture.direction = self.isLarge ? UISwipeGestureRecognizerDirectionRight : UISwipeGestureRecognizerDirectionLeft;
        _swipeGesture.delegate = self;
    }
    return _swipeGesture;
}

#pragma mark - Drawing

- (Sound *)upSound
{
    if (!_upSound) {
        _upSound = [[Sound alloc] initWithPath:@"Up.caf"];
    }
    return _upSound;
}

- (Sound *)downSound
{
    if (!_downSound) {
        _downSound = [[Sound alloc] initWithPath:@"Down.caf"];
    }
    return _downSound;
}

- (Sound *)resetSound
{
    if (!_resetSound) {
        _resetSound = [[Sound alloc] initWithPath:@"Reset.caf"];
    }
    return _resetSound;
}

- (TallyDrawerView *)tallyDrawerView
{
    if (!_tallyDrawerView) {
        CGFloat height = self.frame.size.height-(GlobalShadowDistance*2)-(GlobalPadding*2);
        
        if (!self.isLarge) height += GlobalPadding;
        
        CGRect frame = CGRectMake(GlobalPadding, GlobalPadding+GlobalShadowDistance, self.frame.size.width-(GlobalPadding*2), height);
        
        _tallyDrawerView = [[TallyDrawerView alloc] initWithFrame:frame isLarge:self.isLarge];
        _tallyDrawerView.tally = self.tally;
        
        [self insertSubview:_tallyDrawerView atIndex:0];
    }
    return _tallyDrawerView;
}

- (Card *)card
{
    if (!_card) {
        CGFloat height = self.isLarge ? self.frame.size.height-(GlobalPadding*2) : self.frame.size.height-GlobalPadding;
        
        CGRect frame = CGRectMake(0.0f, 0.0f, self.frame.size.width-(GlobalPadding*2), height);
        
        _card = [[Card alloc] initWithFrame:frame];
        
        [self.mask addSubview:_card];
    }
    return _card;
}

- (UIImageView *)pinnedImageView
{
    if (!_pinnedImageView) {
        CGFloat size = 10.0f;
        
        UIImage *image =  [UIImage imageNamed:!self.locked ? @"Tally-Pinned" : @"Tally-Pinned-Locked"];
        
        _pinnedImageView = [[UIImageView alloc] initWithImage:image];
        _pinnedImageView.frame = CGRectMake(GlobalInset, GlobalInset, size, size);
        
        [self.card addSubview:_pinnedImageView];
    }
    return _pinnedImageView;
}

- (UIImageView *)lockedImageView
{
    if (!_lockedImageView) {
        _lockedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Tally-Locked"]];
        _lockedImageView.frame = CGRectMake(GlobalInset, GlobalInset, 7.5f, 10.0f);
        
        [self.card addSubview:_lockedImageView];
    }
    return _lockedImageView;
}

- (TouchThroughView *)mask
{
    if (!_mask) {
        CGFloat height = self.isLarge ? self.frame.size.height-(GlobalPadding*2) : self.frame.size.height-GlobalPadding;
        
        CGRect frame = CGRectMake(GlobalPadding, GlobalPadding, self.frame.size.width-(GlobalPadding*2), height);
        
        _mask = [[TouchThroughView alloc] initWithFrame:frame];
        _mask.clipsToBounds = YES;
        _mask.layer.cornerRadius  = GlobalCornerRadius;
        _mask.layer.masksToBounds = YES;
        
        [self addSubview:_mask];
    }
    return _mask;
}

- (LabelShadowView *)labelShadowView
{
    if (!_labelShadowView) {
        CGRect frame;
        if (self.isLarge) {
            CGFloat multiplier = 0.60240963855422;
            CGFloat height = multiplier*self.frame.size.height;//250.0f;
            
            frame = CGRectMake(GlobalPadding, 0.0f, self.frame.size.width-(GlobalPadding*4), height);
        } else {
            frame = CGRectMake(GlobalPadding, 0.0f, 110.f-(GlobalPadding*2), self.frame.size.height-GlobalPadding-8.0f);
        }
        
        _labelShadowView = [[LabelShadowView alloc] initWithFrame:frame];
        _labelShadowView.isLarge = self.isLarge;
    }
    return _labelShadowView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        CGRect frame;
        if (self.isLarge) {
            CGFloat multiplier = 0.44672131147541f;
            CGFloat height = self.card.frame.size.height*multiplier;// 218.0f;
            
            frame = CGRectMake(45.0f, self.card.frame.size.height-height-GlobalShadowDistance, self.card.frame.size.width-90.0f, height);
        } else {
            frame = CGRectMake(110.f, 0.0f, self.card.frame.size.width-110.f-GlobalPadding, self.card.frame.size.height-6.0f);
        }
        
        CGFloat size = self.isLarge ? 30.0f : 24.0f;
        
        _titleLabel = [[UILabel alloc] initWithFrame:frame];
        _titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:size];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.numberOfLines = 3;
    }
    return _titleLabel;
}

@end
