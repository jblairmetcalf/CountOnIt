//
//  TouchAndHold.h
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/28/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TouchAndHold;

@protocol TouchAndHoldDelegate

- (void)valueChanged:(TouchAndHold *)sender;
- (void)didChangeValue:(TouchAndHold *)sender;

@end

@interface TouchAndHold : UIButton

@property (nonatomic, weak) id <TouchAndHoldDelegate> delegate;

@property (nonatomic) NSUInteger increment;
@property (nonatomic) BOOL down;

@end