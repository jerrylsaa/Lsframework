//
//  ZHDocDetailView.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/3/30.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZHDoctorDelegate <NSObject>

- (void)click:(UIView *)view;

@end

@interface ZHDocDetailView : UIView

@property (nonatomic ,weak)id<ZHDoctorDelegate> delegate;

@property (nonatomic ,strong)UIImageView *iconView;
@property (nonatomic ,strong)UILabel *textLabel;
@property (nonatomic, strong)UIButton *clickButton;

- (void)initSubViews;
@end

