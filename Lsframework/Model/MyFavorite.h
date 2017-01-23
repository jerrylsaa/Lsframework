//
//  MyFavorite.h
//  FamilyPlatForm
//
//  Created by Mac on 16/12/7.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyFavorite : NSObject

/*
 {
 "RowID": 1,
 "uuid": 47,
 "Message": "喜欢了我的咨询/回答",
 "Type": 2,
 "Params": "{\"UUID\":\"732\"}",
 "NickName": "宝友RjtO4538",
 "CHILD_IMG": "/attach_upload/201611/14/201611141200468955.png",
 "CreateDate": "2016-12-14 12:02:02",
 "Time": "1天前",
 "IsRead": false,
 "Content": "哈哈酷我"
 }
 
 {
 "RowID": 1,
 "Message": "喜欢了我咨询的问题",
 "Type": 2,
 "Params": "{\"UUID\":\"732\"}",
 "NickName": "宝友RjtO4538",
 "CHILD_IMG": "/attach_upload/201611/14/201611141200468955.png",
 "CreateDate": "2016-12-14 12:02:02",
 "Time": "1天前",
 "IsRead": false,
 "Content": "哈哈酷我"
 }
 */

@property(nonatomic,strong) NSNumber *RowID ;
@property(nonatomic,strong)NSNumber *uuid;
@property(nonatomic,strong) NSString *Message;
@property(nonatomic,strong)NSString *Type;
@property(nonatomic,strong)NSString *Params;
@property(nonatomic,strong) NSString *NickName;
@property(nonatomic,strong) NSString *CHILD_IMG;
@property(nonatomic,strong) NSString *CreateDate;
@property(nonatomic,strong) NSString *Time;
@property(nonatomic,assign)BOOL IsRead;
@property(nonatomic,strong)NSString *Content;

//@property(nonatomic,strong) NSNumber * RowID;
//@property(nonatomic,strong) NSNumber * TYPE;
//@property(nonatomic,strong) NSNumber * ID;
//@property(nonatomic,strong) NSString * CONTENT;
//@property(nonatomic,strong) NSString * Message;
//@property(nonatomic,strong) NSNumber * ConsultationID;
//@property(nonatomic,strong) NSNumber * UserID;
//@property(nonatomic,strong) NSString * CreateTime;
//@property(nonatomic,strong) NSString * CHILD_IMG;
//@property(nonatomic,strong) NSString * NickName;
//@property(nonatomic,strong) NSString * Time;


@end
