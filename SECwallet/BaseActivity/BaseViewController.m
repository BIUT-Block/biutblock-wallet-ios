//
//  BaseViewController.m
//  Topzrt
//
//  Created by apple01 on 16/5/26.
//  Copyright © 2016年 AnrenLionel. All rights reserved.
//

#import "BaseViewController.h"

#define HUDYOFFSET   kScreenHeight/Size(3.3)

@interface BaseViewController ()<MBProgressHUDDelegate>
{
    UIImageView *navigationImageView;
}

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUND_DARK_COLOR;
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = BACKGROUND_DARK_COLOR;
    self.navigationController.navigationBar.tintColor = BLACK_COLOR;
    
    //设置返回back
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    navigationImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    
}

-(UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = BACKGROUND_DARK_COLOR;
    
    navigationImageView.hidden = YES;
        
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = BACKGROUND_DARK_COLOR;
    self.navigationController.navigationBar.tintColor = BLACK_COLOR;
    
    //设置返回back
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
}

-(void)backAction
{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - 适配iOS11
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

/** 显示提示信息 */
- (void)hudShowWithString:(NSString *)str delayTime:(CGFloat)time{
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelFont = SystemFontOfSize(12);
    HUD.cornerRadius = Size(5);
    HUD.color = BLACK_COLOR;
    HUD.margin = Size(10);
    HUD.mode = MBProgressHUDModeText;
    HUD.labelText = str;
    HUD.yOffset = HUDYOFFSET;
    [HUD hide:YES afterDelay:time];
}

#pragma mark -- 设置label标题栏
- (void)setNavgationItemTitle:(NSString *)string
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Size(60), Size(36))];
    label.textColor = BLACK_COLOR;
    label.textAlignment = 1;
    label.text = string;
    label.font = BoldSystemFontOfSize(14);
    self.navigationItem.titleView = label;
}

#pragma mark -- 设置导航栏左边按钮图片
- (void)setNavgationLeftImage:(UIImage *)image withAction:(SEL)methot
{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:image
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:methot];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}

#pragma mark 显示请求数据的HUD，不执行方法
- (void)createLoadingView:(NSString *)message
{
    if (_loadingView) {
        [_loadingView removeFromSuperview];
    }
    _loadingView = [[LoadingView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _loadingView.labelText = message==nil?Localized(@"加载中...", nil):message;
    [_loadingView showLoadingViewOnly];    
    [self.view addSubview:_loadingView];
}

#pragma mark  隐藏请求数据的HUD
- (void)hiddenLoadingView
{
    _isLoading  = NO;
    [HUD hide:YES];
    if (self.loadingView) {
        [self.loadingView removeFromSuperview];
    }
}

@end
