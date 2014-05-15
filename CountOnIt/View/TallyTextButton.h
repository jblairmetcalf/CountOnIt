//
//  TallyTextButton.h
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/27/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TallyTextButton : UIView

@property (nonatomic) BOOL selected;

- (TallyTextButton *)initWithFrame:(CGRect)frame deselectedTitle:(NSString *)deselectedTitle deselectedImage:(NSString *)deselectedImage selectedTitle:(NSString *)selectedTitle selectedImage:(NSString *)selectedImage;
- (void)destroy;

@end