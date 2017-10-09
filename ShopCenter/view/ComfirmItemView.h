//
//  ComfirmItemView.h
//  ShopCenter
//
//  Created by mac on 2017/9/28.
//  Copyright © 2017年 wenzhe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComfirmItemView : UIView<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *repertoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *limiteLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *minuteStepButton;
@property (weak, nonatomic) IBOutlet UITextField *stepTextField;
@property (weak, nonatomic) IBOutlet UIButton *plusStepButton;
@property (weak, nonatomic) IBOutlet UIButton *comfirmButton;
@end
