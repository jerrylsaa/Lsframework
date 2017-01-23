//
//  BSHospitalArchivesViewController.m
//  FamilyPlatForm
//
//  Created by Shuai on 16/4/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BSHospitalArchivesViewController.h"
#import "BSHospitalArchivesTableViewCell.h"
#import "UploadInspectionFileViewController.h"
#import "BSHospitalCheckDetailedInformationViewController.h"
#import "BSHospitalArchivesPresenter.h"
#import "HospitalMedicalRecordsPresenter.h"
#import "CooperationHospitalListViewController.h"
#import "UploadInspectionFileViewController.h"

@interface BSHospitalArchivesViewController ()<UITableViewDelegate, UITableViewDataSource, hospitalArchivesDelegate, hospitalMedicalRecordsDelegate>
{
    BSHospitalArchivesTableViewCell *_cell;
    NSString *myType;
    NSArray *_dataArray;
}

@property (weak, nonatomic) IBOutlet UITableView *listTableView;// 列表
@property (weak, nonatomic) IBOutlet UIView *uploadView;// 列表没有数据时候显示
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;// 上传检查档案按钮
@property (weak, nonatomic) IBOutlet UIButton *cooperationHospitalBtn;// 合作医院按钮
@property (weak, nonatomic) IBOutlet UILabel  *hospitalTextLabel;// 第一行提示文字

@property (nonatomic, strong) BSHospitalArchivesPresenter *presenter;
@property (nonatomic, strong) HospitalMedicalRecordsPresenter *ePresenter;

@end

@implementation BSHospitalArchivesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)setupView {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    myType = [user objectForKey:@"bsArchivesType"];
    
    if ([myType isEqualToString:@"0"]) {
        self.title = @"检查档案";
        
        _hospitalTextLabel.text = @"你还没有检查档案，您可以";
        [_uploadBtn setTitle:@"上传检查档案" forState:UIControlStateNormal];
        
    }else if ([myType isEqualToString:@"1"]) {
        self.title = @"病历档案";
        
        _hospitalTextLabel.text = @"你还没有医院病历档案，您可以";
        [_uploadBtn setTitle:@"上传病历档案" forState:UIControlStateNormal];
    }
    
    _listTableView.tableFooterView = [[UIView alloc] init];
    _listTableView.rowHeight = 63;
    [_listTableView registerNib:[UINib nibWithNibName:@"BSHospitalArchivesTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if ([myType isEqualToString:@"0"]) {
        
        self.presenter = [[BSHospitalArchivesPresenter alloc] init];
        self.presenter.delegate = self;
        [ProgressUtil show];
        [self.presenter request];
        
    } else if ([myType isEqualToString:@"1"]) {
        
        self.ePresenter = [[HospitalMedicalRecordsPresenter alloc] init];
        self.ePresenter.delegate = self;
        [ProgressUtil show];
        [self.ePresenter request];
        
    }
}

- (void)rightItemAction {
    
    NSLog(@"您点击了导航上传档案");
    [self.navigationController pushViewController:[[UploadInspectionFileViewController alloc] init] animated:YES];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    _cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    _cell.myType = myType;
    _cell.model = _dataArray[indexPath.row];
    return _cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BSHospitalCheckDetailedInformationViewController *vc = [[BSHospitalCheckDetailedInformationViewController alloc] init];
    
#pragma mark 暂时都是自主
    vc.detailType = @"自主检查档案";
    vc.model = _dataArray[indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)sendData:(NSArray *)dataArray {
    
    if (dataArray.count > 0) {
        
        _dataArray = dataArray;
        [_listTableView reloadData];
        _uploadView.hidden = YES;
        _listTableView.hidden = NO;
        
        if ([myType isEqualToString:@"0"]) {
            
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"上传检查档案" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction)];
        } else if ([myType isEqualToString:@"1"]) {
            
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"上传病历档案" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction)];
        }
    }else {
        _uploadView.hidden = NO;
        _listTableView.hidden = YES;
    }
    
}

- (IBAction)btnAction:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    if ([btn isEqual:_uploadBtn]) {
        NSLog(@"您点击了上传检查档案");
        [self.navigationController pushViewController:[[UploadInspectionFileViewController alloc] init] animated:YES];
    }else if ([btn isEqual:_cooperationHospitalBtn]) {
        NSLog(@"您点击了合作医院");
        [self.navigationController pushViewController:[[CooperationHospitalListViewController alloc] init] animated:YES];
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
