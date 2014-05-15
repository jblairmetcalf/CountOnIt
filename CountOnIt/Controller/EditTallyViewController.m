//
//  EditTallyViewController.m
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/25/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "EditTallyViewController.h"

@interface EditTallyViewController ()

@property (strong, nonatomic) NSString *title;

@end

@implementation EditTallyViewController

- (void)viewDidLoad
{
    self.isEditViewController = YES;
    
    [super viewDidLoad];
    
    self.screenName = @"Edit Tally";
    
    self.tallyTitleView.text = self.tally.title;
    self.tallyPinnedButton.selected = self.tally.pinned;
    self.tallyLockedButton.selected = self.tally.locked;
    self.tallyColorView.tallyColor = self.tally.color;
    
    self.title = [self viewTitle];
}

- (void)setTally:(Tally *)tally
{
    _tally = tally;
}

- (NSString *)viewTitle
{
    if (self.tally) {
        return [NSString stringWithFormat:@"Edit \"%@\"", self.tally.title];
    } else {
        return @"Edit Tally";
    }
}

#pragma mark - Reuse

- (CGFloat)tallyTitleViewFrameOriginY
{
    return 18.0f;
}

- (CGFloat)tallyPinnedButtonFrameOriginY
{
    return 71.0f;
}

- (CGFloat)tallyLockedButtonFrameOriginY
{
    return 124.0f;
}

- (CGFloat)tallyColorViewFrameOriginY
{
    return 177.0f;
}

- (NSString *)alertMessageTitle
{
    return [self viewTitle];
}

@end
