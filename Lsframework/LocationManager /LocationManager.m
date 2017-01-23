//
//  LocationManager.m
//  FamilyPlatForm
//
//  Created by Tom on 16/4/11.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "LocationManager.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationManager()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager * locationManager;
@property (nonatomic, copy) LocationManagerBlcok block;


@end

@implementation LocationManager

+ (instancetype)shareInstance {
    static LocationManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [LocationManager new];
    });
    
    return _instance;
}


- (instancetype)init{
    if (self) {
        
        // 判断定位操作是否被允许
        if([CLLocationManager locationServicesEnabled]) {
            [self initLocation];
            
            [self startUpdateLocation];
            
        }
    }
    
    return self;
}

-(void)initLocation{
    //定位初始化
    _locationManager=[[CLLocationManager alloc] init];
    _locationManager.delegate=self;
    _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    _locationManager.distanceFilter=10;
    if (iOS8_OR_LATER) {
        [_locationManager requestWhenInUseAuthorization];//使用程序其间允许访问位置数据（iOS8定位需要）
        [_locationManager requestAlwaysAuthorization];
    }
}

-(void)startUpdateLocation{
    NSLog(@"开始定位");
    [_locationManager startUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{

    switch (status) {

        casekCLAuthorizationStatusNotDetermined:

            if ([_locationManager  respondsToSelector:@selector(requestAlwaysAuthorization)]) {

                [_locationManager requestWhenInUseAuthorization];
                

            }

            break;



        default:

            break;

    }

}

-(void)getProvinceAndCityWithBlock:(LocationManagerBlcok)block{
    _block = [block copy];
    
    if (![CLLocationManager locationServicesEnabled]) {
        //提示用户无法进行定位操作
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位不成功 ,请确认开启定位" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        NSLog(@"定位没有开启");
        _block(nil, nil,nil, nil, NO);
    }else{
        [self startUpdateLocation];
    }
    
}
#pragma mark - CoreLocation Delegate

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"定位失败：%@", error.localizedDescription);
    _block(@"",@"",@"",@"",NO);
    [manager stopUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    if (locations.count > 0) {
        CLLocation *currentLocation = [locations lastObject];
        // 获取当前所在的城市名
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        //根据经纬度反向地理编译出地址信息
        [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error){
            if (array.count > 0){
                CLPlacemark *placemark = [array objectAtIndex:0];
                //NSLog(@%@,placemark.name);//具体位置
                //获取城市
                NSString *city = placemark.locality;
                if (!city) {
                    //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                    city = placemark.administrativeArea;
                }
                NSString* province = placemark.administrativeArea;
                
                //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
                [manager stopUpdatingLocation];
                NSString  *longitude = [NSString  stringWithFormat:@"%lf",currentLocation.coordinate.longitude];
                NSString  *latitude= [NSString  stringWithFormat:@"%lf",currentLocation.coordinate.latitude];
                NSLog(@"获取省份%@，城市%@", province, city);
                if (_block){
                    NSLog(@"定位回调");
                    _block(province, city,longitude,latitude, YES);
                    _block = nil;
                }
            }else if (error == nil && [array count] == 0){
                //            if (_block)_block(nil, nil, NO);
                NSLog(@"定位失败");
            }else if (error != nil){
                //            if (_block)_block(nil, nil, NO);
                NSLog(@"定位失败");
            }
            
        }];

    }
}

@end
