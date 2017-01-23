//
//  FDAppointManagerViewController.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/20.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "FDAppointManagerViewController.h"
#import "TreatMentViewController.h"
#import "AppointInfoViewController.h"
#import "AppointManagerCell.h"
#import "BSAppointmentTableViewCell.h"
//#import "AppointmentModel.h"
#import "FPNetwork.h"
#import "FDAppointManagerEntity.h"
#import "JMDataPickerView.h"


@interface FDAppointManagerViewController ()<UITableViewDelegate,UITableViewDataSource>{
}

@property (nonatomic, strong) NSMutableArray   *appointmentArray;
@property (strong, strong   ) UITableView      *listTab;
@property (nonatomic,strong ) JMDataPickerView *pickerView;
@property (nonatomic,assign ) NSInteger        pageIndex;

@property (nonatomic, strong) NSMutableString *tempStr;
@property (nonatomic, strong) NSMutableString *tempStr2;


@end

@implementation FDAppointManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initRightBarWithTitle:@"已面诊记录"];
}

- (void)setupView{
    
    self.title = @"预约管理";
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    
    _listTab = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _listTab.backgroundColor = UIColorFromRGB(0xf2f2f2);

    _listTab.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_listTab];
    
    __weak typeof(self) weakSelf = self;
    self.pickerView.block = ^(JMDataModel *model){
        
        NSLog(@"select date %@",model.dateStrWithFormate);
        weakSelf.tempStr = [model.dateStrWithFormate mutableCopy];
        
        
        if (weakSelf.appointmentArray.count > 0) {
            
            [weakSelf.appointmentArray removeAllObjects];
        }
        
        if (![weakSelf.tempStr2 isEqualToString:weakSelf.tempStr]) {
            weakSelf.pageIndex = 1;
        }
        
        [weakSelf.listTab.mj_header beginRefreshing];
        if (weakSelf.tempStr.length > 0 && ![weakSelf isToday:weakSelf.tempStr]) {
            [weakSelf requestDataWithDate:weakSelf.tempStr];
        }else {
            [weakSelf requestData];
        }
        
    };
    
    _listTab.delegate = self;
    _listTab.dataSource = self;
    [_listTab registerClass:[AppointManagerCell class] forCellReuseIdentifier:@"AMCell"];
    
    
    MJRefreshHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        
        weakSelf.pageIndex = 1;
        
        if (weakSelf.appointmentArray.count > 0) {
            
            [weakSelf.appointmentArray removeAllObjects];
        }
        
        
        if (weakSelf.tempStr.length > 0 && ![weakSelf isToday:weakSelf.tempStr]) {
            [weakSelf requestDataWithDate:weakSelf.tempStr];
        }else {
            [weakSelf requestData];
        }
    }];
    
    
    
    _listTab.mj_header = header;
    [_listTab.mj_header beginRefreshing];
}

// 网络请求
- (void)requestData{
    
    __weak typeof(self) weakSelf = self;
    
    NSInteger userID = kCurrentUser.userId;
    //    userID = 8;//测试
    NSString* date = [weakSelf getCurrentDate:[NSDate date] format:@"yyyy-MM-dd"];
    NSDictionary* parames = @{@"UserID":@(userID),@"Date":date};
    [[FPNetwork POST:API_QUERY_CHILDREN_BESPEAK withParams:parames] addCompleteHandler:^(FPResponse *response) {
        [weakSelf.listTab.mj_header endRefreshing];
        
        if(response.success){
            NSArray *tmpModelArray = [FDAppointManagerEntity mj_objectArrayWithKeyValuesArray:response.data];
            [weakSelf.appointmentArray addObjectsFromArray:tmpModelArray];
            [weakSelf.listTab reloadData];
            
        }else{
            [ProgressUtil showError:response.message];
        }
    }];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *todayStr = [df stringFromDate:[NSDate date]];
    weakSelf.tempStr2 = [NSMutableString stringWithString:todayStr];
}

- (void)requestDataWithDate:(NSString *)date{
    
    
    __weak typeof(self) weakSelf = self;
    
    NSInteger userID = kCurrentUser.userId;
    //    userID = 8;//测试
    NSDictionary* parames = @{@"UserID":@(userID),@"Date":date};
    [[FPNetwork POST:API_QUERY_CHILDREN_BESPEAK withParams:parames] addCompleteHandler:^(FPResponse *response) {
        
        [weakSelf.listTab.mj_header endRefreshing];
        
        if(response.success){
            NSArray *tmpModelArray = [FDAppointManagerEntity mj_objectArrayWithKeyValuesArray:response.data];
            [weakSelf.appointmentArray addObjectsFromArray:tmpModelArray];
            [weakSelf.listTab reloadData];
            
        }else{
            [ProgressUtil showError:response.message];
        }
        
    }];
    weakSelf.tempStr2 = [NSMutableString stringWithString:date];
}


#pragma mark-------UITableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.appointmentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    AppointManagerCell* cell = [tableView dequeueReusableCellWithIdentifier:@"AMCell"];
    FDAppointManagerEntity* appoint = [self.appointmentArray objectAtIndex:indexPath.row];
    cell.model = appoint;

    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = kScreenWidth == 320? 110/2.0: 125/2.0;
    return height;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FDAppointManagerEntity* appointManaer = [self.appointmentArray objectAtIndex:indexPath.row];
    AppointInfoViewController* appointInfo = [AppointInfoViewController new];
    appointInfo.appointManager = appointManaer;
    [self.navigationController pushViewController:appointInfo animated:YES];

}

#pragma mark - 点击事件

-(void)rightItemAction:(id)sender{
    [self.navigationController pushViewController:[TreatMentViewController new] animated:YES];
}

#pragma mark - lazyload

-(NSMutableArray *)appointmentArray{
    
    if (!_appointmentArray) {
        _appointmentArray = [NSMutableArray array];
        
    }
    
    return _appointmentArray;
    
}

-(JMDataPickerView *)pickerView{
    
    if (!_pickerView) {
        
        _pickerView = [[JMDataPickerView alloc] init];
        
        [self.view addSubview:_pickerView];
        
        _pickerView.type = JM_DAY;
        
        _pickerView.translatesAutoresizingMaskIntoConstraints = NO;
        
        
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[_pickerView(==_listTab)]-(0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self.view,_listTab,_pickerView)]];
        
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(10)-[_pickerView(50)]-(10)-[_listTab]-(10)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self.view, _listTab,_pickerView)]];
        
        
    }
    
    return _pickerView;
    
}

#pragma mark -

- (NSString*)getCurrentDate:(NSDate*) date format:(NSString*) format{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    return [formatter stringFromDate:date];
}

- (BOOL)isToday:(NSString *)date
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *todayStr = [df stringFromDate:[NSDate date]];
    if ([date isEqualToString:todayStr]) {
        return YES;
    }else {
        return NO;
    }
}


@end
