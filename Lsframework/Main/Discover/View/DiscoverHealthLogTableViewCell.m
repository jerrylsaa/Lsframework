//
//  DiscoverHealthLogTableViewCell.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/8/25.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "DiscoverHealthLogTableViewCell.h"
#import "DefaultChildEntity.h"
#import "ApiMacro.h"
@interface DiscoverHealthLogTableViewCell (){
    UIView *_containerView;
    UIImageView *_logIV;
    UILabel *_creatTimeYMLabel;
    UILabel *_creatTimeDayLabel;

    UILabel *_birthTimeLabel;
    
    UIImageView *_logPhotoIV;
    UILabel *_taskDescribeLabel;
}

@end
@implementation DiscoverHealthLogTableViewCell


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
    
    _logIV =[_containerView viewWithTag:1001];
    if (_logIV==nil) {
        _logIV =[UIImageView new];
        _logIV.tag =1001;
        _logIV.image =[UIImage imageNamed:@"logImage"];
        [_containerView addSubview:_logIV];
    }
    
    
    _creatTimeDayLabel =[UILabel new];
    _creatTimeDayLabel.textAlignment =NSTextAlignmentCenter;
    _creatTimeDayLabel.font =[UIFont systemFontOfSize:26];
    _creatTimeDayLabel.textColor =UIColorFromRGB(0xbcaaa4);
    [_containerView addSubview:_creatTimeDayLabel];
    
    _creatTimeYMLabel =[UILabel new];
    _creatTimeYMLabel.textAlignment =NSTextAlignmentCenter;
    _creatTimeYMLabel.font =[UIFont systemFontOfSize:13];
    _creatTimeYMLabel.textColor =UIColorFromRGB(0x726967);
    [_containerView addSubview:_creatTimeYMLabel];
    
    _birthTimeLabel =[UILabel new];
    _birthTimeLabel.textAlignment =NSTextAlignmentLeft;
    _birthTimeLabel.font =[UIFont systemFontOfSize:16];
    _birthTimeLabel.textColor =UIColorFromRGB(0x61d8d3);
    [_containerView addSubview:_birthTimeLabel];
    
    _logPhotoIV =[_containerView viewWithTag:1002];
    if (_logPhotoIV==nil) {
        _logPhotoIV =[UIImageView new];
        _logPhotoIV.tag =1002;
        _logPhotoIV.contentMode =UIViewContentModeScaleAspectFill;
        _logPhotoIV.clipsToBounds =YES;
        _logPhotoIV.image =[UIImage imageNamed:@"addLogImage"];
        [_containerView addSubview:_logPhotoIV];
    }
    
    _taskDescribeLabel =[UILabel new];
    _taskDescribeLabel.numberOfLines =0;
    _taskDescribeLabel.textColor =UIColorFromRGB(0x999999);
    _taskDescribeLabel.font =[UIFont systemFontOfSize:16];
    _taskDescribeLabel.textAlignment =NSTextAlignmentLeft;
    [_containerView addSubview:_taskDescribeLabel];
    
    _containerView.sd_layout.topSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0);
    
    _logIV.sd_layout.leftSpaceToView(_containerView,15).topSpaceToView(_containerView,25).widthIs(70).heightIs(70);
    _creatTimeDayLabel.sd_layout.centerXEqualToView(_logIV).topSpaceToView(_containerView,30).heightIs(30).widthIs(35);
    _creatTimeYMLabel.sd_layout.centerXEqualToView(_logIV).topSpaceToView(_creatTimeDayLabel,0).widthIs(70).heightIs(35);
    _birthTimeLabel.sd_layout.leftSpaceToView(_logIV,15).centerYEqualToView(_logIV).heightIs(20).widthIs(150);
    
    _logPhotoIV.sd_layout.leftSpaceToView(_containerView,15).topSpaceToView(_logIV,15).rightSpaceToView(_containerView,15).heightIs(176);
    
    _taskDescribeLabel.sd_layout.leftSpaceToView(_containerView,15).topSpaceToView(_logPhotoIV,15).rightSpaceToView(_containerView,15).autoHeightRatio(0);
    
    [_containerView setupAutoHeightWithBottomViewsArray:@[_taskDescribeLabel] bottomMargin:15];
    [self setupAutoHeightWithBottomView:_containerView bottomMargin:0];
}

- (void)setLogEntity:(DiscoverHealthLogEntity *)logEntity{
    _logEntity =logEntity;
    
    NSUInteger month=((((NSUInteger)logEntity.DayNum)/(30))%12);
    
    
    NSUInteger year=((NSUInteger)logEntity.DayNum)/(30*12);
    
    
    _birthTimeLabel.text =[NSString stringWithFormat:@"%d岁%d个月",year,month];
    
    _creatTimeDayLabel.text =[self getDayStringbyDate:logEntity.CreateTime];
    _creatTimeYMLabel.text =[self getYMStringbyDate:logEntity.CreateTime];
    
    if (logEntity.photourl!=nil&&logEntity.photourl.length>4) {
        _logPhotoIV.contentMode =UIViewContentModeScaleAspectFill;
        [_logPhotoIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,logEntity.photourl]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"] ];
    }else {
        _logPhotoIV.contentMode =UIViewContentModeScaleToFill;
        _logPhotoIV.image =[UIImage imageNamed:@"addLogImage"];

    }
    
    if (logEntity.LogStatus==1) {
        self.isEdited =YES;
        _taskDescribeLabel.textColor =UIColorFromRGB(0x666666);
        
        _creatTimeDayLabel.hidden =NO;
        _creatTimeYMLabel.hidden =NO;
        _logIV.image =[UIImage imageNamed:@"logImage"];
        
    }else {
        self.isEdited =NO;
        _taskDescribeLabel.textColor =UIColorFromRGB(0xcccccc);
        
        _creatTimeDayLabel.hidden =YES;
        _creatTimeYMLabel.hidden =YES;
        _logIV.image =[UIImage imageNamed:@"logToBeEditedImage"];


    }
    
    _taskDescribeLabel.text =logEntity.LogContent;
    
}



- (NSString *)getYMStringbyDate:(NSInteger )dateInt{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy.MM"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970: dateInt];
    NSString* dateString = [formatter stringFromDate:date];
    
    return dateString;
    
}

- (NSString *)getDayStringbyDate:(NSInteger )dateInt{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"dd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970: dateInt];
    NSString* dateString = [formatter stringFromDate:date];
    
    return dateString;
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
