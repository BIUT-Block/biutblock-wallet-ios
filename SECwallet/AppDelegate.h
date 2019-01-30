//
//  AppDelegate.h
//  Topzrt
//
//  Created by apple01 on 16/5/26.
//  Copyright © 2016年 AnrenLionel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GuideViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) GuideViewController *guideView;
@property (nonatomic, assign) NSInteger updateType; //1不升级  2升级 3强制升级
@property (nonatomic, copy) NSString *versionName;
@property (nonatomic, copy) NSString *APP_DownloadUrl;

@end

