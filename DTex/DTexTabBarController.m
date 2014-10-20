//
//  DTexTabBarController.m
//  DTex
//
//  Created by Christopher Martin on 10/20/14.
//  Copyright (c) 2014 CS378. All rights reserved.
//

#import "DTexTabBarController.h"

@implementation DTexTabBarController

- (void)viewDidLoad
{    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:174.0f/255.0f green:75.0f/255.0f blue:18.0f/255.0f alpha:1.0f]} forState:UIControlStateSelected];
    [[UITabBar appearance] setSelectedImageTintColor: [UIColor colorWithRed:174.0f/255.0f green:75.0f/255.0f blue:18.0f/255.0f alpha:1.0f]];
}

@end
