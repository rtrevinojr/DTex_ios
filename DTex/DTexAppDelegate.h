//
//  DTexAppDelegate.h
//  DTex
//
//  Created by Rene  Trevino Jr. on 10/16/14.
//  Copyright (c) 2014 CS378. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface DTexAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

// reference files for core data
- (NSURL *)applicationDocumentsDirectory;


@property (strong, nonatomic) UIWindow *window;

@end
