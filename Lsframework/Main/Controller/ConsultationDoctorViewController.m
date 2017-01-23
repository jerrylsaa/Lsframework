//
//  ConsultationDoctorViewController.m
//  FamilyPlatForm
//
//  Created by Tom on 16/3/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ConsultationDoctorViewController.h"
#import "CaseInfoViewController.h"
#import "ACMainViewController.h"
#import "QCDoctorListViewController.h"
#import "ConsultationDoctorPresenter.h"
#import "ConsultationDoctorTableViewCell.h"

@interface ConsultationDoctorViewController ()<ConsultationDoctorPresenterDelegate>
@property (weak, nonatomic) IBOutlet UIView *background;
@property (weak, nonatomic) IBOutlet UILabel *lbNoSign;
@property (weak, nonatomic) IBOutlet UIView *signedDoctorView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signedDoctorViewRight;
@property (weak, nonatomic) IBOutlet UILabel *lbDoctorTitle;
@property (weak, nonatomic) IBOutlet UIView *accurateView;
@property (weak, nonatomic) IBOutlet UIView *freeView;
@property (weak, nonatomic) IBOutlet UIView *quickView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) ConsultationDoctorPresenter * presenter;
@property (weak, nonatomic) IBOutlet UIView *hasSignDoctor;
@property (weak, nonatomic) IBOutlet UIImageView *notSignDoctor;
@property (weak, nonatomic) IBOutlet UILabel *lbMoreSignDoctor;
@property (strong, nonatomic) IBOutlet UILabel *doctorTitle;
@property (strong, nonatomic) IBOutlet UIView *NoSignDoctor;

@end

@implementation ConsultationDoctorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)setupView{
    _presenter = [ConsultationDoctorPresenter new];
    _presenter.delegate = self;
    self.title = @"咨询医生";
    [_tableView registerNib:[UINib nibWithNibName:@"ConsultationDoctorTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [_freeView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(freeViewAction:)]];
    [_accurateView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(accurateViewAction:)]];
    [_quickView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(quickViewAction:)]];
    [_lbDoctorTitle addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doctorTitleAction:)]];
    [_background addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundAction:)]];
    [_NoSignDoctor addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoTabbarDoctor:)]];
    [_lbMoreSignDoctor addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoTabbarDoctor:)]];
    [_presenter getMyFamilyDoctor];
}

#pragma mark Event

-(void)gotoTabbarDoctor:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    [((RDVTabBarController*)self.navigationController.parentViewController) setSelectedIndex:1];
}

-(void)freeViewAction:(id)sender{
    CaseInfoViewController * vc = [CaseInfoViewController new];
    vc.caseInfoType = CaseInfoTypeFree;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)accurateViewAction:(id)sender{
    [self.navigationController pushViewController:[ACMainViewController new] animated:YES];
}

-(void)quickViewAction:(id)sender{
    CaseInfoViewController * vc = [CaseInfoViewController new];
    vc.caseInfoType = CaseInfoTypeQuick;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)doctorTitleAction:(id)sender{
     _background.alpha = 0.0;
    _background.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        _background.alpha = 1.0;
        _signedDoctorViewRight.constant = 0;
        [_background layoutIfNeeded];
    } completion:^(BOOL finished) {

    }];
}

-(void)backgroundAction:(id)sender{
    [UIView animateWithDuration:0.3 animations:^{
        _background.alpha = 0.0;
        _signedDoctorViewRight.constant = - _signedDoctorView.frame.size.width;
        [_background layoutIfNeeded];
    } completion:^(BOOL finished) {
        _background.hidden = YES;
    }];
}

#pragma mark ConsultationDoctorPresenterDelegate

-(void)onGetMyFamilyDoctor{
    _hasSignDoctor.hidden = _presenter.familyDoctors.count == 0;
    _NoSignDoctor.hidden = _presenter.familyDoctors.count != 0;

    _doctorTitle.text = _hasSignDoctor.hidden? @"当前无私人医生，":@"你的私人医生，";
    _notSignDoctor.hidden = _presenter.familyDoctors.count != 0;
    _lbNoSign.hidden = _notSignDoctor.hidden;
    [_tableView reloadData];
}

#pragma UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _presenter.familyDoctors.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ConsultationDoctorTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell configCell:_presenter.familyDoctors[indexPath.row]];
    return cell;
}

#pragma UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
