//
//  DataInputPresenter.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/10/8.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"

typedef void(^UpdateHandler)(BOOL success);

@protocol DataInputDelegate <NSObject>

- (void)complete:(BOOL)success message:(NSString *)message;

@end

@interface DataInputPresenter : BasePresenter

@property (nonatomic, weak) id<DataInputDelegate> delegate;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSDictionary *dataDic;

- (void)GetBabyBodyDataByBabyID:(NSString *)type;
- (void)InsertBabyBodyDataMonth:(NSString *)dataValue type:(NSString *)type month:(NSString *)month block:(UpdateHandler)block;
- (void)UpdateBabyBodyData:(NSString *)dataValue id:(NSNumber *)rowId type:(NSString *)type block:(UpdateHandler)block;
@end
