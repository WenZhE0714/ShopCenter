//
//  FiltView.h
//  ShopCenter
//
//  Created by mac on 2017/9/29.
//  Copyright © 2017年 wenzhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PriceRangeTableViewCell.h"

@interface FiltView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIButton *comfirmButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) PriceRangeTableViewCell *priceCell;
@property (nonatomic,strong) NSMutableArray *mutableArray;
@property (nonatomic,strong) NSDictionary *dictionary;
@property (nonatomic,copy) NSString *choosedRange;
@end
