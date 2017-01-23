//
//  HRHealthAssessmentViewController.m
//  FamilyPlatForm
//
//  Created by lichen on 16/5/19.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HRHealthAssessmentViewController.h"
#import "HRHealthAssessmentPresenter.h"
#import "HRHealthStaticPageViewController.h"
#import "ReadingRecordCollectionVCell.h"
#import "HRScreeningViewController.h"

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && (SCREEN_MAX_LENGTH < 568.0))
#define IS_IPHONE_5 (IS_IPHONE && (SCREEN_MAX_LENGTH == 568.0))
#define IS_IPHONE_6 (IS_IPHONE && (SCREEN_MAX_LENGTH == 667.0))
#define IS_IPHONE_6P (IS_IPHONE && (SCREEN_MAX_LENGTH == 736.0))
@interface HRHealthAssessmentViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    UILabel *_alphaLabel;
    BOOL isFirstTime;
}

@property(nonatomic,retain) HRHealthAssessmentPresenter* presenter;
@property (nonatomic ,strong) UITableView *assessmentTableView;

@end

@implementation HRHealthAssessmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)setupView{
    self.title = @"查看报告";
    self.view.backgroundColor = [UIColor whiteColor];
    _presenter = [HRHealthAssessmentPresenter new];
    isFirstTime = [[kDefaultsUser objectForKey:[NSString stringWithFormat:@"%ldFirstTimeHealthAssessment",(long)kCurrentUser.userId]] boolValue];
    if (!isFirstTime) {
        [self showUserGuildView];
    }
    [self setupTableView];
}

- (void)setupBlank{
    _alphaLabel = [UILabel new];
    
    _alphaLabel.backgroundColor = [UIColor whiteColor];
    _alphaLabel.textColor = UIColorFromRGB(0x5D5D5D);
    _alphaLabel.text = @"您尚无报告可查看";
    _alphaLabel.textAlignment = NSTextAlignmentCenter;
   
    [self.view addSubview:_alphaLabel];
    _assessmentTableView.backgroundColor = [UIColor whiteColor];
    [_assessmentTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _alphaLabel.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(self.view,0).heightIs(300);
    
}
- (void)setupTableView{
    _assessmentTableView = [UITableView new];
    _assessmentTableView.dataSource = self;
    _assessmentTableView.delegate = self;
    _assessmentTableView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.view addSubview:_assessmentTableView];
//    _assessmentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _assessmentTableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    WS(ws);
    [_presenter loadAssessment:^(BOOL success, NSString *message) {
        if (success == YES) {
            [ws.assessmentTableView reloadData];
        }else{
            [ws setupBlank];
        }
    }];
    
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _presenter.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell_assessment";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"查看报告";
    }else{
        cell.textLabel.text = @"筛查报告";
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = UIColorFromRGB(0x8a8a8a);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return  cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, kScreenWidth, 40);
    view.backgroundColor = _assessmentTableView.backgroundColor;
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = UIColorFromRGB(0x999999);
    [view addSubview:titleLabel];
    titleLabel.sd_layout.leftSpaceToView(view,20).rightSpaceToView(view,20).topSpaceToView(view,15).bottomSpaceToView(view,15);
    Screening *screening = _presenter.dataSource[section];
    titleLabel.text = [self dateStrBy:screening.examDate];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Screening *screening = _presenter.dataSource[indexPath.section];
    if (indexPath.row == 0) {
        HRHealthStaticPageViewController *vc = [HRHealthStaticPageViewController new];
        vc.staticPageURL = [BASE_DOMAIN stringByAppendingString:screening.staticPage];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        HRScreeningViewController *vc = [HRScreeningViewController new];
        vc.screening = screening;
        [self.navigationController pushViewController:vc animated:YES];
    }
}



#pragma mark - 私有方法

- (CGFloat)cellContentViewWith
{
    CGFloat width = kScreenWidth;
    
    // 适配ios7
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

- (void)showUserGuildView{
    BOOL didFirstTime =YES;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:@(didFirstTime) forKey:[NSString stringWithFormat:@"%dFirstTimeHealthAssessment",kCurrentUser.userId]];
    
    NSString *imageName = nil;
    if (IS_IPHONE_4_OR_LESS) {
        imageName = @"readRecord960";
        
    } else if (IS_IPHONE_5){
        imageName = @"readRecord1136";
        
    } else if (IS_IPHONE_6){
        imageName = @"readRecord1334";
        
    }else if (IS_IPHONE_6P){
        imageName = @"readRecord2208";
        
    }
    NSArray* windows = [UIApplication sharedApplication].windows;
    UIWindow *window = [windows objectAtIndex:0];
    
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = window.bounds;
    imageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissGuideView:)];
    [imageView addGestureRecognizer:tap];
    
    [window addSubview:imageView];
}

- (void)dismissGuideView:(UITapGestureRecognizer *)tap{
    
    [UIView animateWithDuration:0.2 animations:^{
        tap.view.alpha = 0;
    } completion:^(BOOL finished) {
        
        [tap.view removeFromSuperview];

        
    }];
}

- (NSString *)dateStrBy:(NSString *)str{
    // "/Date(1469750400000)/"
    if (str.length > 0 || ![str isKindOfClass:[NSNull class]]) {
        NSRange range = {6,str.length - 11};
        NSString *subStr = [str substringWithRange:range];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[subStr longLongValue]];
        NSDateFormatter *formatter = [NSDateFormatter new];
        [formatter setDateFormat:@"yyyy.MM.dd"];
        return [formatter stringFromDate:date];
    }else{
        return @"";
    }
}

#pragma mark---umeng页面统计
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"查看报告"];
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"查看报告"];
    
}


@end
