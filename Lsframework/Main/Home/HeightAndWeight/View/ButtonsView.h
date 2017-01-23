//
//  ButtonsView.h
//  FamilyPlatForm
//
//  Created by MAC on 16/9/18.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ButtonsViewDelegate <NSObject>

- (void)selectIndex:(NSInteger )index;

@end

@interface ButtonsView : UIView

@property (nonatomic, weak) id<ButtonsViewDelegate> delegate;

@property (nonatomic, strong) UIButton *preButton;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UILabel *ageLabel;

@end
