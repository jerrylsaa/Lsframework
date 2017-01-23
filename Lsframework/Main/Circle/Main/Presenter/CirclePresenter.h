//
//  CirclePresenter.h
//  FamilyPlatForm
//
//  Created by lichen on 16/9/20.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "CircleEntity.h"
#import "AliPayUtil.h"
#import "VoiceConverter.h"
#import "NSUserDefaults+Category.h"
#import "WXPayUtil.h"

#define kListenIDKeyPath @"listenOrderID"
#define kAddListenKeyPath @"addListen"


@protocol CirclePresenterDelegate <NSObject>

@optional
- (void)loadCompleteWith:(BOOL) success info:(NSString* _Nonnull) message;
- (void)loadMoreCompleteWith:(BOOL) success info:(NSString* _Nonnull) message;

- (void)payCompleteWithAudioURL:(NSURL* _Nonnull) audioURL;

@end

@interface CirclePresenter : BasePresenter

@property(nullable,nonatomic,retain) NSMutableArray<CircleEntity*>* dataSource;
@property(nullable,nonatomic,weak) id<CirclePresenterDelegate> delegate;
@property(nonatomic)BOOL noMoreData;

@property(nullable,nonatomic,copy) NSString* orderID;//订单号
@property(nullable,nonatomic,retain) CircleEntity* circleEntity;//圈子model
@property(nonatomic)CGFloat payPrice;

/**
 下拉刷新
 */
- (void)loadCircleData;

/**
 上拉加载
 */
- (void)loadMoreCircleData;


/**
 支付

 @param price   偷听价格
 @param payType 支付方式：支付宝：alipay，微信：wxpay
 */
- (void)payWithListenPrice:(CGFloat) price payType:(NSString* _Nonnull) payType;

/**
 获取订单号

 @param price   价格，默认是1元
 @param payType 支付宝：alipay，微信：wxpay
 */
- (void)getTradeIDwithPrice:(CGFloat) price withPayType:(NSString* _Nonnull) payType;

/**
 支付宝支付
 
 @param price 支付价格
 */
- (void)payByAliPayWithorderID:(NSString* _Nonnull) orderID price:(CGFloat) price;


/**
 支付成以后，走付款成功接口

 @param orderID 订单ID
 */
- (void)paySuccessWithOrderID:(NSString* _Nonnull) orderID;


/**
 插入偷听列表

 @param circleEntity <#circleEntity description#>
 @param price        <#price description#>
 @param orderID      <#orderID description#>
 */
- (void)insertListenQuestion:(CircleEntity* _Nonnull) circleEntity price:(CGFloat) price orderID:(NSString* _Nonnull) orderID;


/**
 下载音频文件

 @param audioURL 音频URL
 */
-(void)downloadAudioFile:(NSString* _Nonnull) audioURL;


/**
 转换音频

 @param audioSourceURL <#audioSourceURL description#>
 */
- (void)convertAmrToWav:(NSString* _Nonnull) audioSourceURL;


/**
 微信支付

 @param consultationID 咨询id
 @param price          价格
 @param type           咨询类型：语音：listenBiz
 */
- (void)wxpayWithConsultationID:(NSNumber* _Nonnull) consultationID price:(CGFloat) price type:(NSString* _Nonnull) type;


/**
 检查微信支付结果

 @param orderNO <#orderNO description#>
 */
- (void)checkWXPayResultWithOder:(NSString* _Nonnull) orderNO;

@end
