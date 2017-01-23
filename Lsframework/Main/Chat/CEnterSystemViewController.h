//
//  CEnterSystemViewController.h
//  FamilyPlatForm
//
//  Created by Mac on 16/12/12.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"
#import "MyFavorite.h"
#import "CConsultationBeListen.h"// 听过
#import "CMyComment.h" // 评论
#import "SystemNotice.h" // 
@protocol CEnterSystemViewControllerDelegate <NSObject>

-(void)pushToVc:(BaseViewController *)vc;

@end

@interface CEnterSystemViewController : BaseViewController

@property(nonatomic,weak)id <CEnterSystemViewControllerDelegate>delegate;

@property(nonatomic,assign) NSInteger Types;
/** 系统*/
@property(nonatomic,strong)SystemNotice *systemModel;
/** 喜欢*/
@property(nonatomic,strong) MyFavorite *favorite;
/** 听过*/
@property(nonatomic,strong) CConsultationBeListen *listen;
/** 评论*/
@property(nonatomic,strong) CMyComment *comment;


@end
