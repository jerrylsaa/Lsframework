//
//  XLLBPresenter.h
//  FamilyPlatForm
//
//  Created by laoshifu on 16/9/14.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "XLLBEntity.h"
@protocol XLLBPresenterDelegate <NSObject>

@optional
- (void)onCompletion:(BOOL)success info:(NSString *)messsage;

@end
@interface XLLBPresenter : BasePresenter
@property(nonatomic,weak) id<XLLBPresenterDelegate> delegate;
@property(nonatomic,retain) NSArray<XLLBEntity *> * xllbDataSource;

- (void)getXLLBData;

@property (nonatomic,copy) NSString *tableName;
@end
