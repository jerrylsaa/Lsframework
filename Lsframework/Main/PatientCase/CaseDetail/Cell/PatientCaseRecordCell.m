//
//  PatientCaseRecordCell.m
//  FamilyPlatForm
//
//  Created by lichen on 16/10/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "PatientCaseRecordCell.h"

@interface PatientCaseRecordCell (){
    UIView* container;
    
    UILabel* recordTitleLabel;
    UILabel* recordContentLabel;
    UIView* bottomLine;
}

@end

@implementation PatientCaseRecordCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        container = [UIView new];
        [self.contentView addSubview:container];
        
        recordTitleLabel = [UILabel new];
        recordTitleLabel.textColor = UIColorFromRGB(0x61d8d3);
        recordTitleLabel.font = [UIFont systemFontOfSize:bigFont];
        [container addSubview:recordTitleLabel];
        
        recordContentLabel = [UILabel new];
        recordContentLabel.textColor = UIColorFromRGB(0x33333);
        recordContentLabel.font = [UIFont systemFontOfSize:sbigFont];
        [container addSubview:recordContentLabel];
        
        bottomLine = [UIView new];
        bottomLine.backgroundColor = RGB(227, 227, 227);
        [container addSubview:bottomLine];

        //添加约束
        container.sd_layout.topSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0);
        recordTitleLabel.sd_layout.topSpaceToView(container,20).leftSpaceToView(container,20).autoHeightRatio(0);
        [recordTitleLabel setSingleLineAutoResizeWithMaxWidth:200];
        recordContentLabel.sd_layout.topSpaceToView(recordTitleLabel,10).leftEqualToView(recordTitleLabel).rightSpaceToView(container,20).autoHeightRatio(0);
        bottomLine.sd_layout.topSpaceToView(recordContentLabel,10).leftEqualToView(recordTitleLabel).rightSpaceToView(container,0).heightIs(1);
        
        [container setupAutoHeightWithBottomView:bottomLine bottomMargin:0];
        
        [self setupAutoHeightWithBottomView:container bottomMargin:0];
        
    }
    return self;
}

-(void)setRecordDic:(NSDictionary *)recordDic{
    _recordDic = recordDic;
    
    recordTitleLabel.text = [recordDic valueForKey:@"title"];
    
    
    NSString* recordContent = [recordDic valueForKey:@"content"];
    if([recordContent containsString:@"\n"] || [recordContent containsString:@"\\n"]){
        recordContent =  [recordContent stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    }
    recordContentLabel.text = recordContent;


}

@end
