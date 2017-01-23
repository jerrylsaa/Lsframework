//
//  DailyRecordViewController.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/4/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "DailyRecordViewController.h"
#import "ZHCardView.h"
#import "DailyRecordPresenter.h"
#import "FollowUp.h"
#import "FPTextField.h"
#import "DefaultChildEntity.h"
#import "DateEntity.h"

@interface DailyRecordViewController ()<CellFieldDelegate,FollowUpDelegate>

@property (nonatomic ,strong)UIScrollView *scrollView;

@property (nonatomic ,strong)DailyRecordPresenter *preenter;

@property (nonatomic ,strong)FollowUp *followUp;

@property (nonatomic ,strong)FPTextField *ageTextField;

@end

@implementation DailyRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//历史随访处于不可编辑状态，当日随访如果有数据处于不可编辑状态，无数据可编辑
- (void)setupView{
    NSString *ageStr;
    NSArray *array = [DefaultChildEntity MR_findAll];
    if (array.count > 0) {
        DefaultChildEntity *entity = array.lastObject;
        NSString *nlStr = entity.nL;
        ageStr = entity.nL;
        if (nlStr.length > 0) {
            nlStr = [nlStr stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            NSRange range_1 = [nlStr rangeOfString:@"岁"];
            NSRange range_2 = [nlStr rangeOfString:@"月"];
            NSRange range_3 = {0,range_1.length > 0 ? range_1.location : 0};
            NSRange range_4 = {range_1.length > 0 ? range_1.location+1 : 0 ,(range_2.length > 0 ? range_2.location : 0) - (range_1.length > 0 ? range_1.location-1 : 0)};
            
            NSInteger year = range_1.length > 0 ? [[nlStr substringWithRange:range_3] integerValue] : 0;
            NSInteger month = range_2.length > 0 ? [[nlStr substringWithRange:range_4] integerValue] : 0;
            NSInteger totalMonth = year*12+month;
            if (totalMonth < 6) {
//                self.title = @"00-06月随访";
                self.title = @"00-06月健康日志";
            }else if (totalMonth >= 6 && totalMonth < 12){
//                self.title = @"06-12月随访";
                self.title = @"06-12月健康日志";
            }else if (totalMonth >= 12 && totalMonth < 36){
//                self.title = @"12-36月随访";
                self.title = @"12-36月健康日志";
            }else{
//                self.title = @"03-06岁随访";
                self.title = @"03-06月健康日志";
            }
    }
}
    
    self.view.backgroundColor = [UIColor whiteColor];
    _preenter = [DailyRecordPresenter new];
    _preenter.delegate = self;
    _followUp  = [FollowUp new];
    WS(ws);
    if (self.dailyType == DailyRecordTypeCurrent) {
        [_preenter loadHistoryFollowUpDataWith:^(BOOL success, NSArray *followUp ,NSString *age) {
            if (success == YES) {
                //成功，表示已有健康日志
                ws.dailyType = DailyRecordTypeHistory;
                [ws setupBackImageView];
                [ws setupScrollView];
                [ws setupAge:ageStr];
                [ws setupCardViews:followUp];
            }else{
                ws.dailyType = DailyRecordTypeCurrent;
                [ws setupBackImageView];
                [ws setupScrollView];
                [ws setupAge:ageStr];
                [ws setupCardViews:followUp];
                [ws setupSaveButton];
            }
        } byDate:self.date];
    }else{
        [_preenter loadHistoryFollowUpDataWith:^(BOOL success, NSArray *followUp ,NSString *age) {
//            if (success == NO) {
//                [ProgressUtil showError:@"本日无健康日志"];
//                [ws.navigationController popViewControllerAnimated:YES];
//                return ;
//            }
            //成功，表示已有健康日志
            [ws setupBackImageView];
            [ws setupScrollView];
            [ws setupAge:ageStr];
            [ws setupCardViews:followUp];
        } byDate:self.date];
    }
}

- (void)setupBackImageView{
    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:@"archives_record_bg"];
    [self.view addSubview:imageView];
    imageView.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
}

- (void)setupScrollView{
  
    _scrollView = [UIScrollView new];
    if ([self.title isEqualToString:@"03-06岁健康日志"]) {
        _scrollView.contentSize = CGSizeMake(kScreenWidth, 640);
    }else{
        _scrollView.contentSize = CGSizeMake(kScreenWidth, 840);
    }
    _scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollView];
    _scrollView.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
}

- (void)setupAge:(NSString *)age{
    //年龄（是自动计算出来，还是手动输入）
    _ageTextField = [FPTextField new];
    _ageTextField.userInteractionEnabled = NO;
    _ageTextField.title = @"年龄：";
    _ageTextField.text = age;
    if (self.dailyType == DailyRecordTypeHistory) {
        _ageTextField.userInteractionEnabled = NO;
    }
    [_scrollView addSubview:_ageTextField];
    _ageTextField.sd_layout.leftSpaceToView(_scrollView,20).rightSpaceToView(_scrollView,20).topSpaceToView(_scrollView,10).heightIs(40);
    
}

- (void)setupCardViews:(NSArray *)array{
    //拉取数据，生成数组
    NSArray *titleArray;
    if ([self.title isEqualToString:@"03-06岁健康日志"]) {
       titleArray = @[@"一般情况",@"营养补充情况",@"体格评价"];
    }else{
       titleArray = @[@"喂养情况",@"一般情况",@"营养补充情况",@"体格评价"];
    }
    
    
    float top = 0.0;
    
    for (int i = 0; i < array.count; i ++) {
        top += 60;
        if (i > 0) {
         top += ((NSArray *)array[i - 1]).count * 30 + 10;
        }
        ZHCardView *cardView = [[ZHCardView alloc] initWithTitle:titleArray[i] array:array[i]];
        cardView.section = i;
        if (self.dailyType == DailyRecordTypeHistory) {
            cardView.isCurrent = NO;
            cardView.userInteractionEnabled = NO;
        }else{
            cardView.isCurrent = YES;
            cardView.userInteractionEnabled = YES;
        }
        [cardView setupCardView];
        cardView.delegate = self;
        [_scrollView addSubview:cardView];
        cardView.sd_layout.leftSpaceToView(_scrollView,20).rightSpaceToView(_scrollView,20).topSpaceToView(_scrollView,top).heightIs((((NSArray *)array[i]).count + 1)*30 + 10);
        cardView.clipsToBounds = YES;
        cardView.layer.cornerRadius = 15;
        cardView.image = [self stretchableImageWithImageName:@"text_nor"];
    }
}

- (void)setupSaveButton{
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setBackgroundImage:[self stretchableImageWithImageName:@"next_eable2"] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:saveButton];
    saveButton.sd_layout.leftSpaceToView(_scrollView,20).rightSpaceToView(_scrollView,20).topSpaceToView(_scrollView,790).heightIs(40);
    saveButton.clipsToBounds = YES;
    saveButton.layer.cornerRadius = saveButton.height/2;
}

//Action
- (void)saveAction{
    NSLog(@"%@",_ageTextField.text);
    NSLog(@"save");
    id responder = [self findFirstResponder];
    if (responder && ([responder isKindOfClass:[UITextField class]] || [responder isKindOfClass:[UITextView class]])) {
        [responder resignFirstResponder];
    }
    WS(ws);
    NSArray *array = [DefaultChildEntity MR_findAll];
    DefaultChildEntity *entity = array.lastObject;
    [_preenter upLoadFollowUpData:self.followUp forBaby:[NSString stringWithFormat:@"%@",entity.babyID] date:self.date age:_ageTextField.text complete:^(BOOL success, NSArray *followUp) {
        [DateEntity MR_truncateAll];
        [ws.navigationController popViewControllerAnimated:YES];
    }];
    
}
//获取数据
#pragma mark CellFieldDelegate
- (void)endEditingWithText:(NSString *)text forIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld-%ld = %@",(long)indexPath.section,(long)indexPath.row,text);

        switch (indexPath.row + indexPath.section * 10) {
            case 00:
                _followUp.MRWY = text;
                break;
            case 01:
                _followUp.YYBC = text;
                break;
            case 02:
                _followUp.PFNWY = text;
                break;
            case 03:
                _followUp.FSTJ = text;
                break;
            case 10:
                _followUp.SM = text;
                break;
            case 11:
                _followUp.YN = text;
                break;
            case 12:
                _followUp.KN = text;
                break;
            case 13:
                _followUp.DB = text;
                break;
            case 20:
                _followUp.WSS = text;
                break;
            case 21:
                _followUp.TJ = text;
                break;
            case 22:
                _followUp.GJ = text;
                break;
            case 23:
                _followUp.QT = text;
                break;
            case 30:
                _followUp.TZ = text;
                break;
            case 31:
                _followUp.SG = text;
                break;
            case 32:
                _followUp.TW = text;
                break;
            default:
                break;
        }
}

- (UIImage *)stretchableImageWithImageName:(NSString *)imageName{
    //裁减拉伸图片
    UIImage *image = [UIImage imageNamed:imageName];
    CGRect myImageRect = CGRectMake(image.size.width/2 - 1, image.size.height/2 -1 , 3, 3);
    CGImageRef imageRef = image.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    CGSize size = CGSizeMake(myImageRect.size.width, myImageRect.size.height);
    UIGraphicsBeginImageContext (size);
    CGContextRef context = UIGraphicsGetCurrentContext ();
    CGContextDrawImage (context, myImageRect, subImageRef);
    UIImage *newImage = [UIImage imageWithCGImage :subImageRef];
    UIGraphicsEndImageContext ();
    image = [newImage stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:0];
    return image;
}
- (void)saveSuccess{
    [self.navigationController popViewControllerAnimated:YES];
}

//重写返回，收起键盘
-(void)backItemAction:(id)sender{
    id responder = [self findFirstResponder];
    if (responder && ([responder isKindOfClass:[UITextField class]] || [responder isKindOfClass:[UITextView class]])) {
        [responder resignFirstResponder];
    }
    [self.navigationController popViewControllerAnimated:YES];
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
@end
