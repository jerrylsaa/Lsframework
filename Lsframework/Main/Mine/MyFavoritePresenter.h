//
//  MyFavoritePresenter.h
//  FamilyPlatForm
//
//  Created by jerry on 16/12/8.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "MyFavoriteEntity.h"

@protocol  MyFavoritePresenterDelegate <NSObject>

//获取每日必读列表
-(void)GetMyFavoriteListCompletion:(BOOL)success info:(NSString*)message;
-(void)GetMyFavoriteMoreListCompletion:(BOOL)success info:(NSString*)message;

@end

@interface MyFavoritePresenter : BasePresenter
@property (nonatomic, weak) id<MyFavoritePresenterDelegate> delegate;
@property(nonatomic) BOOL noMoreData;

@property(nonatomic,retain) NSMutableArray<MyFavoriteEntity* > * dataSource;



-(void)GetMyFavoriteList;


-(void)GetMyFavoriteMoreList;

@end
