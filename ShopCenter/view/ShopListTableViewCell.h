//
//  ShopListTableViewCell.h
//  ShopDemo
//
//  Created by mac on 2017/9/15.
//  Copyright © 2017年 wenzhe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleLabel;

@end
