//
//  BackupFileViewController.m
//  CEC_wallet
//
//  Created by 通证控股 on 2018/8/9.
//  Copyright © 2018年 AnrenLionel. All rights reserved.
//

#import "BackupFileViewController.h"
#import "DWTagList.h"
#import "RootViewController.h"

@interface BackupFileViewController ()<DWTagListDelegate>

@property (nonatomic, strong) DWTagList *tagList;  // 云标签
@property (nonatomic, copy) NSMutableArray *selectTagList;
@property (nonatomic, strong) DWTagList *showTagList;

@end

@implementation BackupFileViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self setupUI];
    _selectTagList = [NSMutableArray array];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /**************导航栏布局***************/
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

-(void)setupUI
{
    //返回按钮
    UIButton *backBT = [[UIButton alloc]initWithFrame:CGRectMake(Size(20), KStatusBarHeight+Size(13), Size(25), Size(15))];
    [backBT addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backBT setImage:[UIImage imageNamed:@"backIcon"] forState:UIControlStateNormal];
    [self.view addSubview:backBT];
    
    //标题
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(Size(20), backBT.maxY +Size(15), Size(200), Size(30))];
    titleLb.textColor = TEXT_BLACK_COLOR;
    titleLb.font = BoldSystemFontOfSize(20);
    titleLb.text = Localized(@"备份助记词",nil);
    [self.view addSubview:titleLb];
    
    UILabel *titLb = [[UILabel alloc]initWithFrame:CGRectMake(titleLb.minX, titleLb.maxY +Size(10), kScreenWidth, Size(20))];
    titLb.font = SystemFontOfSize(10);
    titLb.textColor = TEXT_DARK_COLOR;
    titLb.text = Localized(@"确认你的钱包助记词", nil);
//    [self.view addSubview:titLb];
    
    UILabel *remindLb = [[UILabel alloc]initWithFrame:CGRectMake(titleLb.minX, backBT.maxY +Size(10), kScreenWidth -Size(20)*2, Size(30))];
    remindLb.font = SystemFontOfSize(10);
    remindLb.textColor = TEXT_DARK_COLOR;
    remindLb.numberOfLines = 2;
    remindLb.text = Localized(@"请按照顺序点击助记词，以确认你备份的助记词正确。", nil);
    NSMutableAttributedString *msgStr = [[NSMutableAttributedString alloc] initWithString:remindLb.text];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = Size(3);
    [msgStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, msgStr.length)];
    remindLb.attributedText = msgStr;
//    [self.view addSubview:remindLb];
    
    UIView *bkgView = [[UIView alloc]initWithFrame:CGRectMake(remindLb.minX, titleLb.maxY +Size(5), remindLb.width, Size(200))];
    bkgView.backgroundColor = DARK_COLOR;
    bkgView.layer.cornerRadius = Size(5);
    [self.view addSubview:bkgView];
    _showTagList = [[DWTagList alloc]initWithFrame:CGRectMake(Size(30), bkgView.minY +Size(8), kScreenWidth - Size(30)*2, bkgView.height -Size(5*2))];
    if (IS_iPhoneX) {
        bkgView.frame = CGRectMake(remindLb.minX, remindLb.maxY +Size(15), remindLb.width, Size(140));
        _showTagList.frame = CGRectMake(Size(30), bkgView.minY +Size(20), kScreenWidth - Size(30)*2, bkgView.height -Size(5*2));
    }
    [_showTagList setTagBackgroundColor:COLOR(186, 187, 188, 1)];
    _showTagList.cornerRadius = Size(12);
    _showTagList.borderWidth = 0;
    _showTagList.textColor = WHITE_COLOR;
    [_showTagList setTagDelegate:self];
    _showTagList.showTagMenu = YES;
    [self.view addSubview:_showTagList];
    
    _tagList = [[DWTagList alloc] initWithFrame:CGRectMake(titleLb.minX, bkgView.maxY +Size(10), kScreenWidth - titleLb.minX*2, Size(190))];
    [_tagList setTagBackgroundColor:WHITE_COLOR];
    _tagList.cornerRadius = Size(5);
    _tagList.borderWidth = Size(0.5);
    _tagList.textColor = TEXT_GREEN_COLOR;
    _tagList.borderColor = TEXT_GREEN_COLOR;
    NSArray *tagArr = [_walletModel.mnemonicPhrase componentsSeparatedByString:@" "];
    //打乱数组顺序
    tagArr = [tagArr sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
        int seed = arc4random_uniform(2);
        if (seed) {
            return [str1 compare:str2];
        } else {
            return [str2 compare:str1];
        }
    }];
    [_tagList setTags:tagArr andSelectTags:@[]];
    [_tagList setTagDelegate:self];
    _showTagList.showTagMenu = NO;
    [self.view addSubview:_tagList];
    
    /*****************确认*****************/
    UIButton *nextBT = [[UIButton alloc] initWithFrame:CGRectMake(titleLb.minX, _tagList.maxY +Size(15), kScreenWidth -titleLb.minX*2, Size(45))];
    [nextBT goldBigBtnStyle:Localized(@"确认", nil)];
    [nextBT addTarget:self action:@selector(comfirmAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBT];
}

#pragma mark DWTagListDelegate
- (void)selectedDWTagList:(DWTagList *)tagList tag:(NSString *)tagName tagIndex:(NSInteger)tagIndex;
{
    if (tagList == _tagList) {
        if (![_selectTagList containsObject:tagName]) {
            [_selectTagList addObject:tagName];
            [_showTagList setTags:_selectTagList andSelectTags:_selectTagList];
            
            NSArray *tagArr = [_walletModel.mnemonicPhrase componentsSeparatedByString:@" "];
            //打乱数组顺序
            tagArr = [tagArr sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
                int seed = arc4random_uniform(2);
                if (seed) {
                    return [str1 compare:str2];
                } else {
                    return [str2 compare:str1];
                }
            }];
            [_tagList setTags:tagArr andSelectTags:_selectTagList];
        }
    }else if (tagList == _showTagList) {
        //删除
        [_selectTagList removeObject:tagName];
        [_showTagList setTags:_selectTagList andSelectTags:_selectTagList];
        NSArray *tagArr = [_walletModel.mnemonicPhrase componentsSeparatedByString:@" "];
        //打乱数组顺序
        tagArr = [tagArr sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
            int seed = arc4random_uniform(2);
            if (seed) {
                return [str1 compare:str2];
            } else {
                return [str2 compare:str1];
            }
        }];
        [_tagList setTags:tagArr andSelectTags:_selectTagList];
    }
}

-(void)comfirmAction
{
    NSArray *tagArr = [_walletModel.mnemonicPhrase componentsSeparatedByString:@" "];
    if (tagArr.count > _selectTagList.count) {
        CommonAlertView *alert = [[CommonAlertView alloc]initWithTitle:Localized(@"备份失败", nil) contentText:Localized(@"请检查您的助记词", nil) imageName:@"exclamation_mark" leftButtonTitle:@"OK" rightButtonTitle:nil alertViewType:CommonAlertViewType_exclamation_mark];
        [alert show];
        return;
    }
    NSString *tagStr = [_selectTagList componentsJoinedByString:@" "];
    if ([tagStr isEqualToString:_walletModel.mnemonicPhrase]) {
        CommonAlertView *alert = [[CommonAlertView alloc]initWithTitle:Localized(@"是否删除本地助记词", nil) contentText:Localized(@"助记词备份成功,\n是否从SEC钱包中删除助记词？", nil) imageName:@"question_mark" leftButtonTitle:Localized(@"取消", nil) rightButtonTitle:Localized(@"确认", nil) alertViewType:CommonAlertViewType_question_mark];
        [alert show];
        alert.rightBlock = ^() {
            /***********更新当前钱包信息***********/
            NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"walletList"];
            NSData* datapath = [NSData dataWithContentsOfFile:path];
            NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:datapath];
            NSMutableArray *list = [NSMutableArray array];
            list = [unarchiver decodeObjectForKey:@"walletList"];
            [unarchiver finishDecoding];
            for (int i = 0; i< list.count; i++) {
                WalletModel *model = list[i];
                if ([model.privateKey isEqualToString:_walletModel.privateKey]) {
                    [model setIsBackUpMnemonic:1];
                    if (model.isFromMnemonicImport == YES) {
                        [model setIsFromMnemonicImport:0];
                    }
                    [list replaceObjectAtIndex:i withObject:model];
                }
            }
            //替换list中当前钱包信息
            NSMutableData* data = [NSMutableData data];
            NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
            [archiver encodeObject:list forKey:@"walletList"];
            [archiver finishEncoding];
            [data writeToFile:path atomically:YES];
            //进入首页
            RootViewController *controller = [[RootViewController alloc] init];
            AppDelegateInstance.window.rootViewController = controller;
            [AppDelegateInstance.window makeKeyAndVisible];
            
            /*************创建钱包成功后删除之前代币数据缓存*************/
            [CacheUtil clearTokenCoinTradeListCacheFile];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdateWalletInfoUI object:nil];
        };
    }else{
        CommonAlertView *alert = [[CommonAlertView alloc]initWithTitle:Localized(@"备份失败", nil) contentText:Localized(@"请检查您的助记词", nil) imageName:@"exclamation_mark" leftButtonTitle:@"OK" rightButtonTitle:nil alertViewType:CommonAlertViewType_exclamation_mark];
        [alert show];
    }
}


@end
