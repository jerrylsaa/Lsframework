//
//  TodayRecommend.h
//  FamilyPlatForm
//
//  Created by Mac on 16/11/30.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TodayRecommend : NSObject

/*
 
 
 {
 "ID": 39,
 "Title": "世界早产日活动",
 "Url": "http://www.zhongkang365.com/MobileHtml/everyday/childgm161110.html",
 "Clicks": 48,
 "CreateTime": "2016-11-01 15:03:43",
 "CreateUser": "CreateUser1",
 "Status": 1,
 "Photo": "http://tigerhuang007.xicp.io/MobileHtml/everyday/images/pic16926.png",
 "CategoryName": "生活百科",
 "BigPhoto": "http://121.42.15.43:9020/attach_upload/voice/20161130163822.jpg",
 "IsTop": true,
 "IsChoice": true,
 "From": "掌上儿保",
 "CommonCount": 2,
 "PraiseCount": 0,
 "IsPraise": 0,
 "DoctorName": "赵冬梅",
 "HospitalName": "济南儿童医院",
 "DepartName": "儿科",
 "ArticleTime": "2016/11/01",
 "Tags": null,
 "TagArticles": null
 }
 */

@property(nonatomic,strong)NSNumber*ID;
@property(nonatomic,strong)NSString *Title;
@property(nonatomic,strong)NSString *Url;
@property(nonatomic,strong)NSNumber *Clicks;
@property(nonatomic,strong)NSString *CreateTime;
@property(nonatomic,strong)NSString *CreateUser;
@property(nonatomic,strong)NSNumber *Status;
@property(nonatomic,strong)NSString *Photo;
@property(nonatomic,strong)NSString *CategoryName;
@property(nonatomic,strong)NSString *BigPhoto;
@property(nonatomic,strong)NSString *From;
@property(nonatomic,strong)NSNumber *CommonCount;
@property(nonatomic,strong)NSNumber *PraiseCount;
@property(nonatomic,strong)NSNumber *IsPraise;
@property(nonatomic,strong)NSString *DoctorName;
@property(nonatomic,strong)NSString *HospitalName;
@property(nonatomic,strong)NSString *DepartName;
@property(nonatomic,strong)NSString *ArticleTime;
@property(nonatomic,strong)NSString *TagArticles;
@property(nonatomic,strong)NSString *Tags;



@end
