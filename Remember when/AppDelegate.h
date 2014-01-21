//
//  AppDelegate.h
//  Remember when
//
//  Created by René Fernández on 10/02/13.
//  Copyright (c) 2013 René Fernández. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "CoreDataManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
