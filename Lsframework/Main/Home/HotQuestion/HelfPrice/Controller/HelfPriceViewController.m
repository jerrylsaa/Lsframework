//
//  HelfPriceViewController.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 2016/10/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HelfPriceViewController.h"
#import "HelfPriceCell.h"
#import "JMFoundation.h"
#import "SFPhotoBrowser.h"
#import "CorePhotoPickerVCManager.h"
#import "UIImage+Category.h"
#import "HelfPresenter.h"
#import "PumpPayManager.h"

#define Tips_placeHolder @"向赵冬梅医生提问，等Ta语音回答；超过48小时未回答，将按支付路径全额退款";

#define   kImageXspace     20
#define   kImageTopspace     7.5
#define   kImageWidth   (kScreenWidth-15*2-3*kImageXspace)/4

@interface HelfPriceViewController ()<UITextViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,HelfDelegate,PhotoBrowerDelegate,UIActionSheetDelegate,PayDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *textBackView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UILabel *clickLabel;
@property (nonatomic, strong) UILabel *maxLabel;
@property (nonatomic, strong) UIButton *publicButton;
@property (nonatomic, strong) UILabel *publicLabel;
@property (nonatomic, strong) UIImageView *publicImageView;
@property (nonatomic, strong) UILabel *publicTipsLabel;
@property (nonatomic, strong) UILabel *oldPriceLabel;
@property (nonatomic, strong) UILabel *helfPriceLabel;
@property (nonatomic, strong) UIButton *commitButton;

@property (nonatomic, strong) UICollectionView *imageListView;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) NSArray *urlArray;
@property (nonatomic, strong) HelfPresenter *presenter;
@property (nonatomic, strong) PumpPayManager *manager;

@property (nonatomic, assign) BOOL isPublic;

@end

@implementation HelfPriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupView{
    self.title = @"追问专家";
    self.view.backgroundColor = [UIColor whiteColor];
    _imageArray = [NSMutableArray array];
    _presenter = [HelfPresenter new];
    _manager = [PumpPayManager new];
    _manager.delegate = self;
    [self setupScrollView];
    [self setupTextView];
    [self setupCollectionView];
    [self setupTipsView];
    [self setupPublicView];
    [self setupCommitView];
}
- (void)setupScrollView{
    _scrollView = [UIScrollView new];
    [self.view addSubview:_scrollView];
    _scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
}
- (void)setupTextView{
    _textBackView = [UIView new];
    _textBackView.layer.borderWidth = 1;
    _textBackView.backgroundColor = UIColorFromRGB(0xfbffff);
    _textBackView.layer.borderColor = UIColorFromRGB(0x61d8d3).CGColor;
    [_scrollView addSubview:_textBackView];
    _textBackView.sd_layout.leftSpaceToView(_scrollView,10).rightSpaceToView(_scrollView,10).topSpaceToView(_scrollView,40).heightIs(140);
    _textBackView.sd_cornerRadius = @2.5f;
    
    _tipsLabel = [UILabel new];
    _tipsLabel.font = [UIFont systemFontOfSize:12];
    _tipsLabel.backgroundColor = _textBackView.backgroundColor;
    _tipsLabel.text = Tips_placeHolder;
    _tipsLabel.textColor = UIColorFromRGB(0x999999);
    [_textBackView addSubview:_tipsLabel];
    _tipsLabel.sd_layout.leftSpaceToView(_textBackView,6).topSpaceToView(_textBackView,8).rightSpaceToView(_textBackView,6).autoHeightRatio(0);
    
    _textView = [UITextView new];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.delegate = self;
    _textView.font = [UIFont systemFontOfSize:12];
    _textView.textColor = UIColorFromRGB(0x999999);
    [_textBackView addSubview:_textView];
    _textView.sd_layout.leftSpaceToView(_textBackView,0).topSpaceToView(_textBackView,0).rightSpaceToView(_textBackView,0).bottomSpaceToView(_textBackView,23);
    
    _numLabel = [UILabel new];
    _numLabel.font = [UIFont systemFontOfSize:12];
    _numLabel.textColor = UIColorFromRGB(0x999999);
    _numLabel.textAlignment = NSTextAlignmentRight;
//    _numLabel.text = @"0/60";
    _numLabel.backgroundColor = _textBackView.backgroundColor;
    [_textBackView addSubview:_numLabel];
    _numLabel.sd_layout.rightSpaceToView(_textBackView,5).bottomSpaceToView(_textBackView,8).heightIs(15).widthIs(40);
    
}

- (void)setupCollectionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setMinimumLineSpacing:0];
    [flowLayout setMinimumInteritemSpacing:20];
    _imageListView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 160, 200, 200) collectionViewLayout:flowLayout];
    _imageListView.dataSource = self;
    _imageListView.delegate = self;
    _imageListView.scrollEnabled = NO;
    _imageListView.backgroundColor = [UIColor whiteColor];
    [_imageListView registerClass:[HelfPriceCell class] forCellWithReuseIdentifier:@"cell_helf"];
    [_scrollView addSubview:_imageListView];
    if (_imageArray.count < 4) {
     _imageListView.sd_layout.leftSpaceToView(_scrollView,15).rightSpaceToView(_scrollView,15).topSpaceToView(_textBackView,15).heightIs(kImageWidth);
    }else{
        
        _imageListView.sd_layout.leftSpaceToView(_scrollView,15).rightSpaceToView(_scrollView,15).topSpaceToView(_textBackView,15).heightIs(kImageWidth+kImageTopspace+kImageWidth);
    }
    
}
- (void)setupTipsView{
    _clickLabel = [UILabel new];
    _clickLabel.text = @"点击添加图片";
    _clickLabel.font = [UIFont systemFontOfSize:14];
    _clickLabel.textVerticalAlignment = UITextVerticalAlignmentBottom;
    _clickLabel.textColor = UIColorFromRGB(0x666666);
    [_scrollView addSubview:_clickLabel];
    CGFloat width = [JMFoundation calLabelWidth:_clickLabel.font andStr:_clickLabel.text withHeight:15];
    _clickLabel.sd_layout.leftSpaceToView(_scrollView,83).centerYEqualToView(_imageListView).heightIs(15).widthIs(width + 8);
    
    _maxLabel = [UILabel new];
    _maxLabel.text = @"(最多6张)";
    _maxLabel.textColor = UIColorFromRGB(0x999999);
    _maxLabel.font = [UIFont systemFontOfSize:11];
    _maxLabel.textVerticalAlignment = UITextVerticalAlignmentBottom;
    [_scrollView addSubview:_maxLabel];
    _maxLabel.sd_layout.leftSpaceToView(_clickLabel,0).bottomEqualToView(_clickLabel).topEqualToView(_clickLabel).widthIs(100);
}

- (void)setupPublicView{
    _publicButton = [UIButton new];
    [_publicButton setBackgroundImage:[UIImage imageNamed:@"ask_normal"] forState:UIControlStateNormal];
    [_publicButton addTarget:self action:@selector(publicAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_publicButton];
    _publicButton.sd_layout.leftSpaceToView(_scrollView,12).topSpaceToView(_imageListView,23).widthIs(13).heightIs(13);
    
    _publicLabel = [UILabel new];
    _publicLabel.text = @"公开图片";
    _publicLabel.font = [UIFont systemFontOfSize:12];
    _publicLabel.textColor = UIColorFromRGB(0x999999);
    [_scrollView addSubview:_publicLabel];
    _publicLabel.sd_layout.leftSpaceToView(_publicButton,3).centerYEqualToView(_publicButton).heightIs(13).widthIs(100);
    
    _publicImageView = [UIImageView new];
    [_publicImageView setImage:[UIImage imageNamed:@"ask_star"]];
    [_scrollView addSubview:_publicImageView];
    _publicImageView.sd_layout.leftEqualToView(_publicButton).topSpaceToView(_publicButton,7).heightIs(13).widthIs(13);
    
    _publicTipsLabel =[UILabel new];
    _publicTipsLabel.textColor = UIColorFromRGB(0x999999);
    _publicTipsLabel.text = @"公开提问，答案每被偷听1次，你从中分成¥0.5";
    _publicTipsLabel.font = _publicLabel.font;
    [_scrollView addSubview:_publicTipsLabel];
    _publicTipsLabel.sd_layout.leftEqualToView(_publicLabel).centerYEqualToView(_publicImageView).rightSpaceToView(_scrollView,12).autoHeightRatio(0);
}
- (void)setupCommitView{
    _oldPriceLabel = [UILabel new];
    _oldPriceLabel.font = [UIFont systemFontOfSize:13];
    _oldPriceLabel.textColor = UIColorFromRGB(0x999999);
    _oldPriceLabel.textAlignment = NSTextAlignmentCenter;
    _oldPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",self.price];
    [_scrollView addSubview:_oldPriceLabel];
    _oldPriceLabel.sd_layout.centerXEqualToView(_textBackView).topSpaceToView(_publicTipsLabel,25).heightIs(15).widthIs(60);
    UIView *sepView = [UIView new];
    sepView.backgroundColor = _oldPriceLabel.textColor;
    [_oldPriceLabel addSubview:sepView];
    sepView.sd_layout.leftSpaceToView(_oldPriceLabel,0).rightSpaceToView(_oldPriceLabel,0).centerYEqualToView(_oldPriceLabel).heightIs(1);
    
    _helfPriceLabel = [UILabel new];
    _helfPriceLabel.textAlignment = NSTextAlignmentCenter;
    _helfPriceLabel.font = [UIFont systemFontOfSize:16];
    _helfPriceLabel.textColor = UIColorFromRGB(0xd50000);
    _helfPriceLabel.text = [NSString stringWithFormat:@"半价  ¥%.2f",self.price/2.f];
    [_scrollView addSubview:_helfPriceLabel];
    _helfPriceLabel.sd_layout.centerXEqualToView(_oldPriceLabel).widthIs(150).heightIs(20).topSpaceToView(_oldPriceLabel,7);
    
    _commitButton = [UIButton new];
    [_commitButton setBackgroundImage: [UIImage imageWithColor:UIColorFromRGB(0x61d8d3)] forState:UIControlStateNormal];
    [_commitButton setTitle:@"确认提问" forState:UIControlStateNormal];
    _commitButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_commitButton addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_commitButton];
    _commitButton.sd_layout.centerXEqualToView(_oldPriceLabel).topSpaceToView(_helfPriceLabel,30).widthIs(90.).heightIs(40);
    _commitButton.sd_cornerRadius = @2.5;
    
    [_scrollView setupAutoContentSizeWithBottomView:_commitButton bottomMargin:50];

}

#pragma mark Action
- (void)publicAction{
    if (_isPublic == NO) {
        [_publicButton setBackgroundImage:[UIImage imageNamed:@"ask_sel"] forState:UIControlStateNormal];
        _isPublic = YES;
    }else{
        [_publicButton setBackgroundImage:[UIImage imageNamed:@"ask_normal"] forState:UIControlStateNormal];
        _isPublic = NO;
    }
}
- (void)commitAction{
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    if (kCurrentUser.userId == 0) {
        //账户超时，退回登陆页面
        [ProgressUtil showError:@"账户超时"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"rememberPsw"];
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_LoginOutAction object:nil];
    }
    
//    if ([self.expertEntity.IsVacation isEqual:@1]) {
//        [ProgressUtil showInfo:@"医生正在休假无法提问"];
//        return;
//    }
    if([_textView.text trimming].length == 0){
        [ProgressUtil showInfo:@"请输入问题"];
        return ;
    }
    //上传图片，返回地址数组
    if (_imageArray.count != 0) {
        WS(ws);
        //支付
        if (ws.price == 0) {
            [_presenter uploadPhoto:_imageArray complete:^(BOOL success, NSArray *UrlArray) {
                ws.urlArray = UrlArray;
                [_manager payWithPayType:@"alipay" expertID:@(self.expert_ID) consultationID:@(self.consultationID) uuid:@(self.uuid) price:_price/2];
            }];
        }else{
            [ws showPaySheet];
        }
    }else{
        //支付
        if (self.price == 0) {
            [_manager payWithPayType:@"alipay" expertID:@(self.expert_ID) consultationID:@(self.consultationID) uuid:@(self.uuid) price:_price/2];
        }else{
            [self showPaySheet];
        }
    }
    
}

#pragma mark delegate
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        _tipsLabel.text = Tips_placeHolder;
//        _numLabel.text = @"0/60";
    }else{
        _tipsLabel.text = @"";
//        if (textView.text.length >= 60) {
//            textView.text = [textView.text substringToIndex:60];
//        }
//        _numLabel.text = [NSString stringWithFormat:@"%lu/60",(unsigned long)textView.text.length];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_imageArray.count == 0) {
        return 1;
    }else if (_imageArray.count == 6){
        return _imageArray.count;
    }else{
        return _imageArray.count + 1;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HelfPriceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell_helf" forIndexPath:indexPath];
    if (_imageArray.count == 0) {
        cell.image = [UIImage imageNamed:@"HEaddimage"];
        cell.isDelete = NO;
    }else if(_imageArray.count == 6){
        cell.image = _imageArray[indexPath.row];
        cell.isDelete = YES;
    }else{
        
        if (indexPath.row == _imageArray.count) {
            cell.image = [UIImage imageNamed:@"HEhaveaddImage"];
            cell.isDelete = NO;
        }else{
            cell.image = _imageArray[indexPath.row];
            cell.isDelete = YES;
        }
    }
    cell.sd_indexPath = indexPath;
    cell.delegate = self;
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kImageWidth, kImageWidth);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (_imageArray.count == 6) {
        [SFPhotoBrowser showImageInView:window selectImageIndex:indexPath.row delegate:self];
    }else if (_imageArray.count == 5){
        if (indexPath.row < 5) {
            [SFPhotoBrowser showImageInView:window selectImageIndex:indexPath.row delegate:self];
        }else{
            [self showSheet];
        }
        
    }else if (_imageArray.count == 4){
        if (indexPath.row < 4) {
            [SFPhotoBrowser showImageInView:window selectImageIndex:indexPath.row delegate:self];
        }else{
            [self showSheet];
        }
        
    }else if (_imageArray.count == 3){
        if (indexPath.row < 3) {
            [SFPhotoBrowser showImageInView:window selectImageIndex:indexPath.row delegate:self];
        }else{
            [self showSheet];
        }
        
    }else if (_imageArray.count == 2){
        if (indexPath.row < 2) {
            [SFPhotoBrowser showImageInView:window selectImageIndex:indexPath.row delegate:self];
        }else{
            [self showSheet];
        }
    }else if (_imageArray.count == 1){
        if (indexPath.row < 1) {
            [SFPhotoBrowser showImageInView:window selectImageIndex:indexPath.row delegate:self];
        }else{
            [self showSheet];
        }
    }else if (_imageArray.count == 0){
        [self showSheet];
    }
    
    [_imageListView reloadData];
    
    if (_imageArray.count < 4) {
        _imageListView.sd_layout.leftSpaceToView(_scrollView,15).rightSpaceToView(_scrollView,15).topSpaceToView(_textBackView,15).heightIs(kImageWidth);
    }else{
        
        _imageListView.sd_layout.leftSpaceToView(_scrollView,15).rightSpaceToView(_scrollView,15).topSpaceToView(_textBackView,15).heightIs(kImageWidth+kImageTopspace+kImageWidth);
    }
    
    
    
}

- (void)deleteImageAtIndexPath:(NSIndexPath *)indexPath{
    [_imageArray removeObjectAtIndex:indexPath.row];
    [self reloadData];
    if (_imageArray.count < 4) {
        _imageListView.sd_layout.leftSpaceToView(_scrollView,15).rightSpaceToView(_scrollView,15).topSpaceToView(_textBackView,15).heightIs(kImageWidth);
    }else{
        
        _imageListView.sd_layout.leftSpaceToView(_scrollView,15).rightSpaceToView(_scrollView,15).topSpaceToView(_textBackView,15).heightIs(kImageWidth+kImageTopspace+kImageWidth);
    }
    
    
    NSLog(@"删除第%ld张图片后刷新",(long)indexPath.row);
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 100) {
        if (buttonIndex == 0) {
            [self pickPhoto];
        }else if (buttonIndex == 1){
            [self takePhoto];
        }
    }else{
        WS(ws);
        if (_imageArray.count != 0) {
            [_presenter uploadPhoto:_imageArray complete:^(BOOL success, NSArray *UrlArray) {
                ws.urlArray = UrlArray;
                NSLog(@"urlArray -is %@",ws.urlArray);
                if (buttonIndex == 0) {
                    //支付宝
                    ws.manager.pay = PayTypeAli;
                    [ws.manager payWithPayType:@"alipay" expertID:@(ws.expert_ID) consultationID:@(ws.consultationID) uuid:@(ws.uuid) price:
                     ws.price/2];
                }else if(buttonIndex == 1){
                    //微信
                    ws.manager.pay = PayTypeWX;
                    [ws.manager wxpayWithConsultationID:@(ws.consultationID) price:ws.price/2 type:@"questionBizTrace" consultContent:ws.textView.text isPublic:[NSString stringWithFormat:@"%d",ws.isPublic] imgArr:ws.urlArray doctorID:[NSString stringWithFormat:@"%ld",(long)ws.expert_ID]];
                }
            }];
        }else{
            if (buttonIndex == 0) {
                //支付宝
                ws.manager.pay = PayTypeAli;
                [ws.manager payWithPayType:@"alipay" expertID:@(ws.expert_ID) consultationID:@(ws.consultationID) uuid:@(ws.uuid) price:
                 ws.price/2];
            }else if(buttonIndex == 1){
                //微信
                ws.manager.pay = PayTypeWX;
                [ws.manager wxpayWithConsultationID:@(ws.consultationID) price:ws.price/2 type:@"questionBizTrace" consultContent:ws.textView.text isPublic:[NSString stringWithFormat:@"%d",ws.isPublic] imgArr:ws.urlArray doctorID:[NSString stringWithFormat:@"%ld",(long)ws.expert_ID]];
            }
        }
    }
}
#pragma mark private
- (void)reloadData{
    [_imageListView reloadData];
    if (_imageArray.count != 0) {
        _clickLabel.hidden = YES;
        _maxLabel.hidden = YES;
    }else{
        _clickLabel.hidden = NO;
        _maxLabel.hidden = NO;
    }
    
}
#pragma mark 图片相关
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
        UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"上传照片", @"拍照上传", nil];
        sheet.tag = 100;
        [sheet showInView:self.view];
    }
}

-(void)takePhoto{
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

-(void)pickPhoto{
    WS(ws);
    CorePhotoPickerVCManager *manager=[CorePhotoPickerVCManager new];
    //设置类型
    manager.pickerVCManagerType = CorePhotoPickerVCMangerTypeMultiPhoto;
    //最多可选3张
    NSInteger count = 0;
    if(_imageArray && _imageArray.count != 0){
        if(_imageArray.count == 1){
            count = 5;
        }else if(_imageArray.count == 2){
            count = 4;
        }else if(_imageArray.count == 3){
            count = 3;
        }else if(_imageArray.count == 4){
            count = 3;
        }else if(_imageArray.count == 5){
            count = 1;
        }else if(_imageArray.count == 6){
            count = 0;
        }
    }else{
        count = 6;
    }
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
                if (![ws.imageArray containsObject:photo.editedImage]) {
                    [ws.imageArray addObject:photo.editedImage];
                }
            }
            
            if (_imageArray.count < 4) {
                _imageListView.sd_layout.leftSpaceToView(_scrollView,15).rightSpaceToView(_scrollView,15).topSpaceToView(_textBackView,15).heightIs(kImageWidth);
            }else{
                
                _imageListView.sd_layout.leftSpaceToView(_scrollView,15).rightSpaceToView(_scrollView,15).topSpaceToView(_textBackView,15).heightIs(kImageWidth+kImageTopspace+kImageWidth);
            }
            [ws reloadData];
            
            [_scrollView updateLayout];
            [_scrollView layoutSubviews];
        });
    };
    [self presentViewController:pickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    // 判断获取类型：图片
    if ([mediaType isEqualToString:( NSString *)kUTTypeImage]){
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        [self.imageArray addObject:image];
        [self reloadData];
        
        if (_imageArray.count < 4) {
            _imageListView.sd_layout.leftSpaceToView(_scrollView,15).rightSpaceToView(_scrollView,15).topSpaceToView(_textBackView,15).heightIs(kImageWidth);
        }else{
            
            _imageListView.sd_layout.leftSpaceToView(_scrollView,15).rightSpaceToView(_scrollView,15).topSpaceToView(_textBackView,15).heightIs(kImageWidth+kImageTopspace+kImageWidth);
        }
//        [ws reloadData];
        
        [_scrollView updateLayout];
        [_scrollView layoutSubviews];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (NSUInteger)numberOfPhotosInPhotoBrowser:(SFPhotoBrowser *)photoBrowser{
    return self.imageArray.count;
}
- (SFPhoto *)photoBrowser:(SFPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    SFPhoto* sfPhoto = [SFPhoto new];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    sfPhoto.srcImageView = ((HelfPriceCell *)[_imageListView  cellForItemAtIndexPath:indexPath]).imageView;
    return sfPhoto;
}

#pragma mark 支付相关
- (void)showPaySheet{
    //选择支付方式
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"请选择支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝",@"微信", nil];
    sheet.tag = 101;
    [sheet showInView:self.view];
}
- (void)InsertConsultingRecordsTrace{
    _manager.expertID = [NSNumber numberWithInteger:self.expert_ID];
    _manager.consultationID = [NSNumber numberWithInteger:self.uuid];
    _manager.uuid = [NSNumber numberWithInteger:self.uuid];
    _manager.price = self.price/2;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@(kCurrentUser.userId) forKey:@"userid"];
    [parameters setObject:_textView.text forKey:@"ConsultCount"];
    for (int i = 1; i < 7; i ++) {
        NSString *key = [NSString stringWithFormat:@"Image%d",i];
        [parameters setObject:@"" forKey:key];
        if (_urlArray && _urlArray.count >= i) {
            [parameters setObject:_urlArray[i-1] forKey:key];
        }
    }
    NSString *isOpen;
    if (_isPublic == NO) {
        isOpen = @"0";
    }else{
        isOpen = @"1";
    }
    [parameters setObject:isOpen forKey:@"IsOpenImage"];
    [_manager InsertConsultingRecordsTrace:parameters];
}
- (void)WXInsertConsultingRecordsTrace{
    _manager.expertID = [NSNumber numberWithInteger:self.expert_ID];
    _manager.consultationID = [NSNumber numberWithInteger:self.uuid];
    _manager.uuid = [NSNumber numberWithInteger:self.uuid];
    _manager.price = self.price/2;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@(kCurrentUser.userId) forKey:@"userid"];
    [parameters setObject:_textView.text forKey:@"ConsultCount"];
    for (int i = 1; i < 7; i ++) {
        NSString *key = [NSString stringWithFormat:@"Image%d",i];
        [parameters setObject:@"" forKey:key];
        if (_urlArray && _urlArray.count >= i) {
            [parameters setObject:_urlArray[i-1] forKey:key];
        }
    }
    NSString *isOpen;
    if (_isPublic == NO) {
        isOpen = @"false";
    }else{
        isOpen = @"true";
    }
    [parameters setObject:isOpen forKey:@"IsOpenImage"];
    [_manager WXInsertConsultingRecordsTrace:parameters];
}
- (void)payComplete:(BOOL ) success{
    if (success == YES) {
        [ProgressUtil showSuccess:@"咨询成功"];
    #pragma 打点统计*问题详情页面->追问
        [BasePresenter  EventStatisticalDotTitle:DotHotQuestionAnswer Action:DotEventEnter  Remark:nil];

        _textView.text = @"";
        [_imageArray removeAllObjects];
        [_imageListView reloadData];
        [kdefaultCenter postNotificationName:@"half" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [ProgressUtil showError:@"咨询失败"];
    }
}

@end
