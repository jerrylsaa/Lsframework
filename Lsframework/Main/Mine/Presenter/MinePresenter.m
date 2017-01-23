//
//  MinePresenter.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/27.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MinePresenter.h"
#import "UIImage+Category.h"



@implementation MinePresenter

-(void)getChildInfo{
    WS(ws);
    FPNetwork *network = [FPNetwork POST:API_PHONE_QUERY_BABY_ARCHIVES_INFO withParams:@{@"userId":@(kCurrentUser.userId)}];
    [network addCompleteHandler:^(FPResponse *response) {
        [DefaultChildEntity MR_truncateAll];
        if (response.isSuccess) {
            [DefaultChildEntity mj_objectWithKeyValues:response.data context:[NSManagedObjectContext MR_defaultContext]];
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];

            ws.GBchildEntity = [GBChildEntity mj_objectWithKeyValues:response.data];
        }
            if(ws.delegate && [ws.delegate respondsToSelector:@selector(onGetChildInfoComplete:info:)]){
                [ws.delegate onGetChildInfoComplete:response.success info:response.message];
            }
        }];
        
    }

- (void)getMyServicePackage{
    NSInteger userID = kCurrentUser.userId;
    //    userID = 8;//测试
    
    NSDictionary* parames = @{@"UserID":@(userID)};
    WS(ws);
    [[FPNetwork POST:API_QUERY_MY_SERVICE_PACKAGE withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success){
            ws.dataSource = [Package mj_objectArrayWithKeyValuesArray:response.data];
        }
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(onComplete:info:)]){
            [ws.delegate onComplete:response.success info:response.message];
        }
    }];
}



-(void)changeChildAvaterWithPath:(NSString *)path{
    runOnMainThread(^{
        [ProgressUtil showWithStatus:@"正在上传头像"];
    });
    FormData * formData = [FormData new];
    UIImage * image = [UIImage imageWithContentsOfFile:path];
    //    formData.data = UIImagePNGRepresentation(image);
    formData.data = [image resetSizeOfImageData:image maxSize:500];
    
    formData.fileName = @"file.png";
    formData.name = @"file";
    formData.mimeType = @"image/png";
    [[FPNetwork POST:nil withParams:nil withFormDatas:@[formData]] addCompleteHandler:^(FPResponse *response) {
        if (response.success) {
            NSDictionary* dic = [response.data dictionary];
            if ([dic.allKeys containsObject:@"Result"]){
                NSString* result = dic[@"Result"];
                NSArray* array = [result componentsSeparatedByString:@","];
                NSString* first = [array firstObject];
                NSArray* subArray = [first componentsSeparatedByString:@"|"];
                
                NSString * url = [subArray lastObject];
                if (url) {
                    //            childImg
                    //保存最新头像url
                    DefaultChildEntity* child = [DefaultChildEntity defaultChild];
                    child.childImg = url;
                    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
                    if ([DefaultChildEntity defaultChild].babyID) {
                        [[FPNetwork POST:API_ADD_BABYHEADER withParams:@{@"BabyID":[DefaultChildEntity defaultChild].babyID, @"HeadPortraitUrl":url}] addCompleteHandler:^(FPResponse *response) {
                            if (response.success) {
                                [_delegate onChangeChildAvaterCompleted:path];
                                [ProgressUtil showSuccess:@"上传成功"];
                            }
                        }];
                    }else{
                        [ProgressUtil showError:@"上传图片成功，获取默认宝贝ID失败"];
                    }
                }else{
                    [ProgressUtil showError:@"上传图片成功，解析图片地址失败"];
                }
                
                
            }
            
        }else{
            [ProgressUtil showError:@"上传失败"];
        }
    }];
}
-(void)getExperIDByUserID{
    WS(ws);
    [[FPNetwork POST:API_GET_EXPERID_BY_USERID withParams:@{@"userid":@(kCurrentUser.userId)}] addCompleteHandler:^(FPResponse *response) {
        if(response.success){
            ws.GBChilSource = [GBChildEntity mj_objectArrayWithKeyValuesArray:response.data];
        }
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(onGetgetExperIDComplete:info:)]){
            [ws.delegate onGetgetExperIDComplete:response.success info:response.message];
        }
    }];


}

- (void)getShareCouponNumber{
    WS(ws);
    [[FPNetwork POST:API_InsertShare withParams:@{@"userID":@(kCurrentUser.userId)}] addCompleteHandler:^(FPResponse *response) {
        if(response.success){
            if (response.data!=nil) {
                NSString *num =response.data;
                
                if(ws.delegate && [ws.delegate respondsToSelector:@selector(onGetShareCouponNumberComplete: info: Coupon:)]){
                    [ws.delegate onGetShareCouponNumberComplete:YES info:response.message Coupon:num];
                }
            }else{
                if(ws.delegate && [ws.delegate respondsToSelector:@selector(onGetShareCouponNumberComplete: info: Coupon:)]){
                    [ws.delegate onGetShareCouponNumberComplete:NO info:response.message Coupon:nil];
                }
            }
            
        }else {
            if(ws.delegate && [ws.delegate respondsToSelector:@selector(onGetShareCouponNumberComplete: info: Coupon:)]){
                [ws.delegate onGetShareCouponNumberComplete:NO info:response.message Coupon:nil];
            }

        }
    }];
}


-(void)loadAllBaby{
    NSInteger userId = kCurrentUser.userId;
    NSDictionary* parames = @{@"userID":@(userId)};
    WS(ws);
    [[FPNetwork POST:API_PHONE_QUERY_BABY_ARCHIVESLIST withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success){
            ws.responseStatus = response.status;
            ws.babyDataSource = [BabayArchList mj_objectArrayWithKeyValuesArray:response.data];
        }
        
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(loadAllBabyComplete:info:)]){
            [ws.delegate loadAllBabyComplete:response.success info:response.message];
        }
        
        
    }];

}

- (void)getVaccineEventWithmonth:(NSString*)Month{
    WS(ws);
    [[FPNetwork POST: API_GET_FIRST_VACCINE withParams:@{@"BirthDate":Month}] addCompleteHandler:^(FPResponse *response) {

        if (response.success) {
            ws.VaccineSource = [VaccineEvent mj_objectArrayWithKeyValuesArray:response.data];
            
        }
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(loadVaccienComplete:info:)]){
            [ws.delegate  loadVaccienComplete:response.success info:response.message];
        }
    }];

}

-(void)setDefaultBaby:(BabayArchList *)baby{
    NSInteger babyID = baby.childID;
    NSInteger userID = kCurrentUser.userId;
    
    NSDictionary* parames = @{@"UserID":@(userID),@"BabyID":@(babyID)};
    
    WS(ws);
    [[FPNetwork POST:API_SET_DEFAULTBABY withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success){
            //            ws.currentBaby = baby;
        }
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(setDefaultBabyCompletion:info:)]){
            [ws.delegate setDefaultBabyCompletion:response.success info:response.message];
        }
        
    }];
    
    
}




@end
