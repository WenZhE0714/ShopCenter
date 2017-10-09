//
//  PriceRangeTableViewCell.m
//  ShopCenter
//
//  Created by mac on 2017/9/29.
//  Copyright © 2017年 wenzhe. All rights reserved.
//

#import "PriceRangeTableViewCell.h"
#import "ShopItemModel.h"
@implementation PriceRangeTableViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"PriceRangeTableViewCell" owner:nil options:nil] lastObject];
        self.frame = CGRectMake(0,0,300, 160);
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)layoutSubviews{
    

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
