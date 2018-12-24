//
//  ViewController.m
//  Topzrt
//
//  Created by apple01 on 16/5/26.
//  Copyright © 2016年 AnrenLionel. All rights reserved.
//


#import "RootViewController.h"
#import "AssetsViewController.h"
#import "SettingViewController.h"

@interface RootViewController ()
{
    UIView *bkgView;
    UIButton *homeBT;
    UIButton *settingBT;
    UIView *bottomLine;
}

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 加载子视图控制器
    [self loadViewControllers];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTabView) name:NotificationShowTabView object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenTabView) name:NotificationHiddenTabView object:nil];
    
}

-(void)showTabView
{
    bkgView.hidden = NO;
    bottomLine.hidden = NO;
}

-(void)hiddenTabView
{
    bkgView.hidden = YES;
    bottomLine.hidden = YES;
}

- (void)loadViewControllers
{
    //切换视图
    bkgView = [[UIView alloc]initWithFrame:CGRectMake((kScreenWidth -Size(130))/2, kScreenHeight -Size(40+25), Size(130), Size(40))];
    bkgView.backgroundColor = COLOR(241, 242, 244, 1);
    bkgView.layer.cornerRadius = Size(10);
    [self.view addSubview:bkgView];
    //中间线
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(bkgView.width/2, Size(3), Size(0.5), bkgView.height -Size(3*2))];
    line.backgroundColor = COLOR(224, 225, 226, 1);
    [bkgView addSubview:line];
    //两个按钮
    homeBT = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, bkgView.width/2, bkgView.height)];
    [homeBT setImage:[UIImage imageNamed:@"icon_tab_selected_01"] forState:UIControlStateNormal];
    [homeBT addTarget:self action:@selector(homeBTAction) forControlEvents:UIControlEventTouchUpInside];
    [bkgView addSubview:homeBT];
    settingBT = [[UIButton alloc]initWithFrame:CGRectMake(homeBT.maxX, 0, bkgView.width/2, bkgView.height)];
    [settingBT setImage:[UIImage imageNamed:@"icon_tab_normal_02"] forState:UIControlStateNormal];
    [settingBT addTarget:self action:@selector(settingBTAction) forControlEvents:UIControlEventTouchUpInside];
    [bkgView addSubview:settingBT];
    
    //下划线
    bottomLine = [[UIView alloc]initWithFrame:CGRectMake(bkgView.minX +Size(13), bkgView.maxY, bkgView.width/2 -Size(13*2), Size(1.2))];
    bottomLine.backgroundColor = COLOR(45, 121, 209, 1);
    bottomLine.layer.cornerRadius = Size(2);
    [self.view addSubview:bottomLine];
    
    //默认首页
    AssetsViewController *vc1 = [[AssetsViewController alloc] init];
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:vc1];
    // 添加标签控制器
    [self setViewControllers:@[homeNav] animated:YES];
    
}

-(void)homeBTAction
{
    AssetsViewController *vc = [[AssetsViewController alloc] init];
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:vc];
    // 添加标签控制器
    [self setViewControllers:@[homeNav] animated:YES];
    [homeBT setImage:[UIImage imageNamed:@"icon_tab_selected_01"] forState:UIControlStateNormal];
    [settingBT setImage:[UIImage imageNamed:@"icon_tab_normal_02"] forState:UIControlStateNormal];
    //从右向左移动
    [UIView animateWithDuration:0.20 animations:^{
        bottomLine.frame = CGRectMake(bkgView.minX +Size(13), bkgView.maxY, bkgView.width/2 -Size(13*2), Size(1.4));
    }];
}

-(void)settingBTAction
{
    // 默认s设置页
    SettingViewController *vc = [[SettingViewController alloc] init];
    UINavigationController *mineNav = [[UINavigationController alloc] initWithRootViewController:vc];
    // 添加标签控制器
    [self setViewControllers:@[mineNav] animated:YES];
    [homeBT setImage:[UIImage imageNamed:@"icon_tab_normal_01"] forState:UIControlStateNormal];
    [settingBT setImage:[UIImage imageNamed:@"icon_tab_selected_02"] forState:UIControlStateNormal];
    //从左向右移动
    [UIView animateWithDuration:0.20 animations:^{
        bottomLine.frame = CGRectMake(bkgView.minX +bkgView.width/2 +Size(13), bkgView.maxY, bkgView.width/2 -Size(13*2), Size(1.4));
    }];
}



@end
