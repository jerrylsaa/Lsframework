//
//  AppointInfoPresenter.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/20.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "AppointInfoPresenter.h"

@implementation AppointInfoPresenter


-(void)commitCancelAppointInfo:(NSString *)info AppointID:(NSInteger)appointID{
    NSString* noSpaceStr = [info stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(noSpaceStr.length == 0){
        if(self.delegate && [self.delegate respondsToSelector:@selector(onCompletion:info:)]){
            [self.delegate onCompletion:NO info:@"请输入取消原因"];
        }
        return ;
    }
    
    NSString* content = info;
    NSDictionary* parames = @{@"ID":@(appointID),@"Content":content};
    WS(ws);
    [[FPNetwork POST:API_ADD_UNAPPOINT_REASON withParams:parames] addCompleteHandler:^(FPResponse *response) {
        
        if(response.success){
            
        }
        
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(onCompletion:info:)]){
            [ws.delegate onCompletion:response.success info:response.message];
        }
        
    }];
    
}


@end
