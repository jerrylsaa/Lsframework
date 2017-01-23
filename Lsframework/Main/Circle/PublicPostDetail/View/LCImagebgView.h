//
//  LCImagebgView.h
//  FamilyPlatForm
//
//  Created by lichen on 16/9/27.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCImagebgView;

@protocol LCImagebgViewDelegate <NSObject>
@optional
- (void)deleteImageViewWith:(LCImagebgView* _Nonnull) lcImagebgView;

@end

@interface LCImagebgView : UIView

@property(nullable,nonatomic,retain) UIImageView* showImageView;
@property(nullable,nonatomic,retain) UIButton* deleteButton;

@property(nullable,nonatomic,weak) id<LCImagebgViewDelegate> delegate;

@end
