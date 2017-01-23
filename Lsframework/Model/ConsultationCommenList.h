//
//  ConsultationCommenList.h
//  FamilyPlatForm
//
//  Created by jerry on 16/9/21.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
#import "ConsulationReplyList.h"


@interface ConsultationCommenList : NSObject
/**
 *  {
 "RowID": 1,
 "uuid": 6,
 "UserID": 4,
 "ConsultationType": 1,
 "ConsultationID": 275,
 "CommentContent": "大厦就是电话大世界很大很谨慎的规划设计好的话就爱上",
 "IsDelete": 0,
 "Image1": "",
 "Image2": "",
 "Image3": "",
 "CreateTime": 1474445033,
 "ModifyTime": null,
 "NickName": "1111",
 "CHILD_IMG": "/attach_upload/201609/12/201609121433324880.png"
 ReplyCount
 }
 */


/*
{
    "RowID": 1,
    "ID": 5,
    "UserID": 4,
    "CommentID": 6,
    "CommentContent": "\"优惠券\"",
    "CreateTime": 1474861350,
    "ModifyTime": null,
    "IsDelete": 0,
    "NickName": "1111",
    "UserPic": "/attach_upload/201609/12/201609121433324880.png"
}
 */
@property(nonatomic) NSInteger RowID;//
@property(nonatomic) NSInteger uuid;
@property(nonatomic) NSInteger UserID;
@property(nonatomic) NSInteger ConsultationID;
@property(nonatomic) NSInteger ConsultationType;
@property(nonatomic) NSInteger ReplyCount;
@property(nonatomic) NSInteger ReplayCount;

@property(nullable,nonatomic,copy) NSString* CommentContent;
@property(nullable,nonatomic,retain) NSNumber *IsDelete;
@property(nullable,nonatomic,copy) NSString *Image1;
@property(nullable,nonatomic,copy) NSString *Image2;
@property(nullable,nonatomic,copy) NSString *Image3;
@property(nullable,nonatomic,copy) NSString *Image4;
@property(nullable,nonatomic,copy) NSString *Image5;
@property(nullable,nonatomic,copy) NSString *Image6;
//@property(nullable,nonatomic,copy)NSNumber  *CreateTime;
@property(nullable,nonatomic,copy)NSString  *CreateTime;
@property(nullable,nonatomic,copy) NSNumber *ModifyTime;
@property(nullable,nonatomic,copy) NSString* NickName;
@property(nullable,nonatomic,copy) NSString* CHILD_IMG;


//详情页
@property(nonatomic) NSInteger ID;
@property(nonatomic) NSInteger CommentID;
@property(nullable,nonatomic,copy) NSString* UserPic;


//@property(nullable,nonatomic,retain) NSDate* publicTime;
@property(nullable,nonatomic,retain) NSString* publicTime;




@property(nullable,nonatomic,retain) NSMutableArray<ConsulationReplyList*> * ReplyCommentList;

//病友案例详情
@property(nullable,nonatomic,retain) NSMutableArray<ConsulationReplyList*> * ReplayList;

+ (void)formatConsulationReplyListWithArray:(NSMutableArray* _Nullable) array;

@end
