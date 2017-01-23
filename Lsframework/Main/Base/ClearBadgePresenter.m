//
//  ClearBadgePresenter.m
//  FamilyPlatForm
//
//  Created by jerry on 16/10/31.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ClearBadgePresenter.h"

@implementation ClearBadgePresenter


-(void)ClearBadgeByBadgeID:(NSInteger)BadgeID finish:(ClearBadgeHandler)block{
WS(ws);
[[FPNetwork POST:API_CLEARBADGE withParams:@{@"userid":@(kCurrentUser.userId),@"badgeID":@(BadgeID)}] addCompleteHandler:^(FPResponse *response) {
    if (response.success == YES) {
        
        NSArray *dataDic =response.data;
        NSDictionary  *dic = [dataDic firstObject];
        ws.badgeCount = [[dic valueForKey:@"ReceiveUnreadCount"] integerValue];
        NSLog(@"respondata:%d",ws.badgeCount);

        block(YES,nil);
    }else{
        block(NO,nil);
    }
}];
}
@end
