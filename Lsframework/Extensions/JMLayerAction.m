//
//  JMLayerAction.m
//  FansGroup0307
//
//  Created by 梁继明 on 16/3/10.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "JMLayerAction.h"

@implementation JMLayerAction

+(CAAnimation *)scaleFromValue:(NSValue *) fromScaleValue andToValue:(NSValue *)toScalevalue andFromPostition:(NSValue *)fromPosValue andToPostion:(NSValue*)toPosValue{

    CABasicAnimation *anmiantion = [CABasicAnimation animationWithKeyPath:@"transform"];
    
    anmiantion.fromValue = fromScaleValue;
    
    anmiantion.toValue =toScalevalue;
    
    anmiantion.removedOnCompletion = NO;
    
    anmiantion.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *postion = [CABasicAnimation animationWithKeyPath:@"position"];
    
    postion.fromValue =fromPosValue ;
    
    postion.toValue = toPosValue;
    
    postion.removedOnCompletion = NO;
    
    postion.fillMode = kCAFillModeForwards;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    
    group.duration =0.3f;
    
    group.autoreverses = NO;
    
    group.removedOnCompletion = NO;
    
    group.fillMode = kCAFillModeForwards;
    
    group.animations = @[anmiantion,postion];

    return group;


}
@end
