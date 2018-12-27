//
//  CommonTableViewCell.m
//  SECwallet
//
//  Created by 通证控股 on 2018/12/21.
//  Copyright © 2018 通证控股. All rights reserved.
//

#import "CommonTableViewCell.h"
#import "TradeModel.h"
#import "WalletModel.h"

@interface CommonTableViewCell()

@property (nonatomic , strong) id object;

@property (nonatomic, strong) UILabel *desLb;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UILabel *contentLb;
@property (nonatomic, strong) UILabel *detailLb;
@property (nonatomic, strong) UILabel *subDetailLb;

@end

@implementation CommonTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = DARK_COLOR;
        self.contentView.layer.cornerRadius = Size(10);
        [self initView];
    }
    return self;
}

-(void) initView
{
    //图标
    _icon = [[UIImageView alloc] initWithFrame:CGRectMake(Size(15), (self.height -Size(25))/2, Size(25), Size(25))];
    [self addSubview:_icon];
    
    //标准
    _staticTitleLb = [[UILabel alloc] initWithFrame:CGRectMake(_icon.maxX +Size(15), 0, Size(100), self.height)];
    _staticTitleLb.textColor = TEXT_BLACK_COLOR;
    _staticTitleLb.font = SystemFontOfSize(10);
    [self addSubview:_staticTitleLb];
    
    //描述
    _desLb = [[UILabel alloc] initWithFrame:CGRectMake(_icon.maxX +Size(15), _icon.minY -Size(3), Size(100), Size(8))];
    _desLb.textColor = TEXT_LightDark_COLOR;
    _desLb.font = SystemFontOfSize(6);
    [self addSubview:_desLb];
    
    //标题
    _titleLb = [[UILabel alloc] initWithFrame:CGRectMake(_desLb.minX, _desLb.maxY, Size(100), _desLb.height)];
    _titleLb.textColor = TEXT_BLACK_COLOR;
    _titleLb.font = BoldSystemFontOfSize(8);
    [self addSubview:_titleLb];
    
    //内容
    _contentLb = [[UILabel alloc] initWithFrame:CGRectMake(_titleLb.minX, _titleLb.maxY, _titleLb.width, _titleLb.height)];
    _contentLb.textColor = TEXT_GREEN_COLOR;
    _contentLb.font = SystemFontOfSize(6);
    [self addSubview:_contentLb];
    
    //详情
    _detailLb = [[UILabel alloc] initWithFrame:CGRectMake(_contentLb.minX, _contentLb.maxY, _contentLb.width, _contentLb.height)];
    _detailLb.textColor = TEXT_DARK_COLOR;
    _detailLb.font = SystemFontOfSize(6);
    [self addSubview:_detailLb];
    
    //描述
    _subDetailLb = [[UILabel alloc] initWithFrame:CGRectMake(self.width -Size(60), 0, Size(30), self.height)];
    _subDetailLb.textColor = TEXT_GREEN_COLOR;
    _subDetailLb.font = BoldSystemFontOfSize(7);
    _subDetailLb.textAlignment = NSTextAlignmentRight;
    [self addSubview:_subDetailLb];
    
    //图标
    _accessoryIV = [[UIImageView alloc] initWithFrame:CGRectMake(_subDetailLb.maxX +Size(15), (self.height -Size(7))/2, Size(4), Size(7))];
    [self addSubview:_accessoryIV];
  
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if ([self.object isMemberOfClass:[TradeModel class]]) {
        
        TradeModel *obj = self.object;
        _titleLb.font = SystemFontOfSize(9);
        _contentLb.font = SystemFontOfSize(7);
        _subDetailLb.frame = CGRectMake(self.width/2-Size(12), 0, self.width/2, self.height);
        _subDetailLb.font = SystemFontOfSize(9);
        //类型（1转入 2转出）
        if (obj.type == 1) {
            _icon.image = [UIImage imageNamed:@"gatherIcon"];  //转入
            _titleLb.text = [NSString addressToAsterisk:obj.transferAddress];
            _contentLb.text = obj.time;
            _subDetailLb.text = [NSString stringWithFormat:@"+%@ SEC",obj.sum];

        }else{
            _icon.image = [UIImage imageNamed:@"transferIcon"];  //转出
            _titleLb.text = [NSString addressToAsterisk:obj.transferAddress];
            _contentLb.text = obj.time;
            _subDetailLb.text = [NSString stringWithFormat:@"-%@ SEC",obj.sum];
        }

        //交易状态(1成功 0失败 2打包中)
        if (obj.status == 0) {
            _icon.image = [UIImage imageNamed:@"fail"];
        }
        if (obj.status == 2) {
            _subDetailLb.text = Localized(@"打包中",nil);
        }
        
    }else if ([self.object isMemberOfClass:[WalletModel class]]) {
        
        WalletModel *obj = self.object;
        _icon.image = [UIImage imageNamed:obj.walletIcon];
        _desLb.text = Localized(@"钱包名称",nil);
        _titleLb.text = obj.walletName;
        _contentLb.text = [NSString stringWithFormat:@"%@ SEC",obj.balance];
        _detailLb.text = obj.address;
        if (obj.isBackUpMnemonic == NO) {
            _subDetailLb.text = Localized(@"请备份",nil);
        }
        
        _accessoryIV.image = [UIImage imageNamed:@"accessory_right"];
    }
}

-(void) fillCellWithObject:(id) object
{
    self.object = object;
}

@end
