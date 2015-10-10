//
//  CityDetailedViewController.m
//  iProg1Lesson2Weather
//
//  Created by Nikolay Shubenkov on 10/10/15.
//  Copyright © 2015 Nikolay Shubenkov. All rights reserved.
//

#import "CityDetailedViewController.h"

@interface CityDetailedViewController ()
@property (weak, nonatomic) IBOutlet UILabel *temperature;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation CityDetailedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSAssert(self.city != nil, @"Не найдена модель. Не показать город((");
    self.title = self.city.name;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadWeatherForCity];
}

- (void)loadWeatherForCity {
    [self.activityIndicator startAnimating];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSString *cityAddress = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/city?q=%@&APPID=d83b07026d3cb020a744160a15bc36a8",self.city.name];
    NSURL *url = [NSURL URLWithString:cityAddress];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        id weatherInfo = [NSJSONSerialization JSONObjectWithData:data options:0 error:0];
        NSLog(@"response: %@",weatherInfo);
        [self parseData:weatherInfo];
        
    }] resume];
}

- (void)parseData:(NSDictionary *)data {
    NSArray *list = data[@"list"];
    NSDictionary *firstWatherElement = list.firstObject;
    
    NSString *date = firstWatherElement[@"dt_txt"];
    
    NSNumber *temperature = firstWatherElement[@"main"][@"temp"];
    double calculatedTemperature = [temperature doubleValue] - 273.0;
    temperature = @(calculatedTemperature);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.activityIndicator stopAnimating];
        self.activityIndicator.hidesWhenStopped = YES;
        
        self.date.text = date;
        self.temperature.text = [temperature stringValue];
    });    
}

@end
