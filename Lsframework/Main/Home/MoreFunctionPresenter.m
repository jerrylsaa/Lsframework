//
//  MoreFunctionPresenter.m
//  FamilyPlatForm
//
//  Created by jerry on 16/11/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MoreFunctionPresenter.h"

@implementation MoreFunctionPresenter

-(void)loadMoreFunction{

    WS(ws);
    [[FPNetwork POST:@"getgrowhappy" withParams:nil] addCompleteHandler:^(FPResponse *response) {
        if (response.success ) {
            if (response.data != nil && [(NSArray *)response.data count] != 0) {
                
                ws.MoreFunctionSource = [MoreFunction mj_objectArrayWithKeyValuesArray:response.data];
                
            }
            
        }else{
            [ProgressUtil showError:response.message];
        }
        
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(LoadMoreFunctionComplete:info:)]){
            [ws.delegate  LoadMoreFunctionComplete:response.success info:response.message];
        }
        
    }];
}

#pragma mark---  获取外网密码
- (void)getOtherPWDByUserID:(haveOtherPWD) block{
    
    [[FPNetwork POST:@"GetUserOtherPass" withParams:@{@"userid":@(kCurrentUser.userId)}] addCompleteHandler:^(FPResponse *response) {
        
        if (response.data) {
            
            if ([response.data isEqualToString:@""]) {
                //没有
                block(NO,nil);
                
                
                
            }else{
                //已有外网密码
                block(YES,response.data);
            }
        }else{
            block(NO,@"error");
            [ProgressUtil showError:response.message];
        }
    }];
}

#pragma mark---  创建外网密码
- (void)createOtherPWDRequest:(createOtherPWD)block{
    // kCurrentUser.userPasswd
    
    [[FPNetwork POST:@"SetUserOtherPass" withParams:@{@"userid":@(kCurrentUser.userId),@"otherPass":kCurrentUser.userPasswd}] addCompleteHandler:^(FPResponse *response) {
        
        if (response.data) {
            
            
            //创建外网密码成功
            block(YES,nil);
            
        }else{
            block(NO,nil);
            [ProgressUtil showError:response.message];
        }
    }];
}
@end
