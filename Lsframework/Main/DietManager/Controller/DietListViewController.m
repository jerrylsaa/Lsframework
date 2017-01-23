//
//  DietListViewController.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/11/15.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "DietListViewController.h"
#import "FoodListCell.h"
#import "CorePhotoPickerVCManager.h"
#import "DietManagerPresenter.h"
#import "FoodResultCell.h"
#import "DietAnalysisCell.h"
#import "DMMyDietAnalysisEntity.h"
#import "UITableView+SDAutoTableViewCellHeight.h"

@interface DietListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,DietManagerPresenterDelegate,UITableViewDelegate, UITableViewDataSource,FoodResultCellDelegate>
@property(nonatomic,retain) DietManagerPresenter *presenter;
@property(nonatomic,retain) UIScrollView *scrollView;
@property(nonatomic,retain) UIView *topView;
@property(nonatomic,retain) UITextField *searchField;
@property(nonatomic,retain) UIButton *searchBtn;

@property(nonatomic,retain) UIImageView *hotKeyLine;
@property(nonatomic,strong) UICollectionView *hotFoodView;

@property(nonatomic,retain) UIScrollView *foodListView;
@property(nonatomic,strong) UIView *foodPhotoView;
@property(nonatomic,retain) NSMutableArray *foodImageViewArr;
@property(nonatomic,retain) UIButton *photoSearchBtn;
@property(nonatomic,retain) UILabel *photoSearchLabel;

@property(nonatomic,retain) NSMutableArray *foodImageUrlArr;

@property(nonatomic,retain) UITableView* table;
@property(nonatomic,retain) UILabel *searchResultLabel;
@property(nonatomic,retain) UIImageView *searchResultLine;
@property(nonatomic,retain) UIButton *cancelBtn;

@property(nonatomic,retain) UITableView *analysisTable;
@property(nonatomic,assign) CGFloat height;
@end

@implementation DietListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor =[UIColor whiteColor];
    self.title =@"膳食管理";
    [ProgressUtil show];
    [_presenter getUserFoodList];
    
    [ProgressUtil show];
    [_presenter getHotKeyWord];
    
    
}

- (void)setupView{
    _presenter =[DietManagerPresenter new];
    _presenter.delegate =self;
    
    _scrollView =[UIScrollView new];
    _scrollView.backgroundColor =UIColorFromRGB(0xf2f2f2);
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    _topView =[UIView new];
    _topView.backgroundColor =[UIColor whiteColor];
    [_scrollView addSubview:_topView];
    
    UIImageView *textFiledBG =[UIImageView new];
    textFiledBG.image =[UIImage imageNamed:@"textFieldBG"];
    [_topView addSubview:textFiledBG];
    
    UIImageView *textFieldIcon =[UIImageView new];
    textFieldIcon.image =[UIImage imageNamed:@"textFileldIcon"];
    [_topView addSubview:textFieldIcon];
    
    _searchField =[UITextField new];
    _searchField.textColor =UIColorFromRGB(0x333333);
    _searchField.font =[UIFont systemFontOfSize:15.0f];
    _searchField.placeholder =@"输入食材名称";
    [_topView addSubview:_searchField];
//
    _searchBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [_searchBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    [_searchBtn setBackgroundImage:[UIImage imageNamed:@"searchBtnBG"] forState:UIControlStateNormal];
    [_searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    _searchBtn.titleLabel.font =[UIFont systemFontOfSize:15.0f];
    [_topView addSubview:_searchBtn];
    
    UILabel *hotKeyLabel =[UILabel new];
    hotKeyLabel.textColor =UIColorFromRGB(0x61d8d3);
    hotKeyLabel.text =@"热门关键字";
    hotKeyLabel.font =[UIFont boldSystemFontOfSize:15.0f];
    [_scrollView addSubview:hotKeyLabel];
    
    _hotKeyLine =[UIImageView new];
    _hotKeyLine.backgroundColor =UIColorFromRGB(0x61d8d3);
    [_scrollView addSubview:_hotKeyLine];
    
    UICollectionViewFlowLayout* layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _hotFoodView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _hotFoodView.delegate = self;
    _hotFoodView.dataSource = self;
    _hotFoodView.backgroundColor = [UIColor whiteColor];
    _hotFoodView.showsVerticalScrollIndicator = NO;
    _hotFoodView.scrollEnabled = NO;
    
    [_hotFoodView registerClass:[FoodListCell class] forCellWithReuseIdentifier:@"cell"];
    [_scrollView addSubview:_hotFoodView];
    
    UILabel *foodListLabel =[UILabel new];
    foodListLabel.textColor =UIColorFromRGB(0x61d8d3);
    foodListLabel.text =@"食材列表";
    foodListLabel.font =[UIFont boldSystemFontOfSize:15.0f];
    [_scrollView addSubview:foodListLabel];
    
    UIImageView *foodListLine =[UIImageView new];
    foodListLine.backgroundColor =UIColorFromRGB(0x61d8d3);
    [_scrollView addSubview:foodListLine];
    
    _foodListView =[UIScrollView new];
    _foodListView.backgroundColor =[UIColor whiteColor];
    _foodListView.showsHorizontalScrollIndicator = NO;
//    _foodListView.
    [_scrollView addSubview:_foodListView];
    
    _foodPhotoView =[UIView new];
    _foodPhotoView.hidden =YES;
    _foodPhotoView.backgroundColor =[UIColor whiteColor];
    [_foodListView addSubview:_foodPhotoView];
    
    _foodImageViewArr =[NSMutableArray array];
    for (int i =0; i<3; i++) {
        UIView *photoBGView =[UIView new];
        photoBGView.backgroundColor =[UIColor whiteColor];
        [_foodPhotoView addSubview:photoBGView];
        [_foodImageViewArr addObject:photoBGView];

        
        UIImageView * photoImage =[UIImageView new];
        photoImage.contentMode =UIViewContentModeScaleAspectFill;
//        photoImage.image =[UIImage imageNamed:@"CouponImage_60"];
        photoImage.userInteractionEnabled = YES;
        photoImage.tag = 3000 + i;
        photoImage.layer.cornerRadius =5;
        [photoImage.layer setBorderWidth:0.5];
        [photoImage.layer setBorderColor:[UIColor clearColor].CGColor];
        photoImage.clipsToBounds =YES;
        [photoBGView addSubview:photoImage];
        
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
        [photoImage addGestureRecognizer:tap];
        
        //删除按钮
        UIButton* deletebt = [UIButton new];
        deletebt.tag =4000+i;
        [deletebt setBackgroundImage:[UIImage imageNamed:@"circle_del_icon1"] forState:UIControlStateNormal];
        [deletebt addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        [photoBGView addSubview:deletebt];
        
        photoBGView.sd_layout.centerYEqualToView(_foodPhotoView).leftSpaceToView(_foodPhotoView,(i)*105).widthIs(90).heightIs(100);
        
        photoImage.sd_layout.spaceToSuperView(UIEdgeInsetsMake(10, 5, 10, 5));
        
        
        deletebt.sd_layout.leftSpaceToView(photoImage,-15).bottomSpaceToView(photoImage,-15).widthIs(25).heightEqualToWidth();

        
    }
    
    _photoSearchBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [_photoSearchBtn setImage:[UIImage imageNamed:@"photoSearchBtn"] forState:UIControlStateNormal];
    [_photoSearchBtn addTarget:self action:@selector(uploadPhotoAction) forControlEvents:UIControlEventTouchUpInside];
    [_foodListView addSubview:_photoSearchBtn];
    
    _photoSearchLabel =[UILabel new];
    _photoSearchLabel.textColor =UIColorFromRGB(0x666666);
    _photoSearchLabel.font =[UIFont systemFontOfSize:13.0f];
    _photoSearchLabel.text =@"拍照片搜索更方便!";
    [_foodListView addSubview:_photoSearchLabel];
    
    
    _searchResultLabel =[UILabel new];
    _searchResultLabel.hidden =YES;
    _searchResultLabel.textColor =UIColorFromRGB(0x61d8d3);
    _searchResultLabel.text =@"搜索结果";
    _searchResultLabel.font =[UIFont boldSystemFontOfSize:15.0f];
    [_scrollView addSubview:_searchResultLabel];
    
    _searchResultLine =[UIImageView new];
    _searchResultLine.backgroundColor =UIColorFromRGB(0x61d8d3);
    [_scrollView addSubview:_searchResultLine];
    
    _cancelBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    _cancelBtn.hidden =YES;
    [_cancelBtn setTitle:@"取消搜索" forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(cancelSearch) forControlEvents:UIControlEventTouchUpInside];
    [_cancelBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    _cancelBtn.titleLabel.font =[UIFont systemFontOfSize:14.0f];
    [_scrollView addSubview:_cancelBtn];
    
    _table = [UITableView new];
    _table.tag =1001;
    _table.backgroundColor =UIColorFromRGB(0xf2f2f2);
    _table.dataSource = self;
    _table.delegate = self;
    _table.scrollEnabled =NO;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_scrollView addSubview:_table];
    
    [_table registerClass:[FoodResultCell class] forCellReuseIdentifier:@"foodResultCell"];
    
    
    UIImageView *foodAnalysisLine =[UIImageView new];
    foodAnalysisLine.backgroundColor =UIColorFromRGB(0x61d8d3);
    [_scrollView addSubview:foodAnalysisLine];
    
    UILabel *foodAnalysisLabel =[UILabel new];
    foodAnalysisLabel.textAlignment =NSTextAlignmentCenter;
    foodAnalysisLabel.backgroundColor =UIColorFromRGB(0xf2f2f2);
    foodAnalysisLabel.textColor =UIColorFromRGB(0x61d8d3);
    foodAnalysisLabel.text =@"营养分析";
    foodAnalysisLabel.font =[UIFont boldSystemFontOfSize:14.0f];
    [_scrollView addSubview:foodAnalysisLabel];
    
    UIImageView *foodAnalysisIcon =[UIImageView new];
    foodAnalysisIcon.image =[UIImage imageNamed:@"foodAnalysisIcon"];
    [_scrollView addSubview:foodAnalysisIcon];
    
    
    _analysisTable = [UITableView new];
    _analysisTable.tag =1002;
    _analysisTable.backgroundColor =UIColorFromRGB(0xf2f2f2);
    _analysisTable.dataSource = self;
    _analysisTable.delegate = self;
    _analysisTable.scrollEnabled =NO;
    _analysisTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_scrollView addSubview:_analysisTable];
    
    [_analysisTable registerClass:[DietAnalysisCell class] forCellReuseIdentifier:@"dietAnalysisCell"];
    
    _scrollView.sd_layout.topSpaceToView(self.view,0).leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
    
    _topView.sd_layout.topSpaceToView(_scrollView,0).leftSpaceToView(_scrollView,0).rightSpaceToView(_scrollView,0).heightIs(55);
    _searchBtn.sd_layout.centerYEqualToView(_topView).rightSpaceToView(_topView,15).widthIs(60).heightIs(35);
    textFiledBG.sd_layout.leftSpaceToView(_topView,15).rightSpaceToView(_searchBtn,15).centerYEqualToView(_topView).heightIs(35);
    textFieldIcon.sd_layout.leftSpaceToView(_topView,25).centerYEqualToView(_topView).widthIs(22).heightIs(22);
    _searchField.sd_layout.leftSpaceToView(textFieldIcon,10).rightSpaceToView(_searchBtn,25).centerYEqualToView(_topView).heightIs(25);
    hotKeyLabel.sd_layout.leftSpaceToView(_scrollView,15).topSpaceToView(_topView,15).widthIs(100).heightIs(30);
    _hotKeyLine.sd_layout.leftSpaceToView(_scrollView,15).topSpaceToView(hotKeyLabel,5).rightSpaceToView(_scrollView,15).heightIs(1);
    
    _hotFoodView.sd_layout.leftSpaceToView(_scrollView,15).rightSpaceToView(_scrollView,15).topSpaceToView(_hotKeyLine,10).heightIs(132);
    
    foodListLabel.sd_layout.leftSpaceToView(_scrollView,15).topSpaceToView(_hotFoodView,15).widthIs(100).heightIs(30);
    foodListLine.sd_layout.leftSpaceToView(_scrollView,15).topSpaceToView(foodListLabel,5).rightSpaceToView(_scrollView,15).heightIs(1);
    
    _foodListView.sd_layout.topSpaceToView(foodListLine,10).leftSpaceToView(_scrollView,15).rightSpaceToView(_scrollView,15).heightIs(100);
    _foodPhotoView.sd_layout.centerYEqualToView(_foodListView).leftSpaceToView(_foodListView,10).heightIs(100).widthIs(0);
    
    _photoSearchBtn.sd_layout.centerYEqualToView(_foodListView).leftSpaceToView(_foodPhotoView,15).heightIs(60).widthIs(60);
    _photoSearchLabel.sd_layout.leftSpaceToView(_photoSearchBtn,20).centerYEqualToView(_foodListView).heightIs(25).widthIs(150);
    [_foodListView setupAutoContentSizeWithRightView:_photoSearchLabel rightMargin:15];
    _searchResultLabel.sd_layout.leftSpaceToView(_scrollView,15).topSpaceToView(_foodListView,0).widthIs(100).heightIs(0);
    _searchResultLine.sd_layout.leftSpaceToView(_scrollView,15).topSpaceToView(_searchResultLabel,0).rightSpaceToView(_scrollView,15).heightIs(0);
    _cancelBtn.sd_layout.rightEqualToView(_searchResultLine).bottomSpaceToView(_searchResultLine,10).widthIs(80).heightIs(0);
    
    
    _table.sd_layout.topSpaceToView(_searchResultLine,0).leftSpaceToView(_scrollView,15).rightSpaceToView(_scrollView,15).heightIs(0);
    
    foodAnalysisLine.sd_layout.topSpaceToView(_table,15).leftSpaceToView(_scrollView,15).rightSpaceToView(_scrollView,15).heightIs(1);
    foodAnalysisLabel.sd_layout.centerYEqualToView(foodAnalysisLine).leftSpaceToView(_scrollView,(kScreenWidth/2.0f)-36.0f).heightIs(25).widthIs(65);
    foodAnalysisIcon.sd_layout.centerYEqualToView(foodAnalysisLine).leftSpaceToView(foodAnalysisLabel,0).heightIs(16.0f).widthIs(16.0f);
    
    _analysisTable.sd_layout.topSpaceToView(_table,30).leftSpaceToView(_scrollView,15).rightSpaceToView(_scrollView,15).heightIs(200);
    
    
    [_scrollView setupAutoHeightWithBottomView:_analysisTable bottomMargin:15];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _presenter.hotKeySource.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
        FoodListCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        
        cell.hotKeyEntity =_presenter.hotKeySource[indexPath.item];
    
        return cell;
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(8.0f,8.0f,8.0f,8.0f);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(((kScreenWidth-48.0f-30.0f)/5.0f), 34.0f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 7.0f;
}
//
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 7.8f;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了%ld",(long)indexPath.item);
    FoodListCell *cell =(FoodListCell *)[collectionView cellForItemAtIndexPath:indexPath];
    _searchField.text =cell.hotKeyEntity.KEYWORD;
    
}

#pragma mark - 代理
/**
 *  tableView的数据源代理
 *
 *  @param tableView <#tableView description#>
 *  @param section   <#section description#>
 *
 *  @return <#return value description#>
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag ==1001) {
        return _presenter.foodSearchResultSource.count;

    }else{
        return _presenter.myDietAnalysisSource.count;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag ==1001) {
        
    
        FoodResultCell* cell=[tableView dequeueReusableCellWithIdentifier:@"foodResultCell"];
        
        cell.foodEntity =_presenter.foodSearchResultSource[indexPath.row];
        
        if(!cell.delegate){
            cell.delegate = self;
        }
        
//        cell.sd_indexPath = indexPath;
//        cell.sd_tableView = tableView;
        
        return cell;
    }else{
        DietAnalysisCell* cell=[tableView dequeueReusableCellWithIdentifier:@"dietAnalysisCell"];
        cell.illMatched =_presenter.myDietIllSource[indexPath.row];
        cell.dietAnalysis =_presenter.myDietAnalysisSource[indexPath.row];
        
        
        cell.sd_indexPath = indexPath;
        cell.sd_tableView = tableView;
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"点击单元格");
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag ==1001) {
        return 100;

    }else {
        DMMyDietAnalysisEntity *myAnalysis= self.presenter.myDietAnalysisSource[indexPath.row];
        _height+=[tableView cellHeightForIndexPath:indexPath model:myAnalysis keyPath:@"dietAnalysis" cellClass:[DietAnalysisCell class] contentViewWidth:[self cellContentViewWith]];
        return [tableView cellHeightForIndexPath:indexPath model:myAnalysis keyPath:@"dietAnalysis" cellClass:[DietAnalysisCell class] contentViewWidth:[self cellContentViewWith]];
    }
}

- (CGFloat)cellContentViewWith{
    CGFloat width = kScreenWidth-25;
    
    // 适配ios7
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

- (void)uploadPhotoAction{
    if (_presenter.myFoodListSource.count==3) {
        [ProgressUtil showInfo:@"最多只能选择3种食材"];
        return;
    }
    
    UIActionSheet* sheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"上传照片", @"拍照上传", nil];
    sheet.tag =1001;
    [sheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag ==1001){
        
        if (buttonIndex == 0) {
            NSLog(@"上传照片");
            [self pickPhoto];
    #pragma 打点统计*膳食管理->拍照
            [BasePresenter  EventStatisticalDotTitle:DotDietManagerFoodCamera Action:DotEventEnter  Remark:nil];

        }else if (buttonIndex == 1) {
            NSLog(@"拍照上传");
            [self takePhoto];
#pragma 打点统计*膳食管理->拍照
            [BasePresenter  EventStatisticalDotTitle:DotDietManagerFoodCamera Action:DotEventEnter  Remark:nil];
        }else if (buttonIndex == 2) {
            NSLog(@"取消");
        }
        
    }
    
}

- (void)pickPhoto{
    WS(ws);
    
    
    
    CorePhotoPickerVCManager *manager=[CorePhotoPickerVCManager new];
    
    //设置类型
    manager.pickerVCManagerType = CorePhotoPickerVCMangerTypeMultiPhoto;
    
    //最多可选1张
    NSInteger count = 1;
    manager.maxSelectedPhotoNumber = count;

    //错误处理
    if(manager.unavailableType!=CorePhotoPickerUnavailableTypeNone){
        NSLog(@"设备不可用");
        return;
    }
    
    UIViewController *pickerVC=manager.imagePickerController;
    
    //选取结束
    manager.finishPickingMedia=^(NSArray *medias){
        [ProgressUtil show];
        
        runOnMainThread(^{
            
            
            [ProgressUtil dismiss];
            
            
            
            for (CorePhoto *photo in medias) {
                
                NSLog(@"%@", photo);
                
                [ProgressUtil show];

                [ws.presenter uploadPhoto:photo.editedImage];
                
            }
        });
        
        
    };
    
    [ws presentViewController:pickerVC animated:YES completion:nil];
    
    
}

- (void)takePhoto{
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else{
        
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
//        [self.uploadImageArr addObject:image];
        [ProgressUtil show];

        [ws.presenter uploadPhoto:image];

        
    }
//
//    
    [picker dismissViewControllerAnimated:YES completion:^{
//        [ProgressUtil showWithStatus:@"正在识别"];

        
    }];

        
     
}

- (void)searchAction{
    if ((_searchField.text ==nil)|[_searchField.text isEqualToString:@""]|_searchField.text.length==0) {
        [ProgressUtil showInfo:@"请输入食材名称"];
        return;
    
    }
    [_searchField resignFirstResponder];
    
    [ProgressUtil show];
    [_presenter searchFoodByKeyWords:_searchField.text OrUrl:nil];
    
    
#pragma 打点统计*膳食管理-->食材搜索
[BasePresenter  EventStatisticalDotTitle:DotDietManagerFoodSearch Action:DotEventEnter  Remark:_searchField.text];

    
}
#pragma mark ---FoodResultCellDelegate

- (void)selectBtn:(FoodSearchResultEntity *)foodEntity{
    [ProgressUtil showWithStatus:@"处理中"];
    [_presenter addUserFoodByFoodID:foodEntity.ID];
}

#pragma mark - 手势监听
- (void)tapGestureAction:(UITapGestureRecognizer*) tap{
    UIImageView* imageView = (UIImageView*)tap.view;
    NSInteger index = imageView.tag - 3000;
    NSLog(@"----%ld",index);
    
//    UIWindow* window = [UIApplication sharedApplication].keyWindow;
//    
//    [SFPhotoBrowser showImageInView:window selectImageIndex:index delegate:self];
    
}

- (void)cancelSearch{
    _searchResultLabel.hidden =YES;
    _cancelBtn.hidden =YES;
    _searchResultLabel.sd_layout.leftSpaceToView(_scrollView,15).topSpaceToView(_foodListView,15).widthIs(100).heightIs(0);
    _searchResultLine.sd_layout.leftSpaceToView(_scrollView,15).topSpaceToView(_searchResultLabel,5).rightSpaceToView(_scrollView,15).heightIs(0);
    _cancelBtn.sd_layout.rightEqualToView(_searchResultLine).bottomSpaceToView(_searchResultLine,10).widthIs(80).heightIs(0);
    
    _table.sd_layout.topSpaceToView(_searchResultLine,0).leftSpaceToView(_scrollView,15).rightSpaceToView(_scrollView,15).heightIs(0);
    
    [_scrollView updateLayout];
}

#pragma mark * 删除照片
- (void)deleteAction:(UIButton* )btn{
    NSLog(@"%ld",btn.tag -4000);
    [ProgressUtil showWithStatus:@"删除中"];
    [_presenter delUserFoodByFoodID:_presenter.myFoodListSource[btn.tag -4000].FOOD_ID];
}

- (void)uploadPhotoDataOnCompletion:(BOOL)success Info:(NSString *)info photoUrl:(NSString *)url{
    if (success) {
        
        [ProgressUtil showWithStatus:@"正在识别"];
        
        [_presenter searchFoodByKeyWords:nil OrUrl:url];

        
        
    }else{
        [ProgressUtil showError:info];
    }
}

- (void)getHotKeyOnCompletion:(BOOL)success Info:(NSString *)info{
    if (success) {
        if (_presenter.hotKeySource.count<=5) {
            _hotFoodView.sd_layout.leftSpaceToView(_scrollView,15).rightSpaceToView(_scrollView,15).topSpaceToView(_hotKeyLine,10).heightIs(50);
        }else if (_presenter.hotKeySource.count<=10){
            _hotFoodView.sd_layout.leftSpaceToView(_scrollView,15).rightSpaceToView(_scrollView,15).topSpaceToView(_hotKeyLine,10).heightIs(91);
        }else{
            _hotFoodView.sd_layout.leftSpaceToView(_scrollView,15).rightSpaceToView(_scrollView,15).topSpaceToView(_hotKeyLine,10).heightIs(132);
        }
        [_scrollView updateLayout];
        [_hotFoodView reloadData];
    }
    [ProgressUtil dismiss];

}

- (void)getFoodSearchResultOnCompletion:(BOOL)success Info:(NSString *)info{
    if (success) {
        _searchResultLabel.hidden =NO;
        _cancelBtn.hidden =NO;
        _searchResultLabel.sd_layout.leftSpaceToView(_scrollView,15).topSpaceToView(_foodListView,15).widthIs(100).heightIs(30);
        _searchResultLine.sd_layout.leftSpaceToView(_scrollView,15).topSpaceToView(_searchResultLabel,5).rightSpaceToView(_scrollView,15).heightIs(1);
        _cancelBtn.sd_layout.rightEqualToView(_searchResultLine).bottomSpaceToView(_searchResultLine,10).widthIs(80).heightIs(20);
        
        _table.sd_layout.topSpaceToView(_searchResultLine,15).leftSpaceToView(_scrollView,15).rightSpaceToView(_scrollView,15).heightIs(_presenter.foodSearchResultSource.count*100);
        
        
        
        [_scrollView updateLayout];
        
        [_table reloadData];
        
        [ProgressUtil dismiss];
    }
}

- (void)addUserFoodOnCompletion:(BOOL)success Info:(NSString *)info{
    if (success) {
        _searchResultLabel.hidden =YES;
        _cancelBtn.hidden =YES;
        _searchResultLabel.sd_layout.leftSpaceToView(_scrollView,15).topSpaceToView(_foodListView,15).widthIs(100).heightIs(0);
        _searchResultLine.sd_layout.leftSpaceToView(_scrollView,15).topSpaceToView(_searchResultLabel,5).rightSpaceToView(_scrollView,15).heightIs(0);
        _cancelBtn.sd_layout.rightEqualToView(_searchResultLine).bottomSpaceToView(_searchResultLine,10).widthIs(80).heightIs(0);
        
        _table.sd_layout.topSpaceToView(_searchResultLine,0).leftSpaceToView(_scrollView,15).rightSpaceToView(_scrollView,15).heightIs(0);
        
        [_scrollView updateLayout];
        
        [_presenter getUserFoodList];

    }
}

- (void)getUserFoodListOnCompletion:(BOOL)success Info:(NSString *)info{
    if (success) {
        
        if (_presenter.myFoodListSource.count==0) {
            _foodPhotoView.hidden =YES;
            _photoSearchLabel.hidden =NO;
            _photoSearchLabel.sd_layout.leftSpaceToView(_photoSearchBtn,20).centerYEqualToView(_foodListView).heightIs(25).widthIs(150);
            
            _foodPhotoView.sd_layout.centerYEqualToView(_foodListView).leftSpaceToView(_foodListView,10).heightIs(100).widthIs(0);
            [_foodListView setupAutoContentSizeWithRightView:_photoSearchLabel rightMargin:15];
            [_foodListView updateLayout];
        
        }else{
        
        _foodPhotoView.hidden =NO;
        _photoSearchLabel.hidden =YES;
        _photoSearchLabel.sd_layout.leftSpaceToView(_photoSearchBtn,20).centerYEqualToView(_foodListView).heightIs(25).widthIs(0);

        _foodPhotoView.sd_layout.centerYEqualToView(_foodListView).leftSpaceToView(_foodListView,10).heightIs(100).widthIs(105*_presenter.myFoodListSource.count);
        [_foodListView setupAutoContentSizeWithRightView:_photoSearchBtn rightMargin:15];
            
        if (_presenter.myFoodListSource.count ==1) {
            
            UIView *photoBG1 =_foodImageViewArr[0];
            UIImageView *photoIV1 =[photoBG1 viewWithTag:3000];
            [photoIV1 sd_setImageWithURL:[NSURL URLWithString:_presenter.myFoodListSource[0].PIC] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
            
            UIView *photoBG2 =_foodImageViewArr[1];
            photoBG2.hidden =YES;
            photoBG2.sd_layout.centerYEqualToView(_foodPhotoView).leftSpaceToView(_foodPhotoView,105).widthIs(0).heightIs(100);

            UIView *photoBG3 =_foodImageViewArr[2];
            photoBG3.hidden =YES;
            photoBG3.sd_layout.centerYEqualToView(_foodPhotoView).leftSpaceToView(_foodPhotoView,105).widthIs(0).heightIs(100);

        }else if (_presenter.myFoodListSource.count ==2){
            
            UIView *photoBG1 =_foodImageViewArr[0];
            UIImageView *photoIV1 =[photoBG1 viewWithTag:3000];
            [photoIV1 sd_setImageWithURL:[NSURL URLWithString:_presenter.myFoodListSource[0].PIC] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
            
            UIView *photoBG2 =_foodImageViewArr[1];
            photoBG2.hidden =NO;
            UIImageView *photoIV2 =[photoBG2 viewWithTag:3001];
            [photoIV2 sd_setImageWithURL:[NSURL URLWithString:_presenter.myFoodListSource[1].PIC] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
            photoBG2.sd_layout.centerYEqualToView(_foodPhotoView).leftSpaceToView(_foodPhotoView,105).widthIs(90).heightIs(100);
            
            UIView *photoBG3 =_foodImageViewArr[2];
            photoBG3.hidden =YES;
            photoBG3.sd_layout.centerYEqualToView(_foodPhotoView).leftSpaceToView(_foodPhotoView,105).widthIs(0).heightIs(100);

        }else if(_presenter.myFoodListSource.count ==3){
            
            UIView *photoBG1 =_foodImageViewArr[0];
            UIImageView *photoIV1 =[photoBG1 viewWithTag:3000];
            [photoIV1 sd_setImageWithURL:[NSURL URLWithString:_presenter.myFoodListSource[0].PIC] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
            
            UIView *photoBG2 =_foodImageViewArr[1];
            photoBG2.hidden =NO;
            UIImageView *photoIV2 =[photoBG2 viewWithTag:3001];
            [photoIV2 sd_setImageWithURL:[NSURL URLWithString:_presenter.myFoodListSource[1].PIC] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
            photoBG2.sd_layout.centerYEqualToView(_foodPhotoView).leftSpaceToView(_foodPhotoView,105).widthIs(90).heightIs(100);
            
            UIView *photoBG3 =_foodImageViewArr[2];
            photoBG3.hidden =NO;
            UIImageView *photoIV3 =[photoBG3 viewWithTag:3002];
            [photoIV3 sd_setImageWithURL:[NSURL URLWithString:_presenter.myFoodListSource[2].PIC] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
            photoBG3.sd_layout.centerYEqualToView(_foodPhotoView).leftSpaceToView(_foodPhotoView,210).widthIs(90).heightIs(100);
            
            }
            [_foodListView updateLayout];
            
        }
        
    }
    [_presenter getFoodAnalysis];

}

- (void)delUserFoodOnCompletion:(BOOL)success Info:(NSString *)info{
    if (success) {
        [_presenter getUserFoodList];
        

    }
}
- (void)getDietAnalysisOnCompletion:(BOOL)success Info:(NSString *)info{
    if (success) {
        _height =0;
        [_analysisTable reloadData];

        _analysisTable.sd_layout.topSpaceToView(_table,30).leftSpaceToView(_scrollView,15).rightSpaceToView(_scrollView,15).heightIs(_height);
        
        [_scrollView updateLayout];
        
    }
    runOnMainThread(^{
        [ProgressUtil dismiss];

    });

}


- (NSMutableArray *)foodImageUrlArr{
    if (_foodImageUrlArr ==nil) {
        _foodImageUrlArr =[NSMutableArray array];
    }
    return _foodImageUrlArr;
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
