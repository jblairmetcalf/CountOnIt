//
//  TallyTitleValue.h
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/23/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TextFieldView;

@protocol TextFieldViewDelegate

- (void)valueChanged:(TextFieldView *)sender;

@end

@interface TextFieldView : UIView

@property (nonatomic, weak) id <TextFieldViewDelegate> delegate;

@property (strong, nonatomic) NSString *emptyText;
@property (strong, nonatomic) NSString *text;

- (TextFieldView *)initWithFrame:(CGRect)frame textColor:(UIColor *)textColor emptyImageName:(NSString *)emptyImageName emptyHighlightedImageName:(NSString *)emptyHighlightedImageName isSearch:(BOOL)isSearch hasBorder:(BOOL)hasBorder fontSize:(CGFloat)fontSize emptyText:(NSString *)emptyText;
- (void)destroy;
- (void)empty;

@end