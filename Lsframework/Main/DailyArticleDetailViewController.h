//
//  DailyArticleDetailViewController.h
//  FamilyPlatForm
//
//  Created by jerry on 16/9/9.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"
#import "PraiseList.h"

@interface DailyArticleDetailViewController : BaseViewController
@property(nonatomic,strong)PraiseList  *PraiseList;
@property(nonatomic,retain)NSNumber  *ArticleId;

@property(nonatomic,strong)void (^deleteRow)(BOOL isCurrentRow);


@end
