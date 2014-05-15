//
//  Card.h
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/23/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Background.h"

@interface Card : UIView

@property (strong, nonatomic) Background *background;
@property (nonatomic) NSUInteger backgroundIndex;

- (Card *)initWithFrame:(CGRect)frame background:(Background *)background;


@end
