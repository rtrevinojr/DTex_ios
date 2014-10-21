//
//  DTexBarEventsTableViewController.h
//  DTex
//
//  Created by Rene  Trevino Jr. on 10/17/14.
//  Copyright (c) 2014 CS378. All rights reserved.
//

#import <Parse/Parse.h>

@interface DTexBarEventsTableViewController : PFQueryTableViewController

@property (strong, nonatomic) PFObject * object;

- (void) setBarSelection:(NSString*)name;


@end
