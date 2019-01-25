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
{
    int _updateType;     //1不升级  2升级 3强制升级
    NSString *APP_DownloadUrl;
}

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
        NSString *versionName = [dic objectForKey:@"version"];
        NSString *msg = [dic objectForKey:@"describ"];
        _updateType = [[dic objectForKey:@"status"] intValue];
        APP_DownloadUrl = [dic objectForKey:@"link"];
        NSString *app_Version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        //1不升级  2非强制升级 3强制升级
        if (_updateType == 2 && ![versionName isEqualToString:app_Version]) {
            [self updateVersionByMsg:msg andVersionName:versionName andIsMust:NO];
        }else if (_updateType == 3 && ![versionName isEqualToString:app_Version]) {
            [self updateVersionByMsg:msg andVersionName:versionName andIsMust:YES];
        }
    }
}
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

-(void)updateVersionByMsg:(NSString *)msg andVersionName:(NSString *)versionName andIsMust:(BOOL)isMust
{
    if (isMust) {
        UIAlertView* alertview =[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@V%@",Localized(@"发现新版本", nil),versionName] message:[NSString stringWithFormat:@"%@:\n%@\n%@",Localized(@"新版本特性", nil),msg, Localized(@"是否升级？", nil)] delegate:self cancelButtonTitle:nil otherButtonTitles:Localized(@"马上升级", nil), nil];
        [alertview show];
    }else{
        UIAlertView* alertview =[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@V%@",Localized(@"发现新版本", nil),versionName] message:[NSString stringWithFormat:@"%@:\n%@\n%@",Localized(@"新版本特性", nil),msg, Localized(@"是否升级？", nil)] delegate:self cancelButtonTitle:Localized(@"稍后升级", nil) otherButtonTitles:Localized(@"马上升级", nil), nil];
        [alertview show];
    }
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_updateType == 3 && buttonIndex == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_DownloadUrl]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            exit(0);
        });
        
    }else if (_updateType == 2 && buttonIndex == 1) {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_DownloadUrl]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            exit(0);
        });
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
    AssetsViewController *vc2 = [[AssetsViewController alloc] init];
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:vc2];
    
    SettingViewController *vc3 = [[SettingViewController alloc] init];
    UINavigationController *mineNav = [[UINavigationController alloc] initWithRootViewController:vc3];
    
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
