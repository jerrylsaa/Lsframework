//
//  PersonFileViewController.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/4/25.
//  Copyright © 2016年 梁继明. All rights reserved.
//


#import "PersonFileViewController.h"
#import "PageView.h"
#import "ArchivesRecordViewController.h"
#import "NeonateViewController.h"
#import "GestationViewController.h"
#import "FamilyHistoryViewController.h"
#import "GrowthStatusViewController.h"
#import "TabViewController.h"
#import "PersonFilePresenter.h"
#import "DefaultChildEntity.h"

@implementation State

@end

@interface PersonFileViewController ()<PersonFilePresenterDelegate>

@property (nonatomic ,strong) PageView *pageView;

@property (nonatomic ,strong) UIButton *rightButton;

@property (nonatomic ,assign) BOOL isEditing;

@property (nonatomic ,strong) PersonFilePresenter *presenter;

@property (nonatomic ,strong) ArchivesRecordViewController *vc_1;
@property (nonatomic ,strong) NeonateViewController *vc_2;
@property (nonatomic ,strong) GestationViewController *vc_3;
@property (nonatomic ,strong) FamilyHistoryViewController *vc_4;
@property (nonatomic ,strong) GrowthStatusViewController *vc_5;

@property (nonatomic ,strong) State *state_1;
@property (nonatomic ,strong) State *state_2;
@property (nonatomic ,strong) State *state_3;
@property (nonatomic ,strong) State *state_4;
@property (nonatomic ,strong) State *state_5;

@property (nonatomic ,copy) NSString *tips;


@end

@implementation PersonFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView{
    self.title = @"个人档案";
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    WS(ws);

    self.view.backgroundColor = [UIColor whiteColor];

    _presenter = [PersonFilePresenter new];
    _presenter.delegate = self;
    [ProgressUtil show];
    [ws setupPage];
    NSInteger babyID = self.babyID;
    if(babyID == 0){
        babyID = [[DefaultChildEntity defaultChild].babyID integerValue];
    }
//    DefaultChildEntity *entity = [DefaultChildEntity MR_findAll].lastObject;
//    ((NSArray *)[DefaultChildEntity MR_findAll]).count > 0 && [entity.babyID intValue] != 0
    if (babyID) {
        [_presenter loadChildFormBy:babyID complete:^(BOOL success) {
            if (success == YES) {
                ws.isEditing = NO;
                _pageView.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
                _pageView.alpha = 1;
                WS(ws);
                [ws loadPageData:_isEditing];
                [ws setupRightItem];
            }
            [ProgressUtil dismiss];
        }];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setupPage{
    _pageView = [PageView new];
    _pageView.pageType = PageTypeSubTitle;
    [_pageView setTabHeight:44.];
    [_pageView setTitleHightLightColor:RGB(100, 192, 224)];
    [_pageView setBottomLineColor:RGB(100, 192, 224)];
    [_pageView setBottomLineHeight:2.0];
    _pageView.frame = self.view.frame;
    [self.view addSubview:_pageView];
    _pageView.alpha = 0;
    
     
}
//加载儿童实体数据

- (void)loadPageData:(BOOL) isEditing{
    if (isEditing == NO) {
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < 5; i ++) {
            TabViewController *tabVc = [TabViewController new];
            [array addObject:tabVc];
        }
        [_pageView setViewControllers:array];
        [_pageView setTitles:@[@"基本\n信息",@"新生儿\n围产期",@"母亲孕\n期情况",@"家庭\n病史",@"发育\n情况"]];
        NSArray *imageArray = @[@"archives_records",@"archives_records2",@"archives_records3",@"family",@"groupStatusbg"];
        for (int i = 0; i < 5 ; i ++) {
            TabViewController *vc = array[i];

            [vc reloadDataWith:_presenter.textArray[i] child:_presenter.child imageName:imageArray[i]];
        }
    }else{
        _vc_1 = [ArchivesRecordViewController new];
        _vc_2 = [NeonateViewController new];
        _vc_3 = [GestationViewController new];
        _vc_4 = [FamilyHistoryViewController new];
        _vc_5 = [GrowthStatusViewController new];
        
        NSArray *vcArray = @[_vc_1 ,_vc_2 , _vc_3, _vc_4,_vc_5];
        [_pageView setViewControllers:vcArray];
        [_pageView setTitles:@[@"基本\n信息",@"新生儿\n围产期",@"母亲孕\n期情况",@"家庭\n病史",@"发育\n情况"]];
        
        [_vc_1 hiddenButton];
        [_vc_2 hiddenButton];
        [_vc_3 hiddenButton];
        [_vc_4 hiddenButton];
        [_vc_5 hiddenButton];
        
        [_vc_1 loadData:_presenter.child];
        [_vc_2 loadData:_presenter.child];
        [_vc_3 loadData:_presenter.child];
        [_vc_4 loadData:_presenter.child];
        [_vc_5 loadData:_presenter.child];
        
        if ([[self findFirstResponder] isKindOfClass:[UITextField class]]) {
            [[self findFirstResponder] resignFirstResponder];
        }
    }
}

- (void)setupRightItem{
    if (self.isEditing == NO) {
        [self initRightBarWithTitle:@"编辑"];
    }else{
        [self initRightBarWithTitle:@"保存"];
    }
}

-(void)rightItemAction:(id)sender{

    ChildForm *child = _presenter.child;
    WS(ws);
    __weak PageView *weakPageView = _pageView;
    if (_isEditing == NO) {
        _isEditing = YES;
        [_presenter loadMenuData:^(BOOL success) {
            if (success == YES) {
                [ProgressUtil dismiss];
                [ws setupRightItem];
                [ws loadPageData:_isEditing];
            }else{
                [ProgressUtil showError:@"加载失败"];
            }
        }];
    }else{
        [_vc_1 vc_1_Save:^(BOOL success, NSString *message) {
            if (success == NO) {
                [ProgressUtil showError:message];
                [weakPageView setSelection:0];
            }else{
                [ws.vc_2 vc_2_save:^(BOOL success, NSString *message) {
                    if (success == NO) {
                       [ProgressUtil showError:message];
                        [weakPageView setSelection:1];
                    }else{
                        [ws.vc_3 vc_3_save:^(BOOL success, NSString *message) {
                            if (success == NO) {
                                [ProgressUtil showError:message];
                                [weakPageView setSelection:2];
                            }else{
                                [ws.vc_4 vc_4_save:^(BOOL success, NSString *message) {
                                    if (success == NO) {
                                        [ProgressUtil showError:message];
                                        [weakPageView setSelection:3];
                                    }else{
                                        [ws.vc_5 vc_5_save:^(BOOL success, NSString *message) {
                                            if (success == NO) {
                                                [ProgressUtil showError:message];
                                                [weakPageView setSelection:4];
                                            }else{
                                                //最终，上传
                                                [ws.presenter upload];
                                            }
                                        }];
                                    }
                                }];
                            }
                        }];
                    }
                }];
            }
        }];
        
    }

    
}



//获取响应者
- (id)findFirstResponder{
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView *subview in self.view.subviews) {
        if ([subview isFirstResponder]&&subview!=nil) {
            return subview;
        }
    }
    return nil;

}

#pragma mark - 代理

- (void)saveCompletion:(BOOL)success info:(NSString *)info{
    if(success){
        [ProgressUtil showSuccess:@"保存成功"];
//        if(self.updateBabyInfo){
        //发送通知
            [kdefaultCenter postNotificationName:Notification_UpdateBabyDetailInfo object:nil userInfo:@{@"userInfo":self.presenter.child}];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"UPDATECHILD" object:nil];
//        }
        
        //更新我的首页
        [kdefaultCenter postNotificationName:Notification_Update_AllBaby object:nil userInfo:nil];
        

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:YES];

        });
        
//        [self.navigationController popToRootViewControllerAnimated:YES];
//        [ProgressUtil showWithStatus:@"正在加载宝贝信息"];
    }else{
        [ProgressUtil showError:@"保存失败"];

    }
    
}
#pragma mark---umeng页面统计
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"个人档案"];
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"个人档案"];
    
}


@end
