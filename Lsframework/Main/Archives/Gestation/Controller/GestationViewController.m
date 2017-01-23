//
//  GestationViewController.m
//  FamilyPlatForm
//
//  Created by Tom on 16/3/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//  孕期

#import "GestationViewController.h"
#import "GesImageView.h"
#import "FPButton.h"
#import "FamilyHistoryViewController.h"
#import "FPDropView.h"
#import "FPTextField.h"
#import "MenuEntity.h"


@interface GestationViewController ()<GestationPresenterDelegate,UITextFieldDelegate,UIAlertViewDelegate>

@property (nonatomic ,strong)UIScrollView *scrollView;
@property (nonatomic ,strong)FPTextField *textFiled;
@property (nonatomic ,strong)NSMutableArray *viewArray;
@property (nonatomic ,strong)FPButton *backButton;
@property (nonatomic ,strong)FPButton *nextButton;

@property (nonatomic ,strong)GesImageView *xianZhaoView;
@property (nonatomic ,strong)FPTextField *renShenView;
@property (nonatomic ,strong)FPTextField *ganRanView;
@property (nonatomic ,strong)GesImageView *yaoWuView;
@property (nonatomic ,strong)FPTextField *youHaiView;
@property (nonatomic ,strong)FPTextField *yiChangView;

@property (nonatomic ,strong)UIAlertView *textAlertView;

@property(nonatomic,retain) GestationPresenter* presenter;

@property(nonatomic) BOOL isFinish;

@end

@implementation GestationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initRightBarWithTitle:@"完成"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIAlertView *)textAlertView{
    if (!_textAlertView) {
        _textAlertView = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [_textAlertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    }
    ((UITextField *)[_textAlertView textFieldAtIndex:0]).text = nil;
    return _textAlertView;
}

- (void)setupView{
    self.title = @"母亲孕期情况";
    self.presenter = [GestationPresenter new];
    self.presenter.delegate = self;
//    _childForm = [ChildForm new];
    _viewArray = [NSMutableArray array];
    [self setupScrollView];
//    [self setupSubView];
    [self setupXianZhaoView];
    [self setupRenShenView];
    [self setupGanRanView];
    [self setupYaoWuView];
    [self setupYouHaiView];
    [self setupYiChangView];
    [self setupOthers];
    [self setupButtons];
}

- (void)setupScrollView{
    //背景
    UIImageView *contentView = [UIImageView new];
    contentView.frame = self.view.bounds;
    contentView.image = [UIImage imageNamed:@"archives_records3"];
    contentView.contentMode = UIViewContentModeScaleAspectFill;
    contentView.userInteractionEnabled = YES;
    [self.view addSubview:contentView];
    
    _scrollView = [UIScrollView new];
    _scrollView.contentSize = CGSizeMake(kScreenWidth, 603);
    [self.view addSubview:_scrollView];
    _scrollView.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
    
}


- (void)setupXianZhaoView{
    _xianZhaoView = [GesImageView new];
    [_scrollView addSubview:_xianZhaoView];
    _xianZhaoView.titleLabel.text = @"先兆流产：";
    [_xianZhaoView.textField.superview removeFromSuperview];
    _xianZhaoView.selectGroup.selection = 0;
    _xianZhaoView.image = [self stretchableImageWithImageName:@"text_nor"];
    _xianZhaoView.sd_layout.leftSpaceToView(_scrollView,25).topSpaceToView(_scrollView,15).rightSpaceToView(_scrollView,25).heightIs(65);
    _xianZhaoView.layer.cornerRadius = _xianZhaoView.height/2;
    _xianZhaoView.clipsToBounds = YES;
    // -0-
    [_viewArray addObject:_xianZhaoView];
}

- (void)setupRenShenView{
    _renShenView = [FPTextField new];
    [_scrollView addSubview:_renShenView];
    _renShenView.title = @"妊娠合并症：";
    _renShenView.rightIcon = [UIImage imageNamed:@"pulldown"];
    _renShenView.sd_layout.leftSpaceToView(_scrollView,25).topSpaceToView(_scrollView,95).rightSpaceToView(_scrollView,25).heightIs(40);
    _renShenView.layer.cornerRadius = _renShenView.height/2;
    _renShenView.clipsToBounds = YES;
    _renShenView.delegate = self;
    // -1-
    [_viewArray addObject:_renShenView];
}

- (void)setupGanRanView{
    _ganRanView = [FPTextField new];
    [_scrollView addSubview:_ganRanView];
    _ganRanView.title = @"急性感染：";
    _ganRanView.rightIcon = [UIImage imageNamed:@"pulldown"];
    _ganRanView.sd_layout.leftSpaceToView(_scrollView,25).topSpaceToView(_scrollView,150).rightSpaceToView(_scrollView,25).heightIs(40);
    _ganRanView.layer.cornerRadius = _ganRanView.height/2;
    _ganRanView.clipsToBounds = YES;
    _ganRanView.delegate = self;
    // -2-
    [_viewArray addObject:_ganRanView];
}

- (void)setupYaoWuView{
    _yaoWuView = [GesImageView new];
    [_scrollView addSubview:_yaoWuView];
    _yaoWuView.titleLabel.text = @"应用药物：";
    _yaoWuView.selectGroup.selection = 0;
    _yaoWuView.image = [self stretchableImageWithImageName:@"text_nor"];
    _yaoWuView.sd_layout.leftSpaceToView(_scrollView,25).topSpaceToView(_scrollView,200).rightSpaceToView(_scrollView,25).heightIs(65);
    _yaoWuView.layer.cornerRadius = _yaoWuView.height/2;
    _yaoWuView.clipsToBounds = YES;
    // -3-
    [_viewArray addObject:_yaoWuView];
    
}

- (void)setupYouHaiView{
    _youHaiView = [FPTextField new];
    [_scrollView addSubview:_youHaiView];
    _youHaiView.title = @"接触有害物质：";
    _youHaiView.rightIcon = [UIImage imageNamed:@"pulldown"];
    _youHaiView.sd_layout.leftSpaceToView(_scrollView,25).topSpaceToView(_scrollView,280).rightSpaceToView(_scrollView,25).heightIs(40);
    _youHaiView.layer.cornerRadius = _youHaiView.height/2;
    _youHaiView.clipsToBounds = YES;
    _youHaiView.delegate = self;
    // -4-
    [_viewArray addObject:_youHaiView];
}

- (void)setupYiChangView{
    _yiChangView = [FPTextField new];
    [_scrollView addSubview:_yiChangView];
    _yiChangView.title = @"异常孕产史：";
    _yiChangView.rightIcon = [UIImage imageNamed:@"pulldown"];
    _yiChangView.sd_layout.leftSpaceToView(_scrollView,25).topSpaceToView(_scrollView,330).rightSpaceToView(_scrollView,25).heightIs(40);
    _yiChangView.layer.cornerRadius = _yiChangView.height/2;
    _yiChangView.clipsToBounds = YES;
    _yiChangView.delegate = self;
    // -5-
    [_viewArray addObject:_yiChangView];
}

- (void )setupOthers{
    _textFiled = [FPTextField new];
    _textFiled.title = @"其他：";
    _textFiled.textColor = FileFontColor;
    _textFiled.textAlignment=NSTextAlignmentCenter;
    [_scrollView addSubview:_textFiled];
    _textFiled.sd_layout.leftSpaceToView(_scrollView,25).rightSpaceToView(_scrollView,25).topSpaceToView(_yiChangView,15).heightIs(40);
}

- (void)setupButtons{
    //上一步按钮
    _backButton = [FPButton buttonWithType:UIButtonTypeCustom];
    [_backButton setTitle:@"上一步" forState:UIControlStateNormal];
    [_backButton setBackgroundImage:[self stretchableImageWithImageName:@"back_nor"] forState:UIControlStateNormal];
    [_backButton setBackgroundImage:[self stretchableImageWithImageName:@"back_sel"] forState:UIControlStateHighlighted];
    [_backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_backButton];
    _backButton.sd_layout.leftSpaceToView(_scrollView,25).topSpaceToView(_textFiled,15).widthIs(kScreenWidth/2-30).heightIs(40);
    _backButton.cornerRadius = _backButton.height/2;
    
    //下一步按钮
    _nextButton = [FPButton buttonWithType:UIButtonTypeCustom];
    [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextButton setBackgroundImage:[self stretchableImageWithImageName:@"next_nor1"] forState:UIControlStateNormal];
    [_nextButton setBackgroundImage:[self stretchableImageWithImageName:@"next_sel1"] forState:UIControlStateHighlighted];
    [_nextButton addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_nextButton];
    _nextButton.sd_layout.topSpaceToView(_textFiled,15).rightSpaceToView(_scrollView,25).widthIs(_backButton.width).heightIs(_backButton.height);
    _nextButton.cornerRadius = _nextButton.height/2;
}
#pragma mark Action
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)nextAction{
//    [self.navigationController pushViewController:[FamilyHistoryViewController new] animated:YES];
    for(int i=0;i<_viewArray.count;++i){
        GesImageView* view = [_viewArray objectAtIndex:i];
        switch (i) {
            case 0:{//流产
                self.childForm.abortion = view.currentSelect;
                self.childForm.abortionMark = view.currentSelect?view.textField.text: nil;
            }
                break;
            case 3:{//药物
                self.childForm.drugs = view.currentSelect;
                self.childForm.drugsMark = view.currentSelect?view.textField.text: nil;
            }
                break;
        }
    }
    //其他
    self.childForm.otherMark = _textFiled.text;
    
    //先兆流产
    self.childForm.abortion = _xianZhaoView.currentSelect;
    self.childForm.abortionMark = _xianZhaoView.currentSelect==1?@"有": @"有";
    //药物应用
    self.childForm.drugs = _yaoWuView.currentSelect;
    self.childForm.drugsMark = _yaoWuView.currentSelect==1?_yaoWuView.textField.text: @"";
    //妊娠合并
    if ([self findIdByName:_renShenView.text] == 0) {
        self.childForm.gestationMark = _renShenView.text;
    }
    //急性感染
    if ([self findIdByName:_ganRanView.text] == 0) {
        self.childForm.infectionMark = _ganRanView.text;
    }
    //有害物质
    if ([self findIdByName:_youHaiView.text] == 0) {
        self.childForm.hazardousMark = _youHaiView.text;
    }
    //异常孕产
    if ([self findIdByName:_yiChangView.text] == 0) {
        self.childForm.abnormalPregnancyMark = _yiChangView.text;
    }
    //其他
    self.childForm.otherMark = _textFiled.text;
    
    [ProgressUtil show];
    [self.presenter commitGestation:self.childForm];
}

-(void)rightItemAction:(id)sender{
    _isFinish = YES;
    for(int i=0;i<_viewArray.count;++i){
        GesImageView* view = [_viewArray objectAtIndex:i];
        switch (i) {
            case 0:{//流产
                self.childForm.abortion = view.currentSelect;
                self.childForm.abortionMark = view.currentSelect?view.textField.text: nil;
            }
                break;
            case 3:{//药物
                self.childForm.drugs = view.currentSelect;
                self.childForm.drugsMark = view.currentSelect?view.textField.text: nil;
            }
                break;
        }
    }
    //其他
    self.childForm.otherMark = _textFiled.text;
    
    [self.presenter commitGestation:self.childForm];

    if (self.poptoClass) {
        UIViewController * back;
        for (UIViewController * vc in self.navigationController.childViewControllers) {
            if ([vc isKindOfClass:self.poptoClass]) {
                back = vc;
                break;
            }
        }
        if (back) {
            [self.navigationController popToViewController:back animated:YES];
        }else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }else{
        [self presentViewController:[TabbarViewController new] animated:YES completion:nil];
    }

}

#pragma mark - 代理

-(void)onCommitComplete:(BOOL)success info:(NSString *)info{
    if(success){
        
        if(_isFinish){
            //完成
            
        }else{
            _isFinish = NO;
            [ProgressUtil dismiss];
            FamilyHistoryViewController* history =[FamilyHistoryViewController new];
            history.poptoClass = self.poptoClass;
            history.childForm=self.childForm;
            [self.navigationController pushViewController:history animated:YES];
        }
    }else{
        [ProgressUtil showError:info];
    }
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    WS(ws);
    
    __weak UITextField * weakTf = textField;

    if ([textField isEqual:_renShenView]) {
        //妊娠合并症
        NSArray *renShenArray = [MenuEntity MR_findByAttribute:@"parentId" withValue:@398];
        NSArray *sortedArray = [renShenArray sortedArrayUsingComparator:^NSComparisonResult(MenuEntity *entity_1, MenuEntity *entity_2){
            return [entity_1.menuId compare:entity_2.menuId];
        }];
        NSMutableArray *titleArray = [NSMutableArray array];
        for (MenuEntity *entity in sortedArray) {
            [titleArray addObject:entity.dictionaryName];
        }
        FPDropView * dropView = [FPDropView new];
        dropView.textAlignment = NSTextAlignmentCenter;
        dropView.textColor = [UIColor darkGrayColor];
        dropView.font = [UIFont  systemFontOfSize:18.];
        dropView.titles = titleArray;
        __weak FPDropView * weakDv = dropView;
        __weak FPTextField * weakSV = _renShenView;
        [dropView setSelectedHandler:^BOOL(NSUInteger selection) {
            weakTf.text = weakDv.titles[selection];
//            weakSV.rightIcon = nil;
            ws.childForm.gestation = [((MenuEntity *)sortedArray[selection]).menuId integerValue];
            if (selection == titleArray.count - 1) {
                [ws.textAlertView setTitle:@"妊娠合并症备注"];
                ws.textAlertView.tag = 1;
                [ws.textAlertView show];
            }
            return YES;
        }];
        [dropView showInController:self parentView:textField];
    }else if ([textField isEqual:_ganRanView]){
        //感染
        NSArray *ganRanArray = [MenuEntity MR_findByAttribute:@"parentId" withValue:@399];
        NSArray *sortedArray = [ganRanArray sortedArrayUsingComparator:^NSComparisonResult(MenuEntity *entity_1, MenuEntity *entity_2){
            return [entity_1.menuId compare:entity_2.menuId];
        }];
        NSMutableArray *titleArray = [NSMutableArray array];
        for (MenuEntity *entity in sortedArray) {
            [titleArray addObject:entity.dictionaryName];
        }

        FPDropView * dropView = [FPDropView new];
        dropView.textAlignment = NSTextAlignmentCenter;
        dropView.textColor = [UIColor darkGrayColor];
        dropView.font = [UIFont systemFontOfSize:18.];
        dropView.titles = titleArray;
        __weak FPDropView * weakDv = dropView;
        [dropView setSelectedHandler:^BOOL(NSUInteger selection) {
            weakTf.text = weakDv.titles[selection];
            ws.childForm.infection = [((MenuEntity *)sortedArray[selection]).menuId integerValue];
            if (selection == titleArray.count - 1) {
                [ws.textAlertView setTitle:@"急性感染备注"];
                ws.textAlertView.tag = 2;
                [ws.textAlertView show];
            }
            return YES;
        }];
        [dropView showInController:self parentView:textField];
        
    }else if ([textField isEqual:_youHaiView]){
        //接触有害物质
        NSArray *youHaiArray = [MenuEntity MR_findByAttribute:@"parentId" withValue:@400];
        NSArray *sortedArray = [youHaiArray sortedArrayUsingComparator:^NSComparisonResult(MenuEntity *entity_1, MenuEntity *entity_2){
            return [entity_1.menuId compare:entity_2.menuId];
        }];
        NSMutableArray *titleArray = [NSMutableArray array];
        for (MenuEntity *entity in sortedArray) {
            [titleArray addObject:entity.dictionaryName];
        }
        FPDropView * dropView = [FPDropView new];
        dropView.textAlignment = NSTextAlignmentCenter;
        dropView.textColor = [UIColor darkGrayColor];
        dropView.font = [UIFont systemFontOfSize:18.];
        dropView.titles = titleArray;
        __weak FPDropView * weakDv = dropView;
        [dropView setSelectedHandler:^BOOL(NSUInteger selection) {
            weakTf.text = weakDv.titles[selection];
            ws.childForm.hazardous = [((MenuEntity *)sortedArray[selection]).menuId integerValue];
            if (selection == titleArray.count - 1) {
                [ws.textAlertView setTitle:@"接触有害物质备注"];
                ws.textAlertView.tag = 3;
                [ws.textAlertView show];
            }
            return YES;
        }];
        [dropView showInController:self parentView:textField];
    }else if ([textField isEqual:_yiChangView]){
        //异常孕产史
        NSArray *yiChangArray = [MenuEntity MR_findByAttribute:@"parentId" withValue:@401];
        NSArray *sortedArray = [yiChangArray sortedArrayUsingComparator:^NSComparisonResult(MenuEntity *entity_1, MenuEntity *entity_2){
            return [entity_1.menuId compare:entity_2.menuId];
        }];
        NSMutableArray *titleArray = [NSMutableArray array];
        for (MenuEntity *entity in sortedArray) {
            [titleArray addObject:entity.dictionaryName];
        }
        FPDropView * dropView = [FPDropView new];
        dropView.textAlignment = NSTextAlignmentCenter;
        dropView.textColor = [UIColor darkGrayColor];
        dropView.font = [UIFont systemFontOfSize:18.];
        dropView.titles = titleArray;
        __weak FPDropView * weakDv = dropView;
        [dropView setSelectedHandler:^BOOL(NSUInteger selection) {
            weakTf.text = weakDv.titles[selection];
            ws.childForm.abnormalPregnancy = [((MenuEntity *)sortedArray[selection]).menuId integerValue];
            if (selection == titleArray.count - 1) {
                [ws.textAlertView setTitle:@"异常孕产史备注"];
                ws.textAlertView.tag = 4;
                [ws.textAlertView show];
            }
            return YES;
        }];
        [dropView showInController:self parentView:textField];
    }
    return NO;
}

#pragma mark UIAlertViewDeleGate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    UITextField *tf = [alertView textFieldAtIndex:0];
    if (alertView.tag == 1) {
        _renShenView.text = tf.text;
    }else if (alertView.tag == 2){
        _ganRanView.text = tf.text;
    }else if (alertView.tag == 3){
        _youHaiView.text = tf.text;
    }else if (alertView.tag == 4){
        _yiChangView.text = tf.text;
    }else{
        
    }
}




#pragma mark -
- (UIImage *)stretchableImageWithImageName:(NSString *)imageName{
    //裁减拉伸图片
    UIImage *image = [UIImage imageNamed:imageName];
    CGRect myImageRect = CGRectMake(image.size.width/2 - 1, image.size.height/2 -1 , 3, 3);
    CGImageRef imageRef = image.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    CGSize size = CGSizeMake(myImageRect.size.width, myImageRect.size.height);
    UIGraphicsBeginImageContext (size);
    CGContextRef context = UIGraphicsGetCurrentContext ();
    CGContextDrawImage (context, myImageRect, subImageRef);
    UIImage *newImage = [UIImage imageWithCGImage :subImageRef];
    UIGraphicsEndImageContext ();
    image = [newImage stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:0];
    return image;
}

- (void)hiddenButton{
    _backButton.hidden = YES;
    _nextButton.hidden = YES;
}

- (void)vc_3_save:(Complete)block{
    //先兆流产
    self.childForm.abortion = _xianZhaoView.currentSelect;
    self.childForm.abortionMark = _xianZhaoView.currentSelect==1?@"有": @"无";
    //药物应用
    self.childForm.drugs = _yaoWuView.currentSelect;
    self.childForm.drugsMark = _yaoWuView.currentSelect==1?_yaoWuView.textField.text: @"";
    //妊娠合并
    if ([self findIdByName:_renShenView.text] == 0) {
        self.childForm.gestationMark = _renShenView.text;
    }
    //急性感染
    if ([self findIdByName:_ganRanView.text] == 0) {
        self.childForm.infectionMark = _ganRanView.text;
    }
    //有害物质
    if ([self findIdByName:_youHaiView.text] == 0) {
        self.childForm.hazardousMark = _youHaiView.text;
    }
    //异常孕产
    if ([self findIdByName:_yiChangView.text] == 0) {
        self.childForm.abnormalPregnancyMark = _yiChangView.text;
    }
    //其他
    self.childForm.otherMark = _textFiled.text;
    
    [ProgressUtil show];
    [self.presenter commitGestation:self.childForm block:^(BOOL success, NSString *message) {
        block(success ,message);
    }];

}

- (void)loadData:(ChildForm *)child{
    self.childForm = child;
    
    if (child.abortion != 0 && child.abortion != 1) {
        child.abortion = 0;
    }
    if (child.drugs != 0 && child.drugs != 1) {
        child.drugs = 0;
    }
    if (child.abortion == 0) {
        _xianZhaoView.selectGroup.selection = 0;
        _xianZhaoView.currentSelect = 0;
    }else if (child.abortion == 1){
        _xianZhaoView.selectGroup.selection = 1;
        _xianZhaoView.currentSelect = 1;
//        [_xianZhaoView showText];
//        _xianZhaoView.textField.text = child.abortionMark;
    }
    
    if (child.drugs == 0) {
        _yaoWuView.selectGroup.selection = 0;
    }else if (child.drugs == 1){
        _yaoWuView.selectGroup.selection = 1;
        _yaoWuView.currentSelect = 1;
        [_yaoWuView showText];
        _yaoWuView.textField.text = child.drugsMark;
    }
    
    if ([[self findDicNameBy:child.gestation] isEqualToString:@"其他"]) {
        _renShenView.text = child.gestationMark;
    }else{
        _renShenView.text = [self findDicNameBy:child.gestation];
    }
    
    if ([[self findDicNameBy:child.infection] isEqualToString:@"其他"]) {
        _ganRanView.text = child.infectionMark;
    }else{
        _ganRanView.text = [self findDicNameBy:child.infection];
    }
    
    if ([[self findDicNameBy:child.hazardous] isEqualToString:@"其他"]) {
        _youHaiView.text = child.hazardousMark;
    }else{
        _youHaiView.text = [self findDicNameBy:child.hazardous];
    }
    
    if ([[self findDicNameBy:child.abnormalPregnancy] isEqualToString:@"其他"]) {
        _yiChangView.text = child.abnormalPregnancyMark;
    }else{
        _yiChangView.text = [self findDicNameBy:child.abnormalPregnancy];
    }
    
    _textFiled.text = child.otherMark;
    
}

- (NSString *)findDicNameBy:(NSInteger)menuId{
    NSArray *array = [MenuEntity MR_findByAttribute:@"menuId" withValue:@(menuId)];
    if (array.count > 0) {
        MenuEntity *entity = array[0];
        return entity.dictionaryName;
    }
    return @"";
}

- (NSInteger)findIdByName:(NSString *)name{
    NSArray *array = [MenuEntity MR_findByAttribute:@"dictionaryName" withValue:name];
    if (array.count > 0 ) {
        MenuEntity *entity = array[0];
        return [entity.menuId integerValue];
    }
    return 0;
}

@end
