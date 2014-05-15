//
//  SettingsViewCell.m
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/22/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "ViewCell.h"
#import "UIColor+Utility.h"
#import <QuartzCore/QuartzCore.h>
#import "TextFieldView.h"
#import "UIColor+Utility.h"

@interface ViewCell () <TextFieldViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;
@property (strong, nonatomic) TextFieldView *textFieldView;

@end

@implementation ViewCell

- (void)destroy
{
    if (_textFieldView) [self.textFieldView destroy];
}

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
    self.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:18.0f];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#4c4c4c"];
}

- (void)setImage:(UIImage *)image
{
    self.imageView.image = image;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 6.0f;
}

- (void)setText:(NSString *)text
{
    self.textFieldView.text = text;
}

- (void)setEmptyText:(NSString *)emptyText
{
    self.textFieldView.emptyText = emptyText;
}

- (TextFieldView *)textFieldView
{
    if (!_textFieldView) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _textFieldView = [[TextFieldView alloc] initWithFrame:CGRectMake(20.0f, 6.5f, 280.0f, 30.0f) textColor:[UIColor colorWithHexString:@"#4c4c4c"] emptyImageName:@"Textfield-Empty-Dark" emptyHighlightedImageName:@"Textfield-Empty-Dark-Highlighted" isSearch:NO hasBorder:NO fontSize:17.0f emptyText:nil];
        _textFieldView.delegate = self;
        [self addSubview:_textFieldView];
    }
    return _textFieldView;
}

- (void)valueChanged:(TextFieldView *)sender
{
    [self.delegate valueChanged:self];
}

- (NSString *)text
{
    return self.textFieldView.text;
}

- (BOOL)enabled
{
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
    return self.userInteractionEnabled;
}

- (void)setEnabled:(BOOL)enabled
{
    self.userInteractionEnabled = enabled;
    self.titleLabel.enabled = enabled;
    if (self.switchButton) self.switchButton.enabled = enabled;
}

- (void)setChecked:(BOOL)checked
{
    self.accessoryType = checked ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    self.tintColor = [UIColor colorWithHexString:@"#e868a2"];
}

- (void)setKey:(NSString *)key
{
    _key = key;
    
    BOOL on = [[[NSUserDefaults standardUserDefaults] objectForKey:self.key] isEqualToString:@"YES"] ? YES : NO;
    self.switchButton.on = on;
    self.switchButton.onTintColor = [UIColor colorWithHexString:@"#e868a2"];
}

- (IBAction)switchButtonChanged:(id)sender
{
    NSString *on = self.switchButton.on ? @"YES" : @"NO";
    
    [[NSUserDefaults standardUserDefaults] setObject:on forKey:self.key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.delegate switchButtonChanged:self];
}

@end
