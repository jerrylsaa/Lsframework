//
//  ChatEntity.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/9/21.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatEntity : NSObject



@property (nonatomic, strong) NSNumber *RowID;
@property (nonatomic, strong) NSNumber *uuid;
@property (nonatomic, strong) NSNumber *DialogID;
@property (nonatomic, strong) NSNumber *SendUserID;
@property (nonatomic, strong) NSNumber *ReceiveUserID;
@property (nonatomic, copy) NSString *Content;
@property (nonatomic, strong) NSNumber *SendStatus;
@property (nonatomic, strong) NSNumber *ReceiveStatus;
@property (nonatomic, strong) NSNumber *CreateDate;
@property (nonatomic, strong) NSNumber *ModifyDate;
@property (nonatomic, copy) NSString *SendNickName;
@property (nonatomic, copy) NSString *SendUserImg;
@property (nonatomic, copy) NSString *ReceiveNickName;
@property (nonatomic, copy) NSString *ReceiveUserImg;
@property (nonatomic, copy) NSString *Params;
@property (nonatomic, copy) NSString *Type;

//新类增加的


@end
