//
//  ShopItemViewModel.m
//  ShopCenter
//
//  Created by mac on 2017/9/28.
//  Copyright © 2017年 wenzhe. All rights reserved.
//

#import "ShopItemViewModel.h"
#import "ShopItemModel.h"
#import <FMDB.h>
@interface ShopItemViewModel ()
@property (nonatomic,strong) FMDatabaseQueue * queue;
@end

@implementation ShopItemViewModel
//打开本地对应的数据库文件
-(void)openDB{
    //数据库
    NSString *filename = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"shopItem.db"];
    NSBundle *bundle = [NSBundle mainBundle];
    NSError *error;
    NSString *filenameAgo = [bundle pathForResource:@"shopItem" ofType:@"db"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager copyItemAtPath:filenameAgo toPath:filename error:&error];
    self.queue = [FMDatabaseQueue databaseQueueWithPath:filename];
}

- (NSMutableArray *)queryData{
    [self openDB];
    NSMutableArray * mutArray = [NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *resultSet = [db executeQuery:@"select * from shopItem"];
        while ([resultSet next]) {
            ShopItemModel * model = [[ShopItemModel alloc]init];
            model.idNo = [resultSet intForColumn:@"id"];
            model.name = [resultSet stringForColumn:@"name"];
            model.price = [resultSet stringForColumn:@"price"];
            model.originPrice = [resultSet stringForColumn:@"originPrice"];
            model.saleNum = [resultSet intForColumn:@"saleNum"];
            model.image = [resultSet stringForColumn:@"image"];
            model.company = [resultSet stringForColumn:@"company"];
            model.website = [resultSet stringForColumn:@"website"];
            model.repertoryNum = [resultSet intForColumn:@"repertoryNum"];
            model.limitNum = [resultSet intForColumn:@"limitNum"];
            [mutArray addObject:model];
        }
        [db close];
    }];
    return mutArray;
}
@end
