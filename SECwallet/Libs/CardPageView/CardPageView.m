//
//  CardPage.m
//  CardPage
//
//  Created by ymj_work on 16/5/22.
//  Copyright © 2016年 ymj_work. All rights reserved.
//

#import "CardPageView.h"
#import "CollectionFlowLayout.h"
#import "CollectionViewCell.h"
#import "WalletModel.h"

#import "CommonPageControl.h"

#define COUNT  10

@interface CardPageView()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
{
    float cellWidth;
    float cellHeight;
    float itemSpacing;
}

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) CommonPageControl *pageControl;
@property (nonatomic,strong) NSArray *walletArray;

@property (nonatomic,assign) CGRect collectionViewRect;
@property (nonatomic,assign) CGRect pageControlRect;

@end

@implementation CardPageView

- (id)initWithFrame:(CGRect)frame withWalletList:(NSArray *)walletList;

{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BACKGROUND_DARK_COLOR;
        [self initData];
        cellWidth = self.frame.size.width -Size(40);
        cellHeight = self.frame.size.height -Size(35);
        itemSpacing = Size(5);
        _walletArray = walletList;
        
        [self initSubviews];
    }
    return self;
}

-(void)initData
{
    _collectionViewRect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height -Size(35));
    _pageControlRect = CGRectMake(0, _collectionViewRect.origin.y +_collectionViewRect.size.height +Size(12), kScreenWidth, Size(15));
}

-(void)initSubviews{
    
    [self addSubview:self.collectionView];
    [self addSubview:self.pageControl];
}

-(UICollectionView*)collectionView{
    //自定义UICollectionViewFlowLayout
    UICollectionViewFlowLayout *layout = [[CollectionFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = Size(10);   //列间距
    layout.minimumInteritemSpacing = itemSpacing;  //item之间的间距
    layout.itemSize = CGSizeMake(cellWidth, cellHeight);
    //初始化collectionView
    _collectionView = [[UICollectionView alloc] initWithFrame:_collectionViewRect collectionViewLayout:layout];
    [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewCell"];
    _collectionView.backgroundColor = CLEAR_COLOR;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    return _collectionView;
}

-(CommonPageControl*)pageControl{
    _pageControl = [[CommonPageControl alloc]initWithFrame:_pageControlRect];
    _pageControl.numberOfPages = _walletArray.count > COUNT ? COUNT : _walletArray.count;  //固定
    [_pageControl setPageIndicatorTintColor:COLOR(215, 216, 217, 1)];
    [_pageControl setCurrentPageIndicatorTintColor:TEXT_GREEN_COLOR];
    return _pageControl;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _walletArray.count;
}

// 定义每个Section的四边间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    if (_walletArray.count == 1) {
        return UIEdgeInsetsMake(0, Size(25), 0, Size(25));
    }else{
        return UIEdgeInsetsMake(0, Size(20), 0, Size(20));
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    
    WalletModel *model = _walletArray[indexPath.row];
    cell.bkgIV.image = [UIImage imageNamed:@"walletBkg0"];
    cell.nameLb.text = model.walletName;
    cell.totalSumLb.text = [NSString stringWithFormat:@"%@",model.balance];
    [cell.addressBT setTitle:[NSString addressToAsterisk:model.address] forState:UIControlStateNormal];
    cell.addressBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [cell.addressBT addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.addressBT.tag = 1000;
    //备份按钮
    [cell.backupBT setTitle:Localized(@"请备份", nil) forState:UIControlStateNormal];
    if (model.isBackUpMnemonic == NO) {
        cell.backupBT.hidden = NO;
        cell.backupBT.tag = 1001;
        [cell.backupBT addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        cell.backupBT.hidden = YES;
    }
    [cell.codeBT addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.codeBT.tag = 1000;
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int index = (scrollView.contentOffset.x+self.bounds.size.width/2)/cellWidth;

    if (_walletArray.count > COUNT) {
        if (index < COUNT-1) {
            _pageControl.currentPage = index;  //0~8
        }else if (index >= COUNT-1 && index < _walletArray.count-1) {
            _pageControl.currentPage = COUNT-2; //8~(COUNT-1)都是8
        }else{
            _pageControl.currentPage = COUNT-1; //最后一个是9
        }
    }else{
        _pageControl.currentPage = index;
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //滑动结束时显示
    int index = (scrollView.contentOffset.x+self.bounds.size.width/2)/(cellWidth+itemSpacing);
    [self.delegate refreshWallet:index clearCache:YES];
    
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"walletList"];
    NSData* datapath = [NSData dataWithContentsOfFile:path];
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:datapath];
    NSMutableArray *walletList = [NSMutableArray array];
    walletList = [unarchiver decodeObjectForKey:@"walletList"];
    [unarchiver finishDecoding];
    _walletArray = walletList;
}

-(void)btnClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 1000:
        {
            [self.delegate showAddressCodeAction];
        }
            break;
        case 1001:
        {
            [self.delegate backUpMnemonicAction];
        }
            break;
        case 1002:
            //添加代币事件
        {
            [self.delegate addTokenCoinAction];
        }
            break;
        default:
            break;
    }
}

@end
