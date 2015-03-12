//
//  AppDelegate.h
//  NotifyAlert
//
//  Created by intent on 29/01/15.
//  Copyright (c) 2015 intent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController    *tabController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) NSArray *localNotifications;
- (void)deleteNotification:(NSDate *)notificationDate name:(NSString *)notificationName;

    // Go to page Add/Edit notify
- (void)addObject:(NSManagedObject *)managedObject
       controller:(UITableViewController *)tableVC
         testBool:(BOOL)boolValue;

    // Go to page Add/Edit material
- (void)addObjectMaterial:(NSManagedObject *)managedObject
       controller:(UITableViewController *)tableVC
         testBool:(BOOL)boolValue;

// Go to page Add/Edit worker
- (void)addObjectWorker:(NSManagedObject *)managedObject
               controller:(UITableViewController *)tableVC
                 testBool:(BOOL)boolValue;

- (void)dateField:(NSDate *)dateNotify
        nameField:(NSString *)nameNotify
      repeatField:(NSString *)repeatNotify;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (NSManagedObjectContext *)managedOC;
- (NSManagedObjectContext *)managedOCTable;
- (NSManagedObjectContext *)managedOCMaterial;
- (NSManagedObjectContext *)managedOCTableMaterial;
- (NSManagedObjectContext *)managedOCWorker;
- (NSManagedObjectContext *)managedOCTableWorker;

@end

