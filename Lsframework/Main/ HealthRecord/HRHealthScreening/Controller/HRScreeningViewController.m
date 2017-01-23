//
//  HRScreeningViewController.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/8/23.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HRScreeningViewController.h"
#import "HRScreeningPresenter.h"
#import "DefaultChildEntity.h"
#import "PageView.h"
#import "ScreeningTableViewController.h"

@interface HRScreeningViewController ()

@property (nonatomic, strong) HRScreeningPresenter *presenter;
@property (nonatomic, strong) PageView *pageView;

@end

@implementation HRScreeningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setupView{
    self.title = @"筛查报告";
    self.view.backgroundColor = [UIColor whiteColor];
    _presenter = [HRScreeningPresenter new];
    _presenter.screening = self.screening;
    [_presenter dealWithTheData];
    //根据年龄段和性别分别创建数组
    NSArray *nowArray = [NSArray new];
    NSArray *bodyArray = [NSArray new];
    NSArray *checkArray = [NSArray new];
    NSArray *resultArray = [NSArray new];
    NSInteger month = [self ageToMonth];
    if (month == 0) {
        //0-6个月
        nowArray = @[@"实足年龄",@"矫正年龄",@"测量方式",@"母乳喂养",@"配方奶喂养",@"辅食添加",@"睡眠",@"溢奶",@"哭闹",@"大便情况",@"两次随访间患病情况",@"维生素D/AD",@"铁剂",@"钙剂",@"其他"];
        bodyArray = @[@"体重",@"身长",@"头围",@"体温",@"呼吸",@"心率",@"精神状态",@"面色",@"前卤",@"皮肤",@"淋巴结",@"眼外观",@"耳外观",@"口腔",@"胸廓",@"肺部",@"心脏",@"腹部",@"脊柱四肢",@"肛门会阴"];
        checkArray = @[@"视力检查",@"听力检查",@"血红蛋白",@"过敏源检测",@"骨密度",@"脑干诱发电位",@"头颅B超",@"头颅MRI",@"心脏彩超",@"髋关节B超",@"其他",@"X线片"];
        resultArray = @[@"评估/诊断结果",@"指导处理",@"专科会诊",@"其 他"];
    }else if (month == 1){
        //6-12个月
        nowArray = @[@"实足年龄",@"矫正年龄",@"测量方式",@"母乳喂养",@"配方奶喂养",@"辅食添加",@"睡眠",@"溢奶",@"哭闹",@"大便情况",@"两次随访间患病情况",@"维生素D/AD",@"铁剂",@"钙剂",@"其他"];
        bodyArray = @[@"体重",@"身长",@"头围",@"体温",@"呼吸",@"心率",@"精神状态",@"面色",@"前卤",@"皮肤",@"淋巴结",@"眼外观",@"耳外观",@"口腔",@"胸廓",@"肺部",@"心脏",@"腹部",@"脊柱四肢",@"肛门会阴"];
        checkArray = @[@"视力检查",@"听力检查",@"血红蛋白",@"过敏源检测",@"骨密度",@"脑干诱发电位",@"头颅B超",@"头颅MRI",@"心脏彩超",@"髋关节B超",@"其他",@"X线片"];
        resultArray = @[@"评估/诊断结果",@"指导处理",@"专科会诊",@"其 他"];
    }else if (month == 2){
        //12-36个月
        nowArray = @[@"实足年龄",@"矫正年龄",@"测量方式",@"母乳喂养",@"配方奶喂养",@"辅食添加",@"睡眠",@"大便情况",@"两次随访间患病情况",@"维生素D/AD",@"喂养行为"];
        bodyArray = @[@"体重",@"身长",@"头围",@"体温",@"呼吸",@"心率",@"精神状态",@"面色",@"前卤",@"皮肤",@"淋巴结",@"眼外观",@"耳外观",@"口腔",@"胸廓",@"肺部",@"心脏",@"腹部",@"脊柱四肢",@"肛门会阴"];
        checkArray = @[@"视力检查",@"听力检查",@"血红蛋白",@"过敏源检测",@"骨密度",@"脑干诱发电位",@"头颅B超",@"头颅MRI",@"心脏彩超",@"髋关节B超",@"其他",@"X线片",@"髋关节X线片/B超"];
        resultArray = @[@"评估/诊断结果",@"指导处理",@"专科会诊",@"其 他"];
    }else{
        //36-72个月
        nowArray = @[@"实足年龄",@"矫正年龄",@"测量方式",@"辅食添加",@"睡眠",@"大便情况",@"两次随访间患病情况",@"维生素D/AD",@"其他",@"喂养行为"];
        bodyArray = @[@"体重",@"身长",@"体温",@"呼吸",@"心率",@"精神状态",@"面色",@"前卤",@"皮肤",@"淋巴结",@"眼外观",@"耳外观",@"口腔",@"胸廓",@"肺部",@"心脏",@"腹部",@"脊柱四肢",@"肛门会阴"];
        checkArray = @[@"视力检查",@"听力检查",@"血红蛋白",@"过敏源检测",@"骨密度",@"脑干诱发电位",@"头颅B超",@"头颅MRI",@"心脏彩超",@"髋关节B超",@"其他",@"X线片"];
        resultArray = @[@"评估/诊断结果",@"指导处理",@"专科会诊",@"其 他",@"康复训练"];
    }
    //根据性别调整
    NSArray *entityArray = [DefaultChildEntity MR_findAll];
    DefaultChildEntity *entity = entityArray.lastObject;
    NSMutableArray *array = [NSMutableArray arrayWithArray:bodyArray];
    if ([entity.childSex isEqualToString:@"1"]) {
        [array addObject:@"(男)外生殖器"];
    }else if ([entity.childSex isEqualToString:@"2"]){
        [array addObject:@"(女)外生殖器"];
    }
    bodyArray = array;
    [self setupPage:@[nowArray,bodyArray,checkArray,resultArray]];
}

- (void)setupPage:(NSArray *)array{
    _pageView = [PageView new];
    _pageView.pageType = PageTypeSubTitle;
    [_pageView setTabHeight:44.];
    [_pageView setTitleHightLightColor:RGB(100, 192, 224)];
    [_pageView setBottomLineColor:RGB(100, 192, 224)];
    [_pageView setBottomLineHeight:2.0];
    _pageView.frame = self.view.frame;
    [self.view addSubview:_pageView];
    _pageView.alpha = 1;
    
    NSMutableArray *vcArray = [NSMutableArray array];
    for (NSArray *titleArray in array) {
        ScreeningTableViewController *vc = [ScreeningTableViewController new];
        vc.sourceDic = _presenter.sourceDic;
        vc.titleArray = titleArray;
        [vcArray addObject:vc];
    }
    [_pageView setViewControllers:vcArray];
    [_pageView setTitles:@[@"现况",@"体格检查",@"辅助检查",@"指导处理"]];
    
    
}

- (NSInteger )ageToMonth{
    NSString *age = _screening.exactAge;
    NSRange yearRange = [age rangeOfString:@"岁"];
    if (yearRange.length == 0 || yearRange.length > 2) {
        NSRange monthRange = [age rangeOfString:@"月"];
        if (monthRange.length == 0 || monthRange.length > 2) {
            //0-6个月
            return 0;
        }else{
            NSString *monthStr = [age substringToIndex:monthRange.location];
            if ([monthStr integerValue] <= 6) {
                //0-6个月
                return 0;
            }else{
                //6-12个月
                return 1;
            }
        }
    }else{
        NSString *yearStr = [age substringToIndex:yearRange.location];
//        NSInteger year = [yearStr integerValue];
        if ([yearStr integerValue] < 3) {
            //12-36个月
            return 2;
        }else{
            //36-72个月
            return 3;
        }
    }
}

@end
