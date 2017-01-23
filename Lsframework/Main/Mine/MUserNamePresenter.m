//
//  MUserNamePresenter.m
//  FamilyPlatForm
//
//  Created by jerry on 16/9/11.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MUserNamePresenter.h"

@implementation MUserNamePresenter

- (void)SetNickName:(NSString*)nickName{
    NSInteger userId = kCurrentUser.userId;
    //    userId = 1;//测试
    NSDictionary* parames = @{@"userID":@(userId),@"nickName":nickName};
    WS(ws);
    [[FPNetwork POST:API_SET_NICKNAME withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success == YES){
            if ([((NSNumber *)response.data) boolValue] == NO) {
                if(ws.delegate && [ws.delegate respondsToSelector:@selector(onCompletion:info:)]){
                    [ws.delegate onCompletion:NO info:@"修改失败"];
                }
            }else{
                if(ws.delegate && [ws.delegate respondsToSelector:@selector(onCompletion:info:)]){
                    [ws.delegate onCompletion:YES info:@"修改成功"];
                }
            }
        }else{
            if(ws.delegate && [ws.delegate respondsToSelector:@selector(onCompletion:info:)]){
                [ws.delegate onCompletion:NO info:response.message];
            }
        }
    }];
}

@end
