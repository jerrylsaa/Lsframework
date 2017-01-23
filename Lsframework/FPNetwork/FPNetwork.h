//
//  FPNetwork.h
//  FamilyPlatForm
//
//  Created by Tom on 16/3/27.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiMacro.h"
#import <AFNetworking.h>
#import <AFNetworkActivityIndicatorManager.h>
#import "FormData.h"
#import "FPResponse.h"
#import "MJExtension.h"

@interface HttpClient : AFHTTPSessionManager
+ (instancetype)sharedClient;
@end

typedef void(^NetworkHandler)(FPResponse* response);
typedef void(^UploadHandler)(NSProgress * pregress);
typedef void(^DownloadHandler)(NSProgress * pregress);



@interface FPNetwork : NSObject


@property(nonatomic, strong) NSURLSessionDataTask * dataTask;

/***/
@property(nonatomic,retain) NSURLSessionDownloadTask* downloadDataTask;
@property(nonatomic,retain) AFURLSessionManager* manager;


+(instancetype)GET:(NSString *)api withParams:(NSDictionary*)params;
+(instancetype)GETtigerhuang007:(NSString *)api withParams:(NSDictionary*)params;

+(instancetype)POST:(NSString *)api withParams:(NSDictionary*)params;
+(instancetype)POSTtigerhuang007:(NSString *)api withParams:(NSDictionary*)params;

+(instancetype)POSTready:(NSString *)api withData:(FormData *)data withParams:(NSDictionary*)params;

+(instancetype)POSTfinish:(NSString *)api withData:(FormData *)data withParams:(NSDictionary*)params;

+(instancetype)POST:(NSString *)api withParams:(NSDictionary*)params withFormDatas:(NSArray<FormData*>*)formDatas;

+(instancetype)POST44:(NSString *)api withParams:(NSDictionary*)params withFormDatas:(NSArray<FormData*>*)formDatas;

+(instancetype)POST:(NSString *)api withParams:(NSDictionary*)params withBlockFormDatas:(NSArray<FormData*>*)formDatas;

+(instancetype)DOWNLOAD:(NSString*)api;

+(instancetype)DOWNLOAD:(NSString*) api downloadPath:(NSString*) downloadPath;

/**
 *  发起网络请求，普通单个请求请使用这个
 *
 *  @param networkHandler 请求结束后回调，默认在主线程
 *
 *  @return FPNetwork
 */
-(instancetype)addCompleteHandler:(NetworkHandler)networkHandler;
/**
 *  添加网络请求的回调，这个方法不会马上发起请求，配合DataManager使用，一般在有多个请求结束时去做其他事情的时候才使用
 *  普通单个请求不要使用
 *  @param networkHandler
 *
 *  @return
 */
-(instancetype)addCompleteHandlerAndNotStartNow:(NetworkHandler)networkHandler;
/**
 *  发起网络请求
 *
 *  @param networkHandler 请求结束后回调
 *  @param uploadHandler  上传过程中回调
 *
 *  @return
 */
-(instancetype)addCompleteHandler:(NetworkHandler)networkHandler withUploadHandler:(UploadHandler)uploadHandler;
/**
 *  发起网络请求
 *
 *  @param networkHandler  请求结束回调
 *  @param downloadHandler 下载过程中回调
 *
 *  @return
 */
-(instancetype)addCompleteHandler:(NetworkHandler)networkHandler withDownloadHandler:(DownloadHandler)downloadHandler;

-(instancetype)addCompleteHandler:(NetworkHandler)networkHandler withUploadHandler:(UploadHandler)uploadHandler withDownloadHandler:(DownloadHandler)downloadHandler isStartNow:(BOOL)isStart;

/**
 *  新的下载方法
 *
 *  @param downloadHandler <#downloadHandler description#>
 *  @param networkHandler  <#networkHandler description#>
 *
 *  @return <#return value description#>
 */
- (instancetype)addDownloadHandler:(DownloadHandler) downloadHandler withCompleteHandler:(NetworkHandler) networkHandler;

/**
 *  新的上传方法
 *
 *  @param uploadHandler  <#uploadHandler description#>
 *  @param networkHandler <#networkHandler description#>
 *
 *  @return <#return value description#>
 */
- (instancetype)addUploadHandler:(UploadHandler) uploadHandler withCompleteHandler:(NetworkHandler) networkHandler;


+(void)postRongCloud:(NSString *)url params:(id )params   success:(void (^)(NSURLSessionDataTask * , id))success
             failure:(void (^)(NSURLSessionDataTask *, NSError * ))failure;

-(void)cancel;

@end
