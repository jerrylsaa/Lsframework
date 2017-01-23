//
//  DietManagerPresenter.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/11/16.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "DietManagerPresenter.h"
#import "UIImage+Category.h"

@implementation DietManagerPresenter

- (void)uploadPhoto:(UIImage *)photo{
    
    WS(ws);
    
    FormData * formData = [FormData new];
    formData.data = [photo resetSizeOfImageData:photo maxSize:200];
    //        formData.data = UIImagePNGRepresentation(image);
    
    formData.fileName = @"file.png";
    formData.name = @"file";
    formData.mimeType = @"image/png";
    
    [[FPNetwork POST:UPLOAD_URL withParams:nil withFormDatas:@[formData]] addCompleteHandler:^(FPResponse *response) {
        if (response.success) {
            
            NSDictionary *data = [response.data dictionary];
            NSLog(@"%@", response.data);
            NSString *uploadPath = [data[@"Result"] getUploadPath];
            WSLog(@"======%@",uploadPath);
            NSString *resultUrl =[NSString stringWithFormat:@"%@%@",ICON_URL,uploadPath];
                
            if(ws.delegate && [ws.delegate respondsToSelector:@selector(uploadPhotoDataOnCompletion: Info: photoUrl:)]){
                [ws.delegate uploadPhotoDataOnCompletion:YES Info:response.message photoUrl:resultUrl];
            }else{
                [ProgressUtil showError:@"网络不可用,请重试"];
            }
            
            
        }else {
            
            
            [ProgressUtil showError:@"网络不可用,请重试"];
            
        }
        
    }];
    
    
}

- (void)getBabyFoodTips{
    NSDictionary* parames = @{@"UserID":@(kCurrentUser.userId)};
    WS(ws);
    [[FPNetwork POST:API_GetBabyFoodTips withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success) {
            if (response.data!=nil) {
                
                NSDictionary *dic1 =response.data;
                
                ws.babyFoodTipsSource = [BabyFoodTipsEntity  mj_objectArrayWithKeyValuesArray:[dic1 objectForKey:@"GuideQuantitys"]];
                NSLog(@"%@",ws.babyFoodTipsSource[0].TYPE_NAME);
                if ([dic1 objectForKey:@"guide"]!=nil) {
                    
                    NSDictionary *dic2 =[dic1 objectForKey:@"guide"];
                    if ([dic2 objectForKey:@"TIPS"]!=nil) {
                        NSString *tips =[dic2 objectForKey:@"TIPS"];

                        if(ws.delegate && [ws.delegate respondsToSelector:@selector(getBabyTips:)]){
                            [ws.delegate getBabyTips:tips];
                        }
                        else {
                            [ProgressUtil showError:response.message];

                        }
                    }
                    else {
                        [ProgressUtil showError:response.message];
                        
                    }
                }else {
                    [ProgressUtil showError:response.message];
                    
                }
//                
                
            }else {
                [ProgressUtil showError:response.message];
                
            }
            
            
        }else if (response.status ==500){
            [ProgressUtil showError:response.message];
        }else {
            [ProgressUtil showError:@"网络不可用,请重试"];
            
        }
        
    }];
}

- (void)getHotKeyWord{
//    GetHotKeyWord
    NSDictionary* parames = @{@"UserID":@(kCurrentUser.userId)};
    WS(ws);
    [[FPNetwork POST:API_GetHotKeyWord withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success) {
            if (response.data!=nil) {
                ws.hotKeySource = [DMHotKeyEntity  mj_objectArrayWithKeyValuesArray:response.data];
//
                if(ws.delegate && [ws.delegate respondsToSelector:@selector(getHotKeyOnCompletion: Info:)]){
                    [ws.delegate getHotKeyOnCompletion:YES Info:response.message];
                }else{
                    [ProgressUtil showError:@"网络不可用,请重试"];
                }
            }else{
                [ProgressUtil showError:@"网络不可用,请重试"];
            }
            
            
        }else if (response.status ==500){
            [ProgressUtil showError:response.message];
        }else {
            [ProgressUtil showError:@"网络不可用,请重试"];
            
        }
        
    }];
    
}

- (void)searchFoodByKeyWords:(NSString *)keyWord OrUrl:(NSString *)url{
    NSDictionary* parames =[NSDictionary dictionary];
    if (keyWord!=nil) {
        parames = @{@"UserID":@(kCurrentUser.userId),@"KeyWords":keyWord};

    }else{
        parames = @{@"UserID":@(kCurrentUser.userId),@"ImgUrl":url};
    }
    WS(ws);
    [[FPNetwork POST:API_SearchFoodByKeyWords withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success) {
            if (response.data!=nil) {
                ws.foodSearchResultSource = [FoodSearchResultEntity  mj_objectArrayWithKeyValuesArray:response.data];
                //
                if(ws.delegate && [ws.delegate respondsToSelector:@selector(getFoodSearchResultOnCompletion: Info:)]){
                    [ws.delegate getFoodSearchResultOnCompletion:YES Info:response.message];
                }else{
                    [ProgressUtil showError:@"网络不可用,请重试"];
                }
            }else{
                if (keyWord==nil) {
                    [ProgressUtil showError:@"无法识别该图"];
                }else{
                    [ProgressUtil showError:@"暂无该食材资料"];
                }
                
            }
            
            
        }else if (response.status ==500){
            [ProgressUtil showError:response.message];
        }else {
            [ProgressUtil showError:@"网络不可用,请重试"];
            
        }
        
    }];
}

- (void)addUserFoodByFoodID:(NSNumber *)foodID{
    
    NSDictionary* parames = @{@"UserID":@(kCurrentUser.userId),@"FoodID":foodID};
    
    WS(ws);
    [[FPNetwork POST:API_AddUserFood withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success) {
            

            if(ws.delegate && [ws.delegate respondsToSelector:@selector(addUserFoodOnCompletion: Info:)]){
                [ws.delegate addUserFoodOnCompletion:YES Info:response.message];
            }else{
                [ProgressUtil showError:@"网络不可用,请重试"];
            }
            
            
            
        }else if (response.status ==500){
            [ProgressUtil showError:response.message];
        }else {
            [ProgressUtil showError:@"网络不可用,请重试"];
            
        }
        
    }];

}

- (void)getUserFoodList{

    NSDictionary* parames = @{@"UserID":@(kCurrentUser.userId)};
    
    WS(ws);
    [[FPNetwork POST:API_GetUserFoodList withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success) {
            if (response.data!=nil) {
                ws.myFoodListSource = [DMMyFoodListEntity  mj_objectArrayWithKeyValuesArray:response.data];
                
                if(ws.delegate && [ws.delegate respondsToSelector:@selector(getUserFoodListOnCompletion: Info:)]){
                    [ws.delegate getUserFoodListOnCompletion:YES Info:response.message];
                }else{
                    [ProgressUtil showError:@"网络不可用,请重试"];
                }
                
            }else{
                ws.myFoodListSource =nil;
                if(ws.delegate && [ws.delegate respondsToSelector:@selector(getUserFoodListOnCompletion: Info:)]){
                    [ws.delegate getUserFoodListOnCompletion:YES Info:response.message];
                }else{
                    [ProgressUtil showError:@"网络不可用,请重试"];
                }
            }
            
            
        }else if (response.status ==500){
            [ProgressUtil showError:response.message];
        }else {
            [ProgressUtil showError:@"网络不可用,请重试"];
            
        }
        
    }];
}

- (void)delUserFoodByFoodID:(NSNumber *)foodID{

    NSDictionary* parames = @{@"UserID":@(kCurrentUser.userId),@"FoodID":foodID};
    
    WS(ws);
    [[FPNetwork POST:API_DelUserFood withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success) {
            
                
            if(ws.delegate && [ws.delegate respondsToSelector:@selector(delUserFoodOnCompletion: Info:)]){
                [ws.delegate delUserFoodOnCompletion:YES Info:response.message];
            }else{
                [ProgressUtil showError:@"网络不可用,请重试"];
            }
            
            
            
        }else if (response.status ==500){
            [ProgressUtil showError:response.message];
        }else {
            [ProgressUtil showError:@"网络不可用,请重试"];
            
        }
        
    }];
}

- (void)getFoodAnalysis{
    _myDietIllSource =[NSMutableArray array];
    NSDictionary* parames = @{@"UserID":@(kCurrentUser.userId)};
    
    WS(ws);
    [[FPNetwork POST:API_GetFoodAnalysis withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success) {
            if (response.data!=nil) {
                ws.myDietAnalysisSource = [DMMyDietAnalysisEntity  mj_objectArrayWithKeyValuesArray:response.data];
                
                for (DMMyDietAnalysisEntity *analysis in ws.myDietAnalysisSource) {
                    [_myDietIllSource addObject:analysis.ILL_MATCHED];
                }
                
                if(ws.delegate && [ws.delegate respondsToSelector:@selector(getDietAnalysisOnCompletion: Info:)]){
                    [ws.delegate getDietAnalysisOnCompletion:YES Info:response.message];
                }else{
                    [ProgressUtil showError:@"网络不可用,请重试"];
                }
                
            }else{
                ws.myDietAnalysisSource =nil;
                if(ws.delegate && [ws.delegate respondsToSelector:@selector(getDietAnalysisOnCompletion: Info:)]){
                    [ws.delegate getDietAnalysisOnCompletion:YES Info:response.message];
                }else{
                    [ProgressUtil showError:@"网络不可用,请重试"];
                }
            }
            
            
        }else if (response.status ==500){
            [ProgressUtil showError:response.message];
        }else {
            [ProgressUtil showError:@"网络不可用,请重试"];
            
        }
        
    }];
}

@end
