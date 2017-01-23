//
//  HEAInfoPresenter.h
//  FamilyPlatForm
//
//  Created by lichen on 16/6/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "HEAParentQuestionEntity.h"
#import "NSUserDefaults+Category.h"
#import "CouponList.h"
#import "WXPayUtil.h"
#import "ExpertCommentListEntity.h"

typedef void(^AddComplete)(BOOL success, NSString *message);
typedef void(^isDoctor)(BOOL isDoctor, NSString *message);

@protocol HEAInfoPresenterDelegate <NSObject>
@optional

/**
 *  获取偷听列表，下来刷新回调
 *
 *  @param success <#success description#>
 *  @param message <#message description#>
 */
- (void)onCompletion:(BOOL) success info:(NSString*) message;

- (void)onHYBCompletion:(BOOL) success info:(NSString*) message;


/**
 *  加载更多回调
 *
 *  @param success <#success description#>
 *  @param message <#message description#>
 */
- (void)MoreOnCompletion:(BOOL) success info:(NSString*) message;

//获取问题咨询微信预支付信息回调
- (void)onGetWXPrePayCompletion:(BOOL) success info:(NSString*) message PayDict:(NSDictionary *)dict;
//获取微信订单状态回调
- (void)onCheckWXPayResultWithOderCompletion:(BOOL) success info:(NSString*) message Url:(NSString *)url;

//获取偷听咨询微信预支付信息回调
- (void)onGetListenWXPrePayCompletion:(BOOL) success info:(NSString*) message PayDict:(NSDictionary *)dict;

/**
 *  添加提问咨询回调
 *
 *  @param success <#success description#>
 *  @param message <#message description#>
 */
- (void)addOnCompletion:(BOOL) success info:(NSString*) message;

/**
 *  获取订单号回调
 *
 *  @param success <#success description#>
 *  @param message <#message description#>
 */
- (void)tradeIDOnCompletion:(BOOL) success info:(NSString*) message;

/**
 *  添加订单支付回调
 *
 *  @param success <#success description#>
 *  @param message <#message description#>
 */
- (void)paySuccessOnCompletion:(BOOL) success info:(NSString*) message;

/**
 *  添加偷听完成回调
 *
 *  @param success <#success description#>
 *  @param message <#message description#>
 */
- (void)listenOnCompletion:(BOOL)success info:(NSString*)message;

/**
 *  下载音频完成回调
 *
 *  @param success <#success description#>
 *  @param message <#message description#>
 */
- (void)downloadOnCompletion:(BOOL) success info:(NSString*) message;

- (void)uploadPhotoDataOnCompletion:(BOOL) success info:(NSString*) message urlPhotoPathArr:(NSMutableArray *)photoPathArr;
/**
 *  获取当天可用优惠券次数
 */
- (void)GetExpertCanConsumeCountOnCompletion:(BOOL) success info:(NSString*) message;

/**
 *  获取当前用户可用优惠券
 */
-(void)GetCouPonListCompletion:(BOOL)success info:(NSString*)message;
/**
 *  获取的价格后回调
 */
-(void)GetConsultationCouponPriceCompletion:(BOOL)success info:(NSString*)message;
/**
 *  消费优惠券成功回调
 */

-(void)GetConsumptionCouponCompletion:(BOOL)success info:(NSString*)message;

-(void)GetCouponByCouponCodeCompletion:(BOOL)success info:(NSString*)message;

- (void)getExpertCommentListSuccess;

@end

@interface HEAInfoPresenter : BasePresenter

@property(nonatomic,weak) id<HEAInfoPresenterDelegate> delegate;

@property(nonatomic,retain) NSArray<HEAParentQuestionEntity* > * dataSource;

@property (nonatomic,retain) ExpertCommentListEntity *myCommentListEntity;
@property(nonatomic,retain) NSArray<ExpertCommentListEntity* > * myCommentListDataSource;



@property(nonatomic) BOOL noMoreData;

@property(nonatomic) NSInteger totalCount;

@property(nonatomic, copy) NSString *orderID;//订单号

@property(nonatomic,copy) NSString* bussinessType;

@property(nonatomic,retain) NSString* voiceURL;
@property(nonatomic,retain) NSNumber* Couponcount;
@property(nonatomic,assign) NSInteger  Status;
@property(nonatomic,assign) float   price;
@property(nonatomic,retain) NSArray<CouponList* > * CouPonSource;

/**
 *  获取对应医生咨询列表接口
 *
 *  @param doctorID <#doctorID description#>
 *  @param status   0，待回复，1，已回复，－1，获取全部
 */
- (void)loadExpertConsultaionData:(NSNumber*) doctorID status:(NSInteger) status;

- (void)loadCommonExpertConsultaionData:(NSNumber*) doctorID status:(NSInteger) status;

-(void)loadHYBExpertConsultaionData:(NSNumber *)doctorID status:(NSInteger)status;

- (void)loadMoreExpertConsultaionData;

/**
 *  添加咨询
 *
 *  @param consultationConten 咨询内容
 */
//- (void)addExpertConsultation:(NSString*) consultationContent doctorID:(NSNumber*) doctorID photo:(NSArray *)photoUrl isOpen:(BOOL)isopen couponid:(NSNumber*)couponIDD;
- (void)addExpertConsultation:(NSString *)consultationContent doctorID:(NSNumber *)doctorID photo:(NSArray *)photoUrl isOpen:(BOOL)isopen couponid:(NSNumber*)couponIDD  Freeclinic:(NSNumber*)Freeclinic;

/**
 *  获取订单号
 *
 *  @param bussinessType 咨询：questionBiz，偷听：listenBiz
 *  @param price         <#price description#>
 *  @param payType       支付宝：alipay，微信：wxpay
 */
- (void)getTradeID:(NSString*) bussinessType withPrice:(CGFloat) price withPayType:(NSString*) payType;

- (void)getTradeID:(NSString*) bussinessType withPrice:(CGFloat) price withPayType:(NSString*) payType withCouponID:(NSNumber *)couponID;

/**
 *  订单支付成功
 */
- (void)tradePaySuccessWithOrderID:(NSString *) orderID;

/**
 *  添加偷听
 *
 *  @param question <#question description#>
 */
- (void)addListenQuestion:(HEAParentQuestionEntity*) question withListenPrice:(CGFloat) listenPrice;

/**
 *  下载音频文件
 *
 *  @param url <#url description#>
 */
- (void)downloadAudioFile:(NSString*) url;



//上传图片
- (void)uploadPhoto:(NSMutableArray *)photoArr;

/**
 *  获取当天可用的优惠券次数
 
 */

-(void)GetExpertCanConsumeCountWithExpertID:(NSNumber*)expertID;

/**
 *  判断当前用户是否有可用优惠券
 */
-(void)getCouPonList;
/**
 *  调用获取价格接口
 */


-(void)GetConsultationConsumptionCouponPriceWithCouponID:(NSNumber*)coupid  Expert_ID:(NSNumber*)expertID;

/**
 *  消费优惠券
 */
-(void)GetConsumptionCouponWithcouponID:(NSNumber*)coupid  expert_ID:(NSNumber*)expertID  ConsultationID:(NSNumber*)consultationid;

- (void)addExpertConsultation:(NSString *)consultationContent doctorID:(NSNumber *)doctorID photo:(NSArray *)photoUrl isOpen:(BOOL)isopen complete:(AddComplete)block;

- (void)weixinPayOpenImage:(BOOL)isOpenImage PhotoArr:(NSArray *)photoArr Question:(NSString *)question DoctorId:(NSNumber *)doctorId;

- (void)weixinPayOpenImage:(BOOL)isOpenImage PhotoArr:(NSArray *)photoArr Question:(NSString *)question DoctorId:(NSNumber *)doctorId CouponID:(NSNumber *)couponID;

- (void)checkWXPayResultWithOder:(NSString *)oder;

- (void)weixinPayWithListenId:(NSInteger )questionId;



- (void)getCouponByCouponCode:(NSString *)code;


- (void)getExpertCommentListByExpertID:(NSNumber *)expertID;



- (void)getExperIDByUserID:(isDoctor) block;

@end
