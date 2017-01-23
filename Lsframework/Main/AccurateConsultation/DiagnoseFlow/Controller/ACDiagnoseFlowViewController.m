//
//  ACDiagnoseFlowViewController.m
//  FamilyPlatForm
//
//  Created by tom on 16/3/29.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ACDiagnoseFlowViewController.h"
#import "SingleFlowView.h"
@interface ACDiagnoseFlowViewController (){
    UIScrollView* _scroll;
}

@end

@implementation ACDiagnoseFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)setupView{
    self.title=@"就诊流程";
    self.view.backgroundColor=[UIColor whiteColor];
    
    _scroll=[UIScrollView new];
    _scroll.showsVerticalScrollIndicator=NO;
    _scroll.showsHorizontalScrollIndicator=NO;
    [self.view addSubview:_scroll];
    _scroll.sd_layout.topSpaceToView(self.view ,0).bottomSpaceToView(self.view,0).leftSpaceToView(self.view,0).rightSpaceToView(self.view,0);
    NSString* search=[NSString stringWithFormat:@"分诊完成  (请到 \"%@\" 中查看咨询状态)",@"消息"];
    NSArray* titleArray=@[@"提交病历资料",@"分诊",@"付费",search,@"确定通话时间",@"与医生通话",@"评价",@"完成"];
    NSMutableArray* viewArray=[NSMutableArray arrayWithCapacity:titleArray.count];
    for(int i = 0; i<titleArray.count; ++i){
        SingleFlowView* flowView=[SingleFlowView new];
        flowView.titleLabel.text=titleArray[i];
        [_scroll addSubview:flowView];
        flowView.sd_layout.topSpaceToView(_scroll,65+i*(50+10)).heightIs(50).leftSpaceToView(_scroll,0).rightSpaceToView(_scroll,0);
        [viewArray addObject:flowView];
        if(i==titleArray.count-1){
            flowView.isHiddenNarrow=YES;
        }
    }
    SingleFlowView * lastFlowView=[viewArray lastObject];
    [_scroll setupAutoContentSizeWithBottomView:lastFlowView bottomMargin:65];
    
}

@end
