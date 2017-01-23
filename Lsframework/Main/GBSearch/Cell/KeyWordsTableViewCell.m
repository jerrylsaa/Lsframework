//
//  KeyWordsTableViewCell.m
//  FamilyPlatForm
//
//  Created by lichen on 16/10/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "KeyWordsTableViewCell.h"

@implementation KeyWordsTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        self.textLabel.textColor = UIColorFromRGB(0x666666);
        self.textLabel.font = [UIFont  systemFontOfSize:16];

        
        //右侧删除按钮
        UIButton  *deletBtn = [UIButton  new];
        [deletBtn setImage:[UIImage imageNamed:@"delete_history"] forState:UIControlStateNormal];
        [self.contentView addSubview:deletBtn];
        
        UIButton  *deletebgBt = [UIButton  new];
        [deletebgBt addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:deletebgBt];
//        deletebgBt.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];

        
        deletBtn.sd_layout.centerYEqualToView(self.contentView).rightSpaceToView(self.contentView,15).widthIs(10).heightEqualToWidth();
        
        deletebgBt.sd_layout.topSpaceToView(self.contentView,0).bottomSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0).widthIs(50);
        
    }
    return self;
}

#pragma mark - 点击事件
- (void)deleteAction{
    
    self.deleteKeyWordBlock(self);
    
}



@end
