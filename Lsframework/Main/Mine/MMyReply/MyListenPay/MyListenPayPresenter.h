//
//  MyListenPayPresenter.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/7/6.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "AliPayUtil.h"

@protocol PayDelegate <NSObject>

- (void)payComplete:(BOOL ) success;

@end

@interface MyListenPayPresenter : BasePresenter

@property (nonatomic, weak) id<PayDelegate> delegate;

- (void)payWithPayType:(NSString *) payType expertID:(NSNumber *) expertID consultationID:(NSNumber *) consultationID;

@end
