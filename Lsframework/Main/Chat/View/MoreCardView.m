//
//  MoreCardView.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/9/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MoreCardView.h"
#import "CorePhotoPickerVCManager.h"
#import <Photos/Photos.h>
#import "UIImage+Category.h"
#import "UIView+ViewController.h"
#import "ChatViewController.h"

@interface MoreCardView ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIButton *cameraButton;

@property (nonatomic, strong) UIButton *pictureButton;

@end

@implementation MoreCardView

- (instancetype)init{
    if (self = [super init]) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    
    [self setupPictureButton];
    [self setupCameraButton];
    
}
- (void)setupPictureButton{
    _pictureButton = [UIButton new];
    [_pictureButton setBackgroundImage:[UIImage imageNamed:@"chat_picture_normal"] forState:UIControlStateNormal];
    [_pictureButton setBackgroundImage:[UIImage imageNamed:@"chat_picture_select"] forState:UIControlStateHighlighted];
    [_pictureButton addTarget:self action:@selector(pictureAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_pictureButton];
    _pictureButton.sd_layout.leftSpaceToView(self,20).topSpaceToView(self,20).heightIs(50).widthIs(50);
    UILabel *picLabel = [UILabel new];
    picLabel.text = @"照片";
    picLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:picLabel];
    picLabel.sd_layout.leftEqualToView(_pictureButton).rightEqualToView(_pictureButton).topSpaceToView(_pictureButton,10).heightIs(20);
}
- (void)setupCameraButton{
    _cameraButton = [UIButton new];
    [_cameraButton setBackgroundImage:[UIImage imageNamed:@"chat_camera_normal"] forState:UIControlStateNormal];
    [_cameraButton setBackgroundImage:[UIImage imageNamed:@"chat_camera_select"] forState:UIControlStateHighlighted];
    [_cameraButton addTarget:self action:@selector(caremaAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cameraButton];
    _cameraButton.sd_layout.leftSpaceToView(_pictureButton,20).topEqualToView(_pictureButton).heightIs(50).widthIs(50);
    UILabel *cameraLabel = [UILabel new];
    cameraLabel.text = @"拍摄";
    cameraLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:cameraLabel];
    cameraLabel.sd_layout.leftEqualToView(_cameraButton).rightEqualToView(_cameraButton).topSpaceToView(_cameraButton,10).heightIs(20);
}



//点击事件
- (void)pictureAction{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if(status == PHAuthorizationStatusDenied || status ==PHAuthorizationStatusRestricted){
        
        NSLog(@"不允许访问");
        //无权限
        // 获取当前App的基本信息字典
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        //app名称
        NSString *app_Name = [infoDictionary objectForKey:@"CFBundleName"];
        NSString *tips = [NSString stringWithFormat:@"请在iPhone的“设置-隐私-照片”选项中，允许%@访问你的手机相册",app_Name];
        
        UIAlertView* alertView= [[UIAlertView alloc] initWithTitle:nil message:tips delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil];
        alertView.tag =1003;
        [alertView show];
    }

    CorePhotoPickerVCManager *manager=[CorePhotoPickerVCManager new];
    
    //设置类型
    manager.pickerVCManagerType = CorePhotoPickerVCMangerTypeMultiPhoto;
    
    //最多可选
    manager.maxSelectedPhotoNumber = 1;
    
    //错误处理
    if(manager.unavailableType!=CorePhotoPickerUnavailableTypeNone){
        NSLog(@"设备不可用");
        return;
    }
    
    UIViewController *pickerVC = manager.imagePickerController;
    WS(ws);
    //选取结束
    manager.finishPickingMedia=^(NSArray *medias){
        
        NSLog(@"%ld",(long)medias.count);
        //处理返回数据
        NSMutableArray *images = [NSMutableArray array];
        for (CorePhoto *photo in medias) {
            [images addObject:photo.editedImage];
        }
        
        [ws.delegate didSelectImage:images];
        
    };
    //弹出图片选择
    [self.delegate selectImage:pickerVC];
}

- (void)caremaAction{
    NSLog(@"拍照");
    // 实例化对象
    UIImagePickerController *pickerVc = [[UIImagePickerController alloc] init];
    
    // 设置照片可编辑
    [pickerVc setAllowsEditing:YES];
    
    // 设置自己为代理
    [pickerVc setDelegate:self];
    /**
     *  UIImagePickerControllerSourceTypePhotoLibrary 所有照片
     *    UIImagePickerControllerSourceTypeCamera 相机
     *    UIImagePickerControllerSourceTypeSavedPhotosAlbum 相册
     */
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        //设置sourceType
        [pickerVc setSourceType:UIImagePickerControllerSourceTypeCamera];
        //弹出拍照
        [self.delegate selectImage:pickerVc];
        
    } else {
        NSLog(@"不支持相机");
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = info[@"UIImagePickerControllerEditedImage"];
    
    NSLog(@"%@", image);
     [self.delegate didSelectImage:@[image]];
}


@end
