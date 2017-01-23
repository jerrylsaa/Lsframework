//
//  FPResponse.h
//  FamilyPlatForm
//
//  Created by Tom on 16/4/2.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FPResponse : NSObject

@property (nonatomic, strong) NSString * message;

@property (nonatomic) NSInteger status;

@property (nonatomic, strong) NSString * token;

@property (nonatomic, strong) id data;

@property (nonatomic,getter=isSuccess) BOOL success;

@property(nonatomic) NSInteger totalCount;//总数

@property (nonatomic,strong) id attributes;

@property (nonatomic,strong) id stocks;


/***/
@property(nonatomic,retain) NSURL* downloadPath;

@property (nonatomic) NSInteger NoAnswer;

@end
