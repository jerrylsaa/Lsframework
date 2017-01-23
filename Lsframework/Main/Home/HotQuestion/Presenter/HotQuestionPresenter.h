//
//  HotQuestionPresenter.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/8/16.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "NSUserDefaults+Category.h"
#import "HEAParentQuestionEntity.h"
#import "ExpertOfficeEntity.h"
#import "WXPayUtil.h"

typedef void(^LoadHandler)(BOOL success, NSString *message);

@protocol HEAInfoPresenterDelegate <NSObject>
@optional

/**
 *  获取偷听列表，下来刷新回调
 *
 *  @param success <#success description#>
 *  @param message <#message description#>
 */
- (void)onCompletion:(BOOL) success info:(NSString*) message;

/**
 *  加载更多回调
 *
 *  @param success <#success description#>
 *  @param message <#message description#>
 */
- (void)MoreOnCompletion:(BOOL) success info:(NSString*) message;

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
 *  获取科室
 */
- (void)onGetOfficeCompletion:(BOOL) success info:(NSString*) messsage;
//获取限时免费次数完成
- (void)onFreeListeningCountCompletion:(BOOL) success info:(NSString*) messsage;


//获取偷听咨询微信预支付信息回调
- (void)onGetListenWXPrePayCompletion:(BOOL) success info:(NSString*) message PayDict:(NSDictionary *)dict;

//获取微信咨询订单状态回调
- (void)onCheckWXPayResultWithOderCompletion:(BOOL) success info:(NSString*) message Url:(NSString *)url;


@end

@interface HotQuestionPresenter : BasePresenter

@property (nonatomic, strong) NSArray *dataSource;
@property(nonatomic,weak) id<HEAInfoPresenterDelegate> delegate;
@property(nonatomic,retain) NSArray<ExpertOfficeEntity* > * officeDataSource;



@property(nonatomic) BOOL noMoreData;

@property(nonatomic) NSInteger totalCount;

@property(nonatomic, copy) NSString *orderID;//订单号

@property(nonatomic,copy) NSString* bussinessType;

@property(nonatomic,retain) NSString* voiceURL;
@property(nonatomic,strong) NSString *hospitalName;
@property(nonatomic,strong) NSString *officeName;


@property (nonatomic, copy) NSString *payType;
@property (nonatomic, strong) NSNumber *expertID;
@property (nonatomic, strong) NSNumber *consultationID;
//@property (nonatomic, copy) NSString *orderID;
@property (nonatomic, strong) NSNumber *uuid;
@property (nonatomic, assign) NSInteger TraceRecords;

/**
 *  获取对应医生咨询列表接口
 *
 *  @param doctorID <#doctorID description#>
 *  @param status   0，待回复，1，已回复，－1，获取全部
 */
- (void)loadExpertConsultaionData:(NSNumber*) doctorID status:(NSInteger) status;

- (void)loadMoreExpertConsultaionData;

/**
 *  添加咨询
 *
 *  @param consultationConten 咨询内容
 */
- (void)addExpertConsultation:(NSString*) consultationContent doctorID:(NSNumber*) doctorID photo:(NSArray *)photoUrl isOpen:(BOOL)isopen;

/**
 *  获取订单号
 *
 *  @param bussinessType 咨询：questionBiz，偷听：listenBiz
 *  @param price         <#price description#>
 *  @param payType       支付宝：alipay，微信：wxpay
 */
- (void)getTradeID:(NSString*) bussinessType withPrice:(CGFloat) price withPayType:(NSString*) payType;

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

- (void)refreshHotQuestion:(LoadHandler)block;
- (void)loadMoreHotQuestion:(LoadHandler)block;
- (void)loadExpertOffice;
//限时免费计数
-(void)FreeListeningCountWithConsultationID:(NSInteger)ConsultationID;

//微信支付语音
- (void)weixinPayWithListenId:(NSInteger )questionId;

- (void)checkWXPayResultWithOder:(NSString *)oder;

@end

