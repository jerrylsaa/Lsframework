//
//  BehaviourTableViewCell.m
//  FamilyPlatForm
//
//  Created by xuwenqi on 16/4/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BehaviourTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "JMFoundation.h"

@interface BehaviourTableViewCell()
{
  
    UIImageView *_headImageView;//头像
    UIImageView *_photoFrame;//相框
    UILabel *_postLabel;//职位
    UILabel *_nameLabel;//姓名
    UILabel *_departmentLabel;//科室
    UILabel *_illnessLable;//所患病
    UILabel *_timeLable;//时间
    UIView *_timeView;
}




@end

@implementation BehaviourTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubViews];
    }
    return self;
    
}

- (void)setupSubViews
{
    [self setupTimeView];
    [self setupHeaderImageView];
    [self setupIllnessView];
    [self setupPostView];
    [self setupNameView];
    [self setupDepartmentView];
    [self setupSep];
    
    
    
}
//时间
-(void)setupTimeView
{
    _timeView = [UIView new];
    _timeView.backgroundColor = UIColorFromRGB(0Xefefef);
     [self addSubview:_timeView];
    _timeView.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).rightSpaceToView(self, 0).heightIs(30);
   
       _timeLable = [UILabel new];
    _timeLable.font = [UIFont systemFontOfSize:15];
    _timeLable.textColor = UIColorFromRGB(0x71d4ce);
    [_timeView addSubview:_timeLable];
    _timeLable.sd_layout.leftSpaceToView(_timeView, 15).topSpaceToView(_timeView, 10).widthIs(self.width - 125).heightIs(15);
    
    UIView *sep = [UIView new];
    sep.backgroundColor = UIColorFromRGB(0x71d4ce);
    [self addSubview:sep];
    sep.sd_layout.leftSpaceToView(self,0).rightSpaceToView(self,0).topSpaceToView(_timeView,1).heightIs(1);

}

#pragma mark 头像
- (void)setupHeaderImageView{
    
    _headImageView = [UIImageView new];
    [self addSubview:_headImageView];
    _headImageView.sd_layout.leftSpaceToView(_timeView,20).topSpaceToView(_timeView,15).widthIs(80).heightIs(80);
    
    _photoFrame = [UIImageView new];
    [self addSubview:_photoFrame];
    _photoFrame.sd_layout.leftSpaceToView(self,20).topSpaceToView(_timeView,15).widthIs(80).heightIs(80);
}
#pragma mark 职称
- (void)setupPostView{
    _postLabel = [UILabel new];
    _postLabel.backgroundColor = UIColorFromRGB(0x68c0de);
    _postLabel.numberOfLines = 0;
    _postLabel.textColor = [UIColor whiteColor];
    _postLabel.textAlignment = NSTextAlignmentCenter;
    _postLabel.clipsToBounds = YES;
    _postLabel.font = [UIFont systemFontOfSize:11];
    _postLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:_postLabel];
    _postLabel.sd_layout.leftSpaceToView(self,90).widthIs(15);
    _postLabel.layer.cornerRadius = 7.5f;
}
#pragma mark 姓名
- (void)setupNameView{
    _nameLabel = [UILabel new];
    _nameLabel.textColor = [UIColor blackColor];
    [self addSubview:_nameLabel];
    _nameLabel.sd_layout.leftSpaceToView(_postLabel,15).topSpaceToView(_timeView,25).heightIs(20);
}
#pragma mark 科室
- (void)setupDepartmentView{
    _departmentLabel = [UILabel new];
    _departmentLabel.font = [UIFont systemFontOfSize:15];
    _departmentLabel.textColor = UIColorFromRGB(0x999999);
    [self addSubview:_departmentLabel];
    _departmentLabel.sd_layout.leftSpaceToView(_postLabel,15).topSpaceToView(_nameLabel,10).widthIs(self.width - 125).heightIs(15);
}
#pragma mark 分割线
- (void)setupSep{
    UIView *sep = [UIView new];
    sep.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self addSubview:sep];
    sep.sd_layout.leftSpaceToView(self,0).rightSpaceToView(self,0).topSpaceToView(_headImageView,10).heightIs(1);
    
    UIView *sep1 = [UIView new];
    sep1.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self addSubview:sep1];
    sep1.sd_layout.leftSpaceToView(self,0).rightSpaceToView(self,0).bottomSpaceToView(self, 0).heightIs(1);
    
}
#pragma mark 所患病
-(void)setupIllnessView
{
    _illnessLable = [UILabel new];
    _illnessLable.font = [UIFont systemFontOfSize:16];
    _illnessLable.textColor = UIColorFromRGB(0x999999);
    [self addSubview:_illnessLable];
    _illnessLable.sd_layout.leftSpaceToView(self, 15).topSpaceToView(_headImageView, 25).rightSpaceToView(self,0).heightIs(10);
    
}


- (void)layoutSubviews{
    [super layoutSubviews];
    _headImageView.backgroundColor = [UIColor clearColor];
    _photoFrame.image = [UIImage imageNamed:@"ConsultationAvatarBg"];
    
//    _postLabel.text = @"副主任";
    CGFloat height = [JMFoundation calLabelHeight:[UIFont systemFontOfSize:11] andStr:@"副主任" withWidth:15];
    if (height < 80) {
        height = height + 5;
    }else{
        height = 80;
    }
    _postLabel.height = height;
    _postLabel.centerY = _headImageView.centerY;
    
//    _nameLabel.text = [NSString stringWithFormat:@"姓名：%@",@"单鸿"];
    CGFloat width_name = [self calLabelHeight:[UIFont systemFontOfSize:18] andStr:_nameLabel.text withHeight:25];
    CGFloat max_width = self.width - 115 - 75;
    if (width_name < max_width) {
        width_name = width_name;
    }else{
        width_name = max_width;
    }
    _nameLabel.width = width_name;
    
//    _departmentLabel.text = [NSString stringWithFormat:@"科室：%@",@"科室"];
//    _illnessLable.text = [NSString stringWithFormat:@"所患疾病：%@", @"孩子连续发烧39度两天"];
    
}
-(void)setModel:(BehaviourGuide *)model
{
    _model = model;
    
    _nameLabel.text = [NSString stringWithFormat:@"姓名：%@",model.doctorName];
    _departmentLabel.text = [NSString stringWithFormat:@"科室：%@", model.departName];
    _illnessLable.text = [NSString stringWithFormat:@"所患疾病：%@", model.descriptionDisease];
    _postLabel.text = model.dictionaryName;
    
     [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.userImg]];
    
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970: model.createTime];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/MM/dd/hh:mm"];
    NSString *dateString = [dateFormat stringFromDate:myDate];
    NSLog(@"date: %@", dateString);
    
    _timeLable.text = dateString;
    
}


- (CGFloat)calLabelHeight:(UIFont *)fontSize andStr:(NSString *)str withHeight:(CGFloat)height{
    NSDictionary *attribute = @{NSFontAttributeName: fontSize};
    
    CGSize retSize = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                       options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil].size;
    return retSize.width;
}


@end
