//
//  JMLayerAction.h
//  FansGroup0307
//
//  Created by 梁继明 on 16/3/10.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMLayerAction : NSObject


+(CAAnimation *)scaleFromValue:(NSValue *) fromScaleValue andToValue:(NSValue *)toScalevalue andFromPostition:(NSValue *)fromPosValue andToPostion:(NSValue*)toPosValue;


@end
