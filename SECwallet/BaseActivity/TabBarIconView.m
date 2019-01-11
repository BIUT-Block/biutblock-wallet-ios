//
//  TabBarIconView.m
//  TOP_zrt
//
//  Created by Laughing on 16/5/20.
//  Copyright © 2016年 topzrt. All rights reserved.
//

#import "TabBarIconView.h"

#define kItemButtonHeight   Size(25)
#define kTextLabelHeight    Size(10)

@implementation TabBarIconView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

#pragma mark - getter methods
- (UILabel *)textLabel
{
    if (_textLabel == nil) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.font = SystemFontOfSize(8);
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.textColor = TEXT_DARK_COLOR;
        [self addSubview:_textLabel];
    }
    return _textLabel;
}

- (UIButton *)iconButton
{
    if (_iconButton == nil) {
        _iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_iconButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        _iconButton.showsTouchWhenHighlighted = YES;
        [self addSubview:_iconButton];
    }
    return _iconButton;
}

#pragma mark - Public Method
- (void)isSelected:(BOOL)selected
{
    _iconButton.selected = selected;
    _textLabel.highlighted = selected;
    
    if(selected){
        _textLabel.textColor = TEXT_GREEN_COLOR;
        _iconButton.frame = CGRectMake((self.frame.size.width -kItemButtonHeight)/2, Size(8), kItemButtonHeight, kItemButtonHeight);
    } else {
        _textLabel.textColor = TEXT_DARK_COLOR;
        _iconButton.frame = CGRectMake((self.frame.size.width -kItemButtonHeight)/2, Size(5), kItemButtonHeight, kItemButtonHeight);
    }
}

#pragma mark - Layout Method
- (void)layoutSubviews
{
    [super layoutSubviews];
    // 如果支持横竖屏幕，通过[UIApplication sharedApplication].statusBarOrientation;
    _textLabel.frame = CGRectMake(0, self.frame.size.height-kTextLabelHeight-Size(5), self.frame.size.width, kTextLabelHeight);
}

#pragma mark - Action Method
- (void)click:(UIButton *)item
{
    if ([self.delegate respondsToSelector:@selector(didSelectIconView:)]) {
        [self.delegate didSelectIconView:self];
    }
}


@end
