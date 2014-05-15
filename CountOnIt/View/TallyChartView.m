//
//  TallyChartView.m
//  CountOnIt
//
//  Created by J. Blair Metcalf on 3/8/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "TallyChartView.h"
#import "Tally.h"
#import "UIColor+Utility.h"
#import "Background.h"
#import "Backgrounds.h"

@interface TallyChartView ()

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *tallies;
@property (nonatomic, strong) UIView *leftColumnBackground;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *chartLegend;

@property (nonatomic) CGFloat widestValue;
@property (nonatomic) NSInteger minimum;
@property (nonatomic) NSInteger maximum;
@property (nonatomic) NSInteger spread;
@property (nonatomic) NSInteger zero;
@property (nonatomic) float chartX;
@property (nonatomic) float chartWidth;
@property (nonatomic) BOOL hasValues;

@end

@implementation TallyChartView

- (TallyChartView *)initWithTitle:(NSString *)title tallies:(NSArray *)tallies
{
    self = [super init];
    if (self) {
        _tallies = tallies;
        
        self.chartX = 410.0f;
        self.chartWidth = 555.0f;
        
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        self.frame = CGRectMake(0.0f, 0.0f, 1000.0f, 125.0f+(_tallies.count*45.0f));
        
        [self addSubview:self.leftColumnBackground];
        
        self.titleLabel.text = title;
        
        [self addSubview:self.chartLegend];
        
        NSInteger index = 0;
        for (Tally *tally in self.tallies) {
            [self addSubview:[self tallyRow:tally index:index]];
            index++;
        }
    }
    return self;
}

#pragma mark - Drawing

- (BOOL)hasValues
{
    if (!_hasValues) {
        _hasValues = NO;
        for (Tally *tally in self.tallies) {
            if (tally.value != 0) {
                _hasValues = YES;
                break;
            }
        }
    }
    return _hasValues;
}

- (CGFloat)widestValue
{
    if (!_widestValue) {
        NSInteger index = 0;
        for (Tally *tally in self.tallies) {
            CGRect frame = [tally.valueString boundingRectWithSize:CGSizeMake(375.0f, 45.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont fontWithName:@"SourceSansPro-Semibold" size:24.0f] } context:nil];
            
            if (index == 0) {
                _widestValue = frame.size.width;
            } else {
                _widestValue = MAX(_widestValue, frame.size.width);
            }
            index++;
        }
    }
    return _widestValue;
}

- (NSInteger)minimum
{
    if (!_minimum) {
        NSInteger index = 0;
        for (Tally *tally in self.tallies) {
            if (index == 0) {
                _minimum = tally.value;
            } else {
                _minimum = MIN(_minimum, tally.value);
            }
            index++;
        }
        _minimum = MIN(0, _minimum);
    }
    return _minimum;
}

- (NSInteger)maximum
{
    if (!_maximum) {
        NSInteger index = 0;
        for (Tally *tally in self.tallies) {
            if (index == 0) {
                _maximum = tally.value;
            } else {
                _maximum = MAX(_maximum, tally.value);
            }
            index++;
        }
        _maximum = MAX(0, _maximum);
    }
    return _maximum;
}

- (NSInteger)spread
{
    if (!_spread) {
        _spread = MAX(self.maximum-self.minimum, abs((int)self.maximum));
    }
    return _spread;
}

- (NSInteger)zero
{
    if (!_zero) {
        _zero = self.chartX+(fabsf(0.0f-self.self.minimum)/self.spread*self.chartWidth);
    }
    return _zero;
}

- (UIView *)chartLegend
{
    if (!_chartLegend) {
        _chartLegend = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, 90.0f)];
        // _chartLegend.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.1f];
        
        CGFloat width = 75.0f;
        CGFloat height = 25.0f;
        CGFloat y = 40.0f;
        UIFont *font = [UIFont fontWithName:@"SourceSansPro-Regular" size:18.0f];
        UIColor *color = [UIColor colorWithHexString:@"#4c4c4c"];
        
        UILabel *zero = [[UILabel alloc] initWithFrame:CGRectMake(self.zero-width/2, y, width, height)];
        zero.font = font;
        zero.textColor = color;
        zero.textAlignment = NSTextAlignmentCenter;
        zero.text = @"0";
        // zero.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.1f];
        
        [_chartLegend addSubview:zero];
        
        if (self.hasValues) {
            if (self.minimum < 0) {
                UILabel *negative = [[UILabel alloc] initWithFrame:CGRectMake(self.chartX-width/2, y, width, height)];
                negative.font = font;
                negative.textColor = color;
                negative.textAlignment = NSTextAlignmentCenter;
                negative.text = [NSString stringWithFormat:@"%d", (int)self.minimum];
                // negative.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.1f];
                
                [_chartLegend addSubview:negative];
            }
            
            if (self.maximum > 0) {
                UILabel *positive = [[UILabel alloc] initWithFrame:CGRectMake((self.chartX+self.chartWidth)-width/2, y, width, height)];
                positive.font = font;
                positive.textColor = color;
                positive.textAlignment = NSTextAlignmentCenter;
                positive.text = [NSString stringWithFormat:@"%d", (int)self.maximum];
                // positive.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.1f];
                
                [_chartLegend addSubview:positive];
            }
        } else {
            
            CGRect frame = zero.frame;
            frame.origin.x = self.chartX+self.chartWidth/2;
            zero.frame = frame;
        }
    }
    return _chartLegend;
}

- (UIView *)tallyRow:(Tally *)tally index:(NSInteger)index
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 90.0f+(45.0f*index), self.frame.size.width, 45.0f)];
    
    UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 35.0f+self.widestValue, 45.0f)];
    valueLabel.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:24.0f];
    valueLabel.textColor = [UIColor colorWithHexString:@"#4c4c4c"];
    valueLabel.textAlignment = NSTextAlignmentRight;
    valueLabel.text = tally.valueString;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(62.0f+self.widestValue, 0.0f, 275.0f-self.widestValue, 45.0f)];
    titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Light" size:24.0f];
    titleLabel.textColor = [UIColor colorWithHexString:@"#4c4c4c"];
    titleLabel.text = tally.title;
    
    [view addSubview:valueLabel];
    [view addSubview:titleLabel];
    
    if (self.hasValues) {
        Background *background = [[Backgrounds sharedInstance] background:tally.color];
        
        float width = fabsf(0.0f-tally.value)/self.spread*self.chartWidth;
        float x;
        
        if (tally.value < 0) {
            x = self.zero+((float)tally.value/(float)self.spread*self.chartWidth);
        } else {
            x = self.zero;
        }
        
        CGRect frame = CGRectMake(x, 0.0f, width, 45.0f);
        
        UIView *valueView = [[UIView alloc] initWithFrame:frame];
        valueView.backgroundColor = background.background;
        
        [view addSubview:valueView];
    }
    
    // view.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.1f];
    // valueLabel.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.1f];
    // titleLabel.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.1f];
    
    return view;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(35.0f, 19.0f, 302.0f, 50.0f)];
        _titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:40.0f];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#4c4c4c"];
        // _titleLabel.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.1f];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIView *)leftColumnBackground
{
    if (!_leftColumnBackground) {
        _leftColumnBackground = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 375.0f, self.frame.size.height)];
        _leftColumnBackground.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    }
    return _leftColumnBackground;
}

@end
