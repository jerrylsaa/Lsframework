//
//  Conversation.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/9/20.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Conversation : NSObject

@property (nonatomic, strong) NSNumber *row_number;
@property (nonatomic, strong) NSNumber *RowID;
@property (nonatomic, strong) NSNumber *SendUserID;
@property (nonatomic, strong) NSNumber *ReceiveUserID;
@property (nonatomic, copy) NSString *NewContent;
@property (nonatomic, copy) NSString *CreateDate;
@property (nonatomic, copy) NSString *ModifyDate;
@property (nonatomic, strong) NSNumber *UnreadCount;
@property (nonatomic, copy) NSString *NickName;
@property (nonatomic, copy) NSString *UserImg;
@property (nonatomic, strong) NSNumber *UserType;

//
@property(nonatomic,assign)BOOL IsRead;


@end
