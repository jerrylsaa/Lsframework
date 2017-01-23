//
// SFPhotoScrollView.h
//
//  Created by laoshifu on 15/9/15.
//  Copyright (c) 2015年 laoshifu All rights reserved.
//

#import <UIKit/UIKit.h>
#define kPhotoImageEdgeSize  40
#define kBackgroundColor [UIColor grayColor]

@interface UIView (viewController)
- (UIViewController *)viewController;
@end

@implementation UIView (viewController)

- (UIViewController *)viewController {
    
    UIResponder *next = self.nextResponder;
    while (next) {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    }
    return nil;
}
@end

@class SFPhotoBrowser, SFPhoto, SFPhotoScrollView;

@protocol PhotoViewDelegate <NSObject>
@optional
- (void)photoViewWillZoomIn:(SFPhotoScrollView *)photoView;
- (void)photoViewDidZoomIn:(SFPhotoScrollView *)photoView;
- (void)photoViewWillZoomOut:(SFPhotoScrollView *)photoView;
- (void)photoViewDidZoomOut:(SFPhotoScrollView *)photoView;

@end

@interface SFPhotoScrollView : UIScrollView <UIScrollViewDelegate>
// 图片
@property (nonatomic, strong) SFPhoto *photo;
// 代理
@property (nonatomic, weak) id<PhotoViewDelegate> photoViewDelegate;
@end