//
//  HSTextView.h
//  FamilyPlatForm
//
//  Created by laoshifu on 16/11/1.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMFoundation.h"

@interface HSTextView : UIView


@property(nonatomic,copy) NSMutableAttributedString* attPlaceholderStr;
@property(nonatomic,retain) UITextView *textView;
@property(nonatomic,strong)UILabel *placeholderLabel;

@end
