//
//  ViewController.m
//  Topzrt
//
//  Created by apple01 on 16/5/26.
//  Copyright © 2016年 AnrenLionel. All rights reserved.
//


#import "RootViewController.h"
#import "DiscoveryViewController.h"
#import "AssetsViewController.h"
#import "SettingViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //隐藏底部黑线
    [self.tabBar setClipsToBounds:YES];
    [[UITabBar appearance] setBarTintColor:COLOR(248, 252, 252, 1)];
    [UITabBar appearance].translucent = NO;
    
    // 加载子视图控制器
    [self loadViewControllers];
    
}

- (void)loadViewControllers
{
//    DiscoveryViewController *vc1 = [[DiscoveryViewController alloc] init];
//    UINavigationController *discoveryNav = [[UINavigationController alloc] initWithRootViewController:vc1];
//    discoveryNav.tabBarItem = [[UITabBarItem alloc]initWithTitle:Localized(@"发现", nil) image:[UIImage imageNamed:@"icon_tab_normal_01"] selectedImage:[UIImage imageNamed:@"icon_tab_selected_01"]];
//    discoveryNav.tabBarItem.tag = 100;
//    discoveryNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_tab_selected_01"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    discoveryNav.tabBarItem.image = [[UIImage imageNamed:@"icon_tab_normal_01"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    [discoveryNav.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:TEXT_GREEN_COLOR forKey:NSForegroundColorAttributeName] forState:UIControlStateSelected];
    
    AssetsViewController *vc2 = [[AssetsViewController alloc] init];
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:vc2];
    homeNav.tabBarItem = [[UITabBarItem alloc]initWithTitle:Localized(@"首页", nil) image:[UIImage imageNamed:@"home"] selectedImage:[UIImage imageNamed:@"homeActive"]];
    homeNav.tabBarItem.tag = 101;
    homeNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"homeActive"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeNav.tabBarItem.image = [[UIImage imageNamed:@"home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeNav.tabBarItem.titlePositionAdjustment = UIOffsetMake(-5, -5);
    [homeNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:TEXT_DARK_COLOR,NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:8]} forState:UIControlStateNormal];
    [homeNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:TEXT_GREEN_COLOR,NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:8]} forState:UIControlStateHighlighted];
    
    SettingViewController *vc3 = [[SettingViewController alloc] init];
    UINavigationController *mineNav = [[UINavigationController alloc] initWithRootViewController:vc3];
    mineNav.tabBarItem = [[UITabBarItem alloc]initWithTitle:Localized(@"我的", nil) image:[UIImage imageNamed:@"settings"] selectedImage:[UIImage imageNamed:@"settingsActive"]];
    mineNav.tabBarItem.tag = 102;
    mineNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"settingsActive"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mineNav.tabBarItem.image = [[UIImage imageNamed:@"settings"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mineNav.tabBarItem.titlePositionAdjustment = UIOffsetMake(-5, -5);
    [mineNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:TEXT_DARK_COLOR,NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:8]} forState:UIControlStateNormal];
    [mineNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:TEXT_GREEN_COLOR,NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:8]} forState:UIControlStateHighlighted];
    
    // 将子视图控制器放入数组
    NSArray *vcs = @[homeNav, mineNav];
    // 添加标签控制器
    [self setViewControllers:vcs animated:YES];
}



@end
