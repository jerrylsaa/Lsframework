//
//  HWView.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/9/7.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HWDelegate <NSObject>

- (void)selectChart:(NSInteger)tag;

- (void)clickWeightAndHeightSegment;

@end

@interface HWView : UIView

@property (nonatomic, weak) id<HWDelegate> delegate;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *compareText;
@property (nonatomic, copy) NSString *tipsText;
@property (nonatomic, copy) NSString *text;//输入内容


@property (nonatomic, strong) UITextView *field;
@property (nonatomic, strong) UILabel *unitLabel;
@property (nonatomic, strong) UILabel *defaultLabel;



@end
