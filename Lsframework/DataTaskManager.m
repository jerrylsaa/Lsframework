//
//  SyncRequest.m
//  FamilyPlatForm
//
//  Created by Tom on 16/4/3.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "DataTaskManager.h"
#import "FPNetwork/FPNetwork.h"

@interface DataTaskManager()

@property (nonatomic, strong) dispatch_group_t group;

@end

@implementation DataTaskManager

-(void)requestWithDataTasks:(NSArray<FPNetwork *> *)dataTasks withComplete:(SyncRequestCompleteBlock)block{
//    [[HttpClient sharedClient].operationQueue setMaxConcurrentOperationCount:3];
    __block SyncRequestCompleteBlock weakBlock = block;
    
    _group = dispatch_group_create();
    for (FPNetwork * network in dataTasks) {
        dispatch_group_enter(_group);
        [network.dataTask resume];
    }
    dispatch_group_notify(_group, dispatch_get_main_queue(), ^{
        /* 回到主线程做进一步处理 */
        NSLog(@"SyncRequest End");
        weakBlock();
        
    });
}



-(void)countDown{
    dispatch_group_leave(_group);
}

@end
