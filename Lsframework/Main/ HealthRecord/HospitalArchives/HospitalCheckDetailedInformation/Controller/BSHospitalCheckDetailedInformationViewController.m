//
//  BSHospitalCheckDetailedInformationViewController.m
//  FamilyPlatForm
//
//  Created by Shuai on 16/4/27.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BSHospitalCheckDetailedInformationViewController.h"
#import "BSHospitalCheckDetailedInformationCell.h"
#import "BSHospitalCheckDetailedInformationPresenter.h"
#import "HospitalFileDetails.h"
#import "UIImageView+WebCache.h"
#import "CorePhotoPickerVCManager.h"
#import "ContinuinglyPicturesPresenter.h"
#import "SDPhotoBrowser.h"

@interface BSHospitalCheckDetailedInformationViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, detailedInformationDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, uploadImagesDelegate, SDPhotoBrowserDelegate>

{
    BSHospitalCheckDetailedInformationCell *_cell;
    UIImageView *_myImageView;
    NSString *myType;
    NSArray *_dataArray;
    UIAlertController *_alert;
    NSMutableArray *_selectedPhotoArray;
}

@property (weak, nonatomic) IBOutlet UILabel            *hospitalNameLabel;// 医院名字
@property (weak, nonatomic) IBOutlet UILabel            *projectLabel;// 项目
@property (weak, nonatomic) IBOutlet UILabel            *dateTimeLabel;// 日期
@property (weak, nonatomic) IBOutlet UICollectionView   *listCollectionView;
@property (weak, nonatomic) IBOutlet UILabel            *contentLabel;// 内容
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelHeight;// 内容的高度
@property (weak, nonatomic) IBOutlet UIView             *contentView;// 内容View
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;

@property (nonatomic, strong) BSHospitalCheckDetailedInformationPresenter *presenter;
@property (nonatomic, strong) ContinuinglyPicturesPresenter *uploadPresenter;

@end

@implementation BSHospitalCheckDetailedInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

//- (void)viewWillLayoutSubviews {
//    if (_contentView != nil) {
//        [_contentView removeFromSuperview];
//    }
//}

- (void)setupView {
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    myType = [user objectForKey:@"bsArchivesType"];
    
    self.presenter = [[BSHospitalCheckDetailedInformationPresenter alloc] init];
    self.presenter.delegate = self;
    [ProgressUtil show];
    [self.presenter requestWithID:_model.ID];
    
    if ([myType isEqualToString:@"0"]) {
        
        if ([_detailType isEqualToString:@"自主检查档案"]) {
            
            self.title = @"自主检查详细信息";
//            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加图片" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction)];
            
            
            [_listCollectionView registerNib:[UINib nibWithNibName:@"BSHospitalCheckDetailedInformationCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
            
            _hospitalNameLabel.text = _model.hospitalName;
            _projectLabel.text      = [NSString stringWithFormat:@"项目：%@",_model.projectName];
            _dateTimeLabel.text     = [NSDate showMyDate:_model.inspectTime withDateFormatter:@"yyyy年MM月dd日"];
            
            [self fitHeight];
        }else {
            NSLog(@"医院检查档案");
        }
        
    }else if ([myType isEqualToString:@"1"]) {
        
        if ([_detailType isEqualToString:@"自主检查档案"]) {
            
            
            self.title = @"自主病历详细信息";
//            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加病历图片" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction)];
            
            
            [_listCollectionView registerNib:[UINib nibWithNibName:@"BSHospitalCheckDetailedInformationCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
            
            _hospitalNameLabel.text = _model.hospitalName;
            _projectLabel.text      = [NSString stringWithFormat:@"主诉：%@",_model.chiefComplaint];
            _dateTimeLabel.text     = [NSDate showMyDate:_model.inspectTime withDateFormatter:@"yyyy年MM月dd日"];
            
        }else {
            NSLog(@"医院检查档案");
        }
    }

    
    
}

- (void)rightItemAction {
    
    NSLog(@"您点击了添加图片");
    _selectedPhotoArray = [NSMutableArray array];
    [self showSheet];
    
}

- (void)uploadData {
    
    self.uploadPresenter = [[ContinuinglyPicturesPresenter alloc] init];
    self.uploadPresenter.delegate = self;
    [self.uploadPresenter requestWithImages:_selectedPhotoArray withID:_model.ID];
    
}

- (void)showSheet {
    
    if([[[UIDevice currentDevice] systemVersion] floatValue]  >= 8.0) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *uploadPhotos = [UIAlertAction actionWithTitle:@"上传照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"上传照片");
            [self pickPhoto];
        }];
        
        UIAlertAction *uploadPhotosByCamera = [UIAlertAction actionWithTitle:@"拍照上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"拍照上传");
            [self takePhoto];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:uploadPhotos];
        [alert addAction:uploadPhotosByCamera];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }else {
        
        UIActionSheet* sheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"上传照片", @"拍照上传", nil];
        [sheet showInView:self.view];
        
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
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

-(void)pickPhoto{
    CorePhotoPickerVCManager *manager=[CorePhotoPickerVCManager new];
    
    //设置类型
    manager.pickerVCManagerType = CorePhotoPickerVCMangerTypeMultiPhoto;
    
    //最多可选3张
    manager.maxSelectedPhotoNumber = 9;
    
    //错误处理
    if(manager.unavailableType!=CorePhotoPickerUnavailableTypeNone){
        NSLog(@"设备不可用");
        return;
    }
    
    UIViewController *pickerVC=manager.imagePickerController;
    //    WS(ws)
    //选取结束
    manager.finishPickingMedia=^(NSArray *medias){
        [ProgressUtil show];
        runOnBackground(^{
            [medias enumerateObjectsUsingBlock:^(CorePhoto *photo, NSUInteger idx, BOOL *stop) {
                //                NSString * path = [photo.editedImage saveToLocal];
                //                [ws.urls addObject:path];
            }];
            runOnMainThread(^{
                //                [ws resetImageView];
                NSLog(@"%ld", medias.count);
                
                for (CorePhoto *photo in medias) {
                    
                    NSLog(@"%@", photo);
                    
                    [_selectedPhotoArray addObject:photo.editedImage];
                    
                }
                NSLog(@"%ld", _selectedPhotoArray.count);
                
                [self uploadData];

            });
        });
        
    };
    if (self) {
        [self presentViewController:pickerVC animated:YES completion:nil];
    }else{
        [self presentViewController:pickerVC animated:YES completion:nil];
    }
    
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
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [_selectedPhotoArray addObject:image];
    [self uploadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSLog(@"%lu",(unsigned long)_dataArray.count);
    return _dataArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    _cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
//    _cell.casesImageView.image = [UIImage imageNamed:@"HeartFull"];
    _cell.dateTimeLabel.text = @"";
    _cell.model = _dataArray[indexPath.row];
    
    return _cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((kScreenWidth - 15) / 2, (kScreenWidth - 15) / 2 + 10);
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"您点击了第%ld个item", indexPath.row);
    
    SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
    photoBrowser.delegate = self;
    photoBrowser.currentImageIndex = indexPath.item;
    photoBrowser.imageCount = _dataArray.count;
    photoBrowser.sourceImagesContainerView = self.listCollectionView;
    
    [photoBrowser show];
    
}

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    // 不建议用此种方式获取小图，这里只是为了简单实现展示而已
    _cell = (BSHospitalCheckDetailedInformationCell *)[self collectionView:self.listCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    
    return _cell.casesImageView.image;
    
}

- (void)sendData:(NSArray *)dataArray {
    
    _dataArray = dataArray;
    [ProgressUtil dismiss];
    [_listCollectionView reloadData];
    if (_model.pacsContent.length > 0 || _model.emrContent.length > 0) {
        if ([myType isEqualToString:@"0"]) {
            _contentLabel.text = _model.pacsContent;
        } else if ([myType isEqualToString:@"1"]) {
            _contentLabel.text = _model.emrContent;
        }
        [self fitHeight];
    } else {
        
        [_contentView removeFromSuperview];
        
    }
    
}

- (void)fitHeight {
    
    CGFloat width = CGRectGetWidth(_contentLabel.frame);
    CGSize newSize = [_contentLabel sizeThatFits:CGSizeMake(width,MAXFLOAT)];
    _contentLabelHeight.constant = newSize.height;
    
}

- (void)sendMessage:(NSString *)message {
    
    NSLog(@"%@", message);
    [self.presenter requestWithID:_model.ID];
    
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
