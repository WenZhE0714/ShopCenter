//
//  ShopListViewController.m
//  ShopDemo
//
//  Created by mac on 2017/9/15.
//  Copyright © 2017年 wenzhe. All rights reserved.
//

#import "ShopListViewController.h"
#import "ShopListTableViewCell.h"
#import "ShopItemViewController.h"
#import "ShopItemViewModel.h"
#import "ShopItemModel.h"
#import "FiltView.h"
#import <ReactiveCocoa.h>
#define IPHONE_H ([UIScreen mainScreen].bounds.size.height)
#define IPHONE_W ([UIScreen mainScreen].bounds.size.width)
@interface ShopListViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *generalSortButton;
@property (weak, nonatomic) IBOutlet UIButton *saleSortButton;
@property (weak, nonatomic) IBOutlet UIButton *newestSortButton;
@property (weak, nonatomic) IBOutlet UIButton *priceSortButton;
@property (weak, nonatomic) IBOutlet UIButton *upValueSortButton;
@property (weak, nonatomic) IBOutlet UIButton *downValueSortButton;
@property (weak, nonatomic) IBOutlet UIButton *filtButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIView *footView;
@property (strong, nonatomic)ShopItemViewModel *shopItemViewModel;
@property (strong, nonatomic)FiltView *filtView;
@property (strong, nonatomic) UIView *shadeView;
@end
@implementation ShopListViewController{
    CGFloat preOffSet;
    CGFloat currentOffSet;
    ShopItemViewController * shopItemVC;
    NSMutableArray *mutableArray;
    NSMutableArray *desMutableArray;
}

-(ShopItemViewModel *)shopItemViewModel{
    if (_shopItemViewModel == nil) {
        _shopItemViewModel = [[ShopItemViewModel alloc]init];
    }
    return _shopItemViewModel;
}

-(FiltView *)filtView{
    if (_filtView == nil) {
        _filtView = [[FiltView alloc]initWithFrame:CGRectMake(IPHONE_W, 0, 300, IPHONE_H)];
    }
    return _filtView;
}

-(UIView *)shadeView{
    if (_shadeView == nil) {
        _shadeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_W, IPHONE_H)];
        _shadeView.backgroundColor = [UIColor blackColor];
        _shadeView.alpha = 0.0;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dissmissShadeView)];
        [self.shadeView addGestureRecognizer:tapGesture];
    }
    return _shadeView;
}

-(UIView *)footView{
    if (_footView == nil) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
        _footView.backgroundColor = [UIColor colorWithRed:228.0/255 green:228.0/255 blue:228.0/255 alpha:1.0];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(100, 20, 175, 10)];
        label.text = @"抱歉，没有更多商品啦~";
        [label setFont:[UIFont boldSystemFontOfSize:15.0]];
        [label setTextColor:[UIColor lightGrayColor]];
        [_footView addSubview:label];
    }
    return _footView;
}

- (void)dissmissShadeView{
    [UIView animateWithDuration:0.2 animations:^{
        self.shadeView.alpha = 0;
        CGRect rect = self.filtView.frame;
        rect.origin = CGPointMake(IPHONE_W, 0);
        self.filtView.frame = rect;
    }];
}

- (void)clickedFilt:(UIButton *)button{
    [self figurePriceRange];
    self.filtView.mutableArray = mutableArray;
    [self buttonChoosedChangeColor:button];
    [self.view addSubview:self.shadeView];
    [self.view addSubview:self.filtView];
    [UIView animateWithDuration:0.5 animations:^{
        self.shadeView.alpha = 0.6;
        CGRect rect = self.filtView.frame;
        rect.origin = CGPointMake(75, 0);
        self.filtView.frame = rect;
    }];
}

- (void)figurePriceRange{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"NO",@"0-50",@"NO",@"51-100",@"NO",@"101-200",@"NO",@"201-500",@"NO",@"501-1000",@"NO",@"1001-10000",nil];

    for (ShopItemModel *model in mutableArray) {
        if (model.price.integerValue >0 && model.price.integerValue<50) {
            [dictionary setValue:@"YES" forKey:@"0-50"];
        }else if(model.price.integerValue >51 && model.price.integerValue<100){
            [dictionary setValue:@"YES" forKey:@"51-100"];
        }else if(model.price.integerValue >101 && model.price.integerValue<200){
            [dictionary setValue:@"YES" forKey:@"101-200"];
        }else if(model.price.integerValue >201 && model.price.integerValue<500){
            [dictionary setValue:@"YES" forKey:@"201-500"];
        }else if(model.price.integerValue >501 && model.price.integerValue<1000){
            [dictionary setValue:@"YES" forKey:@"501-1000"];
        }else if(model.price.integerValue >1001 && model.price.integerValue<10000){
            [dictionary setValue:@"YES" forKey:@"1001-10000"];
        }
        if ([[dictionary valueForKey:@"0-50"] isEqual: @"YES"] && [[dictionary valueForKey:@"51-100"] isEqual: @"YES"]&&[[dictionary valueForKey:@"101-200"] isEqual: @"YES"]&&[[dictionary valueForKey:@"201-500"] isEqual: @"YES"]&&[[dictionary valueForKey:@"501-1000"] isEqual: @"YES"]&&[[dictionary valueForKey:@"1001-10000"] isEqual: @"YES"]) {
            break;
        }
    }
    self.filtView.dictionary = dictionary;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tableFooterView = self.footView;
    
    [self clickedButton];

    preOffSet = self.tableView.contentOffset.y;
    
    mutableArray = [self.shopItemViewModel queryData];
    desMutableArray = mutableArray;
    [self figurePriceRange];
    
    self.searchTextField.delegate = self;
}

-(void)startArraySort:(NSString *)keyString isAscending:(BOOL)isAscending{
    NSSortDescriptor *sortByA = [NSSortDescriptor sortDescriptorWithKey:keyString ascending:isAscending];
    desMutableArray = [[NSMutableArray alloc]initWithArray:[desMutableArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByA]]];
}

-(void)searchKeywordThenUpdateArray{
    NSMutableArray *newArray = [[NSMutableArray alloc]init];
    if ([self.searchTextField.text isEqual: @""]) {
        desMutableArray = mutableArray;
    }else{
        for (ShopItemModel *model in mutableArray) {
            if ([model.name containsString:self.searchTextField.text]) {
                [newArray addObject:model];
            }
        }
        desMutableArray = newArray;
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableViewOperation
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return desMutableArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellidentify = @"cell";
    ShopItemModel *model = desMutableArray[indexPath.row];
    ShopListTableViewCell *cell = (ShopListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellidentify];
    if (cell == nil) {
        cell = [[ShopListTableViewCell alloc]init];
    }
    NSArray *imageNameArray = [model.image componentsSeparatedByString:@"|"];
    NSString *firstImageName = imageNameArray[0];
    [cell.itemImageView setImage:[UIImage imageNamed:firstImageName]];
    cell.titleLabel.text = model.name;
    cell.priceLabel.text = [NSString stringWithFormat:@"%@元",model.price];
    if (model.saleNum >9999) {
        cell.saleLabel.text = [NSString stringWithFormat:@"销量9999+件"];
    }else{
        cell.saleLabel.text = [NSString stringWithFormat:@"销量%ld件",(long)model.saleNum];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.searchTextField resignFirstResponder];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//去除点击后一直灰
    shopItemVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"shopItemVC"];
    shopItemVC.shopItemModel = desMutableArray[indexPath.row];
    [self.navigationController pushViewController:shopItemVC animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.searchTextField resignFirstResponder];
    
    __block CGRect rect = self.buttonView.frame;
    __block CGRect tableRect = self.tableView.frame;
    currentOffSet = scrollView.contentOffset.y;
    if (preOffSet < currentOffSet) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect arect = self.searchView.frame;
            arect.origin.y = 20-64.5;
            self.searchView.frame = arect;
            rect.origin.y = 20;
            self.buttonView.frame = rect;
            tableRect.origin.y = rect.origin.y + rect.size.height;
            tableRect.size.height = self.view.frame.size.height - rect.size.height-20;
            self.tableView.frame = tableRect;
        }];
    }else if(preOffSet > currentOffSet){
        [UIView animateWithDuration:0.5 animations:^{
            CGRect arect = self.searchView.frame;
            arect.origin.y = 20;
            self.searchView.frame = arect;
            rect.origin.y = 64.5;
            
            self.buttonView.frame = rect;
            tableRect.origin.y = rect.origin.y + rect.size.height;
            tableRect.size.height = self.view.frame.size.height - rect.size.height -self.searchView.frame.size.height-20;
            self.tableView.frame = tableRect;
        }];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    preOffSet = scrollView.contentOffset.y;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    preOffSet = scrollView.contentOffset.y;
}

#pragma mark - buttonOperation
- (void)clickedButton{
    [self.generalSortButton addTarget:self action:@selector(SortGeneral:) forControlEvents:UIControlEventTouchUpInside];
    [self.saleSortButton addTarget:self action:@selector(SortSale:) forControlEvents:UIControlEventTouchUpInside];
    [self.newestSortButton addTarget:self action:@selector(SortNewest:) forControlEvents:UIControlEventTouchUpInside];
    [self.filtButton addTarget:self action:@selector(clickedFilt:) forControlEvents:UIControlEventTouchUpInside];
    
    __block BOOL upOrDown = YES;
    [[self.priceSortButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        [self buttonChoosedChangeColor:self.priceSortButton];
        if (upOrDown) {
            [self.upValueSortButton setImage:[UIImage imageNamed:@"blackUpValue"] forState:UIControlStateNormal];
            upOrDown = NO;
            [self startArraySort:@"price" isAscending:NO];
            [self.tableView reloadData];
        }else{
            [self.downValueSortButton setImage:[UIImage imageNamed:@"blackDownValue"] forState:UIControlStateNormal];
            upOrDown = YES;
            [self startArraySort:@"price" isAscending:YES];
            [self.tableView reloadData];
        }
        [self.tableView reloadData];
        
    }];
}

- (void)SortGeneral:(UIButton *)button{
    [self buttonChoosedChangeColor:button];
    [self startArraySort:@"idNo" isAscending:YES];
    [self.tableView reloadData];
}
- (void)SortSale:(UIButton *)button{
    [self buttonChoosedChangeColor:button];
    [self startArraySort:@"saleNum" isAscending:NO];
    [self.tableView reloadData];
}
- (void)SortNewest:(UIButton *)button{
    //最新？？？？暂时先倒排id
    [self buttonChoosedChangeColor:button];
    [self startArraySort:@"idNo" isAscending:NO];
    [self.tableView reloadData];
}

- (void)buttonChoosedChangeColor:(UIButton *)button{
    [self.searchTextField resignFirstResponder];
    [self.filtButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.saleSortButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.priceSortButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.newestSortButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.generalSortButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.upValueSortButton setImage:[UIImage imageNamed:@"upValue"] forState:UIControlStateNormal];
    [self.downValueSortButton setImage:[UIImage imageNamed:@"downValue"] forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.tableView reloadData];
}

//开始编辑时 视图上移 如果输入框不被键盘遮挡则不上移。
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    CGFloat rects = self.view.frame.size.height - (textField.frame.origin.y + textField.frame.size.height + 216 +50);
    if (rects <= 0) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = rects;
            self.view.frame = frame;
        }];
    }
    return YES;
}

//结束编辑时键盘下去 视图下移动画
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0.0;
        self.view.frame = frame;
    }];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.searchTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.searchTextField resignFirstResponder];
    [self searchKeywordThenUpdateArray];
    [self buttonChoosedChangeColor:self.generalSortButton];
    return YES;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
