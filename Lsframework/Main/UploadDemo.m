//
//  UploadDemo.m
//  FamilyPlatForm
//
//  Created by tom on 16/4/6.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "UploadDemo.h"
#import "DataTaskManager.h"
#import "LocationManager.h"

@implementation UploadDemo

-(void)uploadDemo{
    FormData * formData = [FormData new];
    UIImage * image = [UIImage imageNamed:@"ac_commit"];
    formData.data = UIImagePNGRepresentation(image);
    formData.fileName = @"file.png";
    formData.name = @"file";
    formData.mimeType = @"image/png";
    
    DataTaskManager * request = [DataTaskManager new];
    FPNetwork * n1 = [[FPNetwork POST:nil withParams:nil withFormDatas:@[formData]] addCompleteHandlerAndNotStartNow:^(FPResponse *response) {
        NSDictionary * dict = [response.data dictionary];
        NSLog(@"n1\n%@", dict[@"Result"]);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            sleep(5);
            [request countDown];
            NSLog(@"n1 countdown");
        });


    }];
    
    FPNetwork * n2 = [[FPNetwork POST:nil withParams:nil withFormDatas:@[formData]] addCompleteHandlerAndNotStartNow:^(FPResponse *response) {
        NSDictionary * dict = [response.data dictionary];

        NSLog(@"n2\n%@", dict[@"Result"]);
                        [request countDown];
    }];
    
    FPNetwork * n3 = [[FPNetwork POST:nil withParams:nil withFormDatas:@[formData]] addCompleteHandlerAndNotStartNow:^(FPResponse *response) {
        NSDictionary * dict = [response.data dictionary];
        
        NSLog(@"n3\n%@", dict[@"Result"]);
                [request countDown];
    }];
    
    FPNetwork * n4 = [[FPNetwork POST:nil withParams:nil withFormDatas:@[formData]] addCompleteHandlerAndNotStartNow:^(FPResponse *response) {
        NSDictionary * dict = [response.data dictionary];
        
        NSLog(@"n4\n%@", dict[@"Result"]);
                [request countDown];
    }];
    

//    [request requestWithDataTasks:@[n1, n2, n3, n4] withComplete:^{
//        NSLog(@"All Done");
//    }];
    
    //定位Demo
    [[LocationManager shareInstance] getProvinceAndCityWithBlock:^(NSString * province, NSString * city,NSString * longitude, NSString * latitude, BOOL success) {
        if (success) {
            NSLog(@"%@,%@", province, city);
        }
    }];
    
    //下载
    
    [[FPNetwork DOWNLOAD:@"/attach_upload//voice/201607/01/201607011747141745.3gpp"] addCompleteHandler:^(FPResponse *response) {
        
    } withDownloadHandler:^(NSProgress *pregress) {
        NSLog(@"%lldl", pregress.completedUnitCount);
    }];
    
    //新的下载
    [[FPNetwork DOWNLOAD:@"/attach_upload//voice/201607/01/201607011747141745.3gpp" downloadPath:nil] addDownloadHandler:^(NSProgress *pregress) {
        NSLog(@"progress = %g",pregress.fractionCompleted);
    } withCompleteHandler:^(FPResponse *response) {
        if(response.success){
            NSData* data = [NSData dataWithContentsOfURL:response.downloadPath];
        }
        
    }];

    
}

@end
