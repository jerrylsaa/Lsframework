//
//  SyncRequest.h
//  FamilyPlatForm
//
//  Created by Tom on 16/4/3.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FPNetwork.h"

typedef void(^SyncRequestCompleteBlock)();

@interface DataTaskManager : NSObject

-(void)requestWithDataTasks:(NSArray<FPNetwork*>*)dataTasks withComplete:(SyncRequestCompleteBlock)block;

-(void)countDown;

@end
