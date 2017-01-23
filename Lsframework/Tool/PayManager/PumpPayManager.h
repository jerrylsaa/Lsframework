//
//  PumpPayManager.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 2016/10/25.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AliPayUtil.h"
#import "WXPayUtil.h"

typedef NS_ENUM(NSUInteger, PayType) {
    PayTypeAli,
    PayTypeWX,
};

@protocol PayDelegate <NSObject>

- (void)InsertConsultingRecordsTrace;
- (void)WXInsertConsultingRecordsTrace;
- (void)payComplete:(BOOL ) success;

@end
@interface PumpPayManager : NSObject

@property (nonatomic, weak) id<PayDelegate> delegate;

@property (nonatomic, copy) NSString *payType;
@property (nonatomic, strong) NSNumber *expertID;
@property (nonatomic, strong) NSNumber *consultationID;
@property (nonatomic, copy) NSString *orderID;
@property (nonatomic, strong) NSNumber *uuid;
@property (nonatomic, assign) float price;
@property (nonatomic, assign) PayType pay;

//支付宝支付
- (void)payWithPayType:(NSString *) payType expertID:(NSNumber *) expertID consultationID:(NSNumber *) consultationID uuid:(NSNumber *)uuid price:(float)price;
//微信支付
-(void)wxpayWithConsultationID:(NSNumber *)consultationID
                         price:(CGFloat)price
                          type:(NSString *)type
                consultContent:(NSString *)text
                      isPublic:(NSString *)isPublic
                        imgArr:(NSArray *)imgArr
                      doctorID:(NSString *)doctorID;
//插入咨询
- (void)InsertConsultingRecordsTrace:(NSDictionary *)parameters;
- (void)WXInsertConsultingRecordsTrace:(NSDictionary *)parameters;
@end
