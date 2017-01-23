//
//  CommentDetailViewController.h
//  FamilyPlatForm
//
//  Created by lichen on 16/9/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"
#import "ConsultationCommenList.h"

@interface CommentDetailViewController : BaseViewController

@property(nullable,nonatomic,retain) ConsultationCommenList* commentEntity;
@property (nullable,nonatomic,retain) NSNumber *commentID;

@property(nonatomic)BOOL isPatinetCase;//是否是从病友案例评论跳过来的，是的话，就改变一下CommentDetailPresenter中请求评论回复的actionName

@property(nonatomic,strong)void (^deleteRow)(BOOL isDelete);

@property(nonatomic,strong) void(^RefreshRow)(BOOL isFresh);

@property(nonatomic,strong)void (^deletePubPostDetailRow)(BOOL isDelete);


@end
