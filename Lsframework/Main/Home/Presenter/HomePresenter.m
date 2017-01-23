//
//  HomePresenter.m
//  FamilyPlatForm
//
//  Created by Tom on 16/4/2.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HomePresenter.h"
#import "DefaultChildEntity.h"
#import "UIImage+Category.h"
#import "sys/utsname.h"


@implementation HomePresenter
-(void)getChildInfo{
    _birthDates = [NSMutableArray new];
    WS(ws);//PhoneQueryBabyArchivesInfo
    FPNetwork *network = [FPNetwork POST:API_PHONE_QUERY_BABY_ARCHIVES_INFO withParams:@{@"userId":@(kCurrentUser.userId)}];
    [network addCompleteHandler:^(FPResponse *response) {
        [DefaultChildEntity MR_truncateAll];
        if (response.success) {
            NSLog(@"====%@",response.data);
            [DefaultChildEntity mj_objectWithKeyValues:response.data context:[NSManagedObjectContext MR_defaultContext]];
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            ws.childEntity = [ChildEntity mj_objectWithKeyValues:response.data];
            //            kCurrentUser.childName = ws.childEntity.childName;
//            [ws loadStandardChildHeightAndWeight];
//            runOnBackground(^{
//                NSInteger today = [ws generateDate];
//                WSLog(@"today = %ld",today);
//                runOnMainThread(^{
//                    [_delegate onGetChildInfoComplete:YES today:today];
//                    [ProgressUtil dismiss];
//                });
//            });
            
            
            NSInteger today = [ws generateDate];
            WSLog(@"today = %ld",today);
            [_delegate onGetChildInfoComplete:YES today:today];
            [ProgressUtil dismiss];

            
        }else if(response.status ==404){
            [ws.delegate onGetChildInfoComplete:response.success today:0];
            [ProgressUtil dismiss];
            
        }else {
            [ws.delegate onUpdateCompletion:NO today:0];
            [ProgressUtil dismiss];
        }
        
    }];
}
/*
- (void)loadStandardChildHeightAndWeight{
    NSLog(@"%@",self.childEntity.birthDate);
    NSLog(@"8888888888==%d==888888888888",self.childEntity.Brithday);
    [[FPNetwork POST:API_QUERY_INDEX_PAGE_REMIND withParams:@{@"StarTime":@(self.childEntity.Brithday),@"EndTime":@(self.childEntity.Brithday)}] addCompleteHandler:^(FPResponse *response) {
        if (response.isSuccess) {
            if (response.data!=nil) {
                NSArray *dataArr =response.data;
                NSDictionary *infoDict =dataArr[0];
                NSLog(@"%@",infoDict);
                [_delegate onLoadChildStandardInfoComplete:response.success withInfoDictionary:infoDict];
            }
        }
    }];
}
 */

- (void)insertBindDevice{
    
    NSString *deviceToken =kCurrentUser.geTuiDeviceToken;
    
    NSString *appVersion =[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *optime = [df stringFromDate:[NSDate new]];
    
    NSString* phoneModel = [self deviceVersion];
    NSLog(@"%@---%@---%@",phoneModel,deviceToken,appVersion);
    if (kCurrentUser.userId&&phoneModel&&deviceToken&&appVersion&&optime) {
        [[FPNetwork POST:API_INSERTBINDDEVICE withParams:@{@"userid":@(kCurrentUser.userId),@"devicetype":phoneModel,@"deviceid":deviceToken,@"appversion":appVersion,@"optime":optime }] addCompleteHandler:^(FPResponse *response) {
            if (response.success) {
                NSLog(@"上报deviceToken成功");
                NSLog(@"%@",response.message);
            }else {
                NSLog(@"上报deviceToken失败");
                NSLog(@"%@",response.message);
                
            }
        }];
    }
    
}

-(void)checkIsSignToady{
    [[FPNetwork POST:API_QUERY_DAY_ATTENDANCE withParams:@{@"Userid":@(kCurrentUser.userId)}] addCompleteHandler:^(FPResponse *response) {
        [_delegate onCheckIsSignToday:response.success];
    }];
}

-(void)signToday{
    [[FPNetwork POST:API_ADD_USER_SIGN withParams:@{@"Userid":@(kCurrentUser.userId)}] addCompleteHandler:^(FPResponse *response) {
        [_delegate onSignToday:response.success];
    }];
}

-(NSInteger)generateDate{
    
//    NSDate * date = _childEntity.birthDate;
//    
//    NSDate * yearAfter18 = [_childEntity.birthDate afterYear:18];
////    _birthDatesForDate = [NSMutableArray new];
//    NSUInteger count = 0;
//    NSDate * today = [NSDate date];
////    NSLog(@"确定的时间4：%@",today);
//    NSCalendar *cal = [NSCalendar currentCalendar];
//    while ([date compare:yearAfter18] == NSOrderedAscending) {
//        NSString * dateStr = [date formatToChinese:_childEntity.birthDate];
////        NSLog(@"确定的时间5：%@",dateStr);
//        AlertEntity * entity = [AlertEntity new];
//        entity.date = dateStr;
//        [_birthDates addObject:entity];
////        [_birthDatesForDate addObject:[date format2String:@"yyyy-MM-dd"]];
//        date = [date tomorrow];
////        NSLog(@"确定的时间6：%@",date);
//        
//        count ++;
//        
//    }
//    NSDateComponents *d = [cal components:NSCalendarUnitDay fromDate:_childEntity.birthDate toDate:today options:0];
//    count = d.day + 1;
//    NSLog(@"次数：%ld",count);
//    return count;
   
    
    NSUInteger count = 0;
    NSDate * today = [NSDate date];
    //    NSLog(@"确定的时间4：%@",today);
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *d = [cal components:NSCalendarUnitDay fromDate:_childEntity.birthDate toDate:today options:0];
    count = d.day + 1;
    NSLog(@"次数：%ld",count);
    return count;

}


-(void)loadMoreData{
    NSLock *theLock = [[NSLock alloc] init];
    if ([theLock tryLock]){
        [self generateDate];
        [_delegate onLoadMoreDataComplete];
        [theLock unlock];
    }
    
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
                    if ([DefaultChildEntity defaultChild].babyID) {
                        //            childImg
                        //保存最新头像url
                        DefaultChildEntity* child = [DefaultChildEntity defaultChild];
                        child.childImg = url;
                        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
                        
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
                    [ProgressUtil showError:@"上传图片成功，解析Url失败"];
                }
                
            }
            
            
        }else{
            [ProgressUtil showError:@"上传失败"];
        }
    }];
}

-(void)updateChildInfo{
    _birthDates = [NSMutableArray new];
    WS(ws);
    FPNetwork *network = [FPNetwork POST:API_PHONE_QUERY_BABY_ARCHIVES_INFO withParams:@{@"userId":@(kCurrentUser.userId)}];
    [network addCompleteHandler:^(FPResponse *response) {
        [DefaultChildEntity MR_truncateAll];
        if (response.success) {
            NSLog(@"====%@",response.data);
            [DefaultChildEntity mj_objectWithKeyValues:response.data context:[NSManagedObjectContext MR_defaultContext]];
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            ws.childEntity = [ChildEntity mj_objectWithKeyValues:response.data];
            //            kCurrentUser.childName = ws.childEntity.childName;
            
//            runOnBackground(^{
//                NSInteger today = [ws generateDate];
//                runOnMainThread(^{
//                    [_delegate onGetChildInfoComplete:YES today:today];
//                    [ProgressUtil dismiss];
//                });
//            });
            
            NSInteger today = [ws generateDate];
            WSLog(@"today = %ld",today);
            [_delegate onGetChildInfoComplete:YES today:today];
            [ProgressUtil dismiss];

            
        }else if(response.status ==404){
            [ws.delegate onGetChildInfoComplete:response.success today:0];
            [ProgressUtil dismiss];
            
        }else {
            [ws.delegate onUpdateCompletion:NO today:0];
            [ProgressUtil dismiss];
        }
        
    }];
    
}
/*
-(void)getAlertWithDay:(NSUInteger)day{
    [[FPNetwork POST:@"QueryIndexPageRemind" withParams:@{@"UserID":@(kCurrentUser.userId), @"StarTime":@(day), @"EndTime":@(day)}] addCompleteHandler:^(FPResponse *response) {
        NSArray * array = [NSDictionary mj_objectArrayWithKeyValuesArray:response.data];
        if (array) {
            if (_birthDates.count!=0){
            AlertEntity * entity = _birthDates[day];
            entity.alert = array[0][@"RemindContent"];
            [_delegate onGetAlertWithDay:day];
            }
        }
    }];
}
*/
#pragma mark----获取每日提醒
-(void)getAlertWithDay:(NSUInteger)day{
    WS(ws);
//    [ProgressUtil show];
    [[FPNetwork POST:@"QueryIndexPageRemind" withParams:@{@"UserID":@(kCurrentUser.userId), @"StarTime":@(day), @"EndTime":@(day)}] addCompleteHandler:^(FPResponse *response) {
//        [ProgressUtil dismiss];
        if (response.success) {
        NSArray * array = [NSDictionary mj_objectArrayWithKeyValuesArray:response.data];
            NSLog(@"getAlertWithDay:%@",response.data);
//        if (array) {
//            if (_birthDates.count!=0){
//                AlertEntity * entity = _birthDates[day];
//                entity.alert = array[0][@"RemindContent"];
//                 entity.date = array[0][@"RemindDate"];
//               entity.StandardHeight = array[0][@"StandardHeight"];
//              entity.StandardWeight = array[0][@"StandardWeight"];
//            }
//        }
            
            if(array.count != 0){
                ws.alertEntity.alert = array[0][@"RemindContent"];
                ws.alertEntity.date = array[0][@"RemindDate"];
                ws.alertEntity.StandardHeight = array[0][@"StandardHeight"];
                ws.alertEntity.StandardWeight = array[0][@"StandardWeight"];

            }
            
        }
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(onGetAlertWithCompletion:Day:)]){
            [ws.delegate  onGetAlertWithCompletion:response.success Day:day];
        }

    }];
}

//- (void)getVaccineEventWithDay:(NSUInteger)day{
//    WS(ws);
////    [ProgressUtil show];
//    [[FPNetwork POST: API_GET_VACCINE withParams:@{@"userid":@(kCurrentUser.userId), @"time":@(day)}] addCompleteHandler:^(FPResponse *response) {
////        [ProgressUtil dismiss];
//        if (response.success) {
//     ws.VaccineSource = [VaccineEvent mj_objectArrayWithKeyValuesArray:response.data];
//            
//            }
//        if(ws.delegate && [ws.delegate respondsToSelector:@selector(onGetVaccineEventWithCompletion:Day:)]){
//            [ws.delegate  onGetVaccineEventWithCompletion:response.success Day:day];
//        }
//     }];
//}

- (NSString *)deviceVersion
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    
    //iPod
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    
    //iPad
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad mini (GSM)";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad mini (CDMA)";
    
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3(WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3(CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3(4G)";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4 (4G)";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    if ([deviceString isEqualToString:@"iPad4,4"]
        ||[deviceString isEqualToString:@"iPad4,5"]
        ||[deviceString isEqualToString:@"iPad4,6"])      return @"iPad mini 2";
    
    if ([deviceString isEqualToString:@"iPad4,7"]
        ||[deviceString isEqualToString:@"iPad4,8"]
        ||[deviceString isEqualToString:@"iPad4,9"])      return @"iPad mini 3";
    
    return deviceString;
}
#pragma mark---  加载首页三个专家数据
- (void)loadExpertData{

//    NSDictionary* parames = @{@"PageIndex":@(1),@"PageSize":@(3),@"userid":@(kCurrentUser.userId)};
        NSDictionary* parames = @{@"userid":@(kCurrentUser.userId)};
    [[FPNetwork POST:@"GetExpertDoctorInfoIndexV1" withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if (response.isSuccess){
    _dataSource = [ExpertAnswerEntity mj_objectArrayWithKeyValuesArray:response.data];
        }

      [_delegate  onGetExpertListCompletion];
     
    }];
    

}

#pragma mark---  获取优惠券列表
-(void)getCouponList{
    WS(ws);
    [[FPNetwork POST: API_GET_COUPONLIST withParams:@{@"userid":@(kCurrentUser.userId), @"couponType":@(1)}] addCompleteHandler:^(FPResponse *response) {
        
        if (response.success) {
            NSLog(@"====CouponDataSource：%@",response.data);
            ws.CouponDataSource = [CouponEnity  mj_objectArrayWithKeyValuesArray:response.data];
            }
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(onGetCouponListCompletion:info:)]){
            [ws.delegate  onGetCouponListCompletion:response.success info:response.message];
        }
    }];
}
-(void)getClaimCouponWithcouponID:(NSNumber*)CouponID{
    WS(ws);
    [[FPNetwork POST: API_GET_CLAIMCOUPON withParams:@{@"userid":@(kCurrentUser.userId), @"couponID":CouponID}] addCompleteHandler:^(FPResponse *response) {
        if (response.success) {
            
        }
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(onGetClaimCouponCompletion:info:)]){
            [ws.delegate  onGetClaimCouponCompletion:response.success info:response.message];
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
#pragma mark---  判断是否是医生
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
                //保存医生ID到本地
                kCurrentUser.expertID = [NSNumber numberWithInteger:[doctorID integerValue]];
                
                block(YES,doctorID);
            }
        }else{
            [ProgressUtil showError:response.message];
        }
    }];
}

#pragma mark---  首页每日必读
-(void)getDailyFirstArticle{
    
    WS(ws);
        NSDictionary *parameters = @{@"UserID":[NSString stringWithFormat:@"%ld",(long)kCurrentUser.userId]};
    
    [[FPNetwork POST: API_GET_FIRSTARTICLE withParams:parameters] addCompleteHandler:^(FPResponse *response) {
        
        if (response.success) {
            NSLog(@"====DailyFirstArticle：%@",response.data);
            ws.DailyFirstSource = [DailyFirstArticle mj_objectArrayWithKeyValuesArray:response.data];
        }
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(onGetDailyFirstArticleCompletion:info:)]){
            [ws.delegate  onGetDailyFirstArticleCompletion:response.success info:response.message];
        }
    }];
}



- (void)GetEHRChildRecordCount{
    WS(ws);
    [[FPNetwork POST: API_GetEHRChildRecordCount withParams:nil] addCompleteHandler:^(FPResponse *response) {
        if (response.success) {
            if (response.data!=nil) {
                 NSInteger count =[response.data integerValue];
                
                if(ws.delegate && [ws.delegate respondsToSelector:@selector(onGetClaimCouponCompletion:info:)]){
                    [ws.delegate  onGetEHRChildRecordCountCompletion:response.success info:count];
                }
            }
        }else{
            
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



//文章点赞
-(void)InsertArticlePraiseByArticleID:(NSNumber*)articleID{
    WS(ws);
    NSDictionary* parames = @{@"ArticleID":articleID,@"UserID":@(kCurrentUser.userId)};
    
    [[FPNetwork POST: API_INSERT_ARTICLEPRAISE withParams:parames] addCompleteHandler:^(FPResponse *response) {
        
        if (response.success) {
            
            
            if(ws.delegate && [ws.delegate respondsToSelector:@selector(InsertArticlePraiseCommentCompletion:info:)]){
                [ws.delegate InsertArticlePraiseCommentCompletion:response.success info:response.message];
            }
        }
        else {
            [ProgressUtil showError:@"网络故障"];
        }
    }];
}
//取消点赞
-(void)CancelArticlePraiseByArticleID:(NSNumber*)articleID{
    WS(ws);
    NSDictionary* parames = @{@"ArticleID":articleID,@"UserID":@(kCurrentUser.userId)};
    
    [[FPNetwork POST: API_CANCEL_ARTICLEPRAISE withParams:parames] addCompleteHandler:^(FPResponse *response) {
        
        if (response.success) {
            
            
            if(ws.delegate && [ws.delegate respondsToSelector:@selector(CancelArticlePraiseCommentCompletion:info:)]){
                [ws.delegate CancelArticlePraiseCommentCompletion:response.success info:response.message];
            }
        }
        else {
            [ProgressUtil showError:@"网络故障"];
        }
    }];
    
    
    
}

- (void)getNewExpertDoctorInfoWithExpertID:(NSString *)expertID{    WS(ws);
    [[FPNetwork POST:API_GetNewExpertDoctorInfo withParams:@{@"ExpertDoctorID":expertID}] addCompleteHandler:^(FPResponse *response) {
        if(response.success){
            
            if (response.data!=nil) {
                [ProgressUtil dismiss];
                ws.hospitalEntity = [BindHospitalEntity mj_objectArrayWithKeyValuesArray:response.data];
                
                if(ws.delegate && [ws.delegate respondsToSelector:@selector(onGetBindHospitalInfoSuccess:)]){
                    [ws.delegate onGetBindHospitalInfoSuccess:response.success];
                }
            }
            
        }else if(response.status ==500){
            [ProgressUtil showError:response.message];
        }else {
            [ProgressUtil showError:@"网络不可用,请重试"];
            
        }
    }];
}

-(AlertEntity *)alertEntity{
    if(!_alertEntity){
        _alertEntity = [AlertEntity new];
    }
    return _alertEntity;
}

-(void)getFirstActivityVersion:(NSNumber*)version{

    WS(ws);
    
    NSDictionary* parames = @{@"VersionNo":version,@"userID":@(kCurrentUser.userId)};

    [[FPNetwork POST:API_GET_FIRSTACTIVITY withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success){
            
            if (response.data!=nil) {
                ws.ActivitySource = [ActivityData mj_objectArrayWithKeyValuesArray:response.data];
                
                if(ws.delegate && [ws.delegate respondsToSelector:@selector(onGetFirstActivityInfoCompletion:info:)]){
                    [ws.delegate onGetFirstActivityInfoCompletion:response.success info:response.message];
                }
            }
            
        }else if(response.status ==500){
            [ProgressUtil showError:response.message];
        }else {
            [ProgressUtil showError:@"网络不可用,请重试"];
            
        }
    }];
}

- (void)bindWx2mlWithUrl:(NSString *)url{
    WS(ws);
    
    NSDictionary* parames = @{@"WxUrl":url,@"UserID":@(kCurrentUser.userId)};
    
    [[FPNetwork POST:API_BindWx2ml withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success){

            [ProgressUtil showSuccess:@"绑定成功"];
            if(ws.delegate && [ws.delegate respondsToSelector:@selector(onBindWx2mlCompletion)]){
                [ws.delegate onBindWx2mlCompletion];
            }
        }else if(response.status ==500){
            [ProgressUtil showError:response.message];
        }else {
            [ProgressUtil showError:@"网络不可用,请重试"];
            
        }
    }];
}
#pragma mark--红点--
-(void)getRedDot:(RedDotBlock)block
{
    
    NSDictionary* parames = @{@"UserID":@(kCurrentUser.userId)};
    
    [[FPNetwork POST:API_getmymsgunreadstate withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success){
            NSLog(@"getmymsgunreadstate 红点 is--  %@",response.data);
            
            BOOL success;
            if ([response.data integerValue] == 1) {
                NSLog(@"adfsa");
                success =YES;
            }else{
                
                success = NO;
            }
            
            block(success);
        }
        
    }];
    
}
@end
