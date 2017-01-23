//
//  WQHealthFileViewController.m
//  doctors
//
//  Created by xuwenqi on 16/3/29.
//  Copyright © 2016年 zhonghong. All rights reserved.
//

#import "WQHealthFileViewController.h"
#import "WQHealthFileTableViewCell.h"
@interface WQHealthFileViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *dataArray;
    
   
}
@property (weak, nonatomic) IBOutlet UITableView *tab;



@end

@implementation WQHealthFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //初始化数组
    dataArray = [NSMutableArray arrayWithObjects:@"出生日期:",@"民    族",@"身  高:",@"病情主诉:",@" 现病史:",@" 既往史:",@" 过敏史:",@" 家族史:",@"联系电话:",@" 一卡通:",@"身份证号:",@"以往病史:", nil];
    
   // [self setHomeName:@"健康档案" andIsHome:NO];
    
    self.tab.delegate = self;
    
    self.tab.dataSource = self;

}
//网络请求

-(void)requestData
{
    /*
    
    __weak typeof(self) weakSelf = self;
    NSDictionary *parameter = [NSDictionary dictionaryWithObjects:@[@"Phone_MemberListRemarkData",@"1057",@"0",@"1",@"10"]forKeys:@[@"Action",@"id",@"flag",@"page",@"pagesize"]];

    

    [HTTP_REQUEST post:URL_POST_HEALTHFILEDATA params:parameter success:^(NSDictionary *dic) {
        
        
        
        
        
    } failure:^(NSError *error) {
        
     
        
        
        
    }]; */

    
}


#pragma mark---UITableView的代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  67;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    WQHealthFileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
      cell = [[[NSBundle mainBundle]loadNibNamed:@"WQHealthFileTableViewCell" owner:self options:nil] lastObject];
    }
    
    cell.titileLable.text = [dataArray objectAtIndex:indexPath.row];
    
       tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return cell;
    
}

//-(UITableView *)tab{
//    
//    if (!_tab) {
//        
////        _tab = [[UITableView alloc] initWithFrame:CGRectZero];
////        
////        [self.view addSubview:_tab];
//        
//        _tab.translatesAutoresizingMaskIntoConstraints = NO;
//        
//        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[_tab]-(60)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self.view,_tab)]];
//        
//        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[_tab]-(0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self.view,_tab)]];
//    }
//    return _tab;
//    
//}
//

#pragma mark - lazy load
-(NSMutableArray *)detailsArray{
    if (!_detailsArray) {
        _detailsArray = [NSMutableArray array];
    }
    return _detailsArray;
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
