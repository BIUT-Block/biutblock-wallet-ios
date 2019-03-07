//
//  ViewController.m
//  Topzrt
//
//  Created by apple01 on 16/5/26.
//  Copyright © 2016年 AnrenLionel. All rights reserved.
//


#import "RootViewController.h"
#import "TabBarIconView.h"
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
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //请求数据
        [self checkVersion];
    });
}

#pragma mark 版本检测
-(void)checkVersion
{
    NSURL *zoneUrl = [NSURL URLWithString:@"http://scan.secblock.io/publishversionapi"];
    NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
    NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
    if (data != nil) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dic = [[NSDictionary alloc]init];
        dic = [dataDic objectForKey:@"ios"];
        AppDelegateInstance.versionName = [dic objectForKey:@"version"];
        NSString *msg = [dic objectForKey:@"describ"];
        AppDelegateInstance.updateType = [[dic objectForKey:@"status"] intValue];;
        AppDelegateInstance.APP_DownloadUrl = [dic objectForKey:@"link"];
        NSString *app_Version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        //1不升级  2非强制升级 3强制升级
        if (AppDelegateInstance.updateType == 2 && ![AppDelegateInstance.versionName isEqualToString:app_Version]) {
            [self updateVersionByMsg:msg andVersionName:AppDelegateInstance.versionName andIsMust:NO];
        }else if (AppDelegateInstance.updateType == 3 && ![AppDelegateInstance.versionName isEqualToString:app_Version]) {
            [self updateVersionByMsg:msg andVersionName:AppDelegateInstance.versionName andIsMust:YES];
        }        
    }
}

-(void)updateVersionByMsg:(NSString *)msg andVersionName:(NSString *)versionName andIsMust:(BOOL)isMust
{
    if (isMust) {
        CommonAlertView *alert = [[CommonAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@V%@",Localized(@"发现新版本", nil),versionName] contentText:[NSString stringWithFormat:@"%@:\n%@",Localized(@"新版本特性", nil),msg] imageName:@"appIcon" leftButtonTitle:Localized(@"马上升级", nil) rightButtonTitle:nil alertViewType:CommonAlertViewType_question_mark];
        [alert show];
        alert.leftBlock = ^() {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:AppDelegateInstance.APP_DownloadUrl]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                exit(0);
            });
        };

    }else{
        CommonAlertView *alert = [[CommonAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@V%@",Localized(@"发现新版本", nil),versionName] contentText:[NSString stringWithFormat:@"%@:\n%@",Localized(@"新版本特性", nil),msg] imageName:@"appIcon" leftButtonTitle:Localized(@"稍后升级", nil) rightButtonTitle:Localized(@"马上升级", nil) alertViewType:CommonAlertViewType_question_mark];
        [alert show];
        alert.rightBlock = ^() {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:AppDelegateInstance.APP_DownloadUrl]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                exit(0);
            });
        };
    }
}

- (void)customTabBarView
{
    //添加背景视图
    UIImageView *tabBarBG = [[UIImageView alloc] initWithFrame:self.tabBar.bounds];
    tabBarBG.backgroundColor = Tabbar_COLOR;
    [self.tabBar addSubview:tabBarBG];
    
    NSArray *titleArr = @[Localized(@"首页", nil),Localized(@"我的", nil)];
    NSArray *iconArr = @[@"home",@"settings"];
    CGFloat itemWidth = (kScreenWidth -Size(20 *2))/titleArr.count;
    for (int i = 0; i < [[self viewControllers] count]; i++) {
        TabBarIconView *iconView = [[TabBarIconView alloc] initWithFrame:CGRectMake(Size(20) +itemWidth *i, 0, itemWidth, KTabbarHeight)];
        iconView.delegate = self;
        iconView.tag = kTagItem + i;
        [iconView.iconButton setImage:[UIImage imageNamed:iconArr[i]] forState:UIControlStateNormal];
        [iconView.iconButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@Active",iconArr[i]]] forState:UIControlStateSelected];
        iconView.textLabel.text = titleArr[i];
        if (i == 0) {
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
    AssetsViewController *vc1 = [[AssetsViewController alloc] init];
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:vc1];
    
    SettingViewController *vc2 = [[SettingViewController alloc] init];
    UINavigationController *mineNav = [[UINavigationController alloc] initWithRootViewController:vc2];
    
    NSArray *vcs = @[homeNav, mineNav];
    [self setViewControllers:vcs animated:YES];
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
