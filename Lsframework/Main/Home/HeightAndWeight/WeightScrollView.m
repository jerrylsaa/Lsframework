//
//  WeightScrollView.m
//  FamilyPlatForm
//
//  Created by jerry on 16/11/14.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "WeightScrollView.h"

@implementation WeightScrollView{
    float Scrollheight;
    float ScrollWeight;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        Scrollheight = kScreenWidth;
         ScrollWeight = kScreenHeight-kFitHeightScale(216)-50-22;
        
        if (kScreenHeight>=470 &&kScreenHeight<=490) {
            // 4
            ScrollWeight =((kScreenHeight-kFitHeightScale(216))/2+26*10+4)*480/736+13;
        }
        if (kScreenHeight>=660 &&kScreenHeight<=670) {
            // 6
            ScrollWeight =((kScreenHeight-kFitHeightScale(216))/2+26*10+4)*667/736+11;
        }

        if (kScreenHeight>=730 &&kScreenHeight<=740) {
            // 6plus
            ScrollWeight =(kScreenHeight-kFitHeightScale(216))/2+26*10+4;
        }

       
        self.bounces = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
    }
    return self;
}

- (void)createWeightScorllMinruler:(NSInteger )minruler   showType:(WeightAndHeightType)showType{
    if (showType == TypeWeightText) {
        //体重
        //20000为最大值， 100为间隔，10未间隔之间的宽度，都可自己设置
        for (int i = minruler, j = 0; i <= 300; i+=1, j++) {
            Scrollheight += 10;
            UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2 + 10 * j, 0, 1, 13)];
            lable.backgroundColor =  UIColorFromRGB(0x9f8d8e);
            [self addSubview:lable];
            
            //中间横条
            if (i % 5 == 0 && (i/5)%2==1) {
            
                
                lable.frame = CGRectMake(kScreenWidth / 2 + 10 * j, 0, 1, 20);
            }
            //显示刻度
            if (i % 10 == 0 || i == minruler) {
                
                lable.frame = CGRectMake(kScreenWidth / 2 + 10 * j, 0, 2, 20);
                UILabel * numberLable = [[UILabel alloc] initWithFrame:CGRectMake(lable.frame.origin.x - 25,35, 50, 20)];
                numberLable.backgroundColor = [UIColor clearColor];
                numberLable.font = [UIFont systemFontOfSize:15];
                numberLable.textAlignment = NSTextAlignmentCenter;
                numberLable.textColor =  UIColorFromRGB(0x9f8d8e);
                numberLable.text = [NSString stringWithFormat:@"%d",i/10];
                [self addSubview:numberLable];
            }
            
        }
        self.contentSize = CGSizeMake(Scrollheight-10, 50);

        
    }else if (showType == TypeHeightText){
    //身高

        for (int i = minruler*10, j = 0; i >= 400; i-=1, j++) {
            ScrollWeight += 10;
        UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake( 0 ,kFitHeightScale(216)+ 10 * j, 13, 1)];
            lable1.backgroundColor =  UIColorFromRGB(0x9f8d8e);
            [self addSubview:lable1];
            
        UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake( 100 ,kFitHeightScale(216)+ 10 * j, 13, 1)];
            lable2.backgroundColor =  UIColorFromRGB(0x9f8d8e);
            [self addSubview:lable2];

            
            //中间横条
            if (i % 5 == 0 && (i/5)%2==1) {
              
                
                lable1.frame = CGRectMake( 0 ,kFitHeightScale(216)+ 10 * j, 20, 1);
                lable2.frame = CGRectMake(93,kFitHeightScale(216)+ 10 * j, 20, 1);
            }
            //显示刻度
            if (i % 10 == 0 || i == minruler) {
             lable1.frame = CGRectMake( 0 ,kFitHeightScale(216)+ 10 * j, 20, 2);
             lable2.frame = CGRectMake(93,kFitHeightScale(216)+ 10 * j, 20, 2);
                
            UILabel * numberLable = [[UILabel alloc] initWithFrame:CGRectMake(34,lable1.frame.origin.y - 10,45,20)];
            numberLable.font = [UIFont systemFontOfSize:15];
            numberLable.textAlignment = NSTextAlignmentCenter;
            numberLable.textColor =  UIColorFromRGB(0x9f8d8e);
            numberLable.text = [NSString stringWithFormat:@"%d",i/10];
            [self addSubview:numberLable];
            }

        }
        self.contentSize =  CGSizeMake(50, ScrollWeight-10);
    }
    
}


@end
