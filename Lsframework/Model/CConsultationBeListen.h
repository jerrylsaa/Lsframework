//
//  CConsultationBeListen.h
//  FamilyPlatForm
//
//  Created by Mac on 16/12/7.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CConsultationBeListen : NSObject

/*
 
 {
 "RowID": 1,
 "UUID": 742,
 "ID": 521,
 "NickName": "来不及了，快上车",
 "CHILD_IMG": "/attach_upload/201611/22/201611221358118017.jpg",
 "ConsultationContent": "她咯",
 "CreateTime": "2016-11-28 11:27:21",
 "Expert_ID": 1,
 "CT": "2016-11-29 15:28:13",
 "UserID": 2,
 "Message": "听过我咨询的问题",
 "Time": "2016/11/28"
 }
 
 {
 "RowID": 1,
 "Message": "听过我咨询的问题",
 "Type": 3,
 "Params": "{\"UUID\":\"722\"}",
 "NickName": "宝友uTfe5250",
 "CHILD_IMG": null,
 "CreateDate": "2016-12-12 17:06:31",
 "Time": "2天前",
 "IsRead": false,
 "Content": "123"
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


//@property(nonatomic,strong) NSNumber *RowID ;
//@property(nonatomic,strong) NSNumber *UUID;
//@property(nonatomic,strong) NSNumber *ID;
//@property(nonatomic,strong) NSString *NickName;
//@property(nonatomic,strong) NSString *CHILD_IMG;
//@property(nonatomic,strong) NSString *ConsultationContent;
//@property(nonatomic,strong) NSString *CreateTime;
//@property(nonatomic,strong) NSNumber *Expert_ID;
//@property(nonatomic,strong) NSString *CT;
//@property(nonatomic,strong) NSNumber *UserID;
//@property(nonatomic,strong) NSString *Message;
//@property(nonatomic,strong) NSString *Time;



@end
