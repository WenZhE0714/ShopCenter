//
//  ShopDetailTableViewCell.m
//  ShopDemo
//
//  Created by mac on 2017/9/18.
//  Copyright © 2017年 wenzhe. All rights reserved.
//

#import "ShopDetailTableViewCell.h"

@implementation ShopDetailTableViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ShopDetailTableViewCell" owner:nil options:nil] lastObject];
    }
    return self;
}

-(void)layoutSubviews{
    CGRect rect = self.frame;
    rect.size.width = self.frame.size.width;
    rect.size.height = 120;
    self.frame = rect;
    
    NSString *text = [NSString stringWithFormat:@"%@",self.originPriceLabel.text];
    NSMutableAttributedString *attributeMarket = [[NSMutableAttributedString alloc] initWithString:text];
    [attributeMarket setAttributes:@{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle], NSBaselineOffsetAttributeName : @(NSUnderlineStyleSingle)} range:NSMakeRange(0,text.length)];
    self.originPriceLabel.attributedText = attributeMarket;

    self.evaluateView.layer.borderWidth = 1.0;
    self.evaluateView.layer.borderColor = [[UIColor colorWithRed:228.0/255 green:228.0/255 blue:228.0/255 alpha:1.0]CGColor];
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
