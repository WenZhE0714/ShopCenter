//
//  ShopDetailTableViewCell.h
//  ShopDemo
//
//  Created by mac on 2017/9/18.
//  Copyright © 2017年 wenzhe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *originPriceLabel;
@property (weak, nonatomic) IBOutlet UIView *evaluateView;
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *salesLabel;

@end
