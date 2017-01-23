//
//  ImageWidget.m
//  Community
//
//  Created by tom on 16/1/12.
//  Copyright © 2016年 Jia. All rights reserved.
//

#import "ImageWidget.h"
#import "UIImageView+Category.h"
#import "CorePhotoPickerVCManager.h"
#import "UIImage+Category.h"
#import "UIImageView+Category.h"
#import "SDPhotoBrowser.h"

@interface ImageWidget()<SDPhotoBrowserDelegate>
@property (nonatomic, strong) NSMutableArray<NSLayoutConstraint*>* heightContraiints;
@property (nonatomic, strong) NSMutableArray<NSLayoutConstraint*>* xContraiints;
@end

@implementation ImageWidget


-(instancetype)init{
    self = [super init];
    if (self) {
        [self initit];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initit];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initit];
    }
    return self;
}

-(void)initit{
//    self.scrollEnabled = NO;
    _heightContraiints = [NSMutableArray new];
    _xContraiints = [NSMutableArray new];
    _maxCount = 9;
    _urls = [NSMutableArray new];
    _originalUrls = [NSMutableArray new];
    _imageHeight = 80.f;
//    self.backgroundColor = [UIColor lightGrayColor];
    [self resetImageView];
}

-(void)setUrls:(NSMutableArray *)urls{
    _urls = urls;
    [self resetImageView];
}


-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat height = self.frame.size.height - 10;
    if (height > 0) {
        for (int i = 0; i < _heightContraiints.count; i ++) {
            NSLayoutConstraint * constraint = _heightContraiints[i];
            constraint.constant = height;
        }
        _imageHeight = height;
        for (int i = 0; i < _xContraiints.count; i ++) {
            NSLayoutConstraint * x = _xContraiints[i];
            x.constant = i*(height + 5) + 5;
        }
        
        self.contentSize = CGSizeMake((_urls.count + 1) * (height + 5) + 5, 0);

    }
    
}

-(void)resetImageView{
    for (UIView * view in self.subviews) {
        [view removeFromSuperview];
    }
    self.translatesAutoresizingMaskIntoConstraints = NO;
    CGFloat height = self.frame.size.height - 10;
    if (height < 0) {
        height = 0;
    }
    [_heightContraiints removeAllObjects];
    [_xContraiints removeAllObjects];
    for (int i = 0; i < _maxCount; i ++){
        if (_urls.count > i) {
            NSString * url = _urls[i];
            UIImageView * imageView = [UIImageView new];
            [imageView setCornerRadius:6.];
            imageView.translatesAutoresizingMaskIntoConstraints = NO;
            imageView.backgroundColor = [UIColor whiteColor];
            [self addSubview:imageView];
            [imageView setClipsToBounds:YES];
            [imageView setContentMode:UIViewContentModeScaleAspectFill];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[imageView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self, imageView)]];
            NSLayoutConstraint * x = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:i*(height + 5) + 5];
            [self addConstraint:x];
            [_xContraiints addObject:x];
            
            NSLayoutConstraint * width = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:_imageHeight];
            NSLayoutConstraint * height = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:_imageHeight];
            [self addConstraint:width];
            [self addConstraint:height];
            [_heightContraiints addObject:height];
            [_heightContraiints addObject:width];

            [imageView setImage:[UIImage imageWithContentsOfFile:url]];
            
            imageView.tag = i;
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction:)]];
        }else if (_urls.count == i){
            UIImageView * imageView = [UIImageView new];
            imageView.translatesAutoresizingMaskIntoConstraints = NO;

            [self addSubview:imageView];
            [imageView setContentMode:UIViewContentModeScaleAspectFit];
            
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[imageView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self, imageView)]];
            
            NSLayoutConstraint * x = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:i*(height + 5) + 5];
            [self addConstraint:x];
            [_xContraiints addObject:x];
            
            NSLayoutConstraint * height = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:_imageHeight];

            [self addConstraint:height];
            [_heightContraiints addObject:height];
            NSLayoutConstraint * width = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:_imageHeight];
            [self addConstraint:width];
            [_heightContraiints addObject:width];
            [imageView setImage:[UIImage imageNamed:@"AddPhoto"]];
            imageView.tag = i;
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction:)]];
            
        }
        
    }
    self.contentSize = CGSizeMake((_urls.count + 1) * (height + 5) + 5, 0);
    
}

-(void)clickAction:(UITapGestureRecognizer*)sender{
    if (sender.view.tag < _urls.count){
        SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
        
        browser.sourceImagesContainerView = self;
        
        browser.imageCount = _urls.count;
        
        browser.currentImageIndex = sender.view.tag;
        
        browser.delegate = self;
        
        [browser show]; // 展示图片浏览器
    }
    
    if (sender.view.tag == _urls.count) {
        [self pickPhoto];
    }
}

-(void)pickPhoto{
    
    if (_maxCount == _urls.count) {
        [ProgressUtil showError:@"最多只能选9张图片"];
        return;
    }
    
    CorePhotoPickerVCManager *manager=[CorePhotoPickerVCManager new];
    
    //设置类型
    manager.pickerVCManagerType = CorePhotoPickerVCMangerTypeMultiPhoto;
    
    //最多可选3张
    manager.maxSelectedPhotoNumber = _maxCount - _urls.count;
    
    
    //错误处理
    if(manager.unavailableType!=CorePhotoPickerUnavailableTypeNone){
        NSLog(@"设备不可用");
        return;
    }
    
    UIViewController *pickerVC=manager.imagePickerController;
    WS(ws);
    //选取结束
    manager.finishPickingMedia=^(NSArray *medias){
        [ProgressUtil show];

        runOnBackground(^{
            [medias enumerateObjectsUsingBlock:^(CorePhoto *photo, NSUInteger idx, BOOL *stop) {
                NSString * path = [photo.editedImage saveToLocal];
                NSLog(@"=%@",path);
                [ws.urls addObject:path];
            }];
            runOnMainThread(^{
                [ws resetImageView];
                [ProgressUtil dismiss];
            });
        });

    };
    if (self.viewController) {
        [self.viewController presentViewController:pickerVC animated:YES completion:nil];
    }else{
        [[self viewController] presentViewController:pickerVC animated:YES completion:nil];
    }

}

- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;  
}

-(UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    return ((UIImageView*)self.subviews[index]).image;
}

-(NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    return nil;
}

-(void)dealloc{
    _originalUrls = nil;
    _urls = nil;
}

@end
