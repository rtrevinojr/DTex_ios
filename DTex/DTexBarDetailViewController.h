//
//  DTexBarDetailViewController.h
//  DTex
//
//  Created by Rene  Trevino Jr. on 10/17/14.
//  Copyright (c) 2014 CS378. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Parse/Parse.h> 

@interface DTexBarDetailViewController : UIViewController

@property (strong, nonatomic) PFObject * exam;

- (void) setBarName:(NSString*) name;

@end
