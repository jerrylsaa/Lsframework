//
//  CEnterCommentCell.h
//  FamilyPlatForm
//
//  Created by Mac on 16/12/14.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyFavorite.h"
#import "CConsultationBeListen.h"// 听过
#import "CMyComment.h" // 评论
@interface CEnterCommentCell : UITableViewCell
/** 喜欢*/
@property(nonatomic,strong) MyFavorite *favorite;
/** 听过*/
@property(nonatomic,strong) CConsultationBeListen *listen;
/** 评论*/
@property(nonatomic,strong) CMyComment *comment;

@end
