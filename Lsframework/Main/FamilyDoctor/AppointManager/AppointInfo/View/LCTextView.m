//
//  ZHTextView.m
//  TheCentralHospital_Doctor
//
//  Created by lichen on 16/3/14.
//  Copyright © 2016年 中弘科技. All rights reserved.
//

#import "LCTextView.h"

@interface LCTextView (){
    
    
    UILabel* _showTextSizeLabel;
    NSString  *textViewText;
}

@end

@implementation LCTextView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
    }
    return self ;
}

-(instancetype)init{
    self= [super init];
    if(self){
        self.delegate = self;
        self.backgroundColor= [UIColor clearColor];
        self.font= [UIFont systemFontOfSize:15];//默认字体大小
        
        //添加通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
        
        [self setupSubView];
    }
    return self;
}

- (void)setupSubView{
    _placeholderLabel=[UILabel  new];
    _placeholderLabel.backgroundColor=[UIColor clearColor];
    _placeholderLabel.font = self.font;
    [self addSubview:_placeholderLabel];
    
    _showTextSizeLabel=[UILabel  new];
    _showTextSizeLabel.backgroundColor=[UIColor clearColor];
    _showTextSizeLabel.text = @"0/200";
    _showTextSizeLabel.font = self.font;
    _showTextSizeLabel.hidden = YES;
    [self addSubview:_showTextSizeLabel];

    _placeholderLabel.sd_layout.topSpaceToView(self,8).leftSpaceToView(self,5).rightSpaceToView(self,5).autoHeightRatio(0);
    _showTextSizeLabel.sd_layout.bottomSpaceToView(self,5).autoHeightRatio(0).rightSpaceToView(self,5);
    [_showTextSizeLabel setSingleLineAutoResizeWithMaxWidth:150];
}







#pragma mark - 监听通知

/**
 *  监听文本改变通知
 */
- (void)textDidChange{
    _placeholderLabel.hidden=self.hasText;
    
}

#pragma mark - 代理
- (void)textViewDidChange:(UITextView *)textView{
    
    if(self.showTextLength){
        _textLength = textView.text.length;
        _showTextSizeLabel.text = [NSString stringWithFormat:@"%d/%d",textView.text.length,_XTLength];
        [_showTextSizeLabel updateLayout];
    }
    
    
    
    

}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if(self.showTextLength){
        if(textView.text.length > _XTLength){
            //超出60个字了
            if([self isFirstResponder]){
                [self resignFirstResponder];
            }
            
//            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入200个字以内" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alert show];
        }
    }
}


#pragma mark -

-(void)layoutSubviews{
    [super layoutSubviews];
    
}

-(void)setPlaceholder:(NSString *)placeholder{
    _placeholder= placeholder;
    _placeholderLabel.text=placeholder;
    
    [self setNeedsLayout];
    
}

-(void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor=placeholderColor;
    _placeholderLabel.textColor=placeholderColor;
    _showTextSizeLabel.textColor = placeholderColor;
}

-(void)setPlaceholderFont:(UIFont *)placeholderFont{
    _placeholderFont = placeholderFont;
    _placeholderLabel.font = placeholderFont;
    _showTextSizeLabel.font = placeholderFont;
}

-(void)setShowTextLength:(BOOL)showTextLength{
    _showTextLength = showTextLength;
    _showTextSizeLabel.hidden = !showTextLength;
}

-(void)setFont:(UIFont *)font{
    [super setFont:font];
    _placeholderLabel.font=font;
    [self setNeedsLayout];
}

-(void)setText:(NSString *)text{
    [super setText:text];
    [self textDidChange];
}

-(void)setAttributedText:(NSAttributedString *)attributedText{
    [super setAttributedText:attributedText];
    [self textDidChange];
}

-(void)setTextLength:(NSInteger)textLength{
    _textLength = textLength;
    _showTextSizeLabel.text = [NSString stringWithFormat:@"%ld/200",textLength];;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range  replacementText:(NSString *)text{
    
    NSUInteger proposedNewLength = textView.text.length - range.length + text.length;
    if (proposedNewLength > _XTLength) {
                NSString *substring = [text substringToIndex:_XTLength - (textView.text.length - range.length)];
                NSMutableString *lastString = [textView.text mutableCopy];
                [lastString replaceCharactersInRange:range withString:substring];
                textView.text = [lastString copy];
            if(self.showTextLength){
                _textLength = textView.text.length;
                _showTextSizeLabel.text = [NSString stringWithFormat:@"%d/%d",textView.text.length,_XTLength];
                [_showTextSizeLabel updateLayout];
            }

        if([textView isFirstResponder]){
            [textView resignFirstResponder];
        }
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString  stringWithFormat:@"请输入%d个字以内问题",_XTLength] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return NO;//限制长度
    }
    return YES;
    
    
}

#pragma mark - 销毁通知

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}



@end
