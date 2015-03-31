//
//  DTexTabBarViewController.m
//  DTex
//
//  Created by Rene  Trevino Jr. on 10/21/14.
//  Copyright (c) 2014 CS378. All rights reserved.
//

#import "DTexTabBarViewController.h"

@interface DTexTabBarViewController ()

@end

@implementation DTexTabBarViewController

- (void)viewDidLoad
{
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:174.0f/255.0f green:75.0f/255.0f blue:18.0f/255.0f alpha:1.0f]} forState:UIControlStateSelected];
    
    [[UITabBar appearance] setSelectedImageTintColor: [UIColor colorWithRed:174.0f/255.0f green:75.0f/255.0f blue:18.0f/255.0f alpha:1.0f]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
