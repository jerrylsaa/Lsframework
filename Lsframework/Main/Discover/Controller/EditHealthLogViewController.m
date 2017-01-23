//
//  EditHealthLogViewController.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/8/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "EditHealthLogViewController.h"
#import "CorePhotoPickerVCManager.h"
#import "DiscoverPresenter.h"

@interface EditHealthLogViewController ()<DiscoverPresenterDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>{

    UILabel *_yearLabel;
    UILabel *_dayMonthLabel;
    UILabel *_birthLabel;
    UITextView *_logContentView;
    UIImageView *_photoIV;
}
@property (nonatomic,strong) DiscoverPresenter *presenter;
@property (nonatomic,strong) UIImage *uploadImage;
@end

@implementation EditHealthLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initBackBarWithImage:[UIImage imageNamed:@"cancelBtn"]];
    [self initRightBarWithTitle:@"发布"];

}

- (void)backItemAction:(id)sender{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)rightItemAction:(id)sender{
    NSLog(@"点击发布");
    if (_uploadImage==nil) {
       [ProgressUtil showInfo:@"请选择照片上传"];
        return;
    }
    [self.presenter uploadPhoto:_uploadImage];

}

-(void)setupView{
    self.presenter = [DiscoverPresenter new];
    self.presenter.delegate = self;
    
    _yearLabel =[UILabel new];
    _yearLabel.text =[self getYearStringbyDate:self.CreateTime];
    _yearLabel.font =[UIFont systemFontOfSize:16];
    _yearLabel.textColor =UIColorFromRGB(0x666666);
    [self.view addSubview:_yearLabel];
    
    _dayMonthLabel=[UILabel new];
    _dayMonthLabel.text =[self getMonthDayStringbyDate:self.CreateTime];
    _dayMonthLabel.font =[UIFont systemFontOfSize:30];
    _dayMonthLabel.textColor =UIColorFromRGB(0x61d8d3);
    [self.view addSubview:_dayMonthLabel];
    
    _birthLabel =[UILabel new];
    _birthLabel.font =[UIFont systemFontOfSize:16];
    _birthLabel.textColor =UIColorFromRGB(0x666666);
    
    NSUInteger month=((((NSUInteger)self.DayNum)/(30))%12);
   
    NSUInteger year=((NSUInteger)self.DayNum)/(30*12);
    
    
    _birthLabel.text =[NSString stringWithFormat:@"%d岁%d个月",year,month];
    
    [self.view addSubview:_birthLabel];
    
    _logContentView =[UITextView new];
    _logContentView.text =self.LogContent;
    _logContentView.textColor =UIColorFromRGB(0xcccccc);
    _logContentView.font =[UIFont systemFontOfSize:18];
    [self.view addSubview:_logContentView];
    
    
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToImageViewGesture:)];

    _photoIV =[UIImageView new];
    _photoIV.image =[UIImage imageNamed:@"addEditLogImage"];
    _photoIV.contentMode =UIViewContentModeScaleAspectFill;
    _photoIV.clipsToBounds =YES;
    _photoIV.userInteractionEnabled =YES;
    [_photoIV addGestureRecognizer:tap];

    [self.view addSubview:_photoIV];
    
    _yearLabel.sd_layout.leftSpaceToView(self.view,15).topSpaceToView(self.view,25).heightIs(16).widthIs(120);
    _dayMonthLabel.sd_layout.leftEqualToView(_yearLabel).topSpaceToView(_yearLabel,10).widthIs(150).heightIs(30);
    _birthLabel.sd_layout.leftEqualToView(_yearLabel).topSpaceToView(_dayMonthLabel,10).widthIs(120).heightIs(16);
    _logContentView.sd_layout.leftSpaceToView(self.view,15).topSpaceToView(_birthLabel,20).rightSpaceToView(self.view,15).heightIs(90);
    _photoIV.sd_layout.leftEqualToView(_yearLabel).topSpaceToView(_logContentView,80).widthIs(82).heightIs(82);
}

- (void)uploadLogPhotoDataOnCompletion:(BOOL)success info:(NSString*)message urlPhotoPath:(NSString *)photoPath{
    if (success) {

        [self.presenter updateHealthLog:photoPath LogId:self.dlID LogContent:_logContentView.text];
        
    }
    
}

- (void)onUpdateLogCompletion:(BOOL)success info:(NSString *)message{
    if (success) {
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)tapToImageViewGesture:(UITapGestureRecognizer *)tap{
    
    
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
            _photoIV.image =photo.editedImage;
            _uploadImage =photo.editedImage;
//            [ws.presenter uploadPhoto:photo.editedImage];
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
//        [ws.presenter uploadPhoto:image];
        
        _photoIV.image =image;
        _uploadImage =image;
    }
    
    
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        
    }];
    
    
    
}



- (NSString *)getYearStringbyDate:(NSInteger )dateInt{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970: dateInt];
    NSString* dateString = [formatter stringFromDate:date];
    
    return dateString;
    
}

- (NSString *)getMonthDayStringbyDate:(NSInteger )dateInt{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM.dd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970: dateInt];
    NSString* dateString = [formatter stringFromDate:date];
    
    return dateString;
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
