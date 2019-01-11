//
//  TabBarIconView.h
//  TOP_zrt
//
//  Created by Laughing on 16/5/20.
//  Copyright © 2016年 topzrt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TabBarIconView;

@protocol TabBarIconViewDelegate <NSObject>

- (void)didSelectIconView:(TabBarIconView *)iconView;

@end

@interface TabBarIconView : UIView

@property (nonatomic, weak) id <TabBarIconViewDelegate> delegate;

@property (nonatomic, strong) UIButton *iconButton;
@property (nonatomic, strong) UILabel  *textLabel;

- (void)isSelected:(BOOL)selected;

@end

