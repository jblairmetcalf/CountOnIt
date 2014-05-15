//
//  AddEditTallyViewController.h
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/25/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "GAITrackedViewController.h"

#import "Card.h"
#import "Backgrounds.h"
#import "Background.h"

#import "TextFieldView.h"
#import "TallyTextButton.h"
#import "TallyColorView.h"

#import "UIViewController+Utility.h"

@interface AddEditTallyViewController : GAITrackedViewController <TallyColorViewDelegate>

@property (strong, nonatomic) NSString *tallyTitle;
@property (nonatomic) BOOL tallyPinned;
@property (nonatomic) BOOL tallyLocked;
@property (nonatomic) NSUInteger tallyColor;

@property (strong, nonatomic) Card *card;
@property (strong, nonatomic) TextFieldView *tallyTitleView;
@property (strong, nonatomic) TallyTextButton *tallyPinnedButton;
@property (strong, nonatomic) TallyColorView *tallyColorView;
@property (strong, nonatomic) TallyTextButton *tallyLockedButton;

- (void)alert:(NSString *)message;

@property (nonatomic) CGFloat tallyTitleViewFrameOriginY;
@property (nonatomic) CGFloat tallyPinnedButtonFrameOriginY;
@property (nonatomic) CGFloat tallyColorViewFrameOriginY;

@property (nonatomic) CGFloat cardFrameSizeHieght;

@property (strong, nonatomic) NSString *alertMessageTitle;

@property (nonatomic) CGFloat isEditViewController;

@end
