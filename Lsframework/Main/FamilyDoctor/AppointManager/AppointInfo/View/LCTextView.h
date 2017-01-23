//
//  ZHTextView.h
//  TheCentralHospital_Doctor
//
//  Created by lichen on 16/3/14.
//  Copyright © 2016年 中弘科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMFoundation.h"

@interface LCTextView : UITextView<UITextViewDelegate>

@property(nonatomic,copy) NSString* placeholder;

@property(nonatomic,retain) UIColor* placeholderColor;

@property(nonatomic,retain) UIFont* placeholderFont;

@property(nonatomic) BOOL showTextLength;//是否展示统计文本个数

@property(nonatomic) NSInteger textLength;//文本长度

@property(nonatomic) NSInteger XTLength;//设置指定的输入长度

@property(nonatomic,strong)UILabel *placeholderLabel;

@end
