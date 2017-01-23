//
//  ConsulationReplyList.h
//  FamilyPlatForm
//
//  Created by jerry on 16/9/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface ConsulationReplyList : NSObject
/**
 *{
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


@property(nonatomic) NSInteger RowID;// uuid
@property(nonatomic) NSInteger ID;
@property(nonatomic) NSInteger UserID;
@property(nonatomic) NSInteger CommentID;
@property(nullable,nonatomic,copy) NSString* CommentContent;
@property(nullable,nonatomic,copy)NSNumber  *CreateTime;
@property(nullable,nonatomic,copy) NSNumber *ModifyTime;
@property(nullable,nonatomic,retain) NSNumber *IsDelete;
@property(nullable,nonatomic,copy) NSString* NickName;
@property(nullable,nonatomic,copy) NSString* UserPic;

@property(nonatomic) NSInteger uuid;


//@property(nullable,nonatomic,retain) NSDate* replyTime;
@property(nullable,nonatomic,retain) NSString* replyTime;


//特殊处理病友案例某些字段缺失
@property(nullable,nonatomic,copy) NSString* CHILD_IMG;


+ (void)formatChildImageWithArray:(NSMutableArray* _Nullable) array;


@end
