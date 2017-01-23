//
//  DiscoverQuestTableViewCell.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/8/25.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "DiscoverQuestTableViewCell.h"
#import "DefaultChildEntity.h"
@interface DiscoverQuestTableViewCell (){
    UIView *_containerView;
    UILabel *_creatTimeLabel;
    UILabel *_birthTimeLabel;
    UILabel *_taskDescribeLabel;
}

@end
@implementation DiscoverQuestTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        self.selectionStyle =UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    _containerView = [UIView new];
    [self.contentView addSubview:_containerView];
    
    _creatTimeLabel =[UILabel new];
    _creatTimeLabel.textColor =UIColorFromRGB(0x666666);
    _creatTimeLabel.font =[UIFont systemFontOfSize:15];
    [_containerView addSubview:_creatTimeLabel];
    
    _birthTimeLabel =[UILabel new];
    _birthTimeLabel.textAlignment =NSTextAlignmentCenter;
    _birthTimeLabel.textColor =UIColorFromRGB(0x666666);
    _birthTimeLabel.font =[UIFont systemFontOfSize:15];
    [_containerView addSubview:_birthTimeLabel];
    
    UIView *verticalLine =[UIView new];
    verticalLine.backgroundColor =RGB(83, 209, 201);
    [_containerView addSubview:verticalLine];
    
    _taskDescribeLabel =[UILabel new];
    _taskDescribeLabel.numberOfLines =0;
    _taskDescribeLabel.textAlignment =NSTextAlignmentCenter;
    _taskDescribeLabel.textColor =UIColorFromRGB(0x666666);
    _taskDescribeLabel.font =[UIFont systemFontOfSize:15];
    [_containerView addSubview:_taskDescribeLabel];
    
    _containerView.sd_layout.topSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0);
    
    _creatTimeLabel.sd_layout.topSpaceToView(_containerView,23.5).leftSpaceToView(_containerView,15).widthIs(80).heightIs(15);
    _birthTimeLabel.sd_layout.topSpaceToView(_creatTimeLabel,0).leftEqualToView(_creatTimeLabel).widthIs(80).heightIs(15);
    verticalLine.sd_layout.topSpaceToView(_containerView,15).leftSpaceToView(_creatTimeLabel,15).heightIs(47).widthIs(1);
    _taskDescribeLabel.sd_layout.topSpaceToView(_containerView,15).leftSpaceToView(verticalLine,15).rightSpaceToView(_containerView,15).bottomSpaceToView(_containerView,15).autoHeightRatio(0);
    [_containerView setupAutoHeightWithBottomViewsArray:@[_taskDescribeLabel] bottomMargin:15];
    [self setupAutoHeightWithBottomView:_containerView bottomMargin:0];
}

-(void)setQuestEntity:(DIscoverQuestEntity *)questEntity{
    _questEntity =questEntity;
    
    _creatTimeLabel.text =[self getStringbyDate:questEntity.CreateTime];
    _birthTimeLabel.text =[self getChildBirth];
    _taskDescribeLabel.text =questEntity.TaskDescribe;
}

- (NSString *)getStringbyDate:(NSInteger )dateInt{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970: dateInt];
    NSString* dateString = [formatter stringFromDate:date];
    
    return dateString;
}

- (NSString *)getChildBirth{
    
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];//格式化
    [df setDateFormat:@"yyyy MM dd"];
    
    NSTimeInterval time=[[NSDate date] timeIntervalSinceDate:[DefaultChildEntity defaultChild].birthDate];
    
    
    
    NSUInteger month=((((NSUInteger)time)/(3600*24*30))%12);
    
    
    
    NSUInteger year=((NSUInteger)time)/(3600*24*30*12);
    

    
    NSString *dateContent =[NSString stringWithFormat:@"%d岁%d个月",year,month];
    
    return dateContent;
}


/**
 *  将阿拉伯数字转换为中文数字
 */
- (NSString *)translationArabicNum:(NSInteger)arabicNum
{
    NSString *arabicNumStr = [NSString stringWithFormat:@"%ld",(long)arabicNum];
    NSArray *arabicNumeralsArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    NSArray *chineseNumeralsArray = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"零"];
    NSArray *digits = @[@"个",@"十",@"百",@"千",@"万",@"十",@"百",@"千",@"亿",@"十",@"百",@"千",@"兆"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chineseNumeralsArray forKeys:arabicNumeralsArray];
    
    if (arabicNum < 20 && arabicNum > 9) {
        if (arabicNum == 10) {
            return @"十";
        }else{
            NSString *subStr1 = [arabicNumStr substringWithRange:NSMakeRange(1, 1)];
            NSString *a1 = [dictionary objectForKey:subStr1];
            NSString *chinese1 = [NSString stringWithFormat:@"十%@",a1];
            return chinese1;
        }
    }else{
        NSMutableArray *sums = [NSMutableArray array];
        for (int i = 0; i < arabicNumStr.length; i ++)
        {
            NSString *substr = [arabicNumStr substringWithRange:NSMakeRange(i, 1)];
            NSString *a = [dictionary objectForKey:substr];
            NSString *b = digits[arabicNumStr.length -i-1];
            NSString *sum = [a stringByAppendingString:b];
            if ([a isEqualToString:chineseNumeralsArray[9]])
            {
                if([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]])
                {
                    sum = b;
                    if ([[sums lastObject] isEqualToString:chineseNumeralsArray[9]])
                    {
                        [sums removeLastObject];
                    }
                }else
                {
                    sum = chineseNumeralsArray[9];
                }
                
                if ([[sums lastObject] isEqualToString:sum])
                {
                    continue;
                }
            }
            
            [sums addObject:sum];
        }
        NSString *sumStr = [sums  componentsJoinedByString:@""];
        NSString *chinese = [sumStr substringToIndex:sumStr.length-1];
        return chinese;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
