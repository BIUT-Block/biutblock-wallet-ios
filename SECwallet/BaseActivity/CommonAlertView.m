//
//  CommonAlertView.m
//  Topzrt
//
//  Created by Laughing on 16/6/30.
//  Copyright © 2016年 AnrenLionel. All rights reserved.
//

#import "CommonAlertView.h"

#define kAlertWidth     Size(260)

#define kAlertHeight_exclamation_mark    Size(230)
#define kAlertHeight_question_mark       Size(265)
#define kAlertHeight_Check_mark          Size(230)
#define kAlertHeight_remind              Size(230)

#define kTitleHeight       Size(25)

#define kContentHeight_exclamation_mark  Size(50)
#define kContentHeight_question_mark     Size(100)
#define kContentHeight_Check_mark        Size(50)
#define kContentHeight_remind            Size(60)

#define kButtonWidth       Size(90)
#define kButtonHeight      Size(40)

@interface CommonAlertView ()
{
    float _alertViewHeight;
    BOOL _leftLeave;
    int _alertViewType;      //视图类型
}

@property (nonatomic, strong) UILabel *alertTitleLabel;
@property (nonatomic, strong) UILabel *alertMsgLabel;

@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) UIView *backView;
@property (nonatomic,assign) CommonAlertViewType alertType;
@end

@implementation CommonAlertView

+ (CGFloat)alertWidth
{
    return kAlertWidth;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (id)initWithTitle:(NSString *)title
        contentText:(NSString *)content
          imageName:(NSString *)imageName
    leftButtonTitle:(NSString *)leftTitle
   rightButtonTitle:(NSString *)rigthTitle
      alertViewType:(CommonAlertViewType)alertViewType
{
    if (self = [super init]) {
        self.layer.cornerRadius = Size(12);
        self.backgroundColor = BACKGROUND_DARK_COLOR;
        self.alertType = alertViewType;
        _alertViewType = alertViewType;
        
        if (alertViewType == CommonAlertViewType_exclamation_mark) {
            _alertViewHeight = kAlertHeight_exclamation_mark;
            //图片
            UIImageView *imageIV = [[UIImageView alloc] initWithFrame:CGRectMake((kAlertWidth -Size(50))/2, Size(35), Size(50), Size(50))];
            imageIV.image = [UIImage imageNamed:imageName];
            [self addSubview:imageIV];
            
            _alertTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageIV.maxY, kAlertWidth, kTitleHeight)];
            _alertTitleLabel.font = BoldSystemFontOfSize(11);
            _alertTitleLabel.textColor = COLOR(230, 0, 44, 1);
            _alertTitleLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:_alertTitleLabel];
            _alertTitleLabel.text = title;
            //内容
            UILabel *msgLb = [[UILabel alloc] initWithFrame:CGRectMake(Size(15), _alertTitleLabel.maxY, kAlertWidth -Size(30), kContentHeight_exclamation_mark)];
            msgLb.font = SystemFontOfSize(14);
            msgLb.textColor = COLOR(126, 145, 155, 1);
            msgLb.numberOfLines = 2;
            msgLb.text = content;
            [self addSubview:msgLb];
            //设置行间距
            NSMutableAttributedString *msgStr = [[NSMutableAttributedString alloc] initWithString:content];
            NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = Size(3);
            [msgStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, msgStr.length)];
            msgLb.attributedText = msgStr;
            msgLb.textAlignment = NSTextAlignmentCenter;
            
            if (rigthTitle.length == 0) {
                _leftBtn = [[UIButton alloc]initWithFrame:CGRectMake((kAlertWidth -kButtonWidth)/2, kAlertHeight_exclamation_mark -kButtonHeight -Size(20), kButtonWidth, kButtonHeight)];
                [_leftBtn setTitleColor:COLOR(42, 213, 129, 1) forState:UIControlStateNormal];
                _leftBtn.titleLabel.font = BoldSystemFontOfSize(15);
                [_leftBtn setTitle:leftTitle forState:UIControlStateNormal];
                [_leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:_leftBtn];
            }else{
                int insert = (kAlertWidth -kButtonWidth*2)/4;
                _leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(insert, kAlertHeight_exclamation_mark -kButtonHeight -Size(20), kButtonWidth, kButtonHeight)];
                [_leftBtn setTitleColor:COLOR(126, 145, 155, 1) forState:UIControlStateNormal];
                _leftBtn.titleLabel.font = BoldSystemFontOfSize(15);
                [_leftBtn setTitle:leftTitle forState:UIControlStateNormal];
                [_leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:_leftBtn];
                //中间线
                UIView *line = [[UIView alloc]initWithFrame:CGRectMake(_leftBtn.maxX+insert, _leftBtn.minY, Size(0.6), kButtonHeight)];
                line.backgroundColor = COLOR(198, 200, 201, 1);
                [self addSubview:line];
                
                _rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(line.maxX+insert, _leftBtn.minY, kButtonWidth, kButtonHeight)];
                [_rightBtn setTitleColor:COLOR(42, 213, 129, 1) forState:UIControlStateNormal];
                _rightBtn.titleLabel.font = BoldSystemFontOfSize(15);
                [_rightBtn setTitle:rigthTitle forState:UIControlStateNormal];
                [_rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:_rightBtn];
            }
            
        }else if (alertViewType == CommonAlertViewType_question_mark) {
            
            _alertViewHeight = kAlertHeight_question_mark;
            //图片
            UIImageView *imageIV = [[UIImageView alloc] initWithFrame:CGRectMake((kAlertWidth -Size(50))/2, Size(20), Size(50), Size(50))];
            imageIV.image = [UIImage imageNamed:imageName];
            [self addSubview:imageIV];
            
            _alertTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageIV.maxY, kAlertWidth, kTitleHeight)];
            _alertTitleLabel.font = BoldSystemFontOfSize(11);
            _alertTitleLabel.textColor = COLOR(46, 122, 210, 1);
            _alertTitleLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:_alertTitleLabel];
            _alertTitleLabel.text = title;
            //内容
            UILabel *msgLb = [[UILabel alloc] initWithFrame:CGRectMake(Size(15), _alertTitleLabel.maxY, kAlertWidth -Size(30), kContentHeight_question_mark)];
            msgLb.font = SystemFontOfSize(14);
            msgLb.textColor = COLOR(126, 145, 155, 1);
            msgLb.numberOfLines = 5;
            msgLb.text = content;
            [self addSubview:msgLb];
            //设置行间距
            NSMutableAttributedString *msgStr = [[NSMutableAttributedString alloc] initWithString:content];
            NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = Size(3);
            [msgStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, msgStr.length)];
            msgLb.attributedText = msgStr;
            msgLb.textAlignment = NSTextAlignmentCenter;
            
            if (rigthTitle.length == 0) {
                _leftBtn = [[UIButton alloc]initWithFrame:CGRectMake((kAlertWidth -kButtonWidth)/2, kAlertHeight_question_mark -kButtonHeight -Size(20), kButtonWidth, kButtonHeight)];
                [_leftBtn setTitleColor:COLOR(42, 213, 129, 1) forState:UIControlStateNormal];
                _leftBtn.titleLabel.font = BoldSystemFontOfSize(15);
                [_leftBtn setTitle:leftTitle forState:UIControlStateNormal];
                [_leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:_leftBtn];
            }else{
                int insert = (kAlertWidth -kButtonWidth*2)/4;
                _leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(insert, kAlertHeight_question_mark -kButtonHeight -Size(20), kButtonWidth, kButtonHeight)];
                [_leftBtn setTitleColor:COLOR(126, 145, 155, 1) forState:UIControlStateNormal];
                _leftBtn.titleLabel.font = BoldSystemFontOfSize(15);
                [_leftBtn setTitle:leftTitle forState:UIControlStateNormal];
                [_leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:_leftBtn];
                //中间线
                UIView *line = [[UIView alloc]initWithFrame:CGRectMake(_leftBtn.maxX+insert, _leftBtn.minY, Size(0.6), kButtonHeight)];
                line.backgroundColor = COLOR(198, 200, 201, 1);
                [self addSubview:line];
                
                _rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(line.maxX+insert, _leftBtn.minY, kButtonWidth, kButtonHeight)];
                [_rightBtn setTitleColor:COLOR(42, 213, 129, 1) forState:UIControlStateNormal];
                _rightBtn.titleLabel.font = BoldSystemFontOfSize(15);
                [_rightBtn setTitle:rigthTitle forState:UIControlStateNormal];
                [_rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:_rightBtn];                
            }
            
        }else if (alertViewType == CommonAlertViewType_Check_mark) {

            _alertViewHeight = kAlertHeight_Check_mark;
            //图片
            UIImageView *imageIV = [[UIImageView alloc] initWithFrame:CGRectMake((kAlertWidth -Size(50))/2, Size(35), Size(50), Size(50))];
            imageIV.image = [UIImage imageNamed:imageName];
            [self addSubview:imageIV];
            
            _alertTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageIV.maxY, kAlertWidth, kTitleHeight)];
            _alertTitleLabel.font = BoldSystemFontOfSize(11);
            _alertTitleLabel.textColor = COLOR(42, 213, 129, 1);
            _alertTitleLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:_alertTitleLabel];
            _alertTitleLabel.text = title;
            //内容
            UILabel *msgLb = [[UILabel alloc] initWithFrame:CGRectMake(Size(15), _alertTitleLabel.maxY, kAlertWidth -Size(30), Size(20))];
            msgLb.font = SystemFontOfSize(14);
            msgLb.textColor = COLOR(126, 145, 155, 1);
            msgLb.text = content;
            [self addSubview:msgLb];
            //设置行间距
            NSMutableAttributedString *msgStr = [[NSMutableAttributedString alloc] initWithString:content];
            NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = Size(3);
            [msgStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, msgStr.length)];
            msgLb.attributedText = msgStr;
            msgLb.textAlignment = NSTextAlignmentCenter;
            
            _leftBtn = [[UIButton alloc]initWithFrame:CGRectMake((kAlertWidth -kButtonWidth)/2, kAlertHeight_Check_mark -kButtonHeight -Size(30), kButtonWidth, kButtonHeight)];
            [_leftBtn setTitleColor:COLOR(45, 121, 209, 1) forState:UIControlStateNormal];
            _leftBtn.titleLabel.font = BoldSystemFontOfSize(15);
            [_leftBtn setTitle:leftTitle forState:UIControlStateNormal];
            [_leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_leftBtn];
            
        }else if (alertViewType == CommonAlertViewType_remind) {
            //标题，内容，按钮
            _alertViewHeight = kAlertHeight_remind;
            
            _alertTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, Size(30), kAlertWidth, kTitleHeight)];
            _alertTitleLabel.font = BoldSystemFontOfSize(20);
            _alertTitleLabel.textColor = COLOR(50, 66, 74, 1);
            _alertTitleLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:_alertTitleLabel];
            _alertTitleLabel.text = title;
            //内容
            UILabel *msgLb = [[UILabel alloc] initWithFrame:CGRectMake(Size(15), _alertTitleLabel.maxY +Size(10), kAlertWidth -Size(30), kContentHeight_remind)];
            msgLb.font = SystemFontOfSize(10);
            msgLb.textColor = COLOR(126, 145, 155, 1);
            msgLb.numberOfLines = 4;
            msgLb.text = content;
            [self addSubview:msgLb];
            //设置行间距
            NSMutableAttributedString *msgStr = [[NSMutableAttributedString alloc] initWithString:content];
            NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = Size(3);
            [msgStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, msgStr.length)];
            msgLb.attributedText = msgStr;
            msgLb.textAlignment = NSTextAlignmentCenter;
            
            _leftBtn = [[UIButton alloc]initWithFrame:CGRectMake((kAlertWidth -Size(110))/2, kAlertHeight_remind -Size(40) -Size(30), Size(125), Size(45))];
            [_leftBtn goldSmallBtnStyle:leftTitle];
            [_leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_leftBtn];
        }
        
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    }
    return self;
}

- (void)leftBtnClicked:(id)sender
{
    _leftLeave = YES;
    if (self.leftBlock) {
        self.leftBlock();
    }
    [self dismissAlert];

}

- (void)rightBtnClicked:(id)sender
{
    _leftLeave = NO;
    if (self.rightBlock) {
        self.rightBlock();
    }
    [self dismissAlert];
}

- (void)show
{
    UIViewController *topVC = [self appRootViewController];
    self.frame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth)/2, (CGRectGetHeight(topVC.view.bounds) - _alertViewHeight)/2 -Size(12), kAlertWidth, _alertViewHeight);
    [topVC.view addSubview:self];
    
    if (_alertType == CommonAlertViewType_remind) {
        //添加毛玻璃效果
        if (IS_OS_8_OR_LATER) {
            UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
            UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
            effectView.frame = AppDelegateInstance.window.frame;
            effectView.alpha = 0.85;
            [topVC.view addSubview:effectView];
        }else{
            UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:AppDelegateInstance.window.frame];
            toolbar.barStyle = UIBarStyleBlackTranslucent;
            toolbar.alpha = 0.85;
            [topVC.view addSubview:toolbar];
        }
        [topVC.view bringSubviewToFront:self];
        self.backgroundColor = CLEAR_COLOR;
    }else{
        //设置阴影
        CALayer *layer = [self layer];
        layer.shadowOffset = CGSizeMake(0, 0);
        layer.shadowRadius = Size(2);
        layer.shadowColor = [UIColor darkGrayColor].CGColor;
        layer.shadowOpacity = Size(0.3);
    }
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.1f;// 动画时间
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [self.layer addAnimation:animation forKey:nil];
}

- (void)dismissAlert
{
    UIViewController *topVC = [self appRootViewController];
    for (UIView *view in topVC.view.subviews) {
        if ([view isKindOfClass:[UIVisualEffectView class]] || [view isKindOfClass:[UIToolbar class]]) {
            [view removeFromSuperview];
        }
    }
    [self removeFromSuperview];
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}


- (void)removeFromSuperview
{
    [_backView removeFromSuperview];
    _backView = nil;
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.1f;// 动画时间
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    animation.values = values;
    [self.layer addAnimation:animation forKey:nil];
    
    [UIView animateWithDuration:0.1f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
//        [super removeFromSuperview];
    }];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview == nil) {
        return;
    }
    UIViewController *topVC = [self appRootViewController];
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:topVC.view.bounds];
        _backView.backgroundColor = BLACK_COLOR;
        _backView.alpha = 0.0f;
        _backView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    [topVC.view addSubview:_backView];

    self.alpha = 0;
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.transform = CGAffineTransformMakeRotation(0);
        self.alpha = 1;
    } completion:^(BOOL finished) {

    }];

    [super willMoveToSuperview:newSuperview];
}

@end

