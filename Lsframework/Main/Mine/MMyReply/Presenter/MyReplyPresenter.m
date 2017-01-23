//
//  MyReplyPresenter.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/6/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MyReplyPresenter.h"
#import "FPNetwork.h"

@implementation MyReplyPresenter

- (void)getExperIDByUserID:(isDoctor) block{
    [ProgressUtil show];
    [[FPNetwork POST:API_GET_EXPERID_BY_USERID withParams:@{@"userid":@(kCurrentUser.userId)}] addCompleteHandler:^(FPResponse *response) {
        
        if (response.data) {
            [ProgressUtil dismiss];
            if ([response.data count] == 0) {
                //非医生
                block(NO,nil);

//                block(YES,@"1");//模拟医生

            }else{
                //医生
                NSDictionary *dic = ((NSArray *)response.data).firstObject;
                NSString *doctorID = [NSString stringWithFormat:@"%@",dic[@"ExperID"]];
                block(YES,doctorID);
            }
        }else{
            [ProgressUtil showError:response.message];
        }
    }];
}

@end
