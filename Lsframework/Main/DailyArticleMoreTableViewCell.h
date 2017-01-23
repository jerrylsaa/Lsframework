//
//  DailyArticleMoreTableViewCell.h
//  FamilyPlatForm
//
//  Created by jerry on 16/10/9.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DailyFirstArticle.h"

@interface DailyArticleMoreTableViewCell : UITableViewCell
@property(nullable,nonatomic,retain) DailyFirstArticle* DailyArticle;
@property( nullable,nonatomic,strong)UIButton *DailyPraiseCountBt;
@property( nullable,nonatomic,strong)UIView *DailyPraiseView;
@property( nullable,nonatomic,strong)UILabel *DailyPraiseLb;
@end
