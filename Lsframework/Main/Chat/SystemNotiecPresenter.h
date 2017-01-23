//
//  SystemNotiecPresenter.h
//  FamilyPlatForm
//
//  Created by Mac on 16/12/6.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "SystemNotice.h"
#import "MyFavorite.h"
#import "CMyComment.h"
#import "CConsultationBeListen.h"

typedef void (^SystemNoticeBlock)(BOOL success);

@protocol SystemNotiecPresenterDelegate <NSObject>

-(void)GetSystemNoticeCompletion:(BOOL)success info:(NSString *)message;

-(void)GetSystemNoticeMoreListCompletion:(BOOL)success info:(NSString*)message;
@end

typedef NS_ENUM(NSInteger, SegmentNoticeType) {
    SegmentSystemType,
    SegmentCommentType,
    SegmentFavouriteType,
    SegmentListenType
};

@interface SystemNotiecPresenter : BasePresenter

@property (nonatomic, strong) NSMutableArray *dataSource;
@property(nonatomic,strong) NSMutableArray *ListenSource;
@property(nonatomic,strong) NSMutableArray *favoriteSource;
@property(nonatomic,strong) NSMutableArray *commentSource;
@property(nonatomic)BOOL noMoreData;
@property(nonatomic,strong) id<SystemNotiecPresenterDelegate> delegate;
@property(nonatomic) SegmentNoticeType types;

-(void)isReadNoticeWithUuid:(NSNumber *)uuid sysBlock:(SystemNoticeBlock)block;

-(void)loadSystemNotice:(NSString *)url;

-(void)loadSystemMoreNotiec:(NSString *)url;

-(void)loadSystemNotice:(NSString *)url ModelType:(SegmentNoticeType)type;

-(void)loadSystemMoreNotiec:(NSString *)url ModelType:(SegmentNoticeType)type;

@end
