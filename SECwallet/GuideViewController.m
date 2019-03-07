//
//  GuideViewController.m
//  Topzrt
//
//  Created by Laughing on 16/9/7.
//  Copyright © 2016年 AnrenLionel. All rights reserved.
//

#import "GuideViewController.h"
#import "RootViewController.h"
#import "SelectEntryViewController.h"

@interface GuideViewController ()

@property (nonatomic, strong) RootViewController *tabBarController;

@end

@implementation GuideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self startRootViewWithoutAdView];
}

- (void)startRootViewWithoutAdView
{
    if ([AppDefaultUtil sharedInstance].hasCreatWallet == YES) {
        self.tabBarController = [[RootViewController alloc] init];
        AppDelegateInstance.window.rootViewController = self.tabBarController;
        [AppDelegateInstance.window makeKeyAndVisible];
        
    }else{
        SelectEntryViewController *viewController = [[SelectEntryViewController alloc]init];
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:viewController];
        AppDelegateInstance.window.rootViewController = navi;
        [AppDelegateInstance.window makeKeyAndVisible];
    }
}

@end
