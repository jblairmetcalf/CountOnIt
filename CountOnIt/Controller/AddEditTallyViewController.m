//
//  AddEditTallyViewController.m
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/25/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "AddEditTallyViewController.h"
#import "Global.h"

@interface AddEditTallyViewController () <UIGestureRecognizerDelegate>


@property (strong, nonatomic) UISwipeGestureRecognizer *swipeGesture;

@end

@implementation AddEditTallyViewController

- (void)viewDidLoad
{
    [UIViewController backgroundColors:self];
    
    self.screenName = @"Add/Edit Tally";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.card];
    [self.view addSubview:self.tallyTitleView];
    [self.view addSubview:self.tallyPinnedButton];
    [self.view addSubview:self.tallyLockedButton];
    [self.view addSubview:self.tallyColorView];
    
    [self.card addGestureRecognizer:self.swipeGesture];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.tallyTitleView destroy];
    [self.tallyPinnedButton destroy];
    [self.tallyColorView destroy];
    [self.tallyLockedButton destroy];
}

- (NSString *)tallyTitle
{
    return self.tallyTitleView.text;
}

- (BOOL)tallyPinned
{
    return self.tallyPinnedButton.selected;
}

- (BOOL)tallyLocked
{
    return self.tallyLockedButton.selected;
}

- (NSUInteger)tallyColor
{
    return self.tallyColorView.tallyColor;
}

#pragma mark - Reuse

- (CGFloat)tallyTitleViewFrameOriginY
{
    return 139.0f;
}

- (CGFloat)tallyPinnedButtonFrameOriginY
{
    return 192.0f;
}

- (CGFloat)tallyLockedButtonFrameOriginY
{
    return 245.0f;
}

- (CGFloat)tallyColorViewFrameOriginY
{
    return 298.0f;
}

- (NSString *)alertMessageTitle
{
    return @"Add Tally";
}

#pragma mark - Delegate

- (void)colorChanged:(TallyColorView *)sender
{
    self.card.background = [[Backgrounds sharedInstance] background:self.tallyColorView.tallyColor];
}

#pragma mark - Navigation

- (IBAction)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Do Add Tally"]) {
        
    } else if ([segue.identifier isEqualToString:@"Do Not Add Tally"]) {
        
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"Do Add Tally"] || [identifier isEqualToString:@"Do Edit Tally"]) {
        if (!self.tallyTitleView.text.length) {
            [self alert:@"Please enter a title."];
            return NO;
        } else {
            return YES;
        }
    } else {
        return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
    }
}

- (void)alert:(NSString *)message
{
    NSString *title = self.alertMessageTitle;
    
    [[[UIAlertView alloc] initWithTitle:title
                                message:message
                               delegate:nil
                      cancelButtonTitle:nil
                      otherButtonTitles:@"OK", nil] show];
}

#pragma mark - Drawing

- (TextFieldView *)tallyTitleView
{
    if (!_tallyTitleView) {
        CGFloat innerPadding = 10.0f;
        CGFloat y = self.tallyTitleViewFrameOriginY;// 141.0f
        
        _tallyTitleView = [[TextFieldView alloc] initWithFrame:CGRectMake(GlobalPadding+innerPadding, y, 320.0f-((GlobalPadding*2)+(innerPadding*2)), 40.0f)
                                                      textColor:[UIColor whiteColor]
                                                 emptyImageName:@"Textfield-Empty-Light"
                                      emptyHighlightedImageName:@"Textfield-Empty-Light-Highlighted"
                                                       isSearch:NO hasBorder:YES fontSize:20.0f emptyText:@"Enter a Title..."];
    }
    return _tallyTitleView;
}

- (TallyTextButton *)tallyPinnedButton
{
    if (!_tallyPinnedButton) {
        CGFloat innerPadding = 10.0f;
        CGFloat y = self.tallyPinnedButtonFrameOriginY;// 195.0f
        
        _tallyPinnedButton = [[TallyTextButton alloc] initWithFrame:CGRectMake(GlobalPadding+innerPadding, y, 320.0f-((GlobalPadding+innerPadding)*2), 38.0f) deselectedTitle:@"Pin to Top" deselectedImage:@"Edit-Tally-Not-Pinned" selectedTitle:@"Pinned to Top" selectedImage:@"Edit-Tally-Pinned"];
    }
    return _tallyPinnedButton;
}

- (TallyTextButton *)tallyLockedButton
{
    if (!_tallyLockedButton) {
        CGFloat innerPadding = 10.0f;
        CGFloat y = self.tallyLockedButtonFrameOriginY;// 124.0f;
        
        _tallyLockedButton = [[TallyTextButton alloc] initWithFrame:CGRectMake(GlobalPadding+innerPadding, y, 320.0f-((GlobalPadding+innerPadding)*2), 38.0f) deselectedTitle:@"Unlocked" deselectedImage:@"Edit-Tally-Unlocked" selectedTitle:@"Locked" selectedImage:@"Edit-Tally-Locked"];
    }
    return _tallyLockedButton;
}

- (TallyColorView *)tallyColorView
{
    if (!_tallyColorView) {
        CGFloat innerPadding = 10.0f;
        CGFloat y = self.tallyColorViewFrameOriginY;// 248.0f
        
        _tallyColorView = [[TallyColorView alloc] initWithFrame:CGRectMake(GlobalPadding+innerPadding, y, 320.0f-((GlobalPadding+innerPadding)*2), 48.0f)];
        _tallyColorView.delegate = self;
    }
    return _tallyColorView;
}

- (UIView *)card
{
    if (!_card) {
        CGRect frame = [UIViewController frame:self];
        frame = CGRectMake(GlobalPadding, GlobalPadding, frame.size.width-(GlobalPadding*2), frame.size.height-(GlobalPadding*2)+GlobalShadowDistance);
        
        _card = [[Card alloc] initWithFrame:frame];
    }
    return _card;
}

#pragma mark - Gestures

- (UISwipeGestureRecognizer *)swipeGesture
{
    if (!_swipeGesture) {
        _swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
        _swipeGesture.direction = self.isEditViewController ? UISwipeGestureRecognizerDirectionRight : UISwipeGestureRecognizerDirectionDown;
        _swipeGesture.delegate = self;
    }
    return _swipeGesture;
}

- (void)swipe:(UISwipeGestureRecognizer *)gestureRecognizer
{
    if (self.isEditViewController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
