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
    _bkgIV = [[UIImageView alloc] initWithFrame:self.frame];
    _bkgIV.layer.cornerRadius = Size(10);
    [self addSubview:_bkgIV];
    
    //图标
    _bigIcon = [[UIImageView alloc] initWithFrame:CGRectMake(Size(15), 0, Size(22), Size(17))];
    [self addSubview:_bigIcon];
    
    _smallIcon = [[UIImageView alloc] initWithFrame:CGRectMake(Size(15), 0, Size(8), Size(10))];
    [self addSubview:_smallIcon];
    
    //标准
    _staticTitleLb = [[UILabel alloc] initWithFrame:CGRectMake(_bigIcon.maxX +Size(15), Size(3), Size(180), self.height)];
    _staticTitleLb.textColor = TEXT_BLACK_COLOR;
    _staticTitleLb.font = BoldSystemFontOfSize(12);
    [self addSubview:_staticTitleLb];

    //标题
    _titleLb = [[UILabel alloc] initWithFrame:CGRectMake(_staticTitleLb.minX, Size(8), _staticTitleLb.width, Size(15))];
    _titleLb.textColor = TEXT_BLACK_COLOR;
    _titleLb.font = BoldSystemFontOfSize(12);
    [self addSubview:_titleLb];
    
    //内容
    _contentLb = [[UILabel alloc] initWithFrame:CGRectMake(_titleLb.minX, _titleLb.maxY, _titleLb.width, Size(10))];
    _contentLb.textColor = TEXT_GREEN_COLOR;
    _contentLb.font = SystemFontOfSize(9);
    [self addSubview:_contentLb];
    
    //详情
    _detailLb = [[UILabel alloc] initWithFrame:CGRectMake(_contentLb.minX, _contentLb.maxY, _contentLb.width, _contentLb.height)];
    _detailLb.textColor = TEXT_DARK_COLOR;
    _detailLb.font = SystemFontOfSize(9);
    [self addSubview:_detailLb];
    
    //描述
    _subDetailLb = [[UILabel alloc] init];
    _subDetailLb.textColor = TEXT_GREEN_COLOR;
    _subDetailLb.font = BoldSystemFontOfSize(10);
    _subDetailLb.textAlignment = NSTextAlignmentRight;
    [self addSubview:_subDetailLb];
    
    //图标
    _accessoryIV = [[UIImageView alloc] init];
    [self addSubview:_accessoryIV];
  
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _bigIcon.frame = CGRectMake(Size(15), (self.height -Size(17))/2, Size(22), Size(17));
    _smallIcon.frame= CGRectMake(Size(15), (self.height -Size(10))/2, Size(8), Size(10));
    _accessoryIV.frame = CGRectMake(self.width -Size(20), (self.height -Size(7))/2, Size(4), Size(7));
    
    _subDetailLb.frame = CGRectMake(self.width -Size(70), 0, Size(40), self.height);
    
    if ([self.object isMemberOfClass:[TradeModel class]]) {
        
        TradeModel *obj = self.object;
        _subDetailLb.frame = CGRectMake(self.width/2-Size(12), Size(2), self.width/2, self.height);
        
        //类型（1转入 2转出）
        if (obj.type == 1) {
            _titleLb.text = [NSString addressToAsterisk:obj.transferAddress];
            _contentLb.text = obj.time;
            _subDetailLb.text = [NSString stringWithFormat:@"+%@ SEC",obj.sum];

        }else if (obj.type == 2) {
            _titleLb.text = [NSString addressToAsterisk:obj.transferAddress];
            _contentLb.text = obj.time;
            _subDetailLb.text = [NSString stringWithFormat:@"-%@ SEC",obj.sum];
        }else{
            _titleLb.text = [NSString addressToAsterisk:obj.transferAddress];
            _contentLb.text = obj.time;
            _subDetailLb.text = [NSString stringWithFormat:@"+%@ SEC",obj.sum];
        }

        if (obj.status == 2) {
            _subDetailLb.text = Localized(@"打包中",nil);
        }
        
    }else if ([self.object isMemberOfClass:[WalletModel class]]) {
        
        WalletModel *obj = self.object;
        _bigIcon.image = [UIImage imageNamed:obj.walletIcon];
        _titleLb.text = obj.walletName;
        _contentLb.text = [NSString stringWithFormat:@"%@ SEC",obj.balance];
        _detailLb.text = [NSString addressToAsterisk:obj.address];
        if (obj.isBackUpMnemonic == NO) {
            _subDetailLb.text = Localized(@"请备份",nil);
        }
        _accessoryIV.image = [UIImage imageNamed:@"rightArrow"];
    }
}

-(void) fillCellWithObject:(id) object
{
    self.object = object;
}

@end
