//
//  BasePresenter.h
//  FamilyPlatForm
//
//  Created by Tom on 16/3/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FPNetwork.h"


@interface BasePresenter : NSObject


/**
 *  <#Description#>
 *
 *  @param selfTitle 页面标题
 *  @param Event    当前事件： 页面：进入   推送：收到
 */
+(void)EventStatisticalDotTitle:(NSString*)selfTitle Action:(NSString*)Event Remark:(NSString*)remark;

+(void)EventStatisticalDotTitle:(NSString*)selfTitle Action:(NSString*)Event Remark:(NSString*)remark   SrcID:(NSNumber*)SrcID;

@end
