//
//  ActivityData.h
//  FamilyPlatForm
//
//  Created by jerry on 16/11/15.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityData : NSObject
/**
 *  {
 "ID": 4,
 "IconUrl": "http://h.hiphotos.baidu.com/zhidao/pic/item/d62a6059252dd42aaf3af240063b5bb5c9eab82e.jpg",
 "H5Url": "http://www.zhongkang365.com/MobileHtml/everyday/childgm161110.html\r\n",
 "VersionNo": 22,
 "ActivityDate": "2016-11-11 01:38:33",
 "IsOn": 1
 }

 */
@property (nonatomic ,strong) NSNumber *Activity_ID;
@property (nonatomic ,strong) NSString *Activity_iconUrl;
@property (nonatomic ,strong) NSString *H5Url;
@property (nonatomic ,strong) NSNumber *VersionNo;
@property (nonatomic ,strong) NSString *ActivityDate;
@property (nonatomic ,strong) NSNumber *IsOn;
@end
