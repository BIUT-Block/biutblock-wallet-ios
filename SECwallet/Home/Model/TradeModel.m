//
//  TradeModel.m
//  CEC_wallet
//
//  Created by 通证控股 on 2018/8/11.
//  Copyright © 2018年 AnrenLionel. All rights reserved.
//

#import "TradeModel.h"

@implementation TradeModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary walletAddress:(NSString *)walletAddress
{
    if (self = [super init]) {
        //收款地址
        _gatherAddress = [NSString jsonUtils:dictionary[@"TxTo"]];
        if ([walletAddress isEqualToString:_gatherAddress]) {
            _type = 1;  //转入
        }else{
            _type = 2;  //转出
        }
        //转账地址
        _transferAddress = [NSString jsonUtils:dictionary[@"TxFrom"]];
        _sum = [NSString jsonUtils:dictionary[@"Value"]];
        
        NSString *statusStr = [NSString jsonUtils:dictionary[@"TxReceiptStatus"]];
        //1成功 0失败 2打包中
        if ([statusStr isEqualToString:@"success"]) {
            _status = 1;
        }else if ([statusStr isEqualToString:@"fail"]) {
            _status = 0;
        }else if ([statusStr isEqualToString:@"pending"]) {
            _status = 2;
        }
        NSInteger gasPrice = [[NSString jsonUtils:dictionary[@"GasPrice"]] integerValue];
        NSInteger gasUsed = [[NSString jsonUtils:dictionary[@"GasUsedByTxn"]] integerValue];
        NSInteger gas = gasPrice * gasUsed;  //CumulativeGasUsed
        _gas = [NSString stringWithFormat:@"%@ SEC",[NSString decimal:[NSString stringWithFormat:@"%ld",gas] wei:18 withDigit:0]];
        _tradeNum = [NSString jsonUtils:dictionary[@"TxHash"]];
        if (_status == 2) {
            _blockNum = @"Not in Block yet";
        }else{
           _blockNum = [NSString jsonUtils:dictionary[@"BlockNumber"]];
        }
        
        _tip = [NSString jsonUtils:dictionary[@"InputData"]];
        NSInteger timeNum = [[NSString jsonUtils:dictionary[@"TimeStamp"]] integerValue];
        _time = [NSString convertTimeStampsToString:@(timeNum)];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:@(self.type) forKey:@"type"];
    [aCoder encodeObject:self.icon forKey:@"icon"];
    [aCoder encodeObject:self.tokenAddress forKey:@"tokenAddress"];
    [aCoder encodeObject:self.transferAddress forKey:@"transferAddress"];
    [aCoder encodeObject:self.gatherAddress forKey:@"gatherAddress"];
    [aCoder encodeObject:self.time forKey:@"time"];
    [aCoder encodeObject:self.sum forKey:@"sum"];
    
    [aCoder encodeObject:@(self.status) forKey:@"status"];
    [aCoder encodeObject:self.gas forKey:@"gas"];
    [aCoder encodeObject:self.tip forKey:@"tip"];
    [aCoder encodeObject:self.tradeNum forKey:@"tradeNum"];
    [aCoder encodeObject:self.blockNum forKey:@"blockNum"];
    
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.type = [[aDecoder decodeObjectForKey:@"type"] intValue];
        self.icon = [aDecoder decodeObjectForKey:@"icon"];
        self.tokenAddress = [aDecoder decodeObjectForKey:@"tokenAddress"];
        self.transferAddress = [aDecoder decodeObjectForKey:@"transferAddress"];
        self.gatherAddress = [aDecoder decodeObjectForKey:@"gatherAddress"];
        self.time = [aDecoder decodeObjectForKey:@"time"];
        self.sum = [aDecoder decodeObjectForKey:@"sum"];
        
        self.status = [[aDecoder decodeObjectForKey:@"status"] intValue];
        self.gas = [aDecoder decodeObjectForKey:@"gas"];
        self.tip = [aDecoder decodeObjectForKey:@"tip"];
        self.tradeNum = [aDecoder decodeObjectForKey:@"tradeNum"];
        self.blockNum = [aDecoder decodeObjectForKey:@"blockNum"];
        
    }
    return self;
}

@end
