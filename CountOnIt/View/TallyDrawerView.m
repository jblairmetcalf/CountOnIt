//
//  TallyDrawerView.m
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/25/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "TallyDrawerView.h"
#import "UIColor+Utility.h"
#import <QuartzCore/QuartzCore.h>
#import "Global.h"
#import "Tallies.h"

@interface TallyDrawerView ()

@property (nonatomic) BOOL isLarge;

@property (strong, nonatomic) UIButton *editButton;
@property (strong, nonatomic) UIButton *exportButton;
@property (strong, nonatomic) UIButton *trashButton;
@property (strong, nonatomic) UIAlertView *alertView;

@property (strong, nonatomic) UITapGestureRecognizer *gestureRecognizer;

@end

@implementation TallyDrawerView

NSString *const TallyEdit = @"TallyEdit";
NSString *const TallyExport = @"TallyExport";

- (id)initWithFrame:(CGRect)frame isLarge:(BOOL)isLarge
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isLarge = isLarge;
        
        self.backgroundColor = [UIColor colorWithHexString:@"4c4c4c"];
        self.layer.cornerRadius  = GlobalCornerRadius;
        self.layer.masksToBounds = YES;
        
        [self addSubview:self.editButton];
        [self addSubview:self.exportButton];
        [self addSubview:self.trashButton];
        
        [self addGestureRecognizer:self.gestureRecognizer];
    }
    return self;
}

- (void)setLocked:(BOOL)locked
{
    self.trashButton.enabled = !locked;
}

#pragma mark - Gesture

- (UITapGestureRecognizer *)gestureRecognizer
{
    if (!_gestureRecognizer) {
        _gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mouseTrap)];
    }
    return _gestureRecognizer;
}

- (void)mouseTrap
{
    
}

#pragma mark - Interaction

- (IBAction)editTally:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TallyEdit object:self];
}

- (IBAction)exportTally:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TallyExport object:self];
}

- (IBAction)deleteTally:(UIButton *)sender
{
    [self.alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ((int)buttonIndex == 0) [[Tallies sharedInstance] removeTally:self.tally];
}

#pragma mark - Drawing

- (UIAlertView *)alertView
{
    if (!_alertView) {
        _alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Delete \"%@\"?", self.tally.title]
                                   message:@"You will not be able to undo this."
                                  delegate:self
                         cancelButtonTitle:@"Delete"
                                      otherButtonTitles:@"Cancel", nil];
    }
    return _alertView;
}

#define BUTTON_SIZE 50.0f
#define BUTTON_LARGE_X 0.0f
#define BUTTON_NOT_LARGE_Y 43.0f

- (UIButton *)editButton
{
    if (!_editButton) {
        
        CGRect frame;
        if (self.isLarge) {
            frame = CGRectMake(BUTTON_LARGE_X, (self.frame.size.height/2)-102.0f, BUTTON_SIZE, BUTTON_SIZE);
        } else {
            frame = CGRectMake(84.0f, BUTTON_NOT_LARGE_Y, BUTTON_SIZE, BUTTON_SIZE);
        }
        
        _editButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _editButton.frame = frame;
        _editButton.tintColor = [UIColor whiteColor];
        
        [_editButton setImage:[UIImage imageNamed:@"Tally-Edit"] forState:UIControlStateNormal];
        
        [_editButton addTarget:self action:@selector(editTally:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editButton;
}

- (UIButton *)exportButton
{
    if (!_exportButton) {
        
        CGRect frame;
        if (self.isLarge) {
            frame = CGRectMake(BUTTON_LARGE_X, (self.frame.size.height/2)-25.0f, BUTTON_SIZE, BUTTON_SIZE);
        } else {
            frame = CGRectMake(159.0f, BUTTON_NOT_LARGE_Y, BUTTON_SIZE, BUTTON_SIZE);
        }
        
        _exportButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _exportButton.frame = frame;
        _exportButton.tintColor = [UIColor whiteColor];
        
        [_exportButton setImage:[UIImage imageNamed:@"Tally-Export"] forState:UIControlStateNormal];
        
        [_exportButton addTarget:self action:@selector(exportTally:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exportButton;
}

- (UIButton *)trashButton
{
    if (!_trashButton) {
        CGRect frame;
        if (self.isLarge) {
            frame = CGRectMake(BUTTON_LARGE_X, (self.frame.size.height/2)+53.0f, BUTTON_SIZE, BUTTON_SIZE);
        } else {
            frame = CGRectMake(234.0f, BUTTON_NOT_LARGE_Y, BUTTON_SIZE, BUTTON_SIZE);
        }
        
        _trashButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _trashButton.frame = frame;
        _trashButton.tintColor = [UIColor whiteColor];
        
        [_trashButton setImage:[UIImage imageNamed:@"Tally-Trash"] forState:UIControlStateNormal];
        
        [_trashButton addTarget:self action:@selector(deleteTally:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _trashButton;
}

@end
