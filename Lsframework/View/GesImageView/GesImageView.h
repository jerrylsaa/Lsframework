//
//  GesImageView.h
//  FamilyPlatForm
//
//  Created by MAC on 16/3/27.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBRadioGroup.h"
@interface GesImageView : UIImageView<UITextFieldDelegate>
{
    UIImageView *_textFieldBackground;
}

@property (nonatomic ,strong)UILabel *titleLabel;
@property (nonatomic ,strong)FBRadioGroup *selectGroup;
@property (nonatomic ,strong)UITextField *textField;
@property(nonatomic) NSUInteger currentSelect;//当前选中

- (void)hideText;
- (void)showText;

@end
