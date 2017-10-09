//
//  ShopItemModel.h
//  ShopCenter
//
//  Created by mac on 2017/9/28.
//  Copyright © 2017年 wenzhe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopItemModel : NSObject
@property (nonatomic,assign) NSInteger idNo;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *originPrice;
@property (nonatomic,assign) NSInteger saleNum;
@property (nonatomic,copy) NSString *image;
@property (nonatomic,copy) NSString *company;
@property (nonatomic,copy) NSString *website;
@property (nonatomic,assign) NSInteger repertoryNum;
@property (nonatomic,assign) NSInteger limitNum;
@end
