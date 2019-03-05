//
//  CacheUtil.m
//  TOP_zrt
//
//  Created by Laughing on 16/6/1.
//  Copyright © 2016年 topzrt. All rights reserved.
//

#import "CacheUtil.h"

@implementation CacheUtil

+(void) clearTokenCoinTradeListCacheFile
{
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"walletRecodeList"];
    NSMutableData* data = [NSMutableData data];
    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:nil forKey:@"walletRecodeList"];
    [archiver finishEncoding];
    [data writeToFile:path atomically:YES];
    
    NSArray *tokenList = @[@"SEC",@"CEC",@"ETH",@"INT"];
    for (int i = 0; i< tokenList.count; i++) {
        NSString *fileName = [NSString stringWithFormat:@"recodeList_%@",tokenList[i]];
        NSString* path1 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:fileName];
        NSMutableData* data1 = [NSMutableData data];
        NSKeyedArchiver* archiver1 = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data1];
        [archiver1 encodeObject:nil forKey:fileName];
        [archiver1 finishEncoding];
        [data1 writeToFile:path1 atomically:YES];
    }
}

@end
