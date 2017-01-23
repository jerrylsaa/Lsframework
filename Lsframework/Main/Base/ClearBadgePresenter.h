//
//  ClearBadgePresenter.h
//  FamilyPlatForm
//
//  Created by jerry on 16/10/31.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"

typedef void(^ClearBadgeHandler )(BOOL success, NSString *_Nonnull message);

@interface ClearBadgePresenter : BasePresenter

@property(nonatomic) NSInteger badgeCount;

-(void)ClearBadgeByBadgeID:(NSInteger)BadgeID finish:( _Nullable ClearBadgeHandler)block;

@end
