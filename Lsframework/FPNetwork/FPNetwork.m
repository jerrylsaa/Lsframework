//
//  FPNetwork.m
//  FamilyPlatForm
//
//  Created by Tom on 16/3/27.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "FPNetwork.h"
#import "DefaultChildEntity.h"
#import "JMFoundation.h"




@implementation HttpClient



+ (instancetype)sharedClient {
    static HttpClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //设置和加入头信息
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        [config setHTTPAdditionalHeaders:@{@"Content-Type" : @"text/html"}];
        
        _sharedClient = [[HttpClient alloc] initWithSessionConfiguration:config];
        
        //        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        _sharedClient.requestSerializer = [AFHTTPRequestSerializer serializer];
        _sharedClient.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",nil];
        
        [_sharedClient.requestSerializer setHTTPShouldHandleCookies:YES];
        [_sharedClient.requestSerializer setTimeoutInterval:60];
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
        [NSURLCache setSharedURLCache:URLCache];
    });
    
    return _sharedClient;
}

@end

@interface FPNetwork()

@property(nonatomic, strong) NSString * api;
@property(nonatomic, strong) NSString * downlaodUrl;
@property(nonatomic, strong) NSMutableURLRequest * request;

@property(nonatomic, strong) NSDictionary * params;
@property(nonatomic, strong) NSString* requestMethod;
@property(nonatomic, strong) NSArray <FormData*>* formDatas;

@property(nonatomic,retain) NSString* downloadPath;

@end

@implementation FPNetwork

-(instancetype)initWithApiForPost:(NSString*)api withParams:(NSDictionary*)params{
    self = [super init];
    if (self) {
        _api = api;
        _requestMethod = @"POST";
        _params = params;
        [self generateRequest];
    }
    return self;
}

-(instancetype)initWithApiFortigerhuang007Post:(NSString*)api withParams:(NSDictionary*)params{
    self = [super init];
    if (self) {
        _api = api;
        _requestMethod = @"POST";
        _params = params;
        [self generatetigerhuang007Request];
    }
    return self;
}

-(instancetype)initWithApiForReadyPost:(NSString*)api withData:(FormData *)data withParams:(NSDictionary*)params{
    self = [super init];
    if (self) {
        _api = api;
        _requestMethod = @"POST";
        _params = params;
        [self generatereadyRequest:data];
    }
    return self;
}

-(instancetype)initWithApiForFinishPost:(NSString*)api withData:(FormData *)data withParams:(NSDictionary*)params{
    self = [super init];
    if (self) {
        _api = api;
        _requestMethod = @"POST";
        _params = params;
        [self generateFinishRequest:data];
    }
    return self;
}
-(instancetype)initWithApiForPost:(NSString*)api withParams:(NSDictionary*)params withFormData:(NSArray*)formDatas{
    self = [super init];
    if (self) {
        _api = api;
        _requestMethod = @"POST";
        _params = params;
        _formDatas = formDatas;
        [self generateRequest];
    }
    return self;
}

-(instancetype)initWithApiFor44Post:(NSString*)api withParams:(NSDictionary*)params withFormData:(NSArray*)formDatas{
    self = [super init];
    if (self) {
        _api = api;
        _requestMethod = @"POST";
        _params = params;
        _formDatas = formDatas;
        [self generate44Request];
    }
    return self;
}

-(instancetype)initWithApiForBlockPost:(NSString*)api withParams:(NSDictionary*)params withFormData:(NSArray*)formDatas{
    self = [super init];
    if (self) {
        _api = api;
        _requestMethod = @"POST";
        _params = params;
        _formDatas = formDatas;
        [self generateblockRequest];
    }
    return self;
}

-(instancetype)initWithApiForGet:(NSString*)api withParams:(NSDictionary*)params{
    self = [super init];
    if (self) {
        _api = api;
        _requestMethod = @"GET";
        _params = params;
        [self generateRequest];
    }
    return self;
}

-(instancetype)initWithApiFortigerhuang007Get:(NSString*)api withParams:(NSDictionary*)params{
    self = [super init];
    if (self) {
        _api = api;
        _requestMethod = @"GET";
        _params = params;
        [self generatetigerhuang007Request];
    }
    return self;
}

+(instancetype)GET:(NSString *)api withParams:(NSDictionary*)params{
    FPNetwork * network = [[FPNetwork alloc] initWithApiForGet:api withParams:params];
    return network;
}

+(instancetype)GETtigerhuang007:(NSString *)api withParams:(NSDictionary*)params{
    FPNetwork * network = [[FPNetwork alloc] initWithApiFortigerhuang007Get:api withParams:params];
    return network;
}

+(instancetype)POST:(NSString *)api withParams:(NSDictionary*)params{
    FPNetwork * network = [[FPNetwork alloc] initWithApiForPost:api withParams:params];
    return network;
}

+(instancetype)POSTtigerhuang007:(NSString *)api withParams:(NSDictionary*)params{
    FPNetwork * network = [[FPNetwork alloc] initWithApiFortigerhuang007Post:api withParams:params];
    return network;
}

+(instancetype)POSTready:(NSString *)api withData:(FormData *)data withParams:(NSDictionary*)params{
    FPNetwork * network = [[FPNetwork alloc] initWithApiForReadyPost:api withData:data withParams:params];
    return network;
}

+(instancetype)POSTfinish:(NSString *)api withData:(FormData *)data withParams:(NSDictionary*)params{
    FPNetwork * network = [[FPNetwork alloc] initWithApiForFinishPost:api withData:data withParams:params];
    return network;
}

+(instancetype)POST:(NSString *)api withParams:(NSDictionary*)params withFormDatas:(NSArray<FormData*>*)formDatas{
    FPNetwork * network = [[FPNetwork alloc] initWithApiForPost:api withParams:params withFormData:formDatas];
    return network;
}

+(instancetype)POST44:(NSString *)api withParams:(NSDictionary*)params withFormDatas:(NSArray<FormData*>*)formDatas{
    FPNetwork * network = [[FPNetwork alloc] initWithApiFor44Post:api withParams:params withFormData:formDatas];
    return network;
}

+(instancetype)POST:(NSString *)api withParams:(NSDictionary*)params withBlockFormDatas:(NSArray<FormData*>*)formDatas{
    FPNetwork * network = [[FPNetwork alloc] initWithApiForBlockPost:api withParams:params withFormData:formDatas];
    return network;
}

-(instancetype)initWithDownload:(NSString*)api{
    self = [super init];
    if (self) {
        _requestMethod = @"GET";
        _downlaodUrl = api;
        [self generateRequest];
    }
    return self;
}

- (instancetype)initWithDownload:(NSString*) api downloadPath:(NSString*) downloadPath{
    self = [super init];
    if(self){
        _downlaodUrl = api;
        _downloadPath = downloadPath;
        [self generateDownloadRequest];
    }
    return self;
}

+(instancetype)DOWNLOAD:(NSString *)api{
    FPNetwork * fp = [[FPNetwork alloc] initWithDownload:api];
    return fp;
}

+(instancetype)DOWNLOAD:(NSString *)api downloadPath:(NSString *)downloadPath{
    FPNetwork* fp = [[FPNetwork alloc] initWithDownload:api downloadPath:downloadPath];
    return fp;
}

+(void)postRongCloud:(NSString *)url params:(id )params   success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
             failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure{
    
    
    
    
    NSString *urlService = [NSString stringWithFormat:@"%@%@",URL_RONG_HOST,url];
    
    NSLog(@"%@ \n %@",urlService,params);
    
    // [JMFoundation showStrHUD:@"客官，请稍等!"];
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [mgr.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [mgr.requestSerializer setValue:RONG_CLOUD_APP_KEY forHTTPHeaderField:@"App-Key"];
    
    [mgr.requestSerializer setValue:[JMFoundation getLocalTime] forHTTPHeaderField:@"Timestamp"];
    
    [mgr.requestSerializer setValue:@"1721018088" forHTTPHeaderField:@"Nonce"];
    
    NSString *input = [NSString stringWithFormat:@"%@%@%@",RONG_CLOUD_APP_SECRET,@"1721018088",[JMFoundation getLocalTime]];
    
    NSString *sig = [JMFoundation sha1:input];
    
    [mgr.requestSerializer setValue:sig forHTTPHeaderField:@"Signature"];
    
    
    [mgr POST:urlService parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        
        
        NSLog(@"%@ %@",response,[response objectForKey:@"strError"]);
        
        
        // [CustomFountion dismissHUD];
        
        if ([[response objectForKey:@"code"] intValue] == 200) {
            
            success(task,response);
            
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error %@",error.localizedDescription);
        
        failure(task,error);
        
        
    }];
}



-(void)generateRequest{
    NSError *error;
    if (kCurrentUser.token) {
        NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:_params];
        
        [params setValue:kCurrentUser.token forKey:@"Token"];
        _params = params;
    }
    if (_formDatas) {
        _request = [[HttpClient sharedClient].requestSerializer multipartFormRequestWithMethod:_requestMethod URLString:[self makeApi:_api] parameters:_params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            for (FormData * data in _formDatas) {
                [formData appendPartWithFileData:data.data name:data.name fileName:data.fileName mimeType:data.mimeType];
            }
            
        } error:&error];
        
    }else{
        NSMutableURLRequest * request = [[HttpClient sharedClient].requestSerializer requestWithMethod:_requestMethod URLString:[self makeApi:_api] parameters:_params error:&error];
        _request = request;
    }
    if (kCurrentUser.token) {
        [_request setValue:kCurrentUser.token forHTTPHeaderField:@"Token"];
    }
    NSLog(@"\n%@ %@ \n请求头部:\n%@\n请求参数:\n%@", _requestMethod, [self makeApi:_api], _request.allHTTPHeaderFields, _params);
}

-(void)generate44Request{
    NSError *error;
    if (kCurrentUser.token) {
        NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:_params];
        
        [params setValue:kCurrentUser.token forKey:@"Token"];
        _params = params;
    }
    if (_formDatas) {
        _request = [[HttpClient sharedClient].requestSerializer multipartFormRequestWithMethod:_requestMethod URLString:[self make44Api:_api] parameters:_params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            for (FormData * data in _formDatas) {
                [formData appendPartWithFileData:data.data name:data.name fileName:data.fileName mimeType:data.mimeType];
            }
            
        } error:&error];
        
    }else{
        NSMutableURLRequest * request = [[HttpClient sharedClient].requestSerializer requestWithMethod:_requestMethod URLString:[self makeApi:_api] parameters:_params error:&error];
        _request = request;
    }
    if (kCurrentUser.token) {
        [_request setValue:kCurrentUser.token forHTTPHeaderField:@"Token"];
    }
    NSLog(@"\n%@ %@ \n请求头部:\n%@\n请求参数:\n%@", _requestMethod, [self makeApi:_api], _request.allHTTPHeaderFields, _params);
}

-(void)generatereadyRequest:(FormData *)data{
    NSError *error;
//    if (kCurrentUser.token) {
//        NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:_params];
//        
//        [params setValue:kCurrentUser.token forKey:@"Token"];
//        _params = params;
//    }
    
        NSMutableURLRequest * request = [[HttpClient sharedClient].requestSerializer requestWithMethod:_requestMethod URLString:[self makereadyApi:_api] parameters:_params error:&error];
        [request setAllHTTPHeaderFields:@{@"X-Action":@"ready",@"X-FileName":data.fileName,@"X-FileHashCode":data.hashCode,@"X-FileSize":[NSString stringWithFormat:@"%@",data.fileSize]}];
    
    if (kCurrentUser.token) {
        [_request setValue:kCurrentUser.token forHTTPHeaderField:@"Token"];
    }
    _request = request;

    NSLog(@"\n%@ %@ \n请求头部:\n%@\n请求参数:\n%@", _requestMethod, [self makereadyApi:_api], _request.allHTTPHeaderFields, _params);
}

-(void)generateblockRequest{
    NSError *error;
//    if (kCurrentUser.token) {
//        NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:_params];
//        
//        [params setValue:kCurrentUser.token forKey:@"Token"];
//        _params = params;
//    }
    
        _request = [[HttpClient sharedClient].requestSerializer multipartFormRequestWithBlockMethod:_requestMethod URLString:[self makereadyApi:_api] parameters:_params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            for (FormData * data in _formDatas) {
                [formData appendPartWithreadyFileData:data.data fileName:data.fileName FileHashCode:data.hashCode FileSize:data.fileSize FileIndex:data.fileIndex];
            }
            
        } error:&error];
    
        FormData *data;
        if (_formDatas.count!=0&&_formDatas[0]!=nil) {
            data =_formDatas[0];
        }
        [_request setAllHTTPHeaderFields:@{@"X-Action":@"block",@"X-FileName":data.fileName,@"X-FileHashCode":data.hashCode,@"X-FileSize":[NSString stringWithFormat:@"%@",data.fileSize],@"X-Index":[NSString stringWithFormat:@"%@",data.fileIndex],@"X-StartIndex":[NSString stringWithFormat:@"%@",data.startIndex],@"X-EndIndex":[NSString stringWithFormat:@"%@",data.endIndex]}];
    
    if (kCurrentUser.token) {
        [_request setValue:kCurrentUser.token forHTTPHeaderField:@"Token"];
    }
    NSLog(@"\n%@ %@ \n请求头部:\n%@\n请求参数:\n%@", _requestMethod, [self makereadyApi:_api], _request.allHTTPHeaderFields, _params);
}

-(void)generateFinishRequest:(FormData *)data{
    NSError *error;
    //    if (kCurrentUser.token) {
    //        NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:_params];
    //
    //        [params setValue:kCurrentUser.token forKey:@"Token"];
    //        _params = params;
    //    }
    
    NSMutableURLRequest * request = [[HttpClient sharedClient].requestSerializer requestWithMethod:_requestMethod URLString:[self makereadyApi:_api] parameters:_params error:&error];
    [request setAllHTTPHeaderFields:@{@"X-Action":@"finish",@"X-FileHashCode":data.hashCode}];
    
    if (kCurrentUser.token) {
        [_request setValue:kCurrentUser.token forHTTPHeaderField:@"Token"];
    }
    _request = request;
    
    NSLog(@"\n%@ %@ \n请求头部:\n%@\n请求参数:\n%@", _requestMethod, [self makereadyApi:_api], _request.allHTTPHeaderFields, _params);
}

-(void)generatetigerhuang007Request{
    NSError *error;
//    if (kCurrentUser.token) {
//        NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:_params];
//        [params setValue:kCurrentUser.token forKey:@"Token"];
//        _params = params;
//    }
    if (_formDatas) {
        _request = [[HttpClient sharedClient].requestSerializer multipartFormRequestWithMethod:_requestMethod URLString:[self maketigerhuang007Api:_api] parameters:_params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            for (FormData * data in _formDatas) {
                [formData appendPartWithFileData:data.data name:data.name fileName:data.fileName mimeType:data.mimeType];
            }
            
        } error:&error];
        
    }else{
        NSMutableURLRequest * request = [[HttpClient sharedClient].requestSerializer requestWithMethod:_requestMethod URLString:[self maketigerhuang007Api:_api] parameters:_params error:&error];
        _request = request;
    }
//    if (kCurrentUser.token) {
//        [_request setValue:kCurrentUser.token forHTTPHeaderField:@"Token"];
//    }
    NSLog(@"\n%@ %@ \n请求头部:\n%@\n请求参数:\n%@", _requestMethod, [self maketigerhuang007Api:_api], _request.allHTTPHeaderFields, _params);
}

- (void)generateDownloadRequest{
    NSURL* URL = [NSURL URLWithString:[self makeApi:_api]];
    _request = [NSMutableURLRequest requestWithURL:URL];
    
    if (kCurrentUser.token) {
        [_request setValue:kCurrentUser.token forHTTPHeaderField:@"Token"];
    }
    
    NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    _manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
}

-(instancetype)addCompleteHandler:(NetworkHandler)networkHandler{
    return [self addCompleteHandler:networkHandler withUploadHandler:nil withDownloadHandler:nil isStartNow:YES];
}

-(instancetype)addCompleteHandler:(NetworkHandler)networkHandler withUploadHandler:(UploadHandler)uploadHandler{
    
    return [self addCompleteHandler:networkHandler withUploadHandler:uploadHandler withDownloadHandler:nil isStartNow:YES];
}


-(instancetype)addCompleteHandler:(NetworkHandler)networkHandler withDownloadHandler:(DownloadHandler)downloadHandler{
    return [self addCompleteHandler:networkHandler withUploadHandler:nil withDownloadHandler:downloadHandler isStartNow:YES];
}


-(instancetype)addCompleteHandlerAndNotStartNow:(NetworkHandler)networkHandler{
    return [self addCompleteHandler:networkHandler withUploadHandler:nil withDownloadHandler:nil isStartNow:NO];
}

- (instancetype)addDownloadHandler:(DownloadHandler)downloadHandler withCompleteHandler:(NetworkHandler)networkHandler{
    
    _downloadDataTask = [_manager downloadTaskWithRequest:_request progress:^(NSProgress * _Nonnull downloadProgress) {
        if(downloadHandler){
            downloadHandler(downloadProgress);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSURL* documentDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        
        if(_downloadPath.length != 0){
            NSURL *url = [documentDirectoryURL URLByAppendingPathComponent:_downloadPath];
            return [url URLByAppendingPathComponent:[response suggestedFilename]];
        }
        
        return [documentDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        NSHTTPURLResponse * urlResponse = (NSHTTPURLResponse*)_downloadDataTask.response;
        if (urlResponse.statusCode == 401){
            [DefaultChildEntity MR_truncateAll];
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_LoginOutAction object:nil];
        }

        if(networkHandler){
            if(!error){
                NSLog(@"\n请求成功:%@\n接口：%@\n状态码:%ld", [self makeApi:_api], _downlaodUrl, (long)urlResponse.statusCode);
                NSLog(@"下载成功");

                runOnMainThread(^{
                    FPResponse * response = [FPResponse new];
                    response.status = urlResponse.statusCode;
                    response.message = error.localizedDescription;
                    response.downloadPath = filePath;
                    networkHandler(response);
                });

            }else{
                NSLog(@"\n请求失败 %@\n接口：%@\n状态码:%ld", [self makeApi:_api], _downlaodUrl, (long)urlResponse.statusCode);
                NSLog(@"下载失败，error = %@",error.localizedDescription);

                runOnMainThread(^{
                    FPResponse * response = [FPResponse new];
                    response.status = urlResponse.statusCode;
                    response.message = error.localizedDescription;
                    networkHandler(response);
                });
            }
        }
    }];
    
    [_downloadDataTask resume];
    
    return self;
}

-(instancetype)addUploadHandler:(UploadHandler)uploadHandler withCompleteHandler:(NetworkHandler)networkHandler{
    return [self addCompleteHandler:networkHandler withUploadHandler:uploadHandler withDownloadHandler:nil isStartNow:YES];

}

-(instancetype)addCompleteHandler:(NetworkHandler)networkHandler withUploadHandler:(UploadHandler)uploadHandler withDownloadHandler:(DownloadHandler)downloadHandler isStartNow:(BOOL)isStart{
    
//    
//    [[HttpClient sharedClient] POST:[self makeApi:_api] parameters:_params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        for (FormData * data in _formDatas) {
//            [formData appendPartWithFileData:data.data name:data.name fileName:data.fileName mimeType:data.mimeType];
//        }
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        if (uploadHandler) {
//            uploadHandler(uploadProgress);
//        }
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [self disposeCompleteWithHandler:networkHandler responseObject:responseObject];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [self disposeErrorWithHandler:networkHandler error:error];
//    }];
    
    _dataTask = [[HttpClient sharedClient] dataTaskWithRequest:_request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        if (uploadHandler) {
            uploadHandler(uploadProgress);
        }
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        if (downloadHandler) {
            downloadHandler(downloadProgress);
        }
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            [self disposeErrorWithHandler:networkHandler error:error];
        }else{
            [self disposeCompleteWithHandler:networkHandler responseObject:responseObject];
        }
    }];
    if (isStart) {
        [_dataTask resume];
    }
    
    return self;
}

-(void)disposeCompleteWithHandler:(NetworkHandler)networkHandler responseObject:(id)responseObject{
    NSError *jsonError = nil;
    NSString * responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    
    NSError  *error=nil;
 NSDictionary  *dic = [NSJSONSerialization  JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"json解析错误信息：%@",error);
    
  FPResponse * response = [FPResponse mj_objectWithKeyValues:responseStr];

    NSLog(@"\n请求成功:%@\n接口：%@\n数据：\n%@", [self makeApi:_api], _api, responseStr);

    
    if (response.status == 401 && ![_api isEqualToString:API_LOGIN] && ![_api isEqualToString:API_PHONE_INDENTIFYING_CODE] && ![_api isEqualToString:API_PHONE_REGIST]){
        [DefaultChildEntity MR_truncateAll];
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_LoginOutAction object:nil];
    }
    if (networkHandler){
        
        runOnMainThread(^{
            if (!jsonError ) {
                if (response) {
                    networkHandler(response);
                }else{
                    FPResponse * response = [FPResponse new];
                    response.status = -1;
                    response.message = @"网络不可用，请检查网络设置";
                    networkHandler(response);
                }
            }else{
                FPResponse * response = [FPResponse new];
                response.status = -1;
                response.message = jsonError.localizedDescription;
                networkHandler(response);
            }
        });
    }
}

-(void)disposeErrorWithHandler:(NetworkHandler)networkHandler error:(NSError*)error{
    if (networkHandler) {
        NSHTTPURLResponse * urlResponse = (NSHTTPURLResponse*)_dataTask.response;
        if (urlResponse.statusCode == 401  && ![_api isEqualToString:API_LOGIN] && ![_api isEqualToString:API_PHONE_INDENTIFYING_CODE] && ![_api isEqualToString:API_PHONE_REGIST]){
            [DefaultChildEntity MR_truncateAll];
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_LoginOutAction object:nil];
        }else{
#if DEBUG
        NSLog(@"\n请求失败 %@\n接口：%@\n状态码:%ld", [self makeApi:_api], _api, (long)urlResponse.statusCode);
#endif
        runOnMainThread(^{
            FPResponse * response = [FPResponse new];
            response.status = urlResponse.statusCode;
            response.message = error.localizedDescription;
            networkHandler(response);
        });
        }
    }
}

-(void)cancel{
    if (_dataTask) {
        
        [_dataTask cancel];
    }
}


-(NSString *)makeApi:(NSString *)api{
    if (_formDatas){
        return UPLOAD_URL;
    }
    if (_downlaodUrl) {
        return [BASE_DOMAIN stringByAppendingString:_downlaodUrl];
    }
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:_params];
    [dict setValue:api forKey:@"ActionName"];
    _params = dict;
    return BASE_URL;
}

-(NSString *)make44Api:(NSString *)api{
    if (_formDatas){
        return UPLOAD_URL44;
    }
    if (_downlaodUrl) {
        return [BASE_DOMAIN stringByAppendingString:_downlaodUrl];
    }
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:_params];
    [dict setValue:api forKey:@"ActionName"];
    _params = dict;
    return BASE_URL;
}

-(NSString *)makereadyApi:(NSString *)api{
//    if (_formDatas){
        return UPLOAD_URLV1;
//    }
//    if (_downlaodUrl) {
//        return [BASE_DOMAIN stringByAppendingString:_downlaodUrl];
//    }
//    
//    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:_params];
//    [dict setValue:api forKey:@"ActionName"];
//    _params = dict;
//    return BASE_URL;
}

-(NSString *)maketigerhuang007Api:(NSString *)api{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:_params];
    [dict setValue:api forKey:@"ActionName"];
    _params = dict;
    return @"http://www.zhongkang365.com/MobileHtml/gzh/fenda/getappwxapi.aspx";
    
}

@end
