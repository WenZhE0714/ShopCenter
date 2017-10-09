//
//  ShopItemViewController.m
//  ShopDemo
//
//  Created by mac on 2017/9/15.
//  Copyright © 2017年 wenzhe. All rights reserved.
//

#import "ShopItemViewController.h"
#import <MJRefresh.h>
#import "ShopDetailTableViewCell.h"
#import "ChoosedTableViewCell.h"
#import "CompanyTableViewCell.h"
#import "BigImageView.h"
#import "ComfirmItemView.h"
#import <WebKit/WebKit.h>
#define IPHONE_H ([UIScreen mainScreen].bounds.size.height)
#define IPHONE_W ([UIScreen mainScreen].bounds.size.width)
#define PICKER_HEIGHT   216
#define scrollOffSetX (scrollView.contentOffset.x-(index-1)*IPHONE_W)
@interface ShopItemViewController ()<UITableViewDelegate,UITableViewDataSource,WKNavigationDelegate,UIScrollViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *navigationBarView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *shopCarButton;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UIButton *addToCarButton;
@property (weak, nonatomic) IBOutlet UIButton *zixunButton;
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) UIView *shadeView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) WKWebView *secWebView;
@property (strong, nonatomic) NSURLRequest *request;
@property (strong, nonatomic) UIView *footView;
@property (strong, nonatomic) NSArray *imageArray;
@property (strong, nonatomic) BigImageView *bigImageView;
@property (strong, nonatomic) ChoosedTableViewCell *choosedCell;
@property (strong, nonatomic) ComfirmItemView *comfirmItemView;
@property (weak, nonatomic) IBOutlet UIButton *shopItemButton;
@property (weak, nonatomic) IBOutlet UIButton *detailButton;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (strong, nonatomic) NSArray *provinceArray;
@property (strong, nonatomic) UILabel *titleLabel;
@end

@implementation ShopItemViewController{
    int index;
    CGRect originShopItemButtonRect;
    CGRect originDetailButtonRect;
    CGRect originLineRect;
    CGRect originTitleLabelRect;
    UISwipeGestureRecognizer *rightGestureRecognizer;
    UISwipeGestureRecognizer *leftGestureRecognizer;
    BOOL isEnterDetail;
}

-(NSArray *)provinceArray{
    if (_provinceArray == nil) {
        NSString * path = [[NSBundle mainBundle]pathForResource:@"province" ofType:@"plist"];
        _provinceArray = [[NSArray alloc]initWithContentsOfFile:path];
    }
    return _provinceArray;
}

-(BigImageView *)bigImageView{
    if (_bigImageView == nil) {
        _bigImageView = [[BigImageView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_W, IPHONE_H)];
    }
    return _bigImageView;
}

-(ComfirmItemView *)comfirmItemView{
    if (_comfirmItemView == nil) {
        _comfirmItemView = [[ComfirmItemView alloc]initWithFrame:CGRectMake(0, IPHONE_H, IPHONE_W, 230)];
        [_comfirmItemView.itemImageView setImage:[UIImage imageNamed:self.imageArray[0]]];
        _comfirmItemView.priceLabel.text = self.shopItemModel.price;
        _comfirmItemView.repertoryLabel.text = [NSString stringWithFormat:@"库存：%ld件",self.shopItemModel.repertoryNum];
        _comfirmItemView.limiteLabel.text = [NSString stringWithFormat:@"限购%ld件",self.shopItemModel.limitNum];
        [_comfirmItemView.cancelButton addTarget:self action:@selector(dissmissShadeView) forControlEvents:UIControlEventTouchUpInside];
        [_comfirmItemView.comfirmButton addTarget:self action:@selector(pushAlertView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _comfirmItemView;
}

-(UIPickerView *)pickerView{
    if(_pickerView == nil){
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, IPHONE_H, IPHONE_W, PICKER_HEIGHT)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.showsSelectionIndicator = YES;
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
    }
    return _pickerView;
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

-(UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"图文详情";
        [_titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
        [_titleLabel setTextColor:[UIColor whiteColor]];
        _titleLabel.frame = CGRectMake(originShopItemButtonRect.origin.x+20, self.bigImageView.frame.origin.y+30, 100, 30);
        _titleLabel.alpha = 0.0;
    }
    return _titleLabel;
}

- (void)dissmissShadeView{
    [UIView animateWithDuration:0.2 animations:^{
        self.shadeView.alpha = 0;
        CGRect rect = self.pickerView.frame;
        rect.origin = CGPointMake(0, IPHONE_H);
        self.pickerView.frame = rect;
        
        CGRect arect = self.comfirmItemView.frame;
        arect.origin = CGPointMake(0, IPHONE_H);
        self.comfirmItemView.frame = arect;
    }];
}

- (void)pushAlertView{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"确定购买" message:@"你真的要买这个商品吗？" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dissmissShadeView];
    }]];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dissmissShadeView];
    }];
    [cancelAction setValue:[UIColor redColor] forKey:@"_titleTextColor"];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(UIView *)footView{
    if (_footView == nil) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_W, 50)];
        _footView.backgroundColor = [UIColor colorWithRed:228.0/255 green:228.0/255 blue:228.0/255 alpha:1.0];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(120, 20, 120, 10)];
        label.text = @"继续拖动，查看详情";
        [label setTextColor:[UIColor lightGrayColor]];
        [label setFont:[UIFont boldSystemFontOfSize:13.0]];
        [_footView addSubview:label];
    }
    return _footView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.scrollView.contentOffset = CGPointMake(0, 0);
    [self.tableView reloadData];
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    index = 1;
    isEnterDetail = NO;
    self.bottomView.layer.borderWidth = 1.0;
    self.bottomView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    // Do any additional setup after loading the view.
    self.scrollView.contentSize = CGSizeMake(IPHONE_W * 2, IPHONE_H * 2);
    //设置分页效果
    self.scrollView.pagingEnabled = YES;
    //禁用滚动
    self.scrollView.scrollEnabled = NO;
    
    [self addGesture];
    
    [self.backButton addTarget:self action:@selector(turnBack) forControlEvents:UIControlEventTouchUpInside];
    [self.shopItemButton addTarget:self action:@selector(shopItemButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.detailButton addTarget:self action:@selector(detailButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.buyButton addTarget:self action:@selector(buyThisItem) forControlEvents:UIControlEventTouchUpInside];
    [self.addToCarButton addTarget:self action:@selector(buyThisItem) forControlEvents:UIControlEventTouchUpInside];
    
    originLineRect = self.lineView.frame;
    originDetailButtonRect = self.detailButton.frame;
    originShopItemButtonRect = self.shopItemButton.frame;
    [self.view addSubview:self.titleLabel];
    originTitleLabelRect = self.titleLabel.frame;
    
    if (self.tableView == nil) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, IPHONE_W, IPHONE_H-20-44) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.tableFooterView = self.footView;
        [self.scrollView addSubview:self.tableView];
    }
    
    if (self.webView == nil) {
        self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, IPHONE_H, IPHONE_W, IPHONE_H-64-44)];
        [self.scrollView addSubview:self.webView];
    }
    
    if (self.secWebView == nil) {
        self.secWebView = [[WKWebView alloc]initWithFrame:CGRectMake(IPHONE_W, 0, IPHONE_W, IPHONE_H-64-44)];
        [self.scrollView addSubview:self.secWebView];
    }
    
    if ([self.shopItemModel.website containsString:@"https://"] || [self.shopItemModel.website containsString:@"http://"]) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.shopItemModel.website]]];
        [self.secWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.shopItemModel.website]]];
    }else{
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",self.shopItemModel.website]]]];
        [self.secWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",self.shopItemModel.website]]]];
    }
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadWebView)];
    footer.stateLabel.hidden = YES;
    footer.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    self.tableView.mj_footer = footer;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadTableView)];
    header.stateLabel.hidden = YES;
    self.webView.scrollView.mj_header = header;
}

- (void)shopItemButtonDidClicked{
    isEnterDetail = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.scrollView.contentOffset = CGPointMake(0, 0);
        [self.shopItemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.detailButton setTitleColor:[UIColor colorWithRed:222.0/255 green:222.0/255 blue:222.0/255 alpha:1.0] forState:UIControlStateNormal];
        CGRect rect = self.lineView.frame;
        rect.origin = CGPointMake(self.shopItemButton.frame.origin.x+15, rect.origin.y);
        self.lineView.frame = rect;
    }];
}

- (void)detailButtonDidClicked{
    isEnterDetail = YES;
    [UIView animateWithDuration:0.5 animations:^{
        self.scrollView.contentOffset = CGPointMake(IPHONE_W, 0);
        [self.shopItemButton setTitleColor:[UIColor colorWithRed:222.0/255 green:222.0/255 blue:222.0/255 alpha:1.0] forState:UIControlStateNormal];
        [self.detailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        CGRect rect = self.lineView.frame;
        rect.origin = CGPointMake(self.detailButton.frame.origin.x+15, rect.origin.y);
        self.lineView.frame = rect;
    }];
}

- (void)buyThisItem{
    [self.view addSubview:self.shadeView];
    [self.view addSubview:self.comfirmItemView];
    [UIView animateWithDuration:0.5 animations:^{
        self.shadeView.alpha = 0.6;
        CGRect rect = self.comfirmItemView.frame;
        rect.origin = CGPointMake(0, IPHONE_H-self.comfirmItemView.frame.size.height);
        self.comfirmItemView.frame = rect;
    }];
}

- (void)loadTableView{
    [self addGesture];
    //下拉执行对应的操作
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.scrollView.contentOffset = CGPointMake(0, 0);
        self.shopItemButton.frame = originShopItemButtonRect;
        self.detailButton.frame = originDetailButtonRect;
        self.lineView.frame = originLineRect;
        self.titleLabel.frame = originTitleLabelRect;
        self.titleLabel.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        //结束加载
        [self.webView.scrollView.mj_header endRefreshing];
    }];
}

- (void)loadWebView{
    rightGestureRecognizer = [[UISwipeGestureRecognizer alloc]init];
    rightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.scrollView addGestureRecognizer:rightGestureRecognizer];
    
    leftGestureRecognizer = [[UISwipeGestureRecognizer alloc]init];
    leftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.scrollView addGestureRecognizer:leftGestureRecognizer];
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.scrollView.contentOffset = CGPointMake(0, IPHONE_H);
        
        CGRect shopItemButtonRect = self.shopItemButton.frame;
        shopItemButtonRect.origin = CGPointMake(shopItemButtonRect.origin.x, 0-shopItemButtonRect.size.height);
        self.shopItemButton.frame = shopItemButtonRect;
        
        CGRect detailButtonRect = self.detailButton.frame;
        detailButtonRect.origin = CGPointMake(detailButtonRect.origin.x, 0-detailButtonRect.size.height);
        self.detailButton.frame = detailButtonRect;
        
        CGRect lineRect = self.lineView.frame;
        lineRect.origin = CGPointMake(lineRect.origin.x, 0-lineRect.size.height);
        self.lineView.frame = lineRect;
        
        CGRect titleLabelRect = self.titleLabel.frame;
        titleLabelRect.origin = CGPointMake(titleLabelRect.origin.x, originShopItemButtonRect.origin.y);
        self.titleLabel.frame = titleLabelRect;
        self.titleLabel.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        //结束加载
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)addGesture{
    rightGestureRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(shopItemButtonDidClicked)];
    rightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.scrollView addGestureRecognizer:rightGestureRecognizer];
    
    leftGestureRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(detailButtonDidClicked)];
    leftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.scrollView addGestureRecognizer:leftGestureRecognizer];
}

#pragma mark -- UITableView DataSource && Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        return 2;
    }else {
        return 1;
    }
}

//每个分组上边预留的空白高度
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        return 0.01;
    }else{
        return 5;
    }
}

//定制单元格内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellidentify = @"cell";
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        self.imageArray = [self.shopItemModel.image componentsSeparatedByString:@"|"];
        UIScrollView *imageScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_W, IPHONE_W)];
        imageScrollView.delegate = self;
        imageScrollView.pagingEnabled = YES;
        imageScrollView.contentSize = CGSizeMake(self.imageArray.count*IPHONE_W, 0);
        for (int i = 0; i < self.imageArray.count; i++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*IPHONE_W, 0, IPHONE_W, IPHONE_W)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [imageView setImage:[UIImage imageNamed:self.imageArray[i]]];
            imageView.tag = i;
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer* imageClickedTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleimageClickedTap:)];
            [imageView addGestureRecognizer:imageClickedTap];
            [imageScrollView addSubview:imageView];
        }
        
        [cell addSubview:imageScrollView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.section == 1){
        ShopDetailTableViewCell *cell = (ShopDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellidentify];
        if (cell == nil) {
            cell = [[ShopDetailTableViewCell alloc]init];
            cell.itemNameLabel.text = self.shopItemModel.name;
            cell.priceLabel.text = self.shopItemModel.price;
            cell.originPriceLabel.text = [NSString stringWithFormat:@"%@元",self.shopItemModel.originPrice];
            if (self.shopItemModel.saleNum > 9999) {
                cell.salesLabel.text = [NSString stringWithFormat:@"销量9999+件"];
            }else{
                cell.salesLabel.text = [NSString stringWithFormat:@"销量%ld件",self.shopItemModel.saleNum];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.section == 2){
        if (indexPath.row == 0) {
            ChoosedTableViewCell *cell = (ChoosedTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellidentify];
            if (cell == nil) {
                cell = [[ChoosedTableViewCell alloc]init];
                cell.titleLabel.text = @"已 选：";
                cell.addressTextField.text = @"";
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            self.choosedCell = (ChoosedTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellidentify];
            if (self.choosedCell == nil) {
                self.choosedCell = [[ChoosedTableViewCell alloc]init];
                self.choosedCell.titleLabel.text = @"配送至：";
                self.choosedCell.addressTextField.text = @"上海 免运费";
                self.choosedCell.addressTextField.delegate = self;
            }
            self.choosedCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return self.choosedCell;
        }
    }else{
        CompanyTableViewCell *cell = (CompanyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellidentify];
        if (cell == nil) {
            cell = [[CompanyTableViewCell alloc]init];
            cell.instrumentLabel.text = [NSString stringWithFormat:@"由%@发货",self.shopItemModel.company];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return IPHONE_W;
    }else if (indexPath.section == 1){
        return 120;
    }else{
        return 50;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2 && indexPath.row == 1) {
        [self.view addSubview:self.shadeView];
        [self.view addSubview:self.pickerView];
        [UIView animateWithDuration:0.5 animations:^{
            self.shadeView.alpha = 0.6;
            CGRect rect = self.pickerView.frame;
            rect.origin = CGPointMake(0, IPHONE_H-PICKER_HEIGHT);
            self.pickerView.frame = rect;
        }];
    }else if(indexPath.section == 2 && indexPath.row == 0){
        [self buyThisItem];
    }
}

#pragma mark -- UIPickerView DataSource && Delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.provinceArray.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.provinceArray[row][@"name"];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.choosedCell.addressTextField.text = [NSString stringWithFormat:@"%@ 免运费",self.provinceArray[row][@"name"]];
}

// 确认最后选中的结果
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.choosedCell.addressTextField resignFirstResponder];
    [self.comfirmItemView.stepTextField resignFirstResponder];
}

- (void)handleimageClickedTap:(UITapGestureRecognizer *)gestureRecognizer{
    [self.bigImageView.imageView setImage:[UIImage imageNamed:self.imageArray[[gestureRecognizer view].tag]]];
    [self.view addSubview:self.bigImageView];
    self.bigImageView.alpha = 0.0;
    [UIView animateWithDuration:0.5 animations:^{
        self.bigImageView.alpha = 1.0;
    }];
}

- (void)turnBack{
    if (isEnterDetail) {
        [self shopItemButtonDidClicked];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
