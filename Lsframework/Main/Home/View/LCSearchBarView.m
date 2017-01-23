//
//  LCSearchBarView.m
//  FamilyPlatForm
//
//  Created by lichen on 16/10/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "LCSearchBarView.h"

@interface LCSearchBarView ()

@end

@implementation LCSearchBarView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        [self setupView];
    }
    return self ;
}

-(instancetype)init{
    self= [super init];
    if(self){
        [self setupView];
    }
    return self;
}
#pragma mark - 加载子视图
- (void)setupView{
    UITextField* searchTextField = [UITextField  new];
    searchTextField.font = [UIFont systemFontOfSize:15];
    searchTextField.textColor = UIColorFromRGB(0x333333);
    searchTextField.tintColor= [UIColor lightGrayColor];
    searchTextField.placeholder = @"搜索医生、问题、帖子";
    // 提前在Xcode上设置图片中间拉伸
    searchTextField.background = [UIImage imageNamed:@"searchbar_textfield_background"];
    searchTextField.returnKeyType = UIReturnKeySearch;
    self.searchTextField = searchTextField;
    
    UIButton *searchIcon = [UIButton  new];
    [searchIcon  setImage:[UIImage  imageNamed:@"searchbar_textfield_search_icon"] forState:UIControlStateNormal];
    searchIcon.contentMode = UIViewContentModeCenter;
    searchIcon.frame = CGRectMake(0, 0, 30, 39/2);
    [searchIcon  setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    searchTextField.leftView = searchIcon;
    searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchTextField.leftViewMode = UITextFieldViewModeAlways;
    
    [self addSubview:searchTextField];
    
    //添加约束
    searchTextField.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    

}



@end
