//
//  ExpertCommentListEntity.h
//  FamilyPlatForm
//
//  Created by laoshifu on 16/12/6.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExpertCommentListEntity : NSObject
@property (nonatomic, copy) NSString *CommentConetent;
@property (nonatomic, retain) NSNumber *StarLevel;
@property (nonatomic, copy) NSString *NickName;
@property (nonatomic, retain) NSNumber *AddComment;
@property (nonatomic, retain) NSNumber *TotalCount;
@property (nonatomic, copy) NSString *CommentTime;
@end
