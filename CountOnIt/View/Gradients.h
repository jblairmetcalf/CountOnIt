//
//  Gradients.h
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/23/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Background.h"

@interface Gradients : UIView

@property (strong, nonatomic) Background *background;

- (Gradients *)initWithFrame:(CGRect)frame background:(Background *)background;
- (Gradients *)initWithFrame:(CGRect)frame top:(NSString *)top bottom:(NSString *)bottom leftTop:(BOOL)leftTop;

@end
