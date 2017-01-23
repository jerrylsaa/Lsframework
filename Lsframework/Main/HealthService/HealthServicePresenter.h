//
//  HealthServicePresenter.h
//  FamilyPlatForm
//
//  Created by jerry on 16/7/12.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "HealthService.h"
#import "FoodService.h"
@protocol HealthServicePresenterDelegate <NSObject>

@optional
- (void)LoadHealthonComplete:(BOOL) success info:(NSString*) info;

@end
typedef void(^HealthServiceComplete)(BOOL success, NSString *message);
typedef void(^FoodServiceComplete)(BOOL success, NSString *message);
@interface HealthServicePresenter : BasePresenter

@property(nonatomic,weak) id<HealthServicePresenterDelegate> delegate;
//
@property(nonatomic,retain) NSMutableArray<HealthService* >* HealthSource;
//-(void)loadHealthServiceData;
@property (nonatomic, strong)NSMutableArray *dataSource;
//健康测评数据
- (void)loadHealthService:(HealthServiceComplete)block;

//饮食测评数据
- (void)loadFoodService:(FoodServiceComplete)block;

-(void)loadHealthService;

@end
