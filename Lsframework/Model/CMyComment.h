//
//  CMyComment.h
//  FamilyPlatForm
//
//  Created by Mac on 16/12/7.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMyComment : NSObject
/*
  {
 "ID": 402,
 "User_ID": 10,
 "Expert_ID": 1,
 "ConsultationContent": "追问未回答http://fir.im/7rpd?utm_source=fir&amp;utm_medium=qr",
 "Message": "您咨询收到一条评论，请查看哦!",
 "Params": "{\"UUID\":\"402\"}",
 "CreateTime": "2016-11-14 10:42:49",
 "Time": "2016/11/14"
 }
 
 {
 "RowID": 1,
 "uuid": 54,
 "Message": "评论了我的咨询/回答",
 "Type": 0,
 "Params": "{\"UUID\":\"734\"}",
 "CommentContent": "了",
 "NickName": "宝友SvaI3477",
 "CHILD_IMG": null,
 "CreateDate": "2016-12-15 15:39:15",
 "Time": "13分钟前",
 "IsRead": false,
 "Content": "木木木木木"
 }
 */

@property(nonatomic,strong) NSNumber *RowID ;
@property(nonatomic,strong)NSNumber *uuid;
@property(nonatomic,strong) NSString *Message;
@property(nonatomic,strong)NSString *Type;
@property(nonatomic,strong)NSString *Params;
@property(nonatomic,strong)NSString *CommentContent;
@property(nonatomic,strong) NSString *NickName;
@property(nonatomic,strong) NSString *CHILD_IMG;
@property(nonatomic,strong) NSString *CreateDate;
@property(nonatomic,strong) NSString *Time;
@property(nonatomic,assign)BOOL IsRead;
@property(nonatomic,strong)NSString *Content;


@end
