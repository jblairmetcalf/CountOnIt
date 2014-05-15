//
//  ManyTalliesHeaderView.m
//  CountOnIt
//
//  Created by J. Blair Metcalf on 3/5/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "ManyTalliesHeaderView.h"
#import "Global.h"
#import "UIColor+Utility.h"

@interface ManyTalliesHeaderView () <TextFieldViewDelegate>

@property (strong, nonatomic) UIView *seperator;

@end

@implementation ManyTalliesHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#d8d8d8"];
        
        [self addSubview:self.textFieldView];
        [self addSubview:self.seperator];
    }
    return self;
}

- (void)valueChanged:(TextFieldView *)sender
{
    [self.delegate valueChanged:self];
}

- (NSString *)text
{
    return self.textFieldView.text;
}

- (UIView *)seperator
{
    if (!_seperator) {
        _seperator = [[UIView alloc] initWithFrame:CGRectMake(0.0f, self.frame.size.height-0.5f
                                                              , self.frame.size.width, 0.5f)];
        _seperator.backgroundColor = [UIColor colorWithHexString:@"#a7a7aa"];
    }
    return _seperator;
}

- (TextFieldView *)textFieldView
{
    if (!_textFieldView) {
        _textFieldView = [[TextFieldView alloc] initWithFrame:CGRectMake(GlobalPadding, GlobalPadding, self.frame.size.width-(GlobalPadding*2), self.frame.size.height-(GlobalPadding*2))
                                                    textColor:[UIColor colorWithHexString:@"#4c4c4c"]
                                               emptyImageName:@"Textfield-Empty-Dark"
                                    emptyHighlightedImageName:@"Textfield-Empty-Dark-Highlighted"
                                                     isSearch:YES
                                                    hasBorder:YES
                                                     fontSize:20.0f
                                                    emptyText:nil];
        _textFieldView.delegate = self;
    }
    return _textFieldView;
}

@end
