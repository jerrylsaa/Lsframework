//
//  TabViewController.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/4/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "TabViewController.h"
#import "MenuEntity.h"

@interface TabViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) UIScrollView *scrollView;

@property (nonatomic ,strong) UIImageView *imageView;

@property (nonatomic ,strong) UIImageView *alphaView;

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,strong) NSArray *dataSource;

@property (nonatomic ,strong) ChildForm *child;

@property (nonatomic ,copy) NSString *titleName;

@property (nonatomic ,copy) NSString *imageName;

@property (nonatomic ,strong)NSDictionary *contentDic;

@end

@implementation TabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setupView{
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupImageView];
    [self setupScrollView];
    [self setupTableView];
}

- (void)setupImageView{
    _imageView = [UIImageView new];
    _imageView.frame = self.view.frame;
    [self.view addSubview:_imageView];
}

- (void)setupScrollView{
    _scrollView = [UIScrollView new];
    _scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollView];
    _scrollView.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
    _alphaView = [UIImageView new];
    _alphaView.backgroundColor = [UIColor colorWithWhite:.6 alpha:.3];
    [_scrollView addSubview:_alphaView];
    _alphaView.clipsToBounds = YES;
    _alphaView.layer.cornerRadius = 25;
    CGFloat height = _dataSource.count * 35 + 60;
    _alphaView.sd_layout.leftSpaceToView(_scrollView,20).rightSpaceToView(_scrollView,20).topSpaceToView(_scrollView,25).heightIs(height);
}

- (void)setupTableView{
    _tableView = [UITableView new];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.backgroundColor = [UIColor clearColor];
    [_alphaView addSubview:_tableView];
    _tableView.sd_layout.leftSpaceToView(_alphaView,0).rightSpaceToView(_alphaView,0).topSpaceToView(_alphaView,30).heightIs(_dataSource.count * 35 + 60);
    [_scrollView setupAutoContentSizeWithBottomView:_alphaView bottomMargin:20];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell_tab";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
//    NSArray *textArray =
//    NSArray *detailArray = _dataSource;
    if (_contentDic.count > 0) {
        if ([_contentDic objectForKey:_dataSource[indexPath.row]]) {
           cell.textLabel.text = [NSString stringWithFormat:@"%@：%@",_dataSource[indexPath.row],[_contentDic objectForKey:_dataSource[indexPath.row]]];
        }else{
            cell.textLabel.text = [NSString stringWithFormat:@"%@：%@",_dataSource[indexPath.row],@""];
        }
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)reloadDataWith:(NSArray *)data child:(ChildForm *)child imageName:(NSString *)imageName{
    self.dataSource = data;
    self.child = child;
    [self sortDic:child];
    
    self.imageView.image = [UIImage imageNamed:imageName];
    _alphaView.sd_layout.leftSpaceToView(_scrollView,20).rightSpaceToView(_scrollView,20).topSpaceToView(_scrollView,25).heightIs((_dataSource.count) * 35 + 60);
    _tableView.sd_layout.leftSpaceToView(_alphaView,0).rightSpaceToView(_alphaView,0).topSpaceToView(_alphaView,30).heightIs((_dataSource.count) * 35 + 60);
    _scrollView.contentSize = CGSizeMake(kScreenWidth, (_dataSource.count) * 35 + 160);
    [_tableView reloadData];
}

- (NSString *)getContentByTitle:(NSString *)title{
    return title;
}

- (void)sortDic:(ChildForm *)child{
    [self findDicNameBy:child.fatherEducation];
    //性别
    NSString *sex = @"";
    if (child.childSex == 2) {
        sex = @"女";
    }else if (child.childSex == 1){
        sex = @"男";
    }
    //先兆流产
    NSString *liuChan = @"";
    if (child.abortion == 0) {
        liuChan = @"无";
    }else{
        liuChan = @"有";
    }
    //妊娠合并症
    NSString *renShen = @"";
    if ([[self findDicNameBy:child.gestation] isEqualToString:@"其他"]) {
        renShen = child.gestationMark;
    }else{
        renShen = [self findDicNameBy:child.gestation];
    }
    //急性感染
    NSString *ganRan = @"";
    if ([[self findDicNameBy:child.infection] isEqualToString:@"其他"]) {
        ganRan = [NSString stringWithFormat:@"%@",child.infectionMark];
    }else{
        ganRan = [self findDicNameBy:child.infection];
    }
    //应用药物
    NSString *yaoWu = @"";
    if (child.drugs == 0) {
        yaoWu = @"无";
    }else{
        yaoWu = [NSString stringWithFormat:@"%@",(![child.drugsMark isKindOfClass:[NSNull class]] && child.drugsMark.length != 0) ? child.drugsMark : @"有"];
    }
    //接触有害物质
    NSString *youHai = @"";
    if ([[self findDicNameBy:child.hazardous] isEqualToString:@"其他"]) {
        youHai = [NSString stringWithFormat:@"%@",child.hazardousMark];
    }else{
        youHai = [self findDicNameBy:child.hazardous];
    }
    //异常孕产史
    NSString *yiChang = @"";
    if ([[self findDicNameBy:child.abnormalPregnancy] isEqualToString:@"其他"]) {
        yiChang = [NSString stringWithFormat:@"%@",child.abnormalPregnancyMark];
    }else{
        yiChang = [self findDicNameBy:child.abnormalPregnancy];
    }
    //家庭遗传史
    NSString *yiChuan = @"无";

    if (child.historyMark.length !=0) {
        yiChuan = [NSString stringWithFormat:@"%@",child.historyMark];
    }
    
    NSString *bbid = @"";
    
    if (child.identityCode.length !=0) {
        bbid = [NSString stringWithFormat:@"%@",child.identityCode];
    }
    
    NSString *fmid = @"";
    
    if (child.guargianID.length !=0) {
        fmid = [NSString stringWithFormat:@"%@",child.guargianID];
    }
    
    //父亲曾患疾病
    NSString *faDisease = @"";
    if (child.fatherEverDisease == 0) {
        faDisease = @"无";
    }else{
        faDisease = [NSString stringWithFormat:@"%@",child.fatherEverDiseaseMark];
        if (faDisease.length == 0) {
            faDisease = @"有";
        }
    }
    //母亲曾患疾病
    NSString *moDisease = @"";
    if (child.motherEverDisease == 0) {
        moDisease = @"无";
    }else{
        moDisease = [NSString stringWithFormat:@"%@",child.motherEverDiseaseMark];
        if (moDisease.length == 0) {
            moDisease = @"有";
        }
    }
    //胎数
    NSString *taiShu = @"";
    if (child.tireNum != 0) {
       taiShu = [NSString stringWithFormat:@"%@ 第%@个出生",[self findDicNameBy:child.tireNum],child.whichTire];
    }
    //胎产次
    NSString *taiChan = @"";
    if (child.fetusNum.length > 0 && child.birthNum.length > 0) {
       taiChan = [NSString stringWithFormat:@"第%@胎 第%@产",child.fetusNum,child.birthNum];
    }
//    NSMutableDictionary *totalDic = [NSMutableDictionary dictionary];
//    [totalDic setObject:(child.childName?child.childName:@"") forKey:@"姓名"];
//    [totalDic setObject:sex forKey:@"性别"];
//    [totalDic setObject:[self findDicNameBy:child.childNation] forKey:@"国籍"];
//    [totalDic setObject:[self findDicNameBy:child.nation] forKey:@"民族"];
//    [totalDic setObject:child.birthWeight.length != 0 ?[NSString stringWithFormat:@"%@kg",child.birthWeight]:@"" forKey:@"出生体重"];
//    [totalDic setObject:child.birthHeight.length != 0 ?[NSString stringWithFormat:@"%@cm",child.birthHeight]:@"" forKey:@"出生身长"];
//    [totalDic setObject:[self format:(long)[child.birthDate longLongValue]] forKey:@"出生日期"];
//    [totalDic setObject:(child.birthHospital?child.birthHospital:@"") forKey:@"出生医院"];
//    [totalDic setObject:[self findDicNameBy:child.guargionRelation] forKey:@"监护人身份"];
//    [totalDic setObject:(child.guargionName.length != 0 ? child.guargionName:@"") forKey:@"监护人"];
//    [totalDic setObject:(child.childTEL?child.childTEL:@"") forKey:@"联系电话"];
//    [totalDic setObject:(child.gestationalAge?child.gestationalAge:@"") forKey: @"孕周"];
//    [totalDic setObject:taiChan forKey:@"胎产次"];
//    [totalDic setObject:taiShu forKey:@"胎数"];
//    [totalDic setObject:[self findDicNameBy:child.childBirth] forKey:@"分娩方式"];
//    [totalDic setObject:[self findDicNameBy:child.pregnancy] forKey:@"受孕情况"];
//    [totalDic setObject:liuChan forKey:@"先兆流产"];
//    [totalDic setObject:renShen forKey:@"妊娠合并症"];
    
    
    _contentDic = @{@"姓名":(child.childName?child.childName:@""),
                    @"性别":sex,
                    @"国籍":[self findDicNameBy:child.childNation],
                    @"民族":[self findDicNameBy:child.nation],
                    @"出生体重":child.birthWeight.length != 0 ?[NSString stringWithFormat:@"%@kg",child.birthWeight]:@"",
                    @"出生身长":child.birthHeight.length != 0 ?[NSString stringWithFormat:@"%@cm",child.birthHeight]:@"",
                    @"出生日期":[self format:(long)[child.birthDate longLongValue]],
                    @"出生医院":(child.birthHospital?child.birthHospital:@""),
                    @"监护人身份":[self findDicNameBy:child.guargionRelation],
                    @"监护人":(child.guargionName.length != 0 ? child.guargionName:@""),
                    @"家庭住址":(child.childAddress?child.childAddress:@""),
                    @"联系电话":(child.childTEL?child.childTEL:@""),
                    @"宝宝身份证":bbid,
                    @"监护人身份证":fmid,
                    @"孕周":(child.gestationalAge?child.gestationalAge:@""),
                    @"胎产次":taiChan,
                    @"胎数":taiShu,
                    @"分娩方式":[self findDicNameBy:child.childBirth],
                    @"受孕情况":[self transform:child.pregnancy],
                    @"先兆流产":liuChan,
                    @"妊娠合并症":renShen,
                    @"急性感染":ganRan,
                    @"应用药物":yaoWu,
                    @"接触有害物质":youHai,
                    @"异常孕产史":yiChang,
                    @"其他":(child.otherMark?child.otherMark:@""),
                    @"家庭遗传史":yiChuan,
                    @"父亲生育年龄":(child.fatherBearAge != 0 ? [NSString stringWithFormat:@"%ld",(long)child.fatherBearAge]:@""),
                    @"父亲文化程度":[self findDicNameBy:child.fatherEducation],
                    @"父亲曾患疾病":faDisease,
                    @"母亲生育年龄":(child.motherBearAge != 0 ?[NSString stringWithFormat:@"%ld",(long)child.motherBearAge]:@""),
                    @"母亲文化程度":[self findDicNameBy:child.motherEducation],
                    @"母亲曾患疾病":moDisease,
                    @"抬头":(child.rise.length != 0 ?[NSString stringWithFormat:@"%@个月",child.rise]:@""),
                    @"翻身":(child.turnOver.length != 0 ?[NSString stringWithFormat:@"%@个月",child.turnOver]:@""),
                    @"坐稳":(child.sit.length != 0 ?[NSString stringWithFormat:@"%@个月",child.sit]:@""),
                    @"俯爬":(child.overLookClimb.length != 0 ?[NSString stringWithFormat:@"%@个月",child.overLookClimb]:@""),
                    @"手膝爬":(child.handClimb.length != 0 ?[NSString stringWithFormat:@"%@个月",child.handClimb]:@""),
                    @"独站":(child.stand.length != 0 ?[NSString stringWithFormat:@"%@个月",child.stand]:@""),
                    @"独行":(child.walk.length != 0 ?[NSString stringWithFormat:@"%@个月",child.walk]
                           :@""),
                    @"上楼梯/台阶":(child.upStairs.length != 0 ?[NSString stringWithFormat:@"%@个月",child.upStairs]:@""),
                    @"跑步":(child.run.length != 0 ?[NSString stringWithFormat:@"%@个月",child.run]:@""),
                    @"双脚跳":(child.twoFootJump.length != 0 ?[NSString stringWithFormat:@"%@个月",child.twoFootJump]:@""),
                    @"单脚站立":(child.standOneFoot.length != 0 ?[NSString stringWithFormat:@"%@个月",child.standOneFoot]:@""),
                    @"单脚跳":(child.oneFootJump.length != 0 ?[NSString stringWithFormat:@"%@个月",child.oneFootJump]:@""),
                    @"伸手够物":(child.reach.length != 0 ?[NSString stringWithFormat:@"%@个月",child.reach]:@""),
                    @"拇食指对捏":(child.pinch.length != 0 ?[NSString stringWithFormat:@"%@个月",child.pinch]:@""),
                    @"有意识叫爸爸/妈妈":(child.callFather.length != 0 ?[NSString stringWithFormat:@"%@个月",child.callFather]:@""),
                    @"说3个物品的名字":(child.sayGoods.length != 0 ?[NSString stringWithFormat:@"%@个月",child.sayGoods]:@""),
                    @"说2-3个字的短语":(child.sayPhrase.length != 0 ?[NSString stringWithFormat:@"%@个月",child.sayPhrase]:@""),
                    @"说自己的名字":(child.sayOwnName.length != 0 ?[NSString stringWithFormat:@"%@个月",child.sayOwnName]:@"")
                    };
    
}

- (NSString *)findDicNameBy:(NSInteger)menuId{
    if (menuId) {
        NSArray *array = [MenuEntity MR_findByAttribute:@"menuId" withValue:@(menuId)];
        if (array.count > 0) {
            MenuEntity *entity = array[0];
            return entity.dictionaryName;
        }
        return @"";
    }
    return @"";
}

- (NSString *)format:(long)timeInv{
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInv];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    return [format stringFromDate:date];
}

- (NSString *)transform:(NSInteger)pregancy{
    if (pregancy == 1) {
        return @"自然怀孕";
    }else if (pregancy == 2){
        return @"人工授精";
    }else if (pregancy == 3){
        return @"体外助孕";
    }
    return @"";
}

@end
