//
//  SettingsViewCell.h
//  CountOnIt
//
//  Created by J. Blair Metcalf on 2/22/14.
//  Copyright (c) 2014 James Metcalf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewCell;

@protocol ViewCellDelegate

- (void)switchButtonChanged:(ViewCell *)sender;
- (void)valueChanged:(ViewCell *)sender;

@end

@interface ViewCell : UITableViewCell

@property (nonatomic, weak) id <ViewCellDelegate> delegate;

@property (weak, nonatomic, readonly) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *key;
@property (nonatomic) BOOL enabled;
@property (nonatomic) BOOL checked;
@property (nonatomic, strong) NSString *emptyText;
@property (nonatomic, strong) NSString *text;

- (void)destroy;

@end
