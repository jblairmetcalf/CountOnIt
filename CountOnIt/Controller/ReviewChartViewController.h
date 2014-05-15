//
//  ReviewChartViewController.h
//  CountOnIt
//
//  Created by J. Blair Metcalf on 3/6/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import "GAITrackedViewController.h"

@interface ReviewChartViewController : GAITrackedViewController

@property (strong, nonatomic) NSString *chartTitle;
@property (strong, nonatomic) NSArray *chartTallies;

@end
