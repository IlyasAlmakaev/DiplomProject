//
//  WorkerViewController.h
//  NotifyAlert
//
//  Created by intent on 09/03/15.
//  Copyright (c) 2015 intent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface WorkerViewController : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong) NSManagedObject *worker;
@property (nonatomic) BOOL editWorker;

@end
