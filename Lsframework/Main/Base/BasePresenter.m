//
//  BasePresenter.m
//  FamilyPlatForm
//
//  Created by Tom on 16/3/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"


@implementation BasePresenter

+(void)EventStatisticalDotTitle:(NSString*)selfTitle Action:(NSString*)Event Remark:(NSString*)remark   {
    NSDictionary *infoDic =[[NSBundle mainBundle] infoDictionary];
//    NSString *currentStatus =[infoDic valueForKey:@"CFBundleVersion"];
    NSString *app_Version = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"++++++++++++++%@",app_Version);
NSDictionary * parames = @{@"Point":selfTitle,@"UserID":@(kCurrentUser.userId),@"Action":Event,@"AppType":@(1),@"Version":app_Version};
    if (remark != nil) {
        parames = @{@"Point":selfTitle,@"UserID":@(kCurrentUser.userId),@"Action":Event,@"AppType":@(1),@"Version":app_Version,@"Remark":remark};
    }

    [[FPNetwork POST:@"AddUserPoint" withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success){
            
            NSLog(@"%@----打点成功",selfTitle);
        }else {
           NSLog(@"%@----打点失败",selfTitle);
            
        }
    }];
    
    
    





}
+(void)EventStatisticalDotTitle:(NSString*)selfTitle Action:(NSString*)Event Remark:(NSString*)remark   SrcID:(NSNumber*)SrcID{
    
    NSDictionary *infoDic =[[NSBundle mainBundle] infoDictionary];
    //    NSString *currentStatus =[infoDic valueForKey:@"CFBundleVersion"];
    NSString *app_Version = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"++++++++++++++%@",app_Version);
    NSDictionary * parames = @{@"Point":selfTitle,@"UserID":@(kCurrentUser.userId),@"Action":Event,@"AppType":@(1),@"Version":app_Version,@"SrcID":SrcID};
    if (remark != nil) {
        parames = @{@"Point":selfTitle,@"UserID":@(kCurrentUser.userId),@"Action":Event,@"AppType":@(1),@"Version":app_Version,@"Remark":remark,@"SrcID":SrcID};
    }
    
    [[FPNetwork POST:@"AddUserPoint" withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success){
            
            NSLog(@"%@----打点成功",selfTitle);
        }else {
            NSLog(@"%@----打点失败",selfTitle);
            
        }
    }];
    
    
    
 
    
}
@end
