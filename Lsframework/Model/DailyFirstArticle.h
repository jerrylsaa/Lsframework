//
//  DailyFirstArticle.h
//  FamilyPlatForm
//
//  Created by jerry on 16/9/6.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DailyFirstArticle : NSObject
/**
 *  {
 "ID": 12,
 "Title": "世界卫生日：糖友健康饮食离不开这些菜",
 "Url": "http://eat.51ttyy.com/kx/jk/201604/209341.shtml",
 "CreateTime": "/Date(1473160232207)/",
 "CreateUser": "jerry",
 "Status": 1,
 "Photo": "http://eat.51ttyy.com/UploadFiles_9607/201604/2016040810130436.jpg",
 "CommonCount": 0,
 "PraiseCount": 0
 "Clicks":117
 }
 */

@property(nonatomic,strong)NSNumber  *ID;
@property(nonatomic,copy)NSString  *Title;
@property(nonatomic,copy)NSString  *Url;
@property(nonatomic,copy)NSString  *CreateTime;
@property(nonatomic,copy)NSString  *CreateUser;
@property(nonatomic,strong)NSNumber  *Status;
@property(nonatomic,copy)NSString  *Photo;
@property(nonatomic,strong)NSNumber  *CommonCount;
@property(nonatomic,strong)NSNumber  *CommentCount;
@property(nonatomic,strong)NSNumber  *PraiseCount;
@property(nonatomic,strong)NSNumber  *IsPraise;
@property(nonatomic,strong)NSNumber  *Clicks;

@end
