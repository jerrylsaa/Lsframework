//
//  ExpertDPCell.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/12/7.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ExpertDPCell.h"
@interface ExpertDPCell (){
    
    UIView* _contanierView;
    
    UILabel* _titleLabel;
    
    UILabel *_timeLabel;
}

@end
@implementation ExpertDPCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if(self){
        
        _contanierView = [UIView new];
        _contanierView.backgroundColor =[UIColor whiteColor];
        [self.contentView addSubview:_contanierView];
        
        
        _titleLabel = [UILabel new];
        _titleLabel.numberOfLines =0;
        
        [_contanierView addSubview:_titleLabel];
        
        _timeLabel =[UILabel new];
        _timeLabel.textAlignment =NSTextAlignmentRight;
        _timeLabel.font =[UIFont systemFontOfSize:12.0f];
        _timeLabel.textColor =UIColorFromRGB(0x999999);
        [_contanierView addSubview:_timeLabel];
        
        UIImageView *lineIV =[UIImageView new];
        lineIV.backgroundColor =UIColorFromRGB(0x999999);
        [_contanierView addSubview:lineIV];
        
        _contanierView.sd_layout.topSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0);
        
        _titleLabel.sd_layout.topSpaceToView(_contanierView,15).leftSpaceToView(_contanierView,15).rightSpaceToView(_contanierView,15).autoHeightRatio(0);
        _timeLabel.sd_layout.topSpaceToView(_titleLabel,10).rightSpaceToView(_contanierView,15).heightIs(18).widthIs(150);
        lineIV.sd_layout.topSpaceToView(_titleLabel,5).leftSpaceToView(_contanierView,15).rightSpaceToView(_contanierView,15).bottomSpaceToView(_contanierView,0).heightIs(1);
        [_contanierView setupAutoHeightWithBottomViewsArray:@[_titleLabel,_timeLabel] bottomMargin:5];
        [self setupAutoHeightWithBottomView:_contanierView bottomMargin:0];
        
    }
    return self ;
}

- (void)setCellEntity:(ExpertCommentListEntity *)cellEntity{
    _cellEntity =cellEntity;
    
    if (cellEntity.CommentConetent.length!= 0){
        NSString* field = cellEntity.CommentConetent;
        NSMutableAttributedString* attrubutStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@：%@",cellEntity.NickName,field]];
        [attrubutStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x333333) range:NSMakeRange(0, attrubutStr.length)];
        [attrubutStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xff8a80) range:NSMakeRange(0, cellEntity.NickName.length+1)];
        
        [attrubutStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0f] range:NSMakeRange(0, attrubutStr.length)];
        _titleLabel.attributedText = attrubutStr;
    }else{
                _titleLabel.text =@"暂无评价";
    }
    _timeLabel.text =[cellEntity.CommentTime substringToIndex:10];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
