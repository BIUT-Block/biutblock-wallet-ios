//
//  ViewController.m
//  Topzrt
//
//  Created by apple01 on 16/5/26.
//  Copyright © 2016年 AnrenLionel. All rights reserved.
//


#import "RootViewController.h"
#import "TabBarIconView.h"
#import "DiscoveryViewController.h"
#import "AssetsViewController.h"
#import "SettingViewController.h"

#define kTagItem 100

@interface RootViewController ()<TabBarIconViewDelegate>

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //隐藏底部黑线
    [self.tabBar setClipsToBounds:YES];
    
    // 加载子视图控制器
    [self loadViewControllers];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self customTabBarView];
    });
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(updateSelectedItem:) name:NotificationUpdateTab object:nil];
    
    self.selectedIndex = 1;

}

-(void)skipTwoVc{
    
}

- (void)customTabBarView
{
    // 1 移除UITabBarButton
    for (UIView *subView in [self.tabBar subviews]) {
        [subView removeFromSuperview];
    }
    // 2 添加背景视图
    UIImageView *tabBarBG = [[UIImageView alloc] initWithFrame:self.tabBar.bounds];
    tabBarBG.backgroundColor = Tabbar_COLOR;
    tabBarBG.tag = 1000;
    [self.tabBar addSubview:tabBarBG];
    
    NSArray *titleArr = @[Localized(@"发现", nil),Localized(@"首页", nil),Localized(@"我的", nil)];
    NSArray *iconArr = @[@"discovery",@"home",@"settings"];
    CGFloat itemWidth = (kScreenWidth -Size(20 *2))/3;
    for (int i = 0; i < [[self viewControllers] count]; i++) {
        TabBarIconView *iconView = [[TabBarIconView alloc] initWithFrame:CGRectMake(Size(20) +itemWidth *i, 0, itemWidth, KTabbarHeight)];
        iconView.delegate = self;
        iconView.tag = kTagItem + i;
        [iconView.iconButton setImage:[UIImage imageNamed:iconArr[i]] forState:UIControlStateNormal];
        [iconView.iconButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@Active",iconArr[i]]] forState:UIControlStateSelected];
        iconView.textLabel.text = titleArr[i];
        if (i == 1) {
            [iconView isSelected:YES];
        }else{
            [iconView isSelected:NO];
        }
        // 添加子视图
        [self.tabBar addSubview:iconView];
    }
}

- (void)loadViewControllers
{
    DiscoveryViewController *vc1 = [[DiscoveryViewController alloc] init];
    UINavigationController *discoveryNav = [[UINavigationController alloc] initWithRootViewController:vc1];
    
    AssetsViewController *vc2 = [[AssetsViewController alloc] init];
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:vc2];
    
    SettingViewController *vc3 = [[SettingViewController alloc] init];
    UINavigationController *mineNav = [[UINavigationController alloc] initWithRootViewController:vc3];
    
    // 将子视图控制器放入数组
    NSArray *vcs = @[discoveryNav, homeNav, mineNav];
    // 添加标签控制器
    [self setViewControllers:vcs animated:YES];
    
}

-(void) updateSelectedItem:(NSNotification *)notification
{
    NSString *itemIndex = (NSString *)[notification object];
    [self setTabIndex:[itemIndex intValue] + kTagItem];
}

#pragma mark - TabBarIconViewDelegate
- (void)didSelectIconView:(TabBarIconView *)iconView
{
    [self setTabIndex:iconView.tag];
}

-(void) setTabIndex:(NSInteger)index
{
    UIView *viewTemp = [self.tabBar viewWithTag:index];
    if ([viewTemp isMemberOfClass:[TabBarIconView class]]) {
        TabBarIconView *iconView = (TabBarIconView *)viewTemp;
        for (UIView *subview in self.tabBar.subviews) {
            if ([subview isMemberOfClass:[TabBarIconView class]]) {
                TabBarIconView *icon = (TabBarIconView *)subview;
                if (icon == iconView) {
                    [icon isSelected:YES];
                }else {
                    [icon isSelected:NO];
                }
            }
        }
        self.selectedIndex = index - kTagItem;
    }
}


@end
