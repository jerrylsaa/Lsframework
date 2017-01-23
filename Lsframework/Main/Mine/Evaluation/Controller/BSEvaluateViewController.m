//
//  BSEvaluateViewController.m
//  FamilyPlatForm
//
//  Created by Shuai on 16/4/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BSEvaluateViewController.h"
#import "FPNetwork.h"
#import "JMFoundation.h"
#import "EvaluateDetailsPresenter.h"
#import "UIImageView+WebCache.h"

@interface BSEvaluateViewController ()<UITextViewDelegate>
{
    int isAnonymity;//匿名
    EvaluateDetailsPresenter *_presenter;
}
@end

@implementation BSEvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _presenter = [EvaluateDetailsPresenter new];

    [self loadData];
    
}

- (void)setupView {
    
    self.title = @"评价";
    _evaluateTextView.delegate = self;
    _tqStarRatingView.userInteractionEnabled = NO;
    
}

-(void)textViewDidChange:(UITextView *)textView {
    
    if ([textView.text isEqualToString:@""]) {
        _textViewPlaceholder.hidden = NO;
    }else {
        _textViewPlaceholder.hidden = YES;
    }
    CGFloat width = CGRectGetWidth(textView.frame);
    CGSize newSize = [textView sizeThatFits:CGSizeMake(width,MAXFLOAT)];
    _evaluateTextViewHeight.constant = newSize.height;
    
}

- (IBAction)anonymityAction:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    if (btn.isSelected) {
        btn.selected = NO;
        isAnonymity = 1;
    }else {
        btn.selected = YES;
        isAnonymity = 2;
    }
}
#pragma mark 加载数据
- (void)loadData
{
    
    WS(ws);
    
    ws.nameLabel.text = [NSString stringWithFormat:@"姓名：%@",_model.doctorName];
    NSLog(@"%@",_model.doctorName);
    ws.doctorLevelLabel.text = _model.departName;
    
    ws.departmentsLabel.text = [NSString stringWithFormat:@"科室：%@",_model.departName];
    ws.doctorLevelLabel.text = _model.duties;
    ws.diseaseLabel.text = [NSString stringWithFormat:@"所患疾病：%@",_model.descriptionDisease];
    ws.domainLabel.text = [NSString stringWithFormat:@"领域：%@",_model.field];
            ws.tqStarRatingView.userInteractionEnabled = NO;
    
    [ws.tqStarRatingView setScore:(float)_model.starNum withAnimation:YES];
            ws.consultTypeLabel.text = [NSString stringWithFormat:@"%@",_model.askMode];
    

     NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:_model.applyTime];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/MM/dd/hh:mm"];
            NSString *dateString = [dateFormat stringFromDate:myDate];
            NSLog(@"date: %@", dateString);
    ws.timeLabel.text =dateString;
    
    [ws.headImageView sd_setImageWithURL:[NSURL URLWithString:_model.userImg]];
    
    ws.patientAndFollowUp.text = [NSString stringWithFormat:@"患者：%ld例    随访：%ld例",_model.patientNum,_model.followUp];
   

}



- (IBAction)publishAction:(id)sender {
    
//    NSString *docID = [NSString stringWithFormat:@"ld", (long)self.doctorId];
    
    
    NSNumber *docID = [NSNumber numberWithUnsignedInteger: _model.doctorID];

    
    NSLog(@"您点击了发表评价");
    WS(ws);
    NSDictionary *params = @{@"UserID":[NSString stringWithFormat:@"%ld",kCurrentUser.userId], @"DoctorID":docID,@"Service":@(_majorView.numberOfStar), @"Reply":@(_mannerView.numberOfStar), @"Evaluate":@(_replyView.numberOfStar), @"AskID":@"8",@"IsAnonymous":@(isAnonymity),@"EvaluateContent":_evaluateTextView.text};
    
    [[FPNetwork POST:@"AddDoctorEvaluate" withParams:params] addCompleteHandler:^(FPResponse *response) {
        if (response.isSuccess) {
            
            [ProgressUtil showInfo:response.message];
            
            
            [ws.navigationController popViewControllerAnimated:YES];

        }else
        {
            [ProgressUtil showInfo:response.message];
            NSLog(@"😱😱😱😱😱😱😱");
        }
    }];
    
    
    
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
