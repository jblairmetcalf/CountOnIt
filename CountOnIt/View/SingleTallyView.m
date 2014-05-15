//
//  SingleTallyView.m
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/24/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "SingleTallyView.h"
#import "Backgrounds.h"
#import "Background.h"
#import "TallyView.h"
#import "Global.h"

@interface SingleTallyView ()

@property (strong, nonatomic) TallyView *tallyView;

@end

@implementation SingleTallyView

- (id)initWithFrame:(CGRect)frame tally:(Tally *)tally
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.tallyView.tally = tally;
    }
    return self;
}

- (void)removed
{
    CGRect frame = CGRectMake(0.0f, -self.frame.size.height, self.frame.size.width, self.frame.size.height);
    
    [UIView animateWithDuration:GlobalDuration+1.0f animations:^{
        self.tallyView.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)destroy
{
    [self.tallyView destroy];
}

- (TallyView *)tallyView
{
    if (!_tallyView) {
        _tallyView = [[TallyView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height) isLarge:YES];
        [self addSubview:_tallyView];
    }
    return _tallyView;
}

@end
