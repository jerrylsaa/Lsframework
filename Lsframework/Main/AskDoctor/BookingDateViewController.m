//
//  BookingDateViewController.m
//  FamilyPlatForm
//
//  Created by Tom on 16/4/1.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BookingDateViewController.h"
#import "ZHCalendarView.h"
#import "ZHCalendarCell.h"
#import "BookingTimeViewController.h"
#import "CaseInfoViewController.h"
#import "JHCustomMenu.h"
#import "BookingDatePresenter.h"



@interface BookingDateViewController ()<UIScrollViewDelegate,ZHCalendarDelegate,JHCustomMenuDelegate,ZHCityPickerDelegate>
{
    UIScrollView *_scrollView;
    NSMutableArray *_buttonArray;

    UIScrollView *_mainScrollView;
    UICollectionView *_collectionView;
    ZHCalendarCell *_cell;
    NSIndexPath *_indexPath;
    UIButton *_departmentButton;
    
    UILabel *_hospitalLabel;
    UILabel *_departmentLabel;
    BOOL _address;
}
@property (nonatomic ,strong)BookingDatePresenter *presenter;


@property(nonatomic,retain)JHCustomMenu *hospitalMenu;
@property(nonatomic,strong)UIButton *hospitalButton;
@property(nonatomic,strong)NSMutableArray *hospitalArray;
@property(nonatomic,retain)JHCustomMenu *departmentMenu;
@property(nonatomic,strong)UIButton *departmentButton;
@property(nonatomic,strong)NSMutableArray *departmentArray;
@property (nonatomic, strong) UIBarButtonItem * titleItem;

@property(nonatomic,retain) NSString* bookDate;

@end

@implementation BookingDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView{
    self.hospitalArray = [NSMutableArray array];
    self.departmentArray = [NSMutableArray array];
    _presenter = [BookingDatePresenter new];
    _presenter.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeAddress) name:@"dismiss" object:nil];
    [self setupMainScrollView];
    if (self.dateType == BookDateTtypeNomal) {
        self.title = @"普通门诊预约";
        [self setTitleLabel];
    }else if (self.dateType == BookDateTtypeSpecial){
        self.title = @"特需门诊预约";
//        [self setDepartmentMenu];
    }
    
    [self setupScrollView];
    [self setupMonthHeader];
    [self setupCalendar];
    [self setupButtons];
//    [self setupSelectView];
//    [self setupRightItem];
//    [self location];
}

- (void)setupMainScrollView{
    _mainScrollView = [UIScrollView new];
    _mainScrollView.contentSize = CGSizeMake(kScreenWidth, 700);
    [self.view addSubview:_mainScrollView];
    _mainScrollView.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
}

- (void)setTitleLabel{
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"可预约时间";
    titleLabel.font = [UIFont systemFontOfSize:20];
    [_mainScrollView addSubview:titleLabel];
    titleLabel.sd_layout.leftSpaceToView(_mainScrollView,20).rightSpaceToView(_mainScrollView,20).topSpaceToView(_mainScrollView,0).heightIs(50);
//    titleLabel.sd_layout.leftSpaceToView(_mainScrollView,20).rightSpaceToView(_mainScrollView,20).topSpaceToView(self.view,0).heightIs(50);
}
//- (void)setDepartmentMenu{
//    
//    _departmentButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_departmentButton setImage:[UIImage imageNamed:@"ac_down"] forState:UIControlStateNormal];
//    [_departmentButton setTitle:@"选择预约科室：" forState:UIControlStateNormal];
//    [_departmentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    _departmentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [_departmentButton setImageEdgeInsets:UIEdgeInsetsMake(0, kScreenWidth - 50, 0, 0)];
//    [_departmentButton addTarget:self action:@selector(departmentAction) forControlEvents:UIControlEventTouchUpInside];
//    [_mainScrollView addSubview:_departmentButton];
//    _departmentButton.sd_layout.leftSpaceToView(_mainScrollView,0).topSpaceToView(_mainScrollView,0).rightSpaceToView(_mainScrollView,0).heightIs(50);
//}

- (void)setupScrollView{
    _scrollView = [UIScrollView new];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(kScreenWidth*3, kScreenWidth/7*6);
    [_mainScrollView addSubview:_scrollView];
    _scrollView.sd_layout.rightSpaceToView(_mainScrollView,0).rightSpaceToView(_mainScrollView,0).topSpaceToView(_mainScrollView,100).heightIs(kScreenWidth/7*6 + 50);
}

- (void)setupMonthHeader{
    _buttonArray = [NSMutableArray array];
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy年\nMM月";
    for (int i = 0; i < 3; i ++) {
        NSString *title = [fmt stringFromDate:[self dateAfterCurrentMonth:i] ];
        UIButton *monthButton = [UIButton buttonWithType:UIButtonTypeCustom];
        monthButton.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        monthButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [monthButton setTitle:title forState:UIControlStateNormal];
        monthButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [monthButton setBackgroundImage:[self stretchableImageWithImageName:@"date_select"] forState:UIControlStateSelected];
        if (i == 0) {
            monthButton.selected = YES;
        }
        [_buttonArray addObject:monthButton];
        [monthButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [monthButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        monthButton.tag = 120 + i;
        
        [monthButton addTarget:self action:@selector(changeMonth:) forControlEvents:UIControlEventTouchUpInside];
        [_mainScrollView addSubview:monthButton];
        monthButton.sd_layout.leftSpaceToView(_mainScrollView,kScreenWidth/3*i).topSpaceToView(_mainScrollView,50).heightIs(50).widthIs(kScreenWidth/3);
    }
    
    for (int i = 0; i < 2; i ++) {
        UIView *sep = [UIView new];
        sep.backgroundColor = UIColorFromRGB(0x82d7ef);
        [_mainScrollView addSubview:sep];
        sep.sd_layout.leftSpaceToView(_mainScrollView,0).rightSpaceToView(_mainScrollView,0).topSpaceToView(_mainScrollView,50*(i+1)).heightIs(1);
    }
}

- (void)setupCalendar{
    
    for (int i = 0; i < 3; i ++) {
//        ZHCalendarView *calendarView = [[ZHCalendarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/7*6) withDate:[self dateAfterCurrentMonth:i] andDays:@[@10,@18,@20,@23]];
         ZHCalendarView *calendarView = [[ZHCalendarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/7*6) withDate:[self dateAfterCurrentMonth:i] andDays:@[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10,@11,@12,@13,@14,@15,@16,@17,@18,@19,@20,@21,@22,@23,@24,@25,@26,@27,@28,@29,@30,@31]];
        calendarView.tag = 140 + i;
        calendarView.delegate = self;
        [_scrollView addSubview:calendarView];
        calendarView.sd_layout.leftSpaceToView(_scrollView,kScreenWidth*i).topSpaceToView(_scrollView,0).bottomSpaceToView(_scrollView,0).widthIs(kScreenWidth);
    }
}

- (void)setupButtons{
//    NSArray *titles = @[@"上午门诊",@"下午门诊",@"晚间门诊"];
    NSArray *titles = @[@"预约"];
    for (int i = 0; i < titles.count; i ++) {
        UIButton *timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [timeButton setTitle:titles[i] forState:UIControlStateNormal];
        [timeButton setTitleColor:UIColorFromRGB(0xfdc85a) forState:UIControlStateNormal];
        [timeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        timeButton.titleLabel.font = [UIFont systemFontOfSize:20];
        [timeButton setBackgroundImage:[self stretchableImageWithImageName:@"commit_success_bg"] forState:UIControlStateHighlighted];
        timeButton.layer.borderWidth = 1;
        timeButton.layer.borderColor = UIColorFromRGB(0xfdc85a).CGColor;
        timeButton.clipsToBounds = YES;
        timeButton.tag = 130 + i;
        [timeButton addTarget:self action:@selector(timeAction:) forControlEvents:UIControlEventTouchUpInside];
        [_mainScrollView addSubview:timeButton];
        timeButton.sd_layout.leftSpaceToView(_mainScrollView,10).rightSpaceToView(_mainScrollView,10).topSpaceToView(_scrollView,(25+50)*i).heightIs(50);
        timeButton.layer.cornerRadius = 25;
    }
}

//Action
- (void)changeMonth:(UIButton *)button{
    [self updateButtonStateWithTag:(button.tag - 120)];
    [UIView animateWithDuration:.5f animations:^{
        _scrollView.contentOffset = CGPointMake(kScreenWidth*(button.tag - 120), 0);
    }];
}
- (void)timeAction:(UIButton *)button{
    if (button.tag == 130) {
        //上午
    }else if (button.tag == 131){
        //下午
    }else{
        //晚上
    }
    
    
    if (self.dateType == BookDateTtypeSpecial) {
        CaseInfoViewController *vc = [CaseInfoViewController new];
    vc.caseInfoType = CaseInfoTypeVIP;
    [self.navigationController pushViewController:vc animated:YES];
    }else{
        BookingTimeViewController *vc = [BookingTimeViewController new];
        vc.doctor = self.doctor;
        vc.bookDate = self.bookDate;
        [self.navigationController pushViewController:vc animated:YES];
    }
    

   
}

//- (void)departmentAction{
//    __weak typeof(self) weakSelf=self;
//    //科室数组
//    if(!self.departmentMenu){
//        _departmentArray = @[@"1",@"2"];
//        self.departmentMenu=[[JHCustomMenu alloc] initWithDataArr:_departmentArray origin:CGPointMake(0, 50 - _mainScrollView.contentOffset.y) width:kScreenWidth rowHeight:37 rowNumber:10];
//        self.departmentMenu.delegate=self;
//        [self.view addSubview:self.departmentMenu];
//        
//        self.departmentMenu.dismiss=^(){
//            weakSelf.departmentMenu=nil;
//        };
//    }else{
//        
//        [self.departmentMenu dismissWithCompletion:^(JHCustomMenu *object) {
//            weakSelf.departmentMenu=nil;
//        }];
//    }
//}
//
//#pragma mark JHCustomMenuDelegate
//-(void)jhCustomMenu:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSString *title = ((UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath]).textLabel.text;
//    [_departmentButton setTitle:[NSString stringWithFormat:@"选择预约科室：%@",title] forState:UIControlStateNormal];
//}
#pragma mark ZHCalendarDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath andDateStr:(NSString *)dateStr{
    
    ZHCalendarCell *cell = (ZHCalendarCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (_cell && ![_cell isEqual:cell]) {
    
        _cell.isCurrent = NO;
    }
    cell.isCurrent = ! cell.isCurrent;
    if (_collectionView && ![_collectionView isEqual:collectionView]) {
        if (_indexPath) {
            [_collectionView reloadItemsAtIndexPaths:@[indexPath]];
        }
    }
    _cell = cell;
    _collectionView = collectionView;
    _indexPath = indexPath;
    
    self.bookDate = dateStr;
    NSLog(@"%@",dateStr);
    
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    CGFloat offset = targetContentOffset -> x;
    if (offset == 0) {
        [self updateButtonStateWithTag:0];
        
    }else if (offset == kScreenWidth){
        [self updateButtonStateWithTag:1];
            }else if (offset == kScreenWidth * 2){
        [self updateButtonStateWithTag:2];
    }
}

- (void)setupSelectView{
    //医院下拉菜单按钮
    _hospitalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_hospitalButton setTitleEdgeInsets:UIEdgeInsetsMake(15, 0, 15, 35)];
    [_hospitalButton setImageEdgeInsets:UIEdgeInsetsMake(20, kScreenWidth/2 - 35, 20, 0)];
    [self.view addSubview:_hospitalButton];
    [_hospitalButton addTarget:self action:@selector(hospitalAction) forControlEvents:UIControlEventTouchUpInside];
    [_hospitalButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [_hospitalButton setTitle:@"医院:" forState:UIControlStateNormal];
    [_hospitalButton setImage:[UIImage imageNamed:@"ac_down"] forState:UIControlStateNormal];
    _hospitalButton.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,kScreenWidth/2).topSpaceToView(self.view,0).widthIs(kScreenWidth/2).heightIs(50);
    
    //科室下拉菜单按钮
    _departmentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_departmentButton setTitleEdgeInsets:UIEdgeInsetsMake(15, 0, 15, 35)];
    [_departmentButton setImageEdgeInsets:UIEdgeInsetsMake(20, kScreenWidth/2 - 35, 20, 0)];
    [self.view addSubview:_departmentButton];
    [_departmentButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [_departmentButton setTitle:@"科室:" forState:UIControlStateNormal];
    [_departmentButton setImage:[UIImage imageNamed:@"ac_down"] forState:UIControlStateNormal];
    [_departmentButton addTarget:self action:@selector(departmentAction) forControlEvents:UIControlEventTouchUpInside];
    _departmentButton.sd_layout.rightSpaceToView(self.view,0).topSpaceToView(self.view,0).widthIs(kScreenWidth/2).heightIs(50);
    //分割线
    UIView *sep_1 = [UIView new];
    sep_1.backgroundColor = UIColorFromRGB(0xdbdbdb);
    [self.view addSubview:sep_1];
    sep_1.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).bottomSpaceToView(_scrollView,0).heightIs(1);
    
}
//定位按钮
- (void)setupRightItem{
    
    UIBarButtonItem * titleItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(rightAction)];
    [titleItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12.]} forState:UIControlStateNormal];
    
    
    UIBarButtonItem * image = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ac_address"] style:UIBarButtonItemStylePlain target:self action:@selector(rightAction)];
    UIBarButtonItem * fix = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    fix.width = -20;
    self.navigationItem.rightBarButtonItems = @[image, titleItem];
    _titleItem = titleItem;
}

#pragma mark Action
- (void)hospitalAction{
    WS(ws);
    __weak typeof(self) weakSelf=self;
    [_presenter loadHospitalDataWith:^(BOOL complete) {
        if (complete == YES) {
            if(!self.hospitalMenu){
                
                [ws.hospitalArray removeAllObjects];
                for (HospitalEntity *entity in ws.presenter.hospitalArray) {
                    [ws.hospitalArray addObject:(entity.hName.length>0?entity.hName:@"")];
                }
                NSArray* array = self.hospitalArray;
                ws.hospitalMenu=[[JHCustomMenu alloc] initWithDataArr:array origin:CGPointMake(0, 50) width:kScreenWidth/2 rowHeight:37 rowNumber:10];
                ws.hospitalMenu.tableView.tag = 100;
                ws.hospitalMenu.delegate=ws;
                [ws.view addSubview:self.hospitalMenu];
                //科室菜单选项置空
                [ws.departmentButton setTitle:@"科室:" forState:UIControlStateNormal];
                ws.presenter.depart = nil;
                ws.hospitalMenu.dismiss=^(){
                    weakSelf.hospitalMenu=nil;
                };
            }else{
                [ws.hospitalMenu dismissWithCompletion:^(JHCustomMenu *object) {
                    weakSelf.hospitalMenu=nil;
                }];
            }
        }
    }];
}
- (void)departmentAction{
    WS(ws);
    __weak typeof(self) weakSelf=self;
    [_presenter loadDepartmentDataWith:^(BOOL complete) {
        if (complete == YES) {
            if (ws.presenter.departmentArray.count == 0) {
                [ProgressUtil showInfo:@"没有搜索到当前医院科室"];
                return ;
            }
            //科室数组
            [ws.departmentArray removeAllObjects];
            for (DepartmentEntity *entity in ws.presenter.departmentArray) {
                [ws.departmentArray addObject:entity.departName];
            }
            
            if(!ws.departmentMenu){
                NSArray* array = ws.departmentArray;
                ws.departmentMenu=[[JHCustomMenu alloc] initWithDataArr:array origin:CGPointMake(kScreenWidth/2, 50) width:kScreenWidth/2 rowHeight:37 rowNumber:10];
                ws.departmentMenu.delegate=ws;
                [ws.view addSubview:ws.departmentMenu];
                ws.departmentMenu.dismiss=^(){
                    weakSelf.departmentMenu=nil;
                };
            }else{
                [ws.departmentMenu dismissWithCompletion:^(JHCustomMenu *object) {
                    weakSelf.departmentMenu=nil;
                }];
            }
            
        }
    }];
}
#pragma mark JHCustomMenuDelegate
-(void)jhCustomMenu:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 100) {
        NSString *title = [NSString stringWithFormat:@"%@",self.hospitalMenu.arrData[indexPath.row]];
        [_hospitalButton setTitle:title forState:UIControlStateNormal];
        self.presenter.hospital = self.presenter.hospitalArray[indexPath.row];
    }else{
        NSString *title = [NSString stringWithFormat:@"%@",self.departmentMenu.arrData[indexPath.row]];
        [_departmentButton setTitle:title forState:UIControlStateNormal];
        
        self.presenter.depart = self.presenter.departmentArray[indexPath.row];
    }
    
}
#pragma mark ZHCityPickerDelegate
- (void)selected:(CityEntity *)city{
    //医院菜单置空
    [_hospitalButton setTitle:@"医院:" forState:UIControlStateNormal];
    _presenter.hospital = nil;
    [_titleItem setTitle:city.ssqName];
    self.presenter.hospital = nil;
    self.presenter.depart = nil;
}

//选择城市
- (void)rightAction{
    if (_address == NO) {
        [_presenter showPickerInView:self.view];
        _address = YES;
    }else{
        [_presenter dismissPicker];
        _address = NO;
    }
}
- (void)changeAddress{
    _address = NO;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"dismiss" object:nil];
}


//定位Action
- (void)location{
    WS(ws);
    [ProgressUtil showInfo:@"正在定位，请稍后"];
    [self.presenter locationWithBlock:^(NSString * province, NSString * city,NSString * longitude, NSString * latitude, BOOL success) {
        [ws.titleItem setTitle:city];
    }];
}


- (void)updateButtonStateWithTag:(NSInteger )tag{
    
    for (UIButton *bt in _buttonArray) {
        bt.selected = NO;
    }
    UIButton *selBt = ((UIButton *)_buttonArray[tag]);
    selBt.selected = YES;
}

#pragma mark 私有
- (NSDate *)dateAfterCurrentMonth:(NSInteger )integer{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = integer;
    NSDate *nextMonthDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:[NSDate date] options:NSCalendarMatchStrictly];
    return nextMonthDate;
}
-(NSDate *)getPriousDateFromDate:(NSDate *)date withDay:(int)Day
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:Day];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    return mDate;
}

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
@end
