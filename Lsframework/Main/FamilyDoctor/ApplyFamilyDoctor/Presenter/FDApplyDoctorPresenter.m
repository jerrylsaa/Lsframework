//
//  FDApplyDoctorPresenter.m
//  FamilyPlatForm
//
//  Created by tom on 16/4/13.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "FDApplyDoctorPresenter.h"
#import "ChildEntity.h"

@implementation FDApplyDoctorPresenter

- (void)loadBabyData:(Complete)block{
    NSDictionary *parameters = [NSDictionary dictionaryWithObject:@(kCurrentUser.userId) forKey:@"userID"];
    [[FPNetwork POST:API_PHONE_QUERY_BABY_ARCHIVES_LIST withParams:parameters] addCompleteHandler:^(FPResponse *response) {
        if (response.success) {
//            NSMutableArray *babyArray = [NSMutableArray array];
            
           NSArray* babyArray = [ChildEntity mj_objectArrayWithKeyValuesArray:response.data];
            
//            for (NSDictionary *dic in response.data) {
//                ChildEntity *entity = [ChildEntity new];
//                entity.childName = [dic objectForKey:@"Child_Name"];
//                entity.childSex = [dic objectForKey:@"Sex"];
//                entity.childGroupTime = [dic objectForKey:@"NL"];
//                [babyArray addObject:entity];
//            }
            block(response.success ,babyArray);
        }
    }]; 
}


-(void)commitFamilyDoctor:(NSInteger)doctorID babyID:(NSInteger)babyID packageID:(NSInteger)packageID{
    NSInteger userID = kCurrentUser.userId;
    packageID = 1;//测试----
    NSDictionary* parames =@{@"UserID":@(userID), @"DoctorID":@(doctorID), @"BabyID":@(babyID), @"PackageID":@(packageID)};
    WS(ws);
    [[FPNetwork POST:API_ADD_FAMILY_DOCTOR withParams:parames] addCompleteHandler:^(FPResponse *response) {
       
//        NSLog(@"==%@",response.data);
        
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(onCompletion:info:)]){
            [ws.delegate onCompletion:response.success info:response.message];
        }
    }];
}


@end
