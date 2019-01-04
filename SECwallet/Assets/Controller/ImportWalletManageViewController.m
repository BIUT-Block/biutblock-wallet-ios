//
//  InvestRecordManageViewController.m
//  Topzrt
//
//  Created by Laughing on 16/10/13.
//  Copyright © 2016年 AnrenLionel. All rights reserved.
//

#import "ImportWalletManageViewController.h"
#import "SGSegmentedControl.h"
#import "ImportWalletViewController.h"
#import "CommonHtmlShowViewController.h"

@interface ImportWalletManageViewController ()<UIScrollViewDelegate, SGSegmentedControlDelegate>
{
    UIButton *tipBT;
}

@property (nonatomic, strong) SGSegmentedControl *SG;
@property (nonatomic, strong) UIScrollView *mainScrollView;

@end

@implementation ImportWalletManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BACKGROUND_DARK_COLOR;
    
    // 1.添加所有子控制器
    [self setupChildViewController];
    
    [self setupUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /**************导航栏布局***************/
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)setupUI
{
    //返回按钮
    UIButton *backBT = [[UIButton alloc]initWithFrame:CGRectMake(Size(20), KStatusBarHeight+Size(13), Size(25), Size(15))];
    [backBT addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [backBT setImage:[UIImage imageNamed:@"backIcon"] forState:UIControlStateNormal];
    backBT.tag = 100;
    [self.view addSubview:backBT];
    
    tipBT = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth -Size(100+20), KStatusBarHeight+Size(11), Size(100), Size(24))];
    [tipBT greenBorderBtnStyle:Localized(@"什么是助记词？",nil) andBkgImg:@"continue"];
    [tipBT addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    tipBT.tag = 101;
    [self.view addSubview:tipBT];
    //标题
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(Size(15), tipBT.maxY +Size(3), Size(200), Size(35))];
    titleLb.textColor = TEXT_BLACK_COLOR;
    titleLb.font = BoldSystemFontOfSize(20);
    titleLb.text = Localized(@"导入钱包",nil);
    [self.view addSubview:titleLb];
    
    NSArray *titleArr = @[Localized(@"助记词", nil), Localized(@"官方钱包", nil), Localized(@"私钥", nil)];
    // 创建底部滚动视图
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, titleLb.maxY +Size(13), kScreenWidth, kScreenHeight-KNaviHeight-titleLb.maxY +Size(20))];
    _mainScrollView.contentSize = CGSizeMake(kScreenWidth * titleArr.count, 0);
    _mainScrollView.backgroundColor = CLEAR_COLOR;
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.bounces = NO;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.delegate = self;
    [self.view addSubview:_mainScrollView];
    
    self.SG = [SGSegmentedControl segmentedControlWithFrame:CGRectMake(0, self.mainScrollView.minY, kScreenWidth, Size(30)) delegate:self segmentedControlType:(SGSegmentedControlTypeStatic) titleArr:titleArr btn_Margin:15];
    _SG.segmentedControlIndicatorType = SGSegmentedControlIndicatorTypeBottom;
    _SG.titleColorStateSelected = TEXT_GREEN_COLOR;
    _SG.indicatorColor = TEXT_GREEN_COLOR;
    _SG.titleColorStateNormal = COLOR(222, 223, 234, 1);
    [self.view addSubview:_SG];
    //横线
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(Size(20), _SG.maxY -Size(2), kScreenWidth -Size(20)*2, Size(0.5))];
    line.backgroundColor = COLOR(222, 223, 234, 1);
    [self.view addSubview:line];
    
    ImportWalletViewController *controller1 = [[ImportWalletViewController alloc] init];
    controller1.importWalletType = ImportWalletType_mnemonicPhrase;
    [self addChildViewController:controller1];
    
}

-(void)btnClick:(UIButton *)sender
{
    if (sender.tag == 100) {
        if (self.navigationController.viewControllers.count > 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }else if (sender.tag == 101) {
        CommonHtmlShowViewController *viewController = [[CommonHtmlShowViewController alloc]init];
        viewController.titleStr = sender.titleLabel.text;
        viewController.commonHtmlShowViewType = CommonHtmlShowViewType_remindTip;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)SGSegmentedControl:(SGSegmentedControl *)segmentedControl didSelectBtnAtIndex:(NSInteger)index {
    // 1 计算滚动的位置
    CGFloat offsetX = index * self.view.frame.size.width;
    self.mainScrollView.contentOffset = CGPointMake(offsetX, 0);
    // 2.给对应位置添加对应子控制器
    [self showVc:index];
    if (index == 0) {
        [tipBT greenBorderBtnStyle:Localized(@"什么是助记词？",nil) andBkgImg:@"continue"];
    }else if (index == 1) {
        [tipBT greenBorderBtnStyle:Localized(@"什么是Keystore？",nil) andBkgImg:@"continue"];
    }else if (index == 2) {
        [tipBT greenBorderBtnStyle:Localized(@"什么是私钥？",nil) andBkgImg:@"continue"];
    }
}

// 添加所有子控制器
- (void)setupChildViewController {
    // 助记词
    ImportWalletViewController *controller1 = [[ImportWalletViewController alloc] init];
    controller1.importWalletType = ImportWalletType_mnemonicPhrase;
    [self addChildViewController:controller1];
    // 官方钱包
    ImportWalletViewController *controller2 = [[ImportWalletViewController alloc] init];
    controller2.importWalletType = ImportWalletType_keyStore;
    [self addChildViewController:controller2];
    // 私钥
    ImportWalletViewController *controller3 = [[ImportWalletViewController alloc] init];
    controller3.importWalletType = ImportWalletType_privateKey;
    [self addChildViewController:controller3];
}

// 显示控制器的view
- (void)showVc:(NSInteger)index
{
    CGFloat offsetX = index * self.view.frame.size.width;
    UIViewController *vc = self.childViewControllers[index];
    // 判断控制器的view有没有加载过,如果已经加载过,就不需要加载
    if (vc.isViewLoaded) return;
    [self.mainScrollView addSubview:vc.view];
    vc.view.frame = CGRectMake(offsetX, 0, kScreenWidth, kScreenHeight -Size(30) -KNaviHeight);
    
    if (index == 0) {
        [tipBT greenBorderBtnStyle:Localized(@"什么是助记词？",nil) andBkgImg:@"continue"];
    }else if (index == 1) {
        [tipBT greenBorderBtnStyle:Localized(@"什么是Keystore？",nil) andBkgImg:@"continue"];
    }else if (index == 2) {
        [tipBT greenBorderBtnStyle:Localized(@"什么是私钥？",nil) andBkgImg:@"continue"];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 计算滚动到哪一页
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    // 1.添加子控制器view
    [self showVc:index];
    // 2.把对应的标题选中
    [self.SG titleBtnSelectedWithScrollView:scrollView];
    
    if (index == 0) {
        [tipBT greenBorderBtnStyle:Localized(@"什么是助记词？",nil) andBkgImg:@"continue"];
    }else if (index == 1) {
        [tipBT greenBorderBtnStyle:Localized(@"什么是Keystore？",nil) andBkgImg:@"continue"];
    }else if (index == 2) {
        [tipBT greenBorderBtnStyle:Localized(@"什么是私钥？",nil) andBkgImg:@"continue"];
    }
}


@end
