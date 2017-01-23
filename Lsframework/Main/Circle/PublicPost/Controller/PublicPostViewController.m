//
//  PublicPostViewController.m
//  FamilyPlatForm
//
//  Created by lichen on 16/9/23.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "PublicPostViewController.h"
#import "PublicPostTextView.h"
#import "UIImage+Category.h"
#import "DefaultCollectionViewCell.h"
#import "PhotoCollectionViewCell.h"
#import "CorePhotoPickerVCManager.h"
#import "PublicPostPresenter.h"
#import "EmotionTextAttachment.h"

#import "HelfPriceCell.h"
#import "SFPhotoBrowser.h"

#define kToolBarHeight 48
#define kKeyboardHeight (264 - 40)

#define EMOJI_CODE_TO_SYMBOL(x) ((((0x808080F0 | (x & 0x3F000) >> 4) | (x & 0xFC0) << 10) | (x & 0x1C0000) << 18) | (x & 0x3F) << 24)


#define kScrollViewHeight (270/2.0)

#define kRow 3
#define kColumn 6

#define   kImageXspace     20
#define   kImageTopspace     7.5
#define   kImageWidth   (kScreenWidth-15*2-3*kImageXspace)/4

@interface PublicPostViewController ()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,PhotoCollectionViewCellDelegate,PublicPostPresenterDelegate,HelfDelegate,PhotoBrowerDelegate,UIImagePickerControllerDelegate>{
    BOOL convertToSystemKeyboard;
    BOOL titleConvertToSystemboard;
    BOOL isEmotion;//自定义表情
}

@property(nullable,nonatomic,retain) UIScrollView* scroll;
@property(nullable,nonatomic,retain) UITextField* titleTf;
@property(nullable,nonatomic,retain)PublicPostTextView* textView ;
@property(nullable,nonatomic,retain) UIView* toolBar;
@property(nullable,nonatomic,retain) UIButton* addButton;//添加按钮
@property(nullable,nonatomic,retain) UIButton* faceButton;//表情按钮
@property(nullable,nonatomic,retain) UIView* addInputView;
@property(nullable,nonatomic,retain) UIView* faceInputView;
@property(nullable,nonatomic,retain) UIScrollView* faceScrollView;
@property(nullable,nonatomic,retain) UIPageControl* pageControl;

@property(nullable,nonatomic,retain) NSMutableArray* defaultEmotionArray;//默认表情数组

@property(nullable,nonatomic,retain) UICollectionView* collect;
@property(nullable,nonatomic,retain) NSMutableArray* collectDataSource;
@property(nullable,nonatomic,retain) UILabel* photoNumLabel;

@property(nullable,nonatomic,retain) PublicPostPresenter* presenter;

@property(nullable,nonatomic,retain) UIView* titleToolbarView;
@property(nullable,nonatomic,retain) UIButton* titleEmotionbt;
@property(nullable,nonatomic,retain) PublicPostTextView* titleTextView;

@end

@implementation PublicPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initRightBarWithTitle:@"发布"];
    
    //监听键盘frame值改变
    [kdefaultCenter addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if(self.textView.inputView){
        self.textView.inputView = nil;
        [self.textView reloadInputViews];
    }
}

#pragma mark - 加载子视图
-(void)setupView{
    self.title = @"发布帖子";
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    
    UIScrollView* scroll = [UIScrollView new];
    scroll.showsVerticalScrollIndicator = NO;
    self.scroll = scroll;
    [self.view addSubview:scroll];
    
//    UITextField* titletf = [UITextField new];
//    titletf.placeholder = @"添加小标题";
//    titletf.font = [UIFont systemFontOfSize:bigFont];
//    self.titleTf = titletf;
//    [scroll addSubview:titletf];
//    titletf.inputAccessoryView = self.titleToolbarView;
    
    PublicPostTextView* titleTextView = [PublicPostTextView new];
    titleTextView.scrollEnabled = NO;
    titleTextView.placeholder = @"添加小标题";
    titleTextView.font = [UIFont systemFontOfSize:bigFont];
    titleTextView.placeholderColor = UIColorFromRGB(0xcccccc);
    titleTextView.placeholderFont = [UIFont systemFontOfSize:bigFont];
    titleTextView.inputAccessoryView = self.titleToolbarView;
    [scroll addSubview:titleTextView];
    self.titleTextView = titleTextView;

    
    
    PublicPostTextView* textView = [PublicPostTextView new];
    textView.placeholder = @"添加帖子内容";
//    textView.textColor = UIColorFromRGB(0xcccccc);
    textView.font = [UIFont systemFontOfSize:bigFont];
    textView.placeholderColor = UIColorFromRGB(0xcccccc);
    textView.placeholderFont = [UIFont systemFontOfSize:bigFont];
    textView.layer.borderWidth = 1;
    textView.layer.borderColor = UIColorFromRGB(0xf2f2f2).CGColor;
    
    textView.inputAccessoryView = self.toolBar;
    [scroll addSubview:textView];
    self.textView = textView;
    
    scroll.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    titleTextView.sd_layout.topSpaceToView(scroll,10).leftSpaceToView(scroll,10).rightSpaceToView(scroll,5).heightIs(40);
    
    textView.sd_layout.topSpaceToView(titleTextView,10).leftSpaceToView(scroll,5).rightSpaceToView(scroll,5).heightIs(125);
    
    [self setupToolBarView];
    [self setupCollectionView];
    [self setupPhotoNumLabel];
}

- (void)setupToolBarView{
    UIButton* addbt = [UIButton new];
    [addbt setBackgroundImage:[UIImage imageNamed:@"circle_add_nor"] forState:UIControlStateNormal];
    [addbt setBackgroundImage:[UIImage imageNamed:@"circle_add_heigh"] forState:UIControlStateHighlighted];
    [addbt setBackgroundImage:[UIImage imageNamed:@"circle_add_sel"] forState:UIControlStateSelected];
    addbt.tag = 101;
    [addbt addTarget:self action:@selector(clickToolBar:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolBar addSubview:addbt];
    self.addButton = addbt;

    UIButton* facebt = [UIButton new];
    [facebt setBackgroundImage:[UIImage imageNamed:@"circle_face_nor"] forState:UIControlStateNormal];
    [facebt setBackgroundImage:[UIImage imageNamed:@"circle_face_heigh"] forState:UIControlStateHighlighted];
//    [facebt setBackgroundImage:[UIImage imageNamed:@"circle_add_sel"] forState:UIControlStateSelected];
    facebt.tag = 102;
    [facebt addTarget:self action:@selector(clickToolBar:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolBar addSubview:facebt];
    self.faceButton = facebt;
    
    //添加约束
    addbt.sd_layout.topSpaceToView(self.toolBar,10).leftSpaceToView(self.toolBar,5).widthIs(55/2.0).heightEqualToWidth();
    facebt.sd_layout.topEqualToView(addbt).leftSpaceToView(addbt,5).widthRatioToView(addbt,1).heightEqualToWidth();
}
#pragma mark -- 图片布局--collectionview
- (void)setupCollectionView{
    
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [layout setMinimumLineSpacing:0];
    [layout setMinimumInteritemSpacing:20];
    layout.itemSize = CGSizeMake(kImageWidth, kImageWidth);
    
    UICollectionView* collect = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collect.delegate = self;
    collect.dataSource = self;
    collect.scrollEnabled = NO;
    self.collect = collect;
    collect.backgroundColor = [UIColor whiteColor];
    [self.scroll addSubview:collect];
    [collect registerClass:[DefaultCollectionViewCell class] forCellWithReuseIdentifier:@"defaultCell"];
    [collect registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"photoCell"];

    [collect registerClass:[HelfPriceCell class] forCellWithReuseIdentifier:@"cell_helf"];
    
    CGFloat topSpace = 15;
    
    if (self.collectDataSource.count< 4) {
      
        collect.sd_layout.topSpaceToView(self.textView,topSpace).leftSpaceToView(self.scroll,15).rightSpaceToView(self.scroll,15).heightIs(kImageWidth + 16);
    }else{
        
        collect.sd_layout.topSpaceToView(self.textView,topSpace).leftSpaceToView(self.scroll,15).rightSpaceToView(self.scroll,15).heightIs(kImageWidth*2+kImageTopspace + 16);
    }
    
    
//    collect.backgroundColor = [UIColor redColor];
}

- (void)setupPhotoNumLabel{
    UILabel* photoNum = [UILabel new];
    photoNum.textColor = UIColorFromRGB(0x767676);
    photoNum.font = [UIFont systemFontOfSize:smidFont];
    photoNum.textAlignment = NSTextAlignmentRight;
    self.photoNumLabel = photoNum;
    [self.scroll addSubview:photoNum];
    
    photoNum.sd_layout.topSpaceToView(self.collect,45).rightSpaceToView(self.scroll,15).widthIs(100).heightIs(20);
    
    [self.scroll setupAutoContentSizeWithBottomView:photoNum bottomMargin:50];
    
}

#pragma mark - 点击事件
#pragma mark * 发帖子
-(void)rightItemAction:(id)sender{
    
    if([self.titleTextView.text trimming].length == 0){
        [ProgressUtil showInfo:@"请输入标题"];
        return ;
    }
    
    //
    if([self.textView.text trimming].length == 0){
        [ProgressUtil showInfo:@"请输入内容"];
        return ;
    }
    
    if([self.textView isFirstResponder]){
        [self.textView resignFirstResponder];
    }
    if([self.titleTextView isFirstResponder]){
        [self.titleTextView resignFirstResponder];
    }

    
    //标题
    NSMutableString* titleMutableStr  = [NSMutableString string];
    [self.titleTextView.attributedText enumerateAttributesInRange:NSMakeRange(0, self.titleTextView.attributedText.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        EmotionTextAttachment* attach = attrs[@"NSAttachment"];
        if(attach){
            //表情
            [titleMutableStr appendString:attach.emotionTag];
        }else{
            //拼接文本
            NSAttributedString* temp = [self.titleTextView.attributedText attributedSubstringFromRange:range];
            [titleMutableStr appendString:temp.string];
        }
    }];

    
    //内容
    NSMutableString* mutableStr  = [NSMutableString string];
    [self.textView.attributedText enumerateAttributesInRange:NSMakeRange(0, self.textView.attributedText.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        EmotionTextAttachment* attach = attrs[@"NSAttachment"];
        if(attach){
            //表情
            [mutableStr appendString:attach.emotionTag];
        }else{
            //拼接文本
            NSAttributedString* temp = [self.textView.attributedText attributedSubstringFromRange:range];
            [mutableStr appendString:temp.string];
        }
    }];
    
    NSString* titleText = titleMutableStr;
    NSString* consultation = mutableStr;
    NSLog(@"%@",consultation);

    
    //上传图片
    if(self.collectDataSource.count == 0){
        //没选照片，直接走发布接口
        [ProgressUtil show];
        [self.presenter commitConsultation:@"" title:titleText consultation:consultation];
    }else{
        [ProgressUtil showWithStatus:@"正在上传照片..."];
        [self.presenter publicPost:self.collectDataSource title:titleText consultation:consultation];
    }
    
}

#pragma mark * 点击键盘上的toolbar
- (void)clickToolBar:(UIButton*) bt{
    
    if([self.titleTextView isFirstResponder]){
       //标题
        if(self.titleTextView.inputView)self.titleTextView.inputView = nil;
        
        if(titleConvertToSystemboard){
            titleConvertToSystemboard = NO;
            [self.titleEmotionbt setBackgroundImage:[UIImage imageNamed:@"circle_face_nor"] forState:UIControlStateNormal];
            [self.titleEmotionbt setBackgroundImage:[UIImage imageNamed:@"circle_face_heigh"] forState:UIControlStateHighlighted];
            
        }else{
            titleConvertToSystemboard = YES;
            [self.titleEmotionbt setBackgroundImage:[UIImage imageNamed:@"circle_board_nor"] forState:UIControlStateNormal];
            [self.titleEmotionbt setBackgroundImage:[UIImage imageNamed:@"circle_board_heigh"] forState:UIControlStateHighlighted];
            self.faceInputView = nil;
            self.titleTextView.inputView = self.faceInputView;
            
        }
        
        [self.titleTextView reloadInputViews];

    }else{
        //内容
        
        
        
        if(self.textView.inputView)self.textView.inputView = nil;
        
        if(bt.tag == 101){
            NSLog(@"点击添加");
            bt.selected = YES;
            self.addInputView = nil;
            self.textView.inputView = self.addInputView;
            
            
        }else if(bt.tag == 102){
            NSLog(@"点击表情");
            self.addButton.selected = NO;
            
            if(convertToSystemKeyboard){
                convertToSystemKeyboard = NO;
                [self.faceButton setBackgroundImage:[UIImage imageNamed:@"circle_face_nor"] forState:UIControlStateNormal];
                [self.faceButton setBackgroundImage:[UIImage imageNamed:@"circle_face_heigh"] forState:UIControlStateHighlighted];
                
            }else{
                convertToSystemKeyboard = YES;
                [self.faceButton setBackgroundImage:[UIImage imageNamed:@"circle_board_nor"] forState:UIControlStateNormal];
                [self.faceButton setBackgroundImage:[UIImage imageNamed:@"circle_board_heigh"] forState:UIControlStateHighlighted];
                self.faceInputView = nil;
                self.textView.inputView = self.faceInputView;
                
            }
        }
        
        [self.textView reloadInputViews];

    }
    
}

//点击自定义键盘上照相按钮
- (void)clickInputViewCameraAction{
    [self.textView resignFirstResponder];
    self.addButton.selected = NO;
    
//    CorePhotoPickerVCManager *manager=[CorePhotoPickerVCManager new];
//    //设置类型
//    manager.pickerVCManagerType = CorePhotoPickerVCMangerTypeCamera;
//    
//    //错误处理
//    if(manager.unavailableType!=CorePhotoPickerUnavailableTypeNone){
//        NSLog(@"设备不可用");
//        return;
//    }
//    
//    UIViewController *pickerVC=manager.imagePickerController;
//    WS(ws);
//    //选取结束
//    manager.finishPickingMedia=^(NSArray *medias){
//        
//        if(medias.count != 0){
//            [ws.collectDataSource removeLastObject];
//        }
//        
//        for (CorePhoto *photo in medias) {
//            [ws.collectDataSource addObject:photo.editedImage];
//        }
//        
//        if(ws.collectDataSource.count >= 1 && ws.collectDataSource.count <= 3){
//            [ws.collectDataSource addObject:[UIImage imageNamed:@"circle_add_icon"]];
//        }
//        
//        ws.photoNumLabel.hidden = ws.collectDataSource.count == 1;
//        if(ws.collectDataSource.count != 1){
//            ws.photoNumLabel.text = [NSString stringWithFormat:@"%ld/3",ws.collectDataSource.count -1];
//        }
//
//        
//        [ws.collect reloadData];
//    };
//    [self presentViewController:pickerVC animated:YES completion:nil];
    
    [self takePhoto];
    
    
}

//
#pragma mark * 删除emojy表情
- (void)deleteFaceAction{
//    NSRange range = self.textView.selectedRange;
//    if(range.location >= 2){
//        NSString* subString = [self.textView.text substringWithRange:NSMakeRange(range.location -2 , 2)];
//        BOOL isEmotion = NO;
//        for(NSString* emotion in self.defaultEmotionArray){
//            if([subString isEqualToString:emotion]){
//                isEmotion = YES;
//                break;
//            }
//        }
//        
//        NSMutableString* mutable = [NSMutableString stringWithString:self.textView.text];
//        if(isEmotion){
//            //是表情
//            [mutable deleteCharactersInRange:[self.textView.text rangeOfString:subString]];
//        }else{
//            //不是表情
//            [mutable deleteCharactersInRange:NSMakeRange(self.textView.text.length - 1, 1)];
//        }
//        self.textView.text = mutable;
//    }else{
//        NSMutableString* mutable = [NSMutableString stringWithString:self.textView.text];
//        [mutable deleteCharactersInRange:NSMakeRange(self.textView.text.length - 1, 1)];
//        self.textView.text = mutable;
//    }
    
    if([self.titleTextView isFirstResponder]){
        [self.titleTextView deleteBackward];
    }else{
        [self.textView deleteBackward];
    }
    
}

//
#pragma mark * 点击emojy表情
- (void)clickEmotionAction:(UIButton*) emotionbt{
    NSInteger index = emotionbt.tag - 200;
    NSDictionary* emotionDic = self.defaultEmotionArray[index];
    
//    NSString* emotion = self.defaultEmotionArray[index];
//    
//    if(!self.textView.text || self.textView.text.length == 0){
//        self.textView.text = emotion;
//    }else{
//        NSMutableString* mutableStr = [NSMutableString stringWithString:self.textView.text];
//        [mutableStr appendString:emotion];
//        
//        self.textView.text = mutableStr;
//    }
    
    if([self.titleTextView isFirstResponder]){
        //标题
        //获取之前写的文本
        NSAttributedString* str = self.titleTextView.attributedText;
        //将之前的文本包含进去
        NSMutableAttributedString* mutableStr = [[NSMutableAttributedString alloc] initWithAttributedString:str];
        //记录当前光标的位置
        NSInteger currentPosition;
        EmotionTextAttachment* attach = [EmotionTextAttachment new];
        attach.bounds = CGRectMake(0, -2.5, self.titleTextView.font.lineHeight - 5, self.titleTextView.font.lineHeight - 5);
        attach.image = [UIImage imageNamed:[emotionDic valueForKey:@"png"]];
        attach.emotionTag = [emotionDic valueForKey:@"tag"];
        NSAttributedString* attr = [NSAttributedString attributedStringWithAttachment:attach];
        //保存一下当前光标位置
        currentPosition = self.titleTextView.selectedRange.location;
        [mutableStr insertAttributedString:attr atIndex:currentPosition];
        
        //重写给文本框赋值
        [mutableStr addAttribute:NSFontAttributeName value:self.titleTextView.font range:NSMakeRange(0, mutableStr.length)];
        self.titleTextView.attributedText = mutableStr;
        self.titleTextView.selectedRange = NSMakeRange(currentPosition + 1, 0);

    }else{
        //获取之前写的文本
        NSAttributedString* str = self.textView.attributedText;
        //将之前的文本包含进去
        NSMutableAttributedString* mutableStr = [[NSMutableAttributedString alloc] initWithAttributedString:str];
        //记录当前光标的位置
        NSInteger currentPosition;
        EmotionTextAttachment* attach = [EmotionTextAttachment new];
        attach.bounds = CGRectMake(0, -2.5, self.textView.font.lineHeight - 5, self.textView.font.lineHeight - 5);
        attach.image = [UIImage imageNamed:[emotionDic valueForKey:@"png"]];
        attach.emotionTag = [emotionDic valueForKey:@"tag"];
        NSAttributedString* attr = [NSAttributedString attributedStringWithAttachment:attach];
        //保存一下当前光标位置
        currentPosition = self.textView.selectedRange.location;
        [mutableStr insertAttributedString:attr atIndex:currentPosition];
        
        //重写给文本框赋值
        [mutableStr addAttribute:NSFontAttributeName value:self.textView.font range:NSMakeRange(0, mutableStr.length)];
        self.textView.attributedText = mutableStr;
        self.textView.selectedRange = NSMakeRange(currentPosition + 1, 0);

    }
    

}

#pragma mark * 切换表情
- (void)convertEmotionAction:(UIButton*) bt{
    UIButton* emojyButton = (UIButton*)[self.faceInputView viewWithTag:301];
    UIButton* emotionButton = (UIButton*)[self.faceInputView viewWithTag:302];
    
    if([self.titleTextView isFirstResponder]){
        if(self.titleTextView.inputView){
            self.titleTextView.inputView = nil;
            self.faceInputView = nil;
        }
        [self.defaultEmotionArray removeAllObjects];
        self.defaultEmotionArray = nil;
        
        if([bt isEqual:emojyButton]){
            //emojy表情
            isEmotion = NO;
            
        }else if([bt isEqual:emotionButton]){
            //自定义表情
            isEmotion = YES;
            
        }
        self.titleTextView.inputView = self.faceInputView;
        [self.titleTextView reloadInputViews];

    }else{
        if(self.textView.inputView){
            self.textView.inputView = nil;
            self.faceInputView = nil;
        }
        [self.defaultEmotionArray removeAllObjects];
        self.defaultEmotionArray = nil;
        
        if([bt isEqual:emojyButton]){
            //emojy表情
            isEmotion = NO;
            
        }else if([bt isEqual:emotionButton]){
            //自定义表情
            isEmotion = YES;
            
        }
        self.textView.inputView = self.faceInputView;
        [self.textView reloadInputViews];

    }
    
}


#pragma mark - 监听键盘通知
- (void)keyboardWillChangeFrame:(NSNotification*) notification{
//    NSDictionary* userInfo = notification.userInfo;
//    
//     键盘显示\隐藏完毕的frame
//    CGRect frame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
//    NSLog(@"%@---%g",NSStringFromCGRect(frame),duration);
}

#pragma mark - 懒加载
-(UIView *)toolBar{
    if(!_toolBar){
        _toolBar = [UIView new];
        _toolBar.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
//        _toolBar.backgroundColor = UIColorFromRGB(0xf2f2f2);
        _toolBar.height = kToolBarHeight;
        
        
    }
    return _toolBar;
}

#pragma mark * 标题toolbar
-(UIView *)titleToolbarView{
    if(!_titleToolbarView){
        _titleToolbarView = [UIView new];
        _titleToolbarView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
//        _titleToolbarView.backgroundColor = UIColorFromRGB(0xf2f2f2);
        _titleToolbarView.height = kToolBarHeight;
        
        //
        UIButton* addbt = [UIButton new];
        [addbt setBackgroundImage:[UIImage imageNamed:@"circle_add_nor"] forState:UIControlStateNormal];
        [addbt setBackgroundImage:[UIImage imageNamed:@"circle_add_heigh"] forState:UIControlStateHighlighted];
        [addbt setBackgroundImage:[UIImage imageNamed:@"circle_add_sel"] forState:UIControlStateSelected];
        addbt.tag = 201;
        [addbt addTarget:self action:@selector(clickToolBar:) forControlEvents:UIControlEventTouchUpInside];
        [_titleToolbarView addSubview:addbt];
        addbt.enabled = NO;
//        self.addButton = addbt;
        
        UIButton* facebt = [UIButton new];
        [facebt setBackgroundImage:[UIImage imageNamed:@"circle_face_nor"] forState:UIControlStateNormal];
        [facebt setBackgroundImage:[UIImage imageNamed:@"circle_face_heigh"] forState:UIControlStateHighlighted];
        //    [facebt setBackgroundImage:[UIImage imageNamed:@"circle_add_sel"] forState:UIControlStateSelected];
        facebt.tag = 202;
        [facebt addTarget:self action:@selector(clickToolBar:) forControlEvents:UIControlEventTouchUpInside];
        [_titleToolbarView addSubview:facebt];
        self.titleEmotionbt = facebt;
        
        //添加约束
        addbt.sd_layout.topSpaceToView(_titleToolbarView,10).leftSpaceToView(_titleToolbarView,5).widthIs(55/2.0).heightEqualToWidth();
        facebt.sd_layout.topEqualToView(addbt).leftSpaceToView(addbt,5).widthRatioToView(addbt,1).heightEqualToWidth();
        
        
    }
    return _titleToolbarView;
}

-(UIView *)addInputView{
    if(!_addInputView){
        _addInputView = [UIView new];
        _addInputView.height = kKeyboardHeight;
        _addInputView.backgroundColor = RGB(250, 250, 250);
        
        UIButton* camera = [UIButton new];
        [camera setBackgroundImage:[UIImage imageNamed:@"circle_camerra_icon"] forState:UIControlStateNormal];
        [camera addTarget:self action:@selector(clickInputViewCameraAction) forControlEvents:UIControlEventTouchUpInside];
        [_addInputView addSubview:camera];
        
        UILabel* title = [UILabel new];
        title.textAlignment = NSTextAlignmentCenter;
        title.text = @"拍摄";
        title.textColor = UIColorFromRGB(0x767676);
        title.font = [UIFont systemFontOfSize:midFont];
        [_addInputView addSubview:title];
        
        camera.sd_layout.topSpaceToView(_addInputView,20).leftSpaceToView(_addInputView,20).widthIs(60).heightEqualToWidth();
        title.sd_layout.topSpaceToView(camera,10).leftEqualToView(camera).rightEqualToView(camera).heightIs(20);
    }
    return _addInputView;
}

-(UIView *)faceInputView{
    if(!_faceInputView){
        _faceInputView = [UIView new];
        _faceInputView.height = kKeyboardHeight;
        _faceInputView.backgroundColor = UIColorFromRGB(0xffffff);
        
        UIScrollView* faceScrollView = [UIScrollView new];
        faceScrollView.showsHorizontalScrollIndicator = NO;
        faceScrollView.pagingEnabled = YES;
        faceScrollView.delegate = self;
        faceScrollView.backgroundColor = UIColorFromRGB(0xfafafa);
        self.faceScrollView = faceScrollView;
        [_faceInputView addSubview:faceScrollView];
        
        UIPageControl* pageControl = [UIPageControl new];
        pageControl.pageIndicatorTintColor = RGB(232, 208, 217);
        pageControl.currentPageIndicatorTintColor = RGB(248, 187, 208);
        self.pageControl = pageControl;
        [_faceInputView addSubview:pageControl];
        
        UIButton* deleteButton = [UIButton new];
        [deleteButton setBackgroundImage:[UIImage imageNamed:@"circle_face_delete"] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteFaceAction) forControlEvents:UIControlEventTouchUpInside];
        [_faceInputView addSubview:deleteButton];
        
        //
        UIButton* emojybt = [UIButton new];
        [emojybt setImage:[UIImage imageNamed:@"Hotemoij_default"] forState:UIControlStateNormal];
        emojybt.tag = 301;
        [emojybt addTarget:self action:@selector(convertEmotionAction:) forControlEvents:UIControlEventTouchUpInside];
        [_faceInputView addSubview:emojybt];
        
        UIButton* emotionbt = [UIButton new];
        [emotionbt setImage:[UIImage imageNamed:@"Hotemoij_selec"] forState:UIControlStateNormal];
        emotionbt.tag = 302;
        [emotionbt addTarget:self action:@selector(convertEmotionAction:) forControlEvents:UIControlEventTouchUpInside];
        [_faceInputView addSubview:emotionbt];
        
        if(isEmotion){
            emotionbt.backgroundColor = UIColorFromRGB(0xf2f2f2);
            emojybt.backgroundColor = UIColorFromRGB(0xffffff);
        }else{
            emojybt.backgroundColor = UIColorFromRGB(0xf2f2f2);
            emotionbt.backgroundColor = UIColorFromRGB(0xffffff);
        }

        
        CGFloat width = 33;
        CGFloat height = 33;
        CGFloat horizontalMargin = (kScreenWidth - kColumn * width) / (kColumn + 1);
        CGFloat verticalMargin = (kScrollViewHeight - kRow * height) / (kRow + 1);
        
        NSInteger pageTotal = (kColumn * kRow);//当前页表情总个数
        
        NSInteger page = self.defaultEmotionArray.count / pageTotal;
        if(self.defaultEmotionArray.count % pageTotal ){
            page ++ ;
        }
        NSLog(@"====%ld",self.defaultEmotionArray.count);
        faceScrollView.contentSize = CGSizeMake(kScreenWidth * page, kScrollViewHeight);
        pageControl.numberOfPages = page;
        
        NSInteger currentPage = 0;
        for(int i = 0; i < self.defaultEmotionArray.count; i++){
            if(i % pageTotal == 0 ){
                //整数
                currentPage = i / pageTotal;
            }
            NSInteger j = (i - currentPage * pageTotal);
            CGFloat x = currentPage * kScreenWidth + horizontalMargin + (width + horizontalMargin) * (j % kColumn);
            
//            NSLog(@"---%g",x);
            
            CGFloat y = verticalMargin + (height + verticalMargin) * (j / kColumn);
//            NSLog(@"---%ld",self.defaultEmotionArray.count);
            UIButton* emotion = [UIButton new];
            emotion.frame = CGRectMake(x, y, width, height);
//            emotion.backgroundColor = [UIColor redColor];
            NSDictionary* emotionDic = [self.defaultEmotionArray objectAtIndex:i];
            [emotion setBackgroundImage:[UIImage imageNamed:[emotionDic valueForKey:@"png"]] forState:UIControlStateNormal];

            emotion.tag = 200 + i;
            [emotion addTarget:self action:@selector(clickEmotionAction:) forControlEvents:UIControlEventTouchUpInside];
            [faceScrollView addSubview:emotion];
        }
        
        
        
        faceScrollView.sd_layout.topSpaceToView(_faceInputView,0).leftSpaceToView(_faceInputView,0).rightSpaceToView(_faceInputView,0).heightIs(kScrollViewHeight);
        pageControl.sd_layout.topSpaceToView(faceScrollView,20).leftSpaceToView(_faceInputView,0).rightSpaceToView(_faceInputView,0).heightIs(8);
        deleteButton.sd_layout.rightSpaceToView(_faceInputView,0).bottomSpaceToView(_faceInputView,0).widthIs(104/2.0).heightIs(103/2.0);
        emojybt.sd_layout.leftSpaceToView(_faceInputView,0).bottomSpaceToView(_faceInputView,0).widthRatioToView(deleteButton,1).heightRatioToView(deleteButton,1);
        emotionbt.sd_layout.leftSpaceToView(emojybt,0).bottomSpaceToView(_faceInputView,0).widthRatioToView(deleteButton,1).heightRatioToView(deleteButton,1);

    }
    return _faceInputView;
}

-(NSMutableArray *)defaultEmotionArray{
    if(!_defaultEmotionArray){
        NSString* emotionPath = [[NSBundle mainBundle] pathForResource:@"EmotionPlist" ofType:@"plist"];
        
        _defaultEmotionArray = [NSMutableArray arrayWithContentsOfFile:emotionPath];
        NSMutableArray* tempArray = [NSMutableArray array];
        if(isEmotion){
            //移除emojy表情
            for(NSDictionary* dic in _defaultEmotionArray){
                if(![dic valueForKey:@"isEmotion"]){
                    [tempArray addObject:dic];
                }
            }

        }else{
            //移除自定义表情
            for(NSDictionary* dic in _defaultEmotionArray){
                if([dic valueForKey:@"isEmotion"]){
                    [tempArray addObject:dic];
                }
            }

        }
        
        [_defaultEmotionArray removeObjectsInArray:tempArray];

        
        
//        NSMutableArray *array = [NSMutableArray new];
//        for (int i=0x1F600; i<=0x1F64F; i++) {
//            if (i < 0x1F641 || i > 0x1F644) {
//                int sym = EMOJI_CODE_TO_SYMBOL(i);
//                NSString *emoT = [[NSString alloc] initWithBytes:&sym length:sizeof(sym) encoding:NSUTF8StringEncoding];
//                [array addObject:emoT];
//            }
//        }
//        _defaultEmotionArray = array;
    }
    return _defaultEmotionArray;
}

-(NSMutableArray *)collectDataSource{
    if(!_collectDataSource){
        _collectDataSource=[NSMutableArray array];
//        [_collectDataSource addObject:[UIImage imageNamed:@"circle_add_pic"]];
    }
    return _collectDataSource;
}
-(PublicPostPresenter *)presenter{
    if(!_presenter){
        _presenter = [PublicPostPresenter new];
        _presenter.delegate = self;
    }
    return _presenter;
}

#pragma mark - 代理

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    
    if (_collectDataSource.count == 0) {
        return 1;
    }else if (_collectDataSource.count == 6){
        return _collectDataSource.count;
    }else{
        return _collectDataSource.count + 1;
    }

}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    DefaultCollectionViewCell* defaultCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"defaultCell" forIndexPath:indexPath];
//    PhotoCollectionViewCell* photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
//    
//    if(!photoCell.delegate){
//        photoCell.delegate = self;
//    }
    
//    if(self.collectDataSource.count == 1){
//        //默认照片
//        defaultCell.defaultImageView.image = self.collectDataSource[indexPath.item];
//        return defaultCell;
//    }else{
//        // >= 2
//        if(indexPath.item == self.collectDataSource.count -1){
//            
//            NSLog(@"当前行数 %d 数组数量 %d",indexPath.item,_collectDataSource.count);
//            
//            defaultCell.defaultImageView.image = self.collectDataSource[indexPath.item];
//            return defaultCell;
//        }else{
//            photoCell.photoImageView.image = self.collectDataSource[indexPath.item];
//            return photoCell;
//        }
//    }
   
    HelfPriceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell_helf" forIndexPath:indexPath];
    if (_collectDataSource.count == 0) {
        cell.image = [UIImage imageNamed:@"circle_add_pic"];
        cell.isDelete = NO;
    }else if(_collectDataSource.count == 6){
        cell.image = _collectDataSource[indexPath.row];
        cell.isDelete = YES;
    }else{
        
        if (indexPath.row == _collectDataSource.count) {
            cell.image = [UIImage imageNamed:@"circle_add_sel"];
            cell.isDelete = NO;
        }else{
            cell.image = _collectDataSource[indexPath.row];
            cell.isDelete = YES;
        }
    }
    cell.sd_indexPath = indexPath;
    cell.delegate = self;
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    [self.textView resignFirstResponder];
    if(self.faceInputView){
        convertToSystemKeyboard = NO;
        [self.faceButton setBackgroundImage:[UIImage imageNamed:@"circle_face_nor"] forState:UIControlStateNormal];
        [self.faceButton setBackgroundImage:[UIImage imageNamed:@"circle_face_heigh"] forState:UIControlStateHighlighted];
    }
    
    if(self.addInputView){
        self.addButton.selected = NO;
    }
    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (_collectDataSource.count == 6) {
        [SFPhotoBrowser showImageInView:window selectImageIndex:indexPath.row delegate:self];
    }else if (_collectDataSource.count == 5){
        if (indexPath.row < 5) {
            [SFPhotoBrowser showImageInView:window selectImageIndex:indexPath.row delegate:self];
        }else{
            [self pickPhoto];
        }
        
    }else if (_collectDataSource.count == 4){
        if (indexPath.row < 4) {
            [SFPhotoBrowser showImageInView:window selectImageIndex:indexPath.row delegate:self];
        }else{
            [self pickPhoto];
        }
        
    }else if (_collectDataSource.count == 3){
        if (indexPath.row < 3) {
            [SFPhotoBrowser showImageInView:window selectImageIndex:indexPath.row delegate:self];
        }else{
            [self pickPhoto];
        }
        
    }else if (_collectDataSource.count == 2){
        if (indexPath.row < 2) {
            [SFPhotoBrowser showImageInView:window selectImageIndex:indexPath.row delegate:self];
        }else{
            [self pickPhoto];
        }
    }else if (_collectDataSource.count == 1){
        if (indexPath.row < 1) {
            [SFPhotoBrowser showImageInView:window selectImageIndex:indexPath.row delegate:self];
        }else{
            [self pickPhoto];
        }
    }else if (_collectDataSource.count == 0){
        [self pickPhoto];
    }
    
    
    CGFloat topSpace = 15;
    if (self.collectDataSource.count<4) {
        
        self.collect.sd_layout.topSpaceToView(self.textView,topSpace).leftSpaceToView(self.scroll,15).rightSpaceToView(self.scroll,15).heightIs(kImageWidth + 16);
    }else{
        
        self.collect.sd_layout.topSpaceToView(self.textView,topSpace).leftSpaceToView(self.scroll,15).rightSpaceToView(self.scroll,15).heightIs(kImageWidth*2+kImageTopspace + 16);
    }
    
    [self.collect reloadData];
    
    [_scroll updateLayout];
    [_scroll layoutSubviews];
    

    
}
- (void)deleteImageAtIndexPath:(NSIndexPath *)indexPath{
    [_collectDataSource removeObjectAtIndex:indexPath.row];
    [self reloadData];
    CGFloat topSpace = 15;
    if (self.collectDataSource.count<4) {
        
        self.collect.sd_layout.topSpaceToView(self.textView,topSpace).leftSpaceToView(self.scroll,15).rightSpaceToView(self.scroll,15).heightIs(kImageWidth + 16);
    }else{
        
        self.collect.sd_layout.topSpaceToView(self.textView,topSpace).leftSpaceToView(self.scroll,15).rightSpaceToView(self.scroll,15).heightIs(kImageWidth*2+kImageTopspace + 16);
    }
    self.photoNumLabel.hidden = self.collectDataSource.count == 0;
    if(self.collectDataSource.count != 0){
        self.photoNumLabel.text = [NSString stringWithFormat:@"%u/6",self.collectDataSource.count];
    }

    
    NSLog(@"删除第%ld张图片后刷新",(long)indexPath.row);
}
#pragma mark private
- (void)reloadData{
    [self.collect reloadData];
    if (_collectDataSource.count != 0) {
        
    }else{
    
    }
    
}
-(void)takePhoto{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}
-(void)pickPhoto{
    WS(ws);
    CorePhotoPickerVCManager *manager=[CorePhotoPickerVCManager new];
    //设置类型
    manager.pickerVCManagerType = CorePhotoPickerVCMangerTypeMultiPhoto;
    //最多可选3张
    NSInteger count = 0;
    if(_collectDataSource && _collectDataSource.count != 0){
        if(_collectDataSource.count == 1){
            count = 5;
        }else if(_collectDataSource.count == 2){
            count = 4;
        }else if(_collectDataSource.count == 3){
            count = 3;
        }else if(_collectDataSource.count == 4){
            count = 3;
        }else if(_collectDataSource.count == 5){
            count = 1;
        }else if(_collectDataSource.count == 6){
            count = 0;
        }
    }else{
        count = 6;
    }
    manager.maxSelectedPhotoNumber = count;
    //错误处理
    if(manager.unavailableType!=CorePhotoPickerUnavailableTypeNone){
        NSLog(@"设备不可用");
        return;
    }
    UIViewController *pickerVC=manager.imagePickerController;
    //选取结束
    manager.finishPickingMedia=^(NSArray *medias){
        [ProgressUtil show];
        runOnMainThread(^{
            [ProgressUtil dismiss];
            
            for (CorePhoto *photo in medias) {
                NSLog(@"111--%@", photo);
                if (![ws.collectDataSource containsObject:photo.editedImage]) {
                    [ws.collectDataSource addObject:photo.editedImage];
                    NSLog(@"collectdate--is %@",ws.collectDataSource);
                }
            }
            
            CGFloat topSpace = 15;
            if (self.collectDataSource.count<4) {
                
                self.collect.sd_layout.topSpaceToView(self.textView,topSpace).leftSpaceToView(self.scroll,15).rightSpaceToView(self.scroll,15).heightIs(kImageWidth + 16);
            }else{
                
                self.collect.sd_layout.topSpaceToView(self.textView,topSpace).leftSpaceToView(self.scroll,15).rightSpaceToView(self.scroll,15).heightIs(kImageWidth*2+kImageTopspace + 16);
            }
            
            self.photoNumLabel.hidden = self.collectDataSource.count == 0;
            if(self.collectDataSource.count != 0){
                self.photoNumLabel.text = [NSString stringWithFormat:@"%u/6",self.collectDataSource.count];
            }
            [ws reloadData];
            
            [_scroll updateLayout];
            [_scroll layoutSubviews];
        });
    };
    [self presentViewController:pickerVC animated:YES completion:nil];
}

//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    return UIEdgeInsetsMake(0, 15, 0, 15);
//}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.x / kScreenWidth == (int)(scrollView.contentOffset.x / kScreenWidth)){
        self.pageControl.currentPage = scrollView.contentOffset.x / kScreenWidth;
    }
}

//-(void)clickDeletePhoto:(PhotoCollectionViewCell*) photoCell{
//    NSIndexPath* indexPath = [self.collect indexPathForCell:photoCell];
//    if(self.collectDataSource.count > 1){
//        
//        if(self.collectDataSource.count == 5){
//            [self.collectDataSource replaceObjectAtIndex:self.collectDataSource.count - 1 withObject:[UIImage imageNamed:@"circle_add_pic"]];
//        }
//        [self.collectDataSource removeObjectAtIndex:indexPath.item];
//        
//        self.photoNumLabel.text = [NSString stringWithFormat:@"%ld/6",self.collectDataSource.count -1];
//        if(self.collectDataSource.count == 1){
//            self.photoNumLabel.hidden = YES;
//        }
//
//        CGFloat topSpace = 15;
//        if (self.collectDataSource.count<4) {
//            
//            self.collect.sd_layout.topSpaceToView(self.textView,topSpace).leftSpaceToView(self.scroll,0).rightSpaceToView(self.scroll,0).heightIs(kImageWidth + 16);
//        }else{
//            
//            self.collect.sd_layout.topSpaceToView(self.textView,topSpace).leftSpaceToView(self.scroll,0).rightSpaceToView(self.scroll,0).heightIs(kImageWidth*2+kImageTopspace + 16);
//        }
//        
//        [self.collect reloadData];
//        
//        [_scroll updateLayout];
//        [_scroll layoutSubviews];
//
//    }
//}
//
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    // 判断获取类型：图片
    if ([mediaType isEqualToString:( NSString *)kUTTypeImage]){
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        [self.collectDataSource addObject:image];
        [self reloadData];
        
        CGFloat topSpace = 15;
        
        if (self.collectDataSource.count< 4) {
            
            self.collect.sd_layout.topSpaceToView(self.textView,topSpace).leftSpaceToView(self.scroll,15).rightSpaceToView(self.scroll,15).heightIs(kImageWidth + 16);
        }else{
            
            self.collect.sd_layout.topSpaceToView(self.textView,topSpace).leftSpaceToView(self.scroll,15).rightSpaceToView(self.scroll,15).heightIs(kImageWidth*2+kImageTopspace + 16);
        }
        self.photoNumLabel.hidden = self.collectDataSource.count == 0;
        if(self.collectDataSource.count != 0){
            self.photoNumLabel.text = [NSString stringWithFormat:@"%u/6",self.collectDataSource.count];
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (NSUInteger)numberOfPhotosInPhotoBrowser:(SFPhotoBrowser *)photoBrowser{
    return self.collectDataSource.count;
}
- (SFPhoto *)photoBrowser:(SFPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    SFPhoto* sfPhoto = [SFPhoto new];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    sfPhoto.srcImageView = ((HelfPriceCell *)[_collect  cellForItemAtIndexPath:indexPath]).imageView;
    return sfPhoto;
}
#pragma mark * 发帖回调
-(void)publicPostOnCompletion{
    //发送通知，刷新圈子首页
    [kdefaultCenter postNotificationName:Notification_RefreshCircleList object:nil userInfo:nil];
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - dealloc

-(void)dealloc{
    [kdefaultCenter removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void)data:(NSMutableArray *)dataArr title:(NSString *)title twoTitle:(NSString *)twoTitle
{
    [self.presenter loadArr:dataArr title:title consultation:twoTitle];
    
}

@end
