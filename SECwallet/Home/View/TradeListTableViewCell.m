//
//  TradeListTableViewCell.m
//  CEC_wallet
//
//  Created by 通证控股 on 2018/8/11.
//  Copyright © 2018年 AnrenLionel. All rights reserved.
//

#import "TradeListTableViewCell.h"
#import "TradeModel.h"

@interface TradeListTableViewCell()

@property (nonatomic , strong) id object;

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UIButton *address;
@property (nonatomic, strong) UILabel *time;
@property (nonatomic, strong) UILabel *sum;
@property (nonatomic, strong) UILabel *pendingLb;

@end

@implementation TradeListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initView];
    }
    return self;
}

-(void) initView
{
    //图标
    _icon = [[UIImageView alloc] initWithFrame:CGRectMake(Size(20), (kTableCellHeight -Size(20))/2, Size(20), Size(20))];
    [self addSubview:_icon];
    
    //地址
    _address = [[UIButton alloc] initWithFrame:CGRectMake(_icon.maxX +Size(10), _icon.minY, Size(100), Size(10))];
    _address.titleLabel.font = BoldSystemFontOfSize(10);
    [_address setTitleColor:TEXT_BLACK_COLOR forState:UIControlStateNormal];
    _address.userInteractionEnabled = NO;
    [self addSubview:_address];
    
    //时间
    _time = [[UILabel alloc] initWithFrame:CGRectMake(_address.minX, _address.maxY, Size(200), _address.height)];
    _time.textColor = TEXT_DARK_COLOR;
    _time.font = SystemFontOfSize(9);
    [self addSubview:_time];
    
    //额度
    _sum = [[UILabel alloc] initWithFrame:CGRectMake(_address.maxX, 0, kScreenWidth -_address.maxX -Size(20), kTableCellHeight)];
    _sum.textAlignment = NSTextAlignmentRight;
    _sum.font = SystemFontOfSize(10);
    [self addSubview:_sum];
    
    _pendingLb = [[UILabel alloc] initWithFrame:CGRectMake(_sum.minX, _sum.maxY, _sum.width, _sum.height)];
    _pendingLb.textColor = COLOR(253, 152, 0, 1);
    _pendingLb.textAlignment = NSTextAlignmentRight;
    _pendingLb.font = SystemFontOfSize(9);
    [self addSubview:_pendingLb];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if ([self.object isMemberOfClass:[TradeModel class]]) {
        TradeModel *obj = self.object;
        
        //类型（1转入 2转出 3挖矿）
        if (obj.type == 1) {
            _icon.image = [UIImage imageNamed:@"recived"];  //转入
            [_address setTitle:obj.transferAddress forState:UIControlStateNormal];
            _time.text = obj.time;
            _sum.textColor = TEXT_GREEN_COLOR;
             _sum.text = [NSString stringWithFormat:@"+%@ SEC",obj.sum];
  
        }else if (obj.type == 2) {
            _icon.image = [UIImage imageNamed:@"sent"];  //转出
            [_address setTitle:obj.gatherAddress forState:UIControlStateNormal];
            _time.text = obj.time;
            _sum.textColor = TEXT_RED_COLOR;
            _sum.text = [NSString stringWithFormat:@"-%@ SEC",obj.sum];
        }else{
            _icon.image = [UIImage imageNamed:@"minied"];  //转出
            [_address setTitle:obj.transferAddress forState:UIControlStateNormal];
            _time.text = obj.time;
            _sum.frame = CGRectMake(_address.maxX, _address.minY, kScreenWidth -_address.maxX -Size(20), _address.height);
            _pendingLb.frame = CGRectMake(_sum.minX, _sum.maxY, _sum.width, _sum.height);
            _pendingLb.text = [NSString stringWithFormat:@"(%@)",Localized(@"挖矿", nil)];
            _sum.textColor = TEXT_RED_COLOR;
            _sum.text = [NSString stringWithFormat:@"+%@ SEC",obj.sum];
        }
        
        //交易状态(1成功 0失败 2打包中)
        if (obj.status == 0) {
            _icon.image = [UIImage imageNamed:@"transferFailed"];
        }
        if (obj.status == 2) {
            _icon.image = [UIImage imageNamed:@"pending"];
            _sum.frame = CGRectMake(_address.maxX, _address.minY, kScreenWidth -_address.maxX -Size(20), _address.height);
            _pendingLb.frame = CGRectMake(_sum.minX, _sum.maxY, _sum.width, _sum.height);
            _pendingLb.text = Localized(@"(打包中)", nil);
        }
    }
}

-(void) fillCellWithObject:(id) object
{
    self.object = object;
}

@end
