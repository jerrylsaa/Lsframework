//
//  JMDataPickerView.m
//  
//
//  Created by 梁继明 on 16/4/2.
//
//

#import "JMDataPickerView.h"
#import "JMDataCollectionViewCell.h"
#import "JMDataModel.h"

@implementation JMDataPickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
       
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
    }
    return self;
}

-(void)setType:(JMDATA_PICKER_TYPE)type{
    
    _type = type;
   [self setupView];

}


//获取周几；
-(NSInteger) getWeekIndex:(NSDate *)date{
    
    NSDate *confromTimesp = date;
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:confromTimesp];
    
    
    return theComponents.weekday;
    
}

//根据时间戳，获取时间；
-(NSString *) getStringFromDate:(NSTimeInterval )time andForm:(NSString *)formate{
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:time];
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:formate];
    
    return [formatter stringFromDate:confromTimesp];
    
    
}

//获取周几；
-(NSString *) getWeekStrIndex:(NSTimeInterval )time {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:time];
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:confromTimesp];
    
    return  [weekdays objectAtIndex:theComponents.weekday];
    
}


-(void)addForwardDate{
    
    JMDataModel* model = [self.dateArray firstObject];
    
    long dTime = [[NSNumber numberWithDouble:model.startTimeInterval]longValue];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:dTime];
    
    NSInteger weekDay  = [self getWeekIndex:confromTimesp];
    
    NSMutableArray *indexPathArray = [NSMutableArray array];
    
    
    if (self.type == JM_DAY) {
        
        dTime -= 60*60*24;
        
        
        for (int i = 0 ; i<10; i++) {
            
            JMDataModel *model = [[JMDataModel alloc] init];
            
            dTime -= 60*60*24;
            
            model.startTimeInterval = dTime;
            
            NSString *mmDate1 = [self getStringFromDate:dTime andForm:@"MM月dd日"];
            
            model.dateStr = [NSString stringWithFormat:@"%@\n%@",mmDate1,[self getWeekStrIndex:dTime]];
            
            [indexPathArray addObject:[NSIndexPath indexPathForItem:i inSection:0]];
            
            [self.dateArray insertObject:model atIndex:0];
            
        }
        
    }else{
        //去到每周的周日；
      //  dTime -= (weekDay - 0) * 60*60*24;
        
     //   dTime += 60*60*24*7;
        
        for (int i = 0 ; i<4; i++) {
            
            JMDataModel *model = [[JMDataModel alloc] init];
            
              dTime -= 60*60*24*7;
            
            model.startTimeInterval = dTime;
            
            NSString *mmDate1 = [self getStringFromDate:dTime - 60*60*24*6 andForm:@"MM月"];
            NSString *ddDate1 = [self getStringFromDate:dTime- 60*60*24*6 andForm:@"dd"];
            
            NSString *mmDate2 = [self getStringFromDate:dTime  andForm:@"MM月"];
            
            NSString *ddDate2 = [self getStringFromDate:dTime  andForm:@"dd"];
            
            
            if ([mmDate1 isEqualToString:mmDate2]) {
                
                model.dateStr = [NSString stringWithFormat:@"%@\n%@~%@",mmDate2,ddDate1,ddDate2];
                
            }else{
                
                model.dateStr = [NSString stringWithFormat:@"%@~%@\n%@~%@",mmDate1,mmDate2,ddDate1,ddDate2];
                
            }
            
            [indexPathArray addObject:[NSIndexPath indexPathForItem:i inSection:0]];
            
            [self.dateArray insertObject:model atIndex:0];
            
          
            
            
        }
        
    }
    
    [self.myCollectionView insertItemsAtIndexPaths:indexPathArray];

  
    

    
   }

-(void)addBackwardDate{
    
   
    JMDataModel* model = [self.dateArray lastObject];
  
    
    long dTime = [[NSNumber numberWithDouble:model.startTimeInterval]longValue];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:dTime];
    
    NSInteger weekDay  = [self getWeekIndex:confromTimesp];
    
    NSMutableArray *indexPathArray = [NSMutableArray array];
    
    if (self.type == JM_DAY) {
        
        dTime += 60*60*24;
        
        
        for (int i = 0 ; i<10; i++) {
            
            JMDataModel *model = [[JMDataModel alloc] init];
            
            dTime += 60*60*24;
            
            model.startTimeInterval = dTime;
          
            NSString *mmDate1 = [self getStringFromDate:dTime andForm:@"MM月dd日"];
            
            model.dateStr = [NSString stringWithFormat:@"%@\n%@",mmDate1,[self getWeekStrIndex:dTime]];
            
            [indexPathArray addObject:[NSIndexPath indexPathForItem:self.dateArray.count inSection:0]];
            
            [self.dateArray addObject:model];
            
        }
        
    }else{
    
        //去到每周的周日；
        dTime -= (weekDay - 0) * 60*60*24;
        
        dTime += 60*60*24*7;
        
        
        for (int i = 0 ; i<4; i++) {
            
            JMDataModel *model = [[JMDataModel alloc] init];
            
            dTime += 60*60*24*7;
            
            model.startTimeInterval = dTime;
            
            NSString *mmDate1 = [self getStringFromDate:dTime andForm:@"MM月"];
            NSString *ddDate1 = [self getStringFromDate:dTime andForm:@"dd"];
            
            NSString *mmDate2 = [self getStringFromDate:dTime + 60*60*24*6 andForm:@"MM月"];
            
            NSString *ddDate2 = [self getStringFromDate:dTime+ 60*60*24*6 andForm:@"dd"];
            
            if ([mmDate1 isEqualToString:mmDate2]) {
                
                model.dateStr = [NSString stringWithFormat:@"%@\n%@~%@",mmDate1,ddDate1,ddDate2];
                
            }else{
                
                model.dateStr = [NSString stringWithFormat:@"%@~%@\n%@~%@",mmDate1,mmDate2,ddDate1,ddDate2];
                
            }
            
            [indexPathArray addObject:[NSIndexPath indexPathForItem:self.dateArray.count inSection:0]];
            
            [self.dateArray addObject:model];
            
        }
        
    }
    
    [self.myCollectionView performBatchUpdates:^{
     
        [self.myCollectionView insertItemsAtIndexPaths:indexPathArray];
        
    } completion:^(BOOL finished) {
        
    }];
   
}


-(void)addData{

    NSTimeInterval    dTime = [[NSDate date] timeIntervalSince1970];
    // long dTime = [[NSNumber numberWithDouble:model.startTimeInterval]longValue];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:dTime];
    
    NSInteger weekDay  = [self getWeekIndex:confromTimesp];
    
    
    if (self.type == JM_DAY) {
        
        dTime -= 60*60*24*5;
        
        
        for (int i = 0 ; i<10; i++) {
            
            JMDataModel *model = [[JMDataModel alloc] init];
            
            dTime += 60*60*24;
            
            model.startTimeInterval = dTime;
            
            NSString *mmDate1 = [self getStringFromDate:dTime andForm:@"MM月dd日"];
            
            model.dateStr = [NSString stringWithFormat:@"%@\n%@",mmDate1,[self getWeekStrIndex:dTime]];
            [self.dateArray addObject:model];
            
        }
        
        [self.myCollectionView reloadData];
        
        [self.myCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:4 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionLeft];
        
        if (self.block) {
            
            JMDataModel *model = [self.dateArray objectAtIndex:4];
            
            self.block(model);
        }
        
     
        
        
    }else{
        //去到每周的周日；
        dTime -= (weekDay - 1) * 60*60*24;
        
         dTime -= 60*60*24*7*2;
        
        for (int i = 0 ; i<4; i++) {
            
            JMDataModel *model = [[JMDataModel alloc] init];
            
            dTime += 60*60*24*7;
            
            model.startTimeInterval = dTime;
            
            NSString *mmDate1 = [self getStringFromDate:dTime andForm:@"MM月"];
            NSString *ddDate1 = [self getStringFromDate:dTime andForm:@"dd"];
            
            NSString *mmDate2 = [self getStringFromDate:dTime + 60*60*24*6 andForm:@"MM月"];
            
            NSString *ddDate2 = [self getStringFromDate:dTime+ 60*60*24*6 andForm:@"dd"];
            
            if ([mmDate1 isEqualToString:mmDate2]) {
                
                model.dateStr = [NSString stringWithFormat:@"%@\n%@~%@",mmDate1,ddDate1,ddDate2];
                
            }else{
                
                model.dateStr = [NSString stringWithFormat:@"%@~%@\n%@~%@",mmDate1,mmDate2,ddDate1,ddDate2];
                
            }
            
            [self.dateArray addObject:model];
            
        }
        
        [self.myCollectionView reloadData];
        
          [self.myCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionLeft];
        
        if (self.block) {
            
            JMDataModel *model = [self.dateArray objectAtIndex:1];
            
            self.block(model);
        }
        

        
    }
    
 
}



-(void)setupView{

    self.myCollectionView.delegate = self;
    
    self.myCollectionView.dataSource = self;
    
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"JMDataCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    [self addData];
    

}

#pragma mark---scrollView的两个代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float offset = scrollView.contentOffset.x;
    offset = offset/CGRectGetWidth(scrollView.frame);
    // [self.itemControlView moveToIndex:offset];
    
    NSLog(@"%.2f",offset);
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float offset = scrollView.contentOffset.x;
    
    NSLog(@"%.2f",offset);
    
    if (offset < 0.3) {
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self addForwardDate];
            
        });
        
    }
    
}

#pragma mark - collection view 

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.dateArray.count;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{

    return 1.0f;

}


-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{

    return 1.0f;
}


-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.item == self.dateArray.count -2) {
        [self addBackwardDate];
        
    }

}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    JMDataCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    UIView *selectedView = [UIView new];
    
   // selectedView.backgroundColor = COLOR_52CCD6;
    selectedView.backgroundColor = RGB(116, 204, 237);

    cell.selectedBackgroundView = selectedView;
    
    cell.dateModel = [self.dateArray objectAtIndex:indexPath.item];
    

    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    JMDataModel *model = [self.dateArray objectAtIndex:indexPath.item];
    
    if (self.block) {
        
        self.block(model);
        
    }


}


#pragma mark - lazy load

-(UICollectionView *)myCollectionView{
    
    if (!_myCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        layout.itemSize = CGSizeMake(75, 50);
        
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        
        [self addSubview:_myCollectionView];
        
        _myCollectionView.showsHorizontalScrollIndicator = NO;
        
        _myCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[_myCollectionView]-(0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self,_myCollectionView)]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[_myCollectionView]-(0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self,_myCollectionView)]];
        
        _myCollectionView.backgroundColor = [UIColor whiteColor];
    }
    
    return _myCollectionView;
    
    
}

-(NSMutableArray *)dateArray{

    if (!_dateArray) {
        
        _dateArray = [NSMutableArray array];
        
        
    }
    
    return _dateArray;

}



@end
