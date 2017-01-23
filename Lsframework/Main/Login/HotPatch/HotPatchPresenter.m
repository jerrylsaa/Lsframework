//
//  HotPatchPresenter.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/9/1.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HotPatchPresenter.h"

@implementation HotPatchPresenter


- (void)loadLua:(LoadHandler)block{
    
    
    WS(ws);
    //不删除压缩包
//    [kDefaultsUser removeObjectForKey:PATCH_VERSION];//测试用、
    //查询
    [self queryPatch:^(BOOL success, NSString *path) {
        if (success == YES) {
            if ([path isEqualToString:@"NULLPATCH"]) {
                block(YES,@"NULLPATCH");
            }else{
                //下载
                NSString* homePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
                NSString* targetPath = [homePath stringByAppendingPathComponent:@"patch"];
                if (![[NSFileManager defaultManager] fileExistsAtPath:targetPath]) {
                    [[NSFileManager defaultManager] createDirectoryAtPath:targetPath withIntermediateDirectories:YES attributes:nil error:NULL];
                }
                NSString *pathStr = [kDefaultsUser objectForKey:@"zip"];
                NSString *patchStr = [NSString getPatchZipPath];
                BOOL suc = [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",patchStr,pathStr]];
                if (![kDefaultsUser objectForKey:PATCH_VERSION] || ![self.version isEqualToString:[kDefaultsUser objectForKey:PATCH_VERSION]] || suc == NO) {
                    [[FPNetwork DOWNLOAD:path downloadPath:@"patch"] addDownloadHandler:^(NSProgress *pregress) {
                        //                NSLog(@"%.2lld",pregress.completedUnitCount);
                        NSLog(@"progress = %.2f",pregress.fractionCompleted);
                    } withCompleteHandler:^(FPResponse *response) {
                        if (response.success == YES) {
                            //写入
                            block(YES,response.downloadPath.absoluteString);
                            
                        }else{
                            block(NO,nil);
                        }
                    }];
                }else{
                    block(YES,@"NOPATCH");
                }
            }
            
        }else{
            block(NO,nil);
        }
    }];
}




//弃用
- (BOOL)writeToLocal:(NSURL *)filePath{
    
    NSString *homePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString *patchZip = [homePath stringByAppendingPathComponent:@"patch/patch.zip"];
    
    [[NSFileManager defaultManager] removeItemAtPath:patchZip error:NULL];
    
    NSData *data = [NSData dataWithContentsOfURL:filePath];
    
    return [data writeToFile:patchZip atomically:YES];
}


//补丁更新方法
//上传patch.zip,需要更新补丁时使用
- (void)uploadPatchZip{
    FormData * formData = [FormData new];
    NSString *path = [NSString getPatchZipPath];
    formData.data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/patch.zip",path]];
    formData.fileName = @"patch.zip";
    formData.name = @"patch";
    formData.mimeType = @"zip";
//    http://121.42.15.43:9020/attach_upload//zip/201609/05/201609051131274673.zip
    NSDictionary *parameters = @{@"fileType":@"zip"};
    WS(ws);
    [ProgressUtil showWithStatus:@"补丁正在上传中"];
    [[FPNetwork POST:UPLOAD_URL withParams:parameters withFormDatas:@[formData]] addCompleteHandler:^(FPResponse *response) {
        NSDictionary *data = [response.data dictionary];
        NSLog(@"%@", response.data);
        NSMutableArray *uploadPathArr = [data[@"Result"] getSingleUploadPath];
        [ws newPatch:[NSString stringWithFormat:@"%@",uploadPathArr[0]]];
    }];
}
//新增补丁包
- (void)newPatch:(NSString *)path{
    
    NSDictionary *parameters = @{@"UserID":@(kCurrentUser.userId),@"Platform":@1,@"Version":@"1.0.0",@"PackUrl":path};
    
    [[FPNetwork POST:@"InsertPackageInfo" withParams:parameters] addCompleteHandler:^(FPResponse *response) {
        NSLog(@"上传补丁包成功");
    }];
}
//修改补丁包
- (void)updatePatch:(NSString *)path{
    
    NSDictionary *parameters = @{@"UserID":@(kCurrentUser.userId),@"Platform":@1,@"Version":@"1.0.0",@"PackUrl":@"/attach_upload//zip/201609/05/201609051131274673.zip",@"PackID":@4};
    
    [[FPNetwork POST:@"UpdatePackageInfo" withParams:parameters] addCompleteHandler:^(FPResponse *response) {
        NSLog(@"更新补丁包成功");
    }];
}
//删除补丁包
- (void)deletePatch{
    
    [[FPNetwork POST:@"DeletePackageInfo" withParams:@{@"PackID":@4}] addCompleteHandler:^(FPResponse *response) {
        NSLog(@"删除补丁包成功");
    }];
}
//查询补丁包
- (void)queryPatch:(LoadHandler )block{
    WS(ws);
    NSDictionary *parameters = @{@"UserID":@(kCurrentUser.userId),@"Platform":@1,@"Version":@"1.0.0"};
    
    [[FPNetwork POST:@"QueryPackageInfo" withParams:parameters] addCompleteHandler:^(FPResponse *response) {
        NSLog(@"查询补丁包成功");
        if (response.success == YES) {
            NSArray *array = response.data;
            if (array.count != 0) {
                NSDictionary *dic = response.data[0];
                NSString *packUrl = dic[@"PackUrl"];
                ws.version = dic[@"Version"];
                block(YES,packUrl);
            }else{
                block(YES,@"NULLPATCH");
            }
        }else{
            block(NO,nil);
        }
    }];
}



@end
