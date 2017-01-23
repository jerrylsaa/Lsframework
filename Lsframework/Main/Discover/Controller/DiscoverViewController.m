//
//  DiscoverViewController.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/8/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "DiscoverViewController.h"
#import "DiscoverPresenter.h"
#import "DefaultChildEntity.h"
#import "HRHealthAssessmentViewController.h"
#import "ArchivesMainViewController.h"
#import "PersonFileViewController.h"
#import "CorePhotoPickerVCManager.h"
#import "QuestDetailViewController.h"
#import "DiscoverHealthLogTableViewCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "EditHealthLogViewController.h"
#import "ScreenAppraiseController.h"


@interface DiscoverViewController ()<UITableViewDataSource,UITableViewDelegate,DiscoverPresenterDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
@property (nonatomic,strong) DiscoverPresenter *presenter;
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UIView *questView;
@property (nonatomic,strong) UILabel *questLabel;

@property (nonatomic,strong) UIView *titleView;
@property (nonatomic,strong) UIView *photoGraphView;
@property (nonatomic,strong) UIImageView *leftTopIV;
@property (nonatomic,strong) UIImageView *leftBottomIV;
@property (nonatomic,strong) UIImageView *middleIV;
@property (nonatomic,strong) UIImageView *rightTopIV;
@property (nonatomic,strong) UIImageView *rightBottomIV;
@property (nonatomic,assign) NSInteger photoIVTag;

@property(nonatomic,retain) UITableView *table;

@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"宝宝日记";
    
//    [self initBackBarWithImage:nil];
    
    // Do any additional setup after loading the view.
}
#pragma mark---umeng页面统计
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"发现"];
//    self.hidesBottomBarWhenPushed =NO;

    [self.presenter getQuestNumber];
    [self.presenter getPhotoGraphUrls];
    [self.presenter getHealthcareLogList];
     
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"发现"];
    
}

-(void)setupView{
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    
    self.presenter = [DiscoverPresenter new];
    self.presenter.delegate = self;
    
    _table = [UITableView new];
    _table.dataSource = self;
    _table.delegate = self;
    _table.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_table];
    _table.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    _headerView =[UIView new];
    
    
    [self setupQuestView];
//    [self setupTitleView];
    [self setupPhotoGraphView];
    [self setupLogTableView];
    
    
    _table.tableHeaderView = _headerView;
    
}

- (void)setupQuestView{
    UITapGestureRecognizer *questTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(questTapAction)];
    _questView =[UIView new];
    _questView.userInteractionEnabled =YES;
    [_questView addGestureRecognizer:questTap];
    [_headerView addSubview:_questView];
    
    UIImageView *tipIV =[UIImageView new];
    tipIV.image =[UIImage imageNamed:@"tipImage"];
    [_questView addSubview:tipIV];
    
    _questLabel =[UILabel new];
    _questLabel.textColor =UIColorFromRGB(0x666666);
    _questLabel.textAlignment =NSTextAlignmentLeft;
    _questLabel.font =[UIFont systemFontOfSize:14];
    [_questView addSubview:_questLabel];
    
    UIView *bottomLine =[UIView new];
    bottomLine.backgroundColor =UIColorFromRGB(0xf2f2f2);
    [_questView addSubview:bottomLine];
    
    
    _questView.sd_layout.topSpaceToView(_headerView,0).leftSpaceToView(_headerView,0).rightSpaceToView(_headerView,0).heightIs(47);
    tipIV.sd_layout.leftSpaceToView(_questView,15).topSpaceToView(_questView,15).widthIs(16).heightIs(16);
    _questLabel.sd_layout.leftSpaceToView(tipIV,15).centerYEqualToView(tipIV).rightSpaceToView(_questView,0).heightIs(16);
    bottomLine.sd_layout.bottomSpaceToView(_questView,0).leftSpaceToView(_questView,0).rightSpaceToView(_questView,0).heightIs(1);
}

- (void)questTapAction{
    NSLog(@"点击任务列表");
        
    [self.navigationController pushViewController:[QuestDetailViewController new] animated:NO];
    
}

- (void)setupTitleView{
    _titleView =[UIView new];
    [_headerView addSubview:_titleView];
    
    UITapGestureRecognizer *leftTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recordBtnAction)];
    
    UIImageView *leftIV =[UIImageView new];
    leftIV.image =[UIImage imageNamed:@"reportBtn"];
    leftIV.userInteractionEnabled =YES;
    [leftIV addGestureRecognizer:leftTap];
    [_titleView addSubview:leftIV];
    
    UILabel *leftLabel =[UILabel new];
    leftLabel.text =@"医院报告";
    leftLabel.textColor =UIColorFromRGB(0x666666);
    leftLabel.font =[UIFont systemFontOfSize:14];
    [_titleView addSubview:leftLabel];
    
    UITapGestureRecognizer *midTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personFileAction)];
    
    UIImageView *midIV =[UIImageView new];
    midIV.image =[UIImage imageNamed:@"personfileBtn"];
    midIV.userInteractionEnabled =YES;
    [midIV addGestureRecognizer:midTap];
    [_titleView addSubview:midIV];
    
    UILabel *midLabel =[UILabel new];
    midLabel.text =@"基本信息";
    midLabel.textColor =UIColorFromRGB(0x666666);
    midLabel.font =[UIFont systemFontOfSize:14];
    [_titleView addSubview:midLabel];
    
    UITapGestureRecognizer *rightTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenBtnAction)];
    
    UIImageView *rightIV =[UIImageView new];
    rightIV.image =[UIImage imageNamed:@"screenBtn"];
    rightIV.userInteractionEnabled =YES;
    [rightIV addGestureRecognizer:rightTap];
    [_titleView addSubview:rightIV];
    
    UILabel *rightLabel =[UILabel new];
    rightLabel.text =@"测评结果";
    rightLabel.textColor =UIColorFromRGB(0x666666);
    rightLabel.font =[UIFont systemFontOfSize:14];
    [_titleView addSubview:rightLabel];
    
    
    
    _titleView.sd_layout.topSpaceToView(_questView,0).leftSpaceToView(_headerView,0).rightSpaceToView(_headerView,0).heightIs(145);
    
    CGFloat width =(kScreenWidth-80-45*3)/2;
    
    midIV.sd_layout.topSpaceToView(_titleView,35).centerXEqualToView(_titleView).widthIs(45).heightIs(45);
    midLabel.sd_layout.topSpaceToView(midIV,10).centerXEqualToView(midIV).heightIs(15).widthIs(60);
    
    leftIV.sd_layout.topSpaceToView(_titleView,35).rightSpaceToView(midIV,width).widthIs(45).heightIs(45);
    leftLabel.sd_layout.topSpaceToView(leftIV,10).centerXEqualToView(leftIV).heightIs(15).widthIs(60);
    
    rightIV.sd_layout.topSpaceToView(_titleView,35).leftSpaceToView(midIV,width).widthIs(45).heightIs(45);
    rightLabel.sd_layout.topSpaceToView(leftIV,10).centerXEqualToView(rightIV).heightIs(15).widthIs(60);
}

- (void)setupPhotoGraphView{
    _photoGraphView =[UIView new];
    [_headerView addSubview:_photoGraphView];
    
    UILabel *titleLabel =[UILabel new];
    titleLabel.textColor =UIColorFromRGB(0x999999);
    titleLabel.text =@"· 照片墙 ·";
    titleLabel.textAlignment =NSTextAlignmentCenter;
    titleLabel.font =[UIFont systemFontOfSize:19];
    [_photoGraphView addSubview:titleLabel];
    
    UITapGestureRecognizer *tap1001 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToImageViewGesture:)];
    UITapGestureRecognizer *tap1002 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToImageViewGesture:)];
    UITapGestureRecognizer *tap1003 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToImageViewGesture:)];
    UITapGestureRecognizer *tap1004 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToImageViewGesture:)];
    UITapGestureRecognizer *tap1005 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToImageViewGesture:)];
    
    _leftTopIV =[UIImageView new];
    _leftTopIV.tag =1001;
    _leftTopIV.contentMode =UIViewContentModeScaleAspectFill;
    [_leftTopIV.layer setBorderWidth:5];
    [_leftTopIV.layer setBorderColor:RGB(237,246,246).CGColor];
    _leftTopIV.clipsToBounds =YES;
    _leftTopIV.image =[UIImage imageNamed:@"leftTopImage"];
    _leftTopIV.userInteractionEnabled =YES;
    [_leftTopIV addGestureRecognizer:tap1001];
    [_photoGraphView addSubview:_leftTopIV];
    
    _leftBottomIV =[UIImageView new];
    _leftBottomIV.tag =1002;
    _leftBottomIV.contentMode =UIViewContentModeScaleAspectFill;
    [_leftBottomIV.layer setBorderWidth:5];
    [_leftBottomIV.layer setBorderColor:RGB(237,246,246).CGColor];
    _leftBottomIV.clipsToBounds =YES;
    _leftBottomIV.image =[UIImage imageNamed:@"leftBottomImage"];
    _leftBottomIV.userInteractionEnabled =YES;
    [_leftBottomIV addGestureRecognizer:tap1002];
    [_photoGraphView addSubview:_leftBottomIV];
    
    _middleIV =[UIImageView new];
    _middleIV.tag =1003;
    _middleIV.contentMode =UIViewContentModeScaleAspectFill;
    [_middleIV.layer setBorderWidth:5];
    [_middleIV.layer setBorderColor:RGB(237,246,246).CGColor];
    _middleIV.clipsToBounds =YES;
    _middleIV.image =[UIImage imageNamed:@"middleImage"];
    _middleIV.userInteractionEnabled =YES;
    [_middleIV addGestureRecognizer:tap1003];
    [_photoGraphView addSubview:_middleIV];
    
    _rightTopIV =[UIImageView new];
    _rightTopIV.tag =1004;
    _rightTopIV.contentMode =UIViewContentModeScaleAspectFill;
    [_rightTopIV.layer setBorderWidth:5];
    [_rightTopIV.layer setBorderColor:RGB(237,246,246).CGColor];
    _rightTopIV.clipsToBounds =YES;
    _rightTopIV.image =[UIImage imageNamed:@"rightTopImage"];
    _rightTopIV.userInteractionEnabled =YES;
    [_rightTopIV addGestureRecognizer:tap1004];
    [_photoGraphView addSubview:_rightTopIV];
    
    _rightBottomIV =[UIImageView new];
    _rightBottomIV.tag =1005;
    _rightBottomIV.contentMode =UIViewContentModeScaleAspectFill;
    [_rightBottomIV.layer setBorderWidth:5];
    [_rightBottomIV.layer setBorderColor:RGB(237,246,246).CGColor];
    _rightBottomIV.clipsToBounds =YES;
    _rightBottomIV.image =[UIImage imageNamed:@"rightBottomImage"];
    _rightBottomIV.userInteractionEnabled =YES;
    [_rightBottomIV addGestureRecognizer:tap1005];
    [_photoGraphView addSubview:_rightBottomIV];
    
    CGFloat otherWidth= (kScreenWidth-20)/3.3;
    CGFloat midWidth= ((kScreenWidth-20)*1.3)/3.3;

    
    _photoGraphView.sd_layout.topSpaceToView(_questView,20).leftSpaceToView(_headerView,0).rightSpaceToView(_headerView,0).heightIs(232);//232
    titleLabel.sd_layout.topSpaceToView(_photoGraphView,0).centerXEqualToView(_photoGraphView).heightIs(20).widthIs(100);
    _leftTopIV.sd_layout.topSpaceToView(titleLabel,25).leftSpaceToView(_photoGraphView,5).widthIs(otherWidth).heightIs(108);
    _leftBottomIV.sd_layout.topSpaceToView(_leftTopIV,5).leftEqualToView(_leftTopIV).widthIs(otherWidth).heightIs(64);
    _middleIV.sd_layout.topSpaceToView(titleLabel,25).leftSpaceToView(_leftTopIV,5).widthIs(midWidth).heightIs(177);
    _rightTopIV.sd_layout.topSpaceToView(titleLabel,25).leftSpaceToView(_middleIV,5).widthIs(otherWidth).heightIs(108);
    _rightBottomIV.sd_layout.topSpaceToView(_rightTopIV,5).leftSpaceToView(_middleIV,5).widthIs(otherWidth).heightIs(64);
}

- (void)setupLogTableView{
    
    UILabel *titleLabel =[UILabel new];
    titleLabel.text =@"· 日记 ·";
    titleLabel.font =[UIFont systemFontOfSize:19];
    titleLabel.textColor =UIColorFromRGB(0x999999);
    titleLabel.textAlignment =NSTextAlignmentCenter;
    [_headerView addSubview:titleLabel];
    
    
    titleLabel.sd_layout.topSpaceToView(_photoGraphView,30).centerXEqualToView(_headerView).heightIs(20).widthIs(150);
    
    _headerView.width =kScreenWidth;
    _headerView.height =504;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.presenter.logDataSource.count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cell";
    
    
    DiscoverHealthLogTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell = [[DiscoverHealthLogTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    cell.logEntity = [self.presenter.logDataSource objectAtIndex:indexPath.row];
    
    
    cell.sd_indexPath = indexPath;
    cell.sd_tableView = _table;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DiscoverHealthLogTableViewCell* cell =[tableView cellForRowAtIndexPath:indexPath];
    if (cell.isEdited==NO) {
        NSLog(@"点击编辑");
        EditHealthLogViewController *vc =[EditHealthLogViewController new];
        vc.dlID =cell.logEntity.dlID;
        vc.DayNum =cell.logEntity.DayNum;
        vc.CreateTime =cell.logEntity.CreateTime;
        vc.LogContent =cell.logEntity.LogContent;
        [self.navigationController pushViewController:vc animated:NO];

    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [_table cellHeightForIndexPath:indexPath model:self.presenter.logDataSource[indexPath.row] keyPath:@"logEntity" cellClass:[DiscoverHealthLogTableViewCell class] contentViewWidth:[self cellContentViewWith]];
    
}

- (CGFloat)cellContentViewWith
{
    CGFloat width = kScreenWidth;
    
    // 适配ios7
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

- (void)recordBtnAction{
    NSArray *entityArray = [DefaultChildEntity MR_findAll];
    if (entityArray.count > 0) {
        DefaultChildEntity *entity = entityArray.lastObject;
        if ([entity.babyID intValue] != 0) {
            [self.navigationController pushViewController:[HRHealthAssessmentViewController new] animated:YES];
        }else{
            [self.navigationController pushViewController:[[ArchivesMainViewController alloc] init] animated:YES];
        }
    }else{
        [self.navigationController pushViewController:[[ArchivesMainViewController alloc] init] animated:YES];
    }
}

- (void)personFileAction{
    NSArray *entityArray = [DefaultChildEntity MR_findAll];
    if (entityArray.count > 0) {
        DefaultChildEntity *entity = entityArray.lastObject;
        if ([entity.babyID intValue] != 0) {
            [self.navigationController pushViewController:[PersonFileViewController new] animated:YES];
            
        }else{
            [self.navigationController pushViewController:[[ArchivesMainViewController alloc] init] animated:YES];
        }
    }else{
        [self.navigationController pushViewController:[[ArchivesMainViewController alloc] init] animated:YES];
    }
}

- (void)screenBtnAction{
    NSLog(@"点击测评结果");
    [self.navigationController pushViewController:[ScreenAppraiseController new] animated:YES];
}

- (void)tapToImageViewGesture:(UITapGestureRecognizer *)tap{
    _photoIVTag =tap.view.tag;
    NSLog(@"%d",_photoIVTag);

    [self showSheet];
}

- (void)showSheet {
    WS(ws);
    if([[[UIDevice currentDevice] systemVersion] floatValue]  >= 8.0) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *uploadPhotos = [UIAlertAction actionWithTitle:@"上传照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"上传照片");
            [ws pickPhoto];
        }];
        
        UIAlertAction *uploadPhotosByCamera = [UIAlertAction actionWithTitle:@"拍照上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"拍照上传");
            [ws takePhoto];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:uploadPhotos];
        [alert addAction:uploadPhotosByCamera];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }else {
        
        UIActionSheet* sheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"上传照片", @"拍照上传", nil];
        sheet.tag =1009;
        [sheet showInView:self.view];
        
    }
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag ==1009){
        
        if (buttonIndex == 0) {
            NSLog(@"上传照片");
            [self pickPhoto];
        }else if (buttonIndex == 1) {
            NSLog(@"拍照上传");
            [self takePhoto];
        }else if (buttonIndex == 2) {
            NSLog(@"取消");
        }
        
    }

}

-(void)pickPhoto{
    WS(ws);
    
    CorePhotoPickerVCManager *manager=[CorePhotoPickerVCManager new];
    
    //设置类型
    manager.pickerVCManagerType = CorePhotoPickerVCMangerTypeMultiPhoto;
    
    //最多可选3张
    manager.maxSelectedPhotoNumber = 1;
    
    //错误处理
    if(manager.unavailableType!=CorePhotoPickerUnavailableTypeNone){
        NSLog(@"设备不可用");
        return;
    }
    
    UIViewController *pickerVC=manager.imagePickerController;
    
    //选取结束
    manager.finishPickingMedia=^(NSArray *medias){
            
            NSLog(@"%d", medias.count);
            
            for (CorePhoto *photo in medias) {
                
                [ws.presenter uploadPhoto:photo.editedImage];
                NSLog(@"%@", photo);
            }
    };
    
    [ws presentViewController:pickerVC animated:YES completion:nil];
}

-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    WS(ws);
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    // 判断获取类型：图片
    if ([mediaType isEqualToString:( NSString *)kUTTypeImage]){
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        [ws.presenter uploadPhoto:image];
        
    }
    
    
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        
    }];
    
    
    
}


- (void)onGetQuestNumberCompletion:(BOOL)success info:(NSString *)message questNumber:(NSInteger )number{
    _questLabel.text =[NSString stringWithFormat:@"任务列表:您最近30天有%d项任务",number];
}

- (void)uploadPhotoDataOnCompletion:(BOOL)success info:(NSString*)message urlPhotoPath:(NSString *)photoPath{
    if (success) {
        UIImageView *imageView =[_photoGraphView viewWithTag:_photoIVTag];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,photoPath]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"] ];
        [self.presenter uploadPhotoUrl:photoPath photoNum:_photoIVTag];
        
    }
    
}


- (void)onGetPhotoUrlCompletion:(BOOL)success info:(NSString *)message dataDictionary:(NSDictionary *)dict{
    if (success) {
        NSString *url1 =[dict objectForKey:@"PhotoUrl1"];
        NSString *url2 =[dict objectForKey:@"PhotoUrl2"];
        NSString *url3 =[dict objectForKey:@"PhotoUrl3"];
        NSString *url4 =[dict objectForKey:@"PhotoUrl4"];
        NSString *url5 =[dict objectForKey:@"PhotoUrl5"];

        if (url1!=nil&&url1.length>4) {
            [_leftTopIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,url1]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"] ];
        }
        if (url2!=nil&&url2.length>4) {
            [_leftBottomIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,url2]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"] ];
        }
        if (url3!=nil&&url3.length>4) {
            [_middleIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,url3]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"] ];
        }
        if (url4!=nil&&url4.length>4) {
            [_rightTopIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,url4]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"] ];
        }
        if (url5!=nil&&url5.length>4) {
            [_rightBottomIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,url5]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"] ];
        }
    }
}

- (void)onGetLogListCompletion:(BOOL)success info:(NSString *)messsage{
    if(success){
        [_table reloadData];
    }else{
        [ProgressUtil showError:messsage];
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
