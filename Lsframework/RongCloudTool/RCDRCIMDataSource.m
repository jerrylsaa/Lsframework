//
//  RCDRCIMDelegateImplementation.m
//  RongCloud
//
//  Created by Liv on 14/11/11.
//  Copyright (c) 2014年 RongCloud. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>
#import "AFHttpTool.h"
#import "RCDRCIMDataSource.h"
#import "RCDLoginInfo.h"
#import "RCDGroupInfo.h"
#import "RCDUserInfo.h"
#import "RCDHttpTool.h"
#import "DBHelper.h"
#import "RCDataBaseManager.h"
#import "RCDCommonDefine.h"
#import "FPNetwork.h"
#import "JMChatUserModel.h"
#import "DoctorList.h"

@interface RCDRCIMDataSource ()

@end

@implementation RCDRCIMDataSource

+ (RCDRCIMDataSource*)shareInstance
{
    static RCDRCIMDataSource* instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];

    });
    return instance;
}



-(void) syncGroups
{
    //开发者调用自己的服务器接口获取所属群组信息，同步给融云服务器，也可以直接
    //客户端创建，然后同步
    
    [RCDHTTPTOOL getAllGroupsWithCompletion:^(NSMutableArray *result) {
        
        [[RCIMClient sharedRCIMClient] syncGroups:result
                                          success:^{
                                              
                                              NSLog(@"同步群组成功!");
                                          } error:^(RCErrorCode status) {
                                              NSLog(@"同步群组失败!  %ld",(long)status);
                                              
                                          }];
        
        
    
    }];
    
    /*
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"strType":@"myteam",@"nPage":@"1",@"nPageSize":@"10",@"strOrderBy":@"DESC"}];
    
    [HTTPREQUEST_SINGLE postRequestWithService:URL_GET_DREAM_LIST andParams:params success:^(RequestManager *manager, NSDictionary *response) {
        
        
        NSArray *array = [response objectForKey:@"DreamList"];
        
        
        
        JSONModelArray *tmpArray =  [[JSONModelArray alloc] initWithArray:array modelClass:[DreamDetailModel class]];
        
        NSMutableArray *result = [NSMutableArray array];
        
        
        for (DreamDetailModel *model in tmpArray) {
            RCDGroupInfo *group = [[RCDGroupInfo alloc] init];
            group.groupId = [NSString stringWithFormat:@"%ldgroup%ld",model.nUserID,model.nDreamID];
            group.groupName =[NSString stringWithFormat:@"%@的义工团",model.strDreamName];
            group.portraitUri =model.strTitlePage;
            if (group.portraitUri) {
                group.portraitUri=@"";
            }
            group.creatorId = [NSString stringWithFormat:@"%ld",model.nUserID];
            group.introduce = [NSString stringWithFormat:@"%@的义工团",model.strDreamName];
            if (group.introduce) {
                group.introduce=@"";
            }
          //  group.number = [dic objectForKey:@"number"];
            //group.maxNumber = [dic objectForKey:@"max_number"];
            group.creatorTime =[NSString stringWithFormat:@"%ld",model.nCreateTime];
            
            if (!group.number) {
                group.number=@"10";
            }
            if (!group.maxNumber) {
                group.maxNumber=@"100";
            }
            [result addObject:group];
            group.isJoin = YES;
            [[RCDataBaseManager shareInstance] insertGroupToDB:group];
            //[_allGroups addObject:group];
        }
        */
        
        
    
        
    
        
        
 

    
    /*
    [RCDHTTPTOOL getMyGroupsWithBlock:^(NSMutableArray *result) {
        if (result!=nil) {
            //同步群组
            [[RCIMClient sharedRCIMClient] syncGroups:result
                                         success:^{
                NSLog(@"同步群组成功!");
            } error:^(RCErrorCode status) {
                NSLog(@"同步群组失败!  %ld",(long)status);
                
            }];
        }
    }];*/
    
   /*[RCDHTTPTOOL getAllGroupsWithCompletion:^(NSMutableArray *result) {
        
    }];*/

}

-(void) syncFriendList:(void (^)(NSMutableArray* friends))completion
{
    [RCDHTTPTOOL getFriends:^(NSMutableArray *result) {
        completion(result);
    }];
}

 /*
#pragma mark - GroupInfoFetcherDelegate
- (void)getGroupInfoWithGroupId:(NSString*)groupId completion:(void (^)(RCGroup*))completion
{
    if ([groupId length] == 0)
        return;
    

    RCDGroupInfo *groupInfor = (RCDGroupInfo *)[[RCDataBaseManager shareInstance] getGroupByGroupId:groupId];
    
    
    if (groupInfor.portraitUri.length > 1) {
        
        completion(groupInfor);
        
        return;
    }
    
    NSArray *array = [groupId componentsSeparatedByString:@"group"];
    
    NSString *dreamID = [array objectAtIndex:1];
   
    [HTTPREQUEST_SINGLE postRequestWithService:URL_GET_DREAM_DETAIL andParams: @{@"nDreamID":dreamID} withHub:NO success:^(RequestManager *manager, NSDictionary *response) {
        
        
      NSDictionary *  dreamDetailDic = [response objectForKey:@"Data"];
        
        NSLog(@"%@",[dreamDetailDic JSONFragment]);
        
        DreamDetailModel*  myDreamModel = [[DreamDetailModel alloc] initWithDictionary:dreamDetailDic error:nil];

        RCDGroupInfo *group = [[RCDGroupInfo alloc] init];
        group.groupId = [NSString stringWithFormat:@"%dgroup%d",myDreamModel.nUserID,myDreamModel.nDreamID];
        group.groupName =[NSString stringWithFormat:@"%@的义工团",myDreamModel.strDreamName];
        group.portraitUri =myDreamModel.strTitlePage;
        if (!group.portraitUri) {
            group.portraitUri=@"";
        }
        group.creatorId = [NSString stringWithFormat:@"%d",myDreamModel.nUserID];
        group.introduce = [NSString stringWithFormat:@"%@的义工团",myDreamModel.strDreamName];
        if (!group.introduce) {
            group.introduce=@"";
        }
        //  group.number = [dic objectForKey:@"number"];
        //group.maxNumber = [dic objectForKey:@"max_number"];
        group.creatorTime =[NSString stringWithFormat:@"%d",myDreamModel.nCreateTime];
        
        if (!group.number) {
            group.number=@"";
        }
        if (!group.maxNumber) {
            group.maxNumber=@"";
        }
               group.isJoin = YES;
        [[RCDataBaseManager shareInstance] insertGroupToDB:group];

        
        completion(group);
        
        
    } failure:^(RequestManager *manager, NSError *error) {
        
          completion(nil);
        
    }];
    
}
*/

#pragma mark - RCIMUserInfoDataSource
- (void)getUserInfoWithUserId:(NSString*)userId completion:(void (^)(RCUserInfo*))completion
{
    NSLog(@"getUserInfoWithUserId ----- %@", userId);
    
    
    if (userId == nil || [userId length] == 0 )
    {
        RCUserInfo *user = [RCUserInfo new];
        user.userId = userId;
        user.portraitUri = @"";
        user.name = @"";
        completion(user);
        return ;
    }
    
    //查询数据库；
    RCUserInfo *userInfor = [[RCDataBaseManager shareInstance] getUserByUserId:userId];
 
    if (userInfor) {
        
        completion(userInfor);
        
        return;
        
    }
    
    
    
    if([userId hasPrefix:@"u"]){
    
        RCUserInfo *user = [RCUserInfo new];
        user.userId = [NSString stringWithFormat:@"%ld",kCurrentUser.userId];
        user.portraitUri = [NSString stringWithFormat:@"%@_small",kCurrentUser.userImageStr];
        user.name = kCurrentUser.userName;
        
        [[RCDataBaseManager shareInstance] insertUserToDB:user];
        completion(user);
        return ;

    
    }
    
    if([userId isEqualToString:@"kefu114"])
    {
        RCUserInfo *user=[[RCUserInfo alloc]initWithUserId:@"kefu114" name:@"客服" portrait:@""];
        completion(user);
        return;
    }
    
    NSString * subUserID= [userId substringWithRange:NSMakeRange(1, userId.length-1)];
    
    if ([userId hasPrefix:@"d"]) {
        
        NSString *strUser = [NSString stringWithFormat:@"{%@}",subUserID];
        
        NSDictionary * params = @{@"userid":strUser};
        
        [[FPNetwork GET:API_GET_COMMON_USER_INFO withParams:params] addCompleteHandler:^(FPResponse* response) {
            NSLog(@"%@", response);
            
            NSArray * array = response.data;
            
            if (array.count < 1) {
                
                return ;
            }
            
            
            
            NSDictionary * rep =[array objectAtIndex:0];
            
            NSError *modelError;
            
            JMChatUserModel * model =[[ JMChatUserModel alloc] initWithDictionary:rep error:&modelError];
            
            RCUserInfo *user = [RCUserInfo new];
            user.userId = userId;
            
            user.portraitUri = model.image;
            
            user.name = model.name;
            
            completion(user);
            
        }];
        
    }
    
    if ([userId hasPrefix:@"d"]) {
        /*
        NSDictionary *parameters = [NSDictionary dictionaryWithObject:subUserID forKey:@"DoctorID"];
        
        [[FPNetwork POST:API_PHONE_QUERY_DOCTOR_INFO withParams:parameters] addCompleteHandler:^(FPResponse *response) {
            //拉取医生详细信息
            if (response.success) {
                NSArray *modelArray = [DoctorList mj_objectArrayWithKeyValuesArray:@[response.data]];
               
                DoctorList * doctorModel = [modelArray lastObject];
                
                RCUserInfo *user = [RCUserInfo new];
                user.userId = [NSString stringWithFormat:@"%@",doctorModel.DoctorID];
                user.portraitUri = doctorModel.UserImg;
                user.name = [NSString stringWithFormat:@"%@", doctorModel.UserName];
                [[RCDataBaseManager shareInstance] insertUserToDB:user];

                completion(user);
               
            }
        }];*/
        
        
    }
    
    
  
    
    /*
    
    [HTTPREQUEST_SINGLE postRequestWithService:URL_USER_VOL_INFOR andWithEncryParams:@{@"strUserIds":userId} withHub:NO  success:^(RequestManager *manager, NSDictionary *response) {
        
        NSArray *array = [response objectForKey:@"InfoList"];
        
        if (array.count < 1) {
            
            return ;
        }
        
        NSDictionary *dic =[[response objectForKey:@"InfoList"] objectAtIndex:0];
        
        
        if (dic) {
            
            VolModelInGroup *group = [[VolModelInGroup alloc] initWithDictionary:dic error:nil];
            
            RCUserInfo *user = [RCUserInfo new];
            user.userId = [NSString stringWithFormat:@"%d",group.nUserID];
            user.portraitUri = group.strAvatar;
            user.name = [NSString stringWithFormat:@"%@", group.strRealName];
            [[RCDataBaseManager shareInstance] insertUserToDB:user];
            completion(user);
        }
        else
        {
            RCUserInfo *user = [RCUserInfo new];
            user.userId = userId;
            user.portraitUri = @"";
            user.name = [NSString stringWithFormat:@"name%@", userId];
            completion(user);
            
        }
        
        
    } failure:^(RequestManager *manager, NSError *error) {
        
    }];*/
    
    
}

#pragma mark - RCIMGroupUserInfoDataSource
/**
 *  获取群组内的用户信息。
 *  如果群组内没有设置用户信息，请注意：1，不要调用别的接口返回全局用户信息，直接回调给我们nil就行，SDK会自己巧用用户信息提供者；2一定要调用completion(nil)，这样SDK才能继续往下操作。
 *
 *  @param groupId  群组ID.
 *  @param completion 获取完成调用的BLOCK.
 */
- (void)getUserInfoWithUserId:(NSString *)userId inGroup:(NSString *)groupId
                   completion:(void (^)(RCUserInfo *userInfo))completion {
    
/*
    //在这里查询该group内的群名片信息，如果能查到，调用completion返回。如果查询不到也一定要调用completion(nil)
    if ([userId isEqualToString:USER_DATA.userid]) {
        completion([[RCUserInfo alloc] initWithUserId:USER_DATA.userid name:USER_DATA.username portrait:USER_DATA.strAvatar]);
    } else {
        completion(nil);//融云demo中暂时没有实现，以后会添加上该功能。app也可以自己实现该功能。
    }*/
}

- (void)cacheAllUserInfo:(void (^)())completion
{
    __block NSArray * regDataArray;
    
    [AFHttpTool getFriendsSuccess:^(id response) {
        if (response) {
            NSString *code = [NSString stringWithFormat:@"%@",response[@"code"]];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                if ([code isEqualToString:@"200"]) {
                    regDataArray = response[@"result"];
                    for(int i = 0;i < regDataArray.count;i++){
                        NSDictionary *dic = [regDataArray objectAtIndex:i];
                        
                        RCUserInfo *userInfo = [RCUserInfo new];
                        NSNumber *idNum = [dic objectForKey:@"id"];
                        userInfo.userId = [NSString stringWithFormat:@"%d",idNum.intValue];
                        userInfo.portraitUri = [dic objectForKey:@"portrait"];
                        userInfo.name = [dic objectForKey:@"username"];
                        [[RCDataBaseManager shareInstance] insertUserToDB:userInfo];
                    }
                    completion();
                }
            });
        }
        
    } failure:^(NSError *err) {
        NSLog(@"getUserInfoByUserID error");
    }];
}
- (void)cacheAllGroup:(void (^)())completion
{
    
    [RCDHTTPTOOL getAllGroupsWithCompletion:^(NSMutableArray *result) {
        
        [[RCIMClient sharedRCIMClient] syncGroups:result
                                          success:^{
                                              
                                              NSLog(@"同步群组成功!");
                                          } error:^(RCErrorCode status) {
                                              NSLog(@"同步群组失败!  %ld",(long)status);
                                              
                                          }];
        
        
        
    }];
    
    /*
    [RCDHTTPTOOL getAllGroupsWithCompletion:^(NSMutableArray *result) {
        [[RCDataBaseManager shareInstance] clearGroupsData];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            for(int i = 0;i < result.count;i++){
                RCGroup *userInfo =[result objectAtIndex:i];
                [[RCDataBaseManager shareInstance] insertGroupToDB:userInfo];
            }
            completion();
        });
    }];*/
}

- (void)cacheAllFriends:(void (^)())completion
{
        /*
    [RCDHTTPTOOL getFriends:^(NSMutableArray *result) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [[RCDataBaseManager shareInstance] clearFriendsData];
            [result enumerateObjectsUsingBlock:^(RCDUserInfo *userInfo, NSUInteger idx, BOOL *stop) {
                RCUserInfo *friend = [[RCUserInfo alloc] initWithUserId:userInfo.userId name:userInfo.name portrait:userInfo.portraitUri];
                [[RCDataBaseManager shareInstance] insertFriendToDB:friend];
            }];
            completion();
        });
    }];*/
}
- (void)cacheAllData:(void (^)())completion
{
    __weak RCDRCIMDataSource *weakSelf = self;
    [self cacheAllUserInfo:^{
        [weakSelf cacheAllGroup:^{
            [weakSelf cacheAllFriends:^{
                [DEFAULTS setBool:YES forKey:@"notFirstTimeLogin"];
                [DEFAULTS synchronize];
                completion();
            }];
        }];
    }];
}

- (NSArray *)getAllUserInfo:(void (^)())completion
{
    NSArray *allUserInfo = [[RCDataBaseManager shareInstance] getAllUserInfo];
    if (!allUserInfo.count) {
       [self cacheAllUserInfo:^{
           completion();
       }];
    }
    return allUserInfo;
}
/*
 * 获取所有群组信息
 */
- (NSArray *)getAllGroupInfo:(void (^)())completion
{
    NSArray *allUserInfo = [[RCDataBaseManager shareInstance] getAllGroup];
    if (!allUserInfo.count) {
        [self cacheAllGroup:^{
            completion();
        }];
    }
    return allUserInfo;
}

- (NSArray *)getAllFriends:(void (^)())completion
{
    NSArray *allUserInfo = [[RCDataBaseManager shareInstance] getAllFriends];
    if (!allUserInfo.count) {
        [self cacheAllFriends:^{
            completion();
        }];
    }
    return allUserInfo;
}
@end
