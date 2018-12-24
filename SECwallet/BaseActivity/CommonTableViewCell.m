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

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *desLb;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UILabel *contentLb;
@property (nonatomic, strong) UILabel *detailLb;
@property (nonatomic, strong) UILabel *subDetailLb;
@property (nonatomic, strong) UIImageView *accessoryIV;

@end

@implementation CommonTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = COLOR(242, 244, 245, 1);
        self.contentView.layer.cornerRadius = Size(5);
        [self initView];
    }
    return self;
}

-(void) initView
{
    //图标
    _icon = [[UIImageView alloc] initWithFrame:CGRectMake(Size(15), (kTableCellHeight -Size(25))/2, Size(25), Size(25))];
    [self addSubview:_icon];
    
    //描述
    _desLb = [[UILabel alloc] initWithFrame:CGRectMake(_icon.maxX +Size(15), _icon.minY -Size(3), Size(100), Size(8))];
    _desLb.textColor = COLOR(159, 160, 162, 1);
    _desLb.font = SystemFontOfSize(6);
    [self addSubview:_desLb];
    
    //标题
    _titleLb = [[UILabel alloc] initWithFrame:CGRectMake(_desLb.minX, _desLb.maxY, Size(200), _desLb.height)];
    _titleLb.textColor = COLOR(50, 66, 74, 1);
    _titleLb.font = SystemFontOfSize(8);
    [self addSubview:_titleLb];
    
    //内容
    _contentLb = [[UILabel alloc] initWithFrame:CGRectMake(_titleLb.minX, _titleLb.maxY, _titleLb.width, _titleLb.height)];
    _contentLb.textColor = COLOR(45, 211, 131, 1);
    _contentLb.font = SystemFontOfSize(6);
    [self addSubview:_contentLb];
    
    //详情
    _detailLb = [[UILabel alloc] initWithFrame:CGRectMake(_contentLb.minX, _contentLb.maxY, _contentLb.width, _contentLb.height)];
    _detailLb.textColor = COLOR(125, 145, 157, 1);
    _detailLb.font = SystemFontOfSize(6);
    [self addSubview:_detailLb];
    
    //描述
    _subDetailLb = [[UILabel alloc] initWithFrame:CGRectMake(self.width -Size(60), 0, Size(30), kTableCellHeight)];
    _subDetailLb.textColor = COLOR(45, 211, 131, 1);
    _subDetailLb.font = SystemFontOfSize(7);
    _subDetailLb.textAlignment = NSTextAlignmentRight;
    [self addSubview:_subDetailLb];
    
    //图标
    _accessoryIV = [[UIImageView alloc] initWithFrame:CGRectMake(_subDetailLb.maxX +Size(15), (kTableCellHeight -Size(7))/2, Size(4), Size(7))];
    _accessoryIV.image = [UIImage imageNamed:@"accessory_right"];
    [self addSubview:_accessoryIV];
  
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if ([self.object isMemberOfClass:[TradeModel class]]) {
//        TradeModel *obj = self.object;
//        _desLb.text = @"Wallet Name";
//        //类型（1转入 2转出）
//        if (obj.type == 1) {
//            _icon.image = [UIImage imageNamed:@"gatherIcon"];  //转入
//            _titleLb.text =
//
//
//
//            [_address setTitle:obj.transferAddress forState:UIControlStateNormal];
//            _time.text = obj.time;
//            _sum.text = [NSString stringWithFormat:@"+%@ SEC",obj.sum];
//            //设置不同字体颜色
//            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:_sum.text];
//            [attStr addAttribute:NSForegroundColorAttributeName value:COLOR(33, 163, 72, 1) range:NSMakeRange(0, _sum.text.length -3)];
//            _sum.attributedText = attStr;
//
//        }else{
//            _icon.image = [UIImage imageNamed:@"transferIcon"];  //转出
//            [_address setTitle:obj.gatherAddress forState:UIControlStateNormal];
//            _time.text = obj.time;
//            _sum.text = [NSString stringWithFormat:@"-%@ SEC",obj.sum];
//            //设置不同字体颜色
//            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:_sum.text];
//            [attStr addAttribute:NSForegroundColorAttributeName value:COLOR(222, 57, 57, 1) range:NSMakeRange(0, _sum.text.length -3)];
//            _sum.attributedText = attStr;
//        }
//
//        //交易状态(1成功 0失败 2打包中)
//        if (obj.status == 0) {
//            _icon.image = [UIImage imageNamed:@"fail"];
//            //设置不同字体颜色
//            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:_sum.text];
//            [attStr addAttribute:NSForegroundColorAttributeName value:TEXT_DARK_COLOR range:NSMakeRange(0, _sum.text.length -3)];
//            _sum.attributedText = attStr;
//        }
//        if (obj.status == 2) {
//            _pendingLb.text = @"打包中";
//        }
        
    }else if ([self.object isMemberOfClass:[WalletModel class]]) {
        WalletModel *obj = self.object;
        
        _icon.image = [UIImage imageNamed:obj.walletIcon];
        _desLb.text = @"Wallet Name";
        _titleLb.text = obj.walletName;
        _contentLb.text = [NSString stringWithFormat:@"%@ SEC",obj.balance];
        _detailLb.text = obj.address;
        if (obj.isBackUpMnemonic == NO) {
            _subDetailLb.text = @"Backup";
        }
    }
}

-(void) fillCellWithObject:(id) object
{
    self.object = object;
}

@end
