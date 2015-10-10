//
//  CitiesTableViewController.m
//  iProg1Lesson2Weather
//
//  Created by Nikolay Shubenkov on 10/10/15.
//  Copyright © 2015 Nikolay Shubenkov. All rights reserved.
//

#import "CitiesTableViewController.h"

#import "CityDetailedViewController.h"

#import "City.h"

@interface CitiesTableViewController ()

@property (nonatomic, strong) NSArray *cities;

@end

@implementation CitiesTableViewController

- (IBAction)addCity:(UIBarButtonItem *)sender {
    //Создадив всплывающий на экран контроллер
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Добавление города"
                                                                        message:nil
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    //добавим туда поле для ввода названия города
    [controller addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        //Перед добавлением, можно настроить это поле для ввода как угодно
       textField.placeholder = @"Мой город";
    }];
    
    /**
     *  Добавим  кнопку
     */
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Добавить"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       //если кнопку нажали, то будет запущен этот код
                                                       //считать перое поле для ввода
                                                       UITextField *textField = [controller.textFields firstObject];
                                                       //передать из поля для ввода текст в качестве названия города
                                                       [self addCityWithName:textField.text];
                                                   }];
    //Добавим на контроллер кнопку действия
    [controller addAction:action];
    
    //выведем контроллер на экран
    [self presentViewController:controller animated:YES completion:nil];
}

//Модифицируйте этот метод, чтобы добавлялся город с именем из переменной 'name'
- (void)addCityWithName:(NSString *)name {
    //1. Создадим город с некоторым названием
    City *aCity = [City new];
    aCity.name = name;
    //2. добавим его в массив
    self.cities = [self.cities arrayByAddingObject:aCity];
    //3. обновим tableView
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cities = [NSArray new];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CityCellID"];
    City *aCity = self.cities[indexPath.row];
    
    //Настройте ячейку в соответствии с названием города
    cell.textLabel.text = aCity.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    City *selectedCity = self.cities[indexPath.row];
    
    //начать переход на другой вьюконтроллер и послать вдогонку город
    [self performSegueWithIdentifier:@"Show City" sender:selectedCity];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //Проверим название перехода
    if ([segue.identifier isEqualToString:@"Show City"]){
        City *cityToPresent = sender;
        CityDetailedViewController *controller = segue.destinationViewController;
        
        controller.city = cityToPresent;
    }
}


















@end
