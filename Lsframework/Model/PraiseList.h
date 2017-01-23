//
//  PraiseList.h
//  FamilyPlatForm
//
//  Created by jerry on 16/9/6.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PraiseList : NSObject
/**
 *  {
 "RowID": 1,
 "uuid": 1,
 "ArticleID": 1,
 "CommentID": 0,
 "UserID": 1,
 "CommentContent": "1",
 "CreateTime": 1473005573,
 "IsDelete": false
 }
 */
@property(nonatomic,strong)NSNumber  *RowID;
@property(nonatomic,strong)NSNumber  *uuid;
@property(nonatomic,strong)NSNumber  *ArticleID;
@property(nonatomic,strong)NSNumber  *CommentID;
@property(nonatomic,strong)NSNumber  *UserID;
@property(nonatomic,copy)NSString  *CommentContent;
@property(nonatomic,strong)NSNumber  *CreateTime;
@property(nonatomic,strong)NSNumber  *IsDelete;
@property(nonatomic,copy)NSString  *CHILD_IMG;
@property(nonatomic,copy)NSString  *NickName;

@end
