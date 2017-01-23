//
//  GrowthStatusPresenter.m
//  FamilyPlatForm
//
//  Created by Tom on 16/3/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "GrowthStatusPresenter.h"

@implementation GrowthStatusPresenter

-(void)commitGrowthStatus:(ChildForm *)childForm{
    for(int i=0;i<self.dataSource.count;++i){
        NSString* text = [self.dataSource objectAtIndex:i];
        if(text.length==0){
            text = @"";
        }else{
            //判断是不是数字
            if(![self checkIsValid:text index:i]) return ;
        }
        switch (i) {
            case 0:{//抬头
                childForm.rise = text;
            }
                break;
            case 1:{//翻身
                childForm.turnOver = text;
            }
                break;
            case 2:{//坐稳
                childForm.sit = text;
            }
                break;
            case 3:{//俯爬
                childForm.overLookClimb = text;
            }
                break;
            case 4:{//手膝爬
                childForm.handClimb = text;
            }
                break;
            case 5:{//独站
                childForm.stand =text;
            }
                break;
            case 6:{//独行
                childForm.walk = text;
            }
                break;
            case 7:{//上楼梯
                childForm.upStairs =text;
            }
                break;
            case 8:{//跑步
                childForm.run = text;
            }
                break;
            case 9:{//双脚跳
                childForm.twoFootJump = text;
            }
                break;
            case 10:{//单脚站立
                childForm.standOneFoot = text;
            }
                break;
            case 11:{//单脚跳
                childForm.oneFootJump = text;
            }
                break;
            case 12:{//伸手购物
                childForm.reach = text;
            }
                break;
            case 13:{//拇食指对捏
                childForm.pinch = text;
            }
                break;
            case 14:{//叫爸爸
                childForm.callFather =text;
            }
                break;
            case 15:{//说物品名字
                childForm.sayGoods = text;
            }
                break;
            case 16:{//说短语
                childForm.sayPhrase = text;
            }
                break;
            case 17:{//说自己的名字
                childForm.sayOwnName = text;
            }
                break;
        }
    }
    
    NSDictionary* parames = @{@"Child_ID":@(childForm.childID),
                              @"Rise":childForm.rise,
                              @"Turn_Over":childForm.turnOver,
                              @"Sit_Steadily":childForm.sit,
                              @"Overlooking_Climb":childForm.overLookClimb,
                              @"Handknee_Climb":childForm.handClimb,
                              @"Stand_Alone":childForm.stand,
                              @"Walk_Alone":childForm.walk,
                              @"Up_Stairs":childForm.upStairs,
                              @"Run":childForm.run,
                              @"Jump_TwoFoot":childForm.twoFootJump,
                              @"Stand_OneFoot":childForm.standOneFoot,
                              @"Jump_OneFoot":childForm.oneFootJump,
                              @"Reaching_Object":childForm.reach,
                              @"Pinch":childForm.pinch,
                              @"Call_BaMa":childForm.callFather,
                              @"Say_Goods":childForm.sayGoods,
                              @"Say_Phrase":childForm.sayPhrase,
                              @"Call_OwnName":childForm.sayOwnName
                              };
    WS(ws);
    [[FPNetwork POST:API_PHONE_ADD_DEVELOPMENT withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(onCommitComplete:info:)]){
            [ws.delegate onCommitComplete:response.success info:response.message];
        }
    }];

    
}

#pragma mark - 

- (BOOL)checkIsValid:(NSString*) text index:(NSUInteger) index{
    BOOL isValid= NO;
    NSString* inputText = [NSString stringWithFormat:@"%@项必须是大于0的整数",self.titleArray[index]];
    
    if(![text isPureNumber]){
        [self.delegate onCommitComplete:NO info:inputText];

    }else{
        NSUInteger month= [text integerValue];
        if(month==0){
            //输入大于零
            [self.delegate onCommitComplete:NO info:inputText];
        }else{
            isValid = YES;
        }
    }
    return isValid ;
}

- (void)commitGrowthStatus:(ChildForm*) childForm block:(Complete)block{
    for(int i=0;i<self.dataSource.count;++i){
        NSString* text = [self.dataSource objectAtIndex:i];
        if(text.length==0){
            text = @"";
        }else{
            //判断是不是数字
            if(![self checkIsValid:text index:i]) return ;
        }
        switch (i) {
            case 0:{//抬头
                childForm.rise = text;
            }
                break;
            case 1:{//翻身
                childForm.turnOver = text;
            }
                break;
            case 2:{//坐稳
                childForm.sit = text;
            }
                break;
            case 3:{//俯爬
                childForm.overLookClimb = text;
            }
                break;
            case 4:{//手膝爬
                childForm.handClimb = text;
            }
                break;
            case 5:{//独站
                childForm.stand =text;
            }
                break;
            case 6:{//独行
                childForm.walk = text;
            }
                break;
            case 7:{//上楼梯
                childForm.upStairs =text;
            }
                break;
            case 8:{//跑步
                childForm.run = text;
            }
                break;
            case 9:{//双脚跳
                childForm.twoFootJump = text;
            }
                break;
            case 10:{//单脚站立
                childForm.standOneFoot = text;
            }
                break;
            case 11:{//单脚跳
                childForm.oneFootJump = text;
            }
                break;
            case 12:{//伸手购物
                childForm.reach = text;
            }
                break;
            case 13:{//拇食指对捏
                childForm.pinch = text;
            }
                break;
            case 14:{//叫爸爸
                childForm.callFather =text;
            }
                break;
            case 15:{//说物品名字
                childForm.sayGoods = text;
            }
                break;
            case 16:{//说短语
                childForm.sayPhrase = text;
            }
                break;
            case 17:{//说自己的名字
                childForm.sayOwnName = text;
            }
                break;
            default:
                break;
        }
    }
    block(YES,nil);
}
@end
