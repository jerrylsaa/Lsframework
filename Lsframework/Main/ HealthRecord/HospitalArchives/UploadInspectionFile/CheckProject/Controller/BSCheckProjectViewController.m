//
//  BSCheckProjectViewController.m
//  FamilyPlatForm
//
//  Created by Shuai on 16/4/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BSCheckProjectViewController.h"
#import "BSCheckProjectCell.h"
#import "CheckProjectPresenter.h"
#import "CheckProject.h"

@interface BSCheckProjectViewController ()<UITableViewDelegate, UITableViewDataSource, checkProjectNameDelegate, UITextFieldDelegate>

@property (weak, nonatomic  ) IBOutlet UITextField *searchTF;
@property (weak, nonatomic  ) IBOutlet UIButton    *searchBtn;
@property (weak, nonatomic  ) IBOutlet UITableView *listTableView;

@property (nonatomic, strong) CheckProjectPresenter *presenter;
@property (nonatomic, strong) NSArray               *dataArray;
@property (nonatomic, strong) NSMutableArray        *searchDataArray;

@end

@implementation BSCheckProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)setupView {
    
    self.presenter = [[CheckProjectPresenter alloc] init];
    self.presenter.delegate = self;
    [ProgressUtil show];
    [self.presenter request];
    
    self.title = @"检查项目";
    self.listTableView.rowHeight = 50.5;
    [self.listTableView registerNib:[UINib nibWithNibName:@"BSCheckProjectCell" bundle:nil] forCellReuseIdentifier:@"cell"];

    self.listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _searchTF.delegate = self;
    [_searchTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_searchBtn.tag == 0) {
        return self.dataArray.count;
    } else {
        return _searchDataArray.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BSCheckProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.model = self.dataArray[indexPath.row];
    
    if (_searchBtn.tag == 0) {
        
        cell.model = self.dataArray[indexPath.row];
    } else {
        
        cell.model = [_searchDataArray objectAtIndex:indexPath.row];
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_searchBtn.tag == 0) {
        
        CheckProject *model = [self.dataArray objectAtIndex:indexPath.row];
        _sendName(model.projectName, model.projectID);
    } else {
        CheckProject *model = [_searchDataArray objectAtIndex:indexPath.row];
        _sendName(model.projectName, model.projectID);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)sendData:(NSArray *)dataArray {
    
    self.dataArray = dataArray;
    [self.listTableView reloadData];
    
}

- (void)textFieldDidChange:(UITextField *)textField {
    if ([textField.text isEqualToString:@""]) {
        _searchBtn.tag = 0;
        [_searchDataArray removeAllObjects];
        [_listTableView reloadData];
        NSLog(@"空");
    }
}

- (IBAction)btnAction:(id)sender {
    
    if (_searchTF.text.length == 0) {
        _searchBtn.tag = 0;
    }else {
        _searchBtn.tag = 1;
    }
    _searchDataArray = [NSMutableArray array];
    
    NSMutableArray *tempStrArray = [NSMutableArray array];
    for (CheckProject *model in _dataArray) {
        [tempStrArray addObject:model.projectName];
    }
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", _searchTF.text];
    NSArray *tempSearchStr = [[tempStrArray filteredArrayUsingPredicate:searchPredicate] mutableCopy];
    
    for (NSString *str in tempSearchStr) {
        for (CheckProject *model in _dataArray) {
            if ([str isEqualToString:model.projectName]) {
                if (![_searchDataArray containsObject:model]) {
                    [_searchDataArray addObject:model];
                }
            }
        }
    }
    
    [_listTableView reloadData];
    [_searchTF resignFirstResponder];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _listTableView) {
        [_searchTF resignFirstResponder];
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
