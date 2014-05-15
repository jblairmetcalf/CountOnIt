//
//  MannyTalliesCell.m
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/24/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "ManyTalliesCell.h"
#import "TallyView.h"

@interface ManyTalliesCell ()

@property (strong, nonatomic) TallyView *tallyView;

@end

@implementation ManyTalliesCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)destroy
{
    [self.tallyView destroy];
}

- (void)setTally:(Tally *)tally
{
    self.tallyView.tally = tally;
}

- (TallyView *)tallyView
{
    if (!_tallyView) {
        _tallyView = [[TallyView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height) isLarge:NO];
        [self addSubview:_tallyView];
    }
    return _tallyView;
}

@end
