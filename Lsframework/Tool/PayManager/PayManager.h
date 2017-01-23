//
//  PayManager.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/8/17.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AliPayUtil.h"

@protocol PayDelegate <NSObject>

- (void)payComplete:(BOOL ) success;

@end

@interface PayManager : NSObject

@property (nonatomic, weak) id<PayDelegate> delegate;

- (void)payWithPayType:(NSString *) payType expertID:(NSNumber *) expertID consultationID:(NSNumber *) consultationID uuid:(NSNumber *)uuid;

@end

