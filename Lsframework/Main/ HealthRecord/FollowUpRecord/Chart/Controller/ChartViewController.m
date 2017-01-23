//
//  ChartViewController.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/4/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ChartViewController.h"
#import "JHCustomMenu.h"
#import "DefaultChildEntity.h"
#import "ApiMacro.h"

@interface ChartViewController ()<JHCustomMenuDelegate>

@property (nonatomic ,strong) UILabel *titleLabel;
@property (nonatomic ,strong) UIButton *menuButton;
@property (nonatomic ,strong) JHCustomMenu *menu;
@property (nonatomic ,assign) CGRect buttonFrame;
@property (nonatomic ,strong) NSMutableArray *buttonArray;
@property (nonatomic ,copy) NSString *requestStr;
@property (nonatomic ,strong)UIWebView *webView;

@end

@implementation ChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView{
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.clipsToBounds = YES;
    NSArray *entityArray = [DefaultChildEntity MR_findAll];
    
    DefaultChildEntity *entity = entityArray.lastObject;
//    entity.babyID = @(363);
    switch (self.chartType) {
        case ChartTypeBreastFeeding:
            self.title = @"母乳喂养";
            _requestStr = [NSString stringWithFormat:@"%@%@%@",BASE_DOMAIN,API_HTML_MRWY,entity.babyID];
            break;
        case ChartTypeFormulaFeeding:
            self.title = @"配方奶喂养";
            _requestStr = [NSString stringWithFormat:@"%@%@%@",BASE_DOMAIN,API_HTML_PFNWY,entity.babyID];
            break;
        case ChartTypeSleeping:
            self.title = @"睡眠";
            _requestStr = [NSString stringWithFormat:@"%@%@%@",BASE_DOMAIN,API_HTML_SM,entity.babyID];
            break;
        case ChartTypeShit:
            self.title = @"大便";
            _requestStr = [NSString stringWithFormat:@"%@%@%@",BASE_DOMAIN,API_HTML_DB,entity.babyID];
            break;
        case ChartTypeNutritionalSupplement:
            self.title = @"营养补充";
            _requestStr = [NSString stringWithFormat:@"%@%@%@",BASE_DOMAIN,API_HTML_YYBC,entity.babyID];
            break;
        default:
            break;
    }
    [self setupTitleBar];
    if (self.chartType == ChartTypeNutritionalSupplement) {
        [self setupNutritionalButton];
    }
    [self setupMenuBar];
    [self setupWebView];
}

- (void)setupNutritionalButton{
    _buttonArray = [NSMutableArray array];
    //营养补充按钮 - D/AD、钙、铁
    NSArray *titleArray = @[@"D/AD",@"钙",@"铁"];
    for (int i = 0; i < 3; i ++) {
        UIButton *nutriButton = [UIButton new];
        [nutriButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        nutriButton.backgroundColor = [UIColor whiteColor];
        nutriButton.layer.borderWidth = 1;
        nutriButton.layer.borderColor = UIColorFromRGB(0x71CAEE).CGColor;
        nutriButton.layer.cornerRadius = 2;
        nutriButton.tag = i;
        [nutriButton addTarget:self action:@selector(nutriAction:) forControlEvents:UIControlEventTouchUpInside];
        [nutriButton setTitle:titleArray[i] forState:UIControlStateNormal];
        [self.view addSubview:nutriButton];
        CGFloat space = (kScreenWidth - 240)/4;
        if (i == 0) {
            nutriButton.sd_layout.leftSpaceToView(self.view,space).topSpaceToView(self.view,61).heightIs(30).widthIs(80);
            [nutriButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [nutriButton setBackgroundColor:UIColorFromRGB(0x71CAEE)];
        }else if (i == 1){
            nutriButton.sd_layout.leftSpaceToView(self.view,space*2+80).topSpaceToView(self.view,61).heightIs(30).widthIs(80);
        }else{
            nutriButton.sd_layout.rightSpaceToView(self.view,space).topSpaceToView(self.view,61).heightIs(30).widthIs(80);
        }
        [_buttonArray addObject:nutriButton];
    }
}
- (void)setupTitleBar{
    _titleLabel = [UILabel new];
    _titleLabel.text = self.title;
    _titleLabel.textColor = UIColorFromRGB(0x7FC0DA);
    [self.view addSubview:_titleLabel];
    _titleLabel.sd_layout.leftSpaceToView(self.view,20).rightSpaceToView(self.view,20).topSpaceToView(self.view,0).heightIs(50);
    //割
    UIView *speView = [UIView new];
    speView.backgroundColor = UIColorFromRGB(0xEFEFEF);
    [self.view addSubview:speView];
    if (self.chartType == ChartTypeNutritionalSupplement) {
        speView.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(_titleLabel,0).heightIs(50);
    }else{
        speView.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(_titleLabel,0).heightIs(10);
    }
}

- (void)setupMenuBar{
    UILabel *label = [UILabel new];
    NSString *text;
    CGFloat orginY = 10;
    switch (self.chartType) {
        case ChartTypeBreastFeeding:
            text = @"母乳喂养次数";
            break;
        case ChartTypeFormulaFeeding:
            text = @"配方奶喂养ml";
            break;
        case ChartTypeSleeping:
            text = @"睡眠时间h";
            break;
        case ChartTypeShit:
            text = @"大便次数";
            break;
        case ChartTypeNutritionalSupplement:
            text = @"营养补充";
            orginY = 60;
            break;
        default:
            break;
    }
    label.text = text;
    [self.view addSubview:label];
    label.sd_layout.leftSpaceToView(self.view,20).rightSpaceToView(self.view,120).topSpaceToView(_titleLabel,orginY + 1).heightIs(50);
    
    _menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_menuButton];
    _menuButton.sd_layout.rightSpaceToView(self.view,20).topSpaceToView(_titleLabel,orginY + 11).heightIs(30).widthIs(80);
    _buttonFrame = CGRectMake(kScreenWidth-100, orginY + 91, 80, 60);
    _menuButton.layer.borderWidth = 1.f;
    _menuButton.layer.borderColor = UIColorFromRGB(0x71CAEE).CGColor;
    [_menuButton setTitleEdgeInsets:UIEdgeInsetsMake(5, -10, 5, 30)];
    _menuButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_menuButton setTitle:@"周线" forState:UIControlStateNormal];
    [_menuButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_menuButton setImageEdgeInsets:UIEdgeInsetsMake(10, 55, 10, 0)];
    [_menuButton setImage:[UIImage imageNamed:@"ac_down"] forState:UIControlStateNormal];
    [_menuButton addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *speView = [UIView new];
    speView.backgroundColor = UIColorFromRGB(0xD3D3D3);
    [self.view addSubview:speView];
    speView.sd_layout.leftSpaceToView(self.view,20).rightSpaceToView(self.view,20).topSpaceToView(_menuButton,10).heightIs(1);
    
    _menuButton.hidden = YES;
}

- (void)setupWebView{
    
    CGFloat top = 120;
    if (self.chartType == ChartTypeNutritionalSupplement) {
        top = 170;
    }
    
    UIView *scaleView = [UIView new];
    scaleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scaleView];
    scaleView.frame = CGRectMake(-kScreenWidth/2, top, kScreenWidth*2, 350);
    
    _webView = [UIWebView new];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_requestStr]];
    [_webView loadRequest:request];
    [scaleView addSubview:_webView];
    
    _webView.scalesPageToFit = YES;
    _webView.sd_layout.leftSpaceToView(scaleView,0).rightSpaceToView(scaleView,0).topSpaceToView(scaleView,0).bottomSpaceToView(scaleView,0);
    
    scaleView.transform = CGAffineTransformMakeScale(.9,1);
    float xx = kScreenWidth == 320 ? 30 : 35;
    scaleView.frame = CGRectMake((kScreenWidth - scaleView.width)/2 + xx, top, kScreenWidth*2*0.9, 350);
}

//Action
- (void)menuAction:(UIButton *)button{
    WS(ws);
    __weak typeof(self) weakSelf=self;
    if(!self.menu){
        NSArray* array = @[@"周线",@"月线",@"季度线",@"半年线",@"年度线",@"最早"];
        ws.menu=[[JHCustomMenu alloc] initWithDataArr:array origin:CGPointMake(_buttonFrame.origin.x, _buttonFrame.origin.y) width:_buttonFrame.size.width rowHeight:30 rowNumber:5];
        ws.menu.tableView.tag = 100;
        ws.menu.delegate = ws;
        [ws.view addSubview:ws.menu];
        ws.menu.dismiss=^(){
            weakSelf.menu=nil;
        };
    }else{
        [ws.menu dismissWithCompletion:^(JHCustomMenu *object) {
            weakSelf.menu=nil;
        }];
    }
}

- (void)nutriAction:(UIButton *)button{
    for (UIButton *nurButton in _buttonArray) {
        [nurButton setBackgroundColor:[UIColor whiteColor]];
        [nurButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    [((UIButton *)_buttonArray[button.tag]) setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [((UIButton *)_buttonArray[button.tag]) setBackgroundColor:UIColorFromRGB(0x71CAEE)];
    
    NSArray *entityArray = [DefaultChildEntity MR_findAll];
    DefaultChildEntity *entity = entityArray.lastObject;
    if (button.tag == 0) {
        _requestStr = [NSString stringWithFormat:@"%@%@%@",BASE_DOMAIN,API_HTML_YYBC,entity.babyID];
    }else if (button.tag == 1){
        _requestStr = [NSString stringWithFormat:@"%@%@%@",BASE_DOMAIN,API_HTML_GJ,entity.babyID];
    }else if (button.tag == 2){
        _requestStr = [NSString stringWithFormat:@"%@%@%@",BASE_DOMAIN,API_HTML_TJ,entity.babyID];
    }
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_requestStr]];
    [_webView loadRequest:request];
    [_webView loadRequest:request];
}
#pragma mark JHCustomDelegate
- (void)jhCustomMenu:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = (UITableViewCell *)[_menu.tableView cellForRowAtIndexPath:indexPath];
    [_menuButton setTitle:cell.textLabel.text forState:UIControlStateNormal];
}

@end
