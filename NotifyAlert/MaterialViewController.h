//
//  MaterialViewController.h
//  NotifyAlert
//
//  Created by intent on 09/03/15.
//  Copyright (c) 2015 intent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface MaterialViewController : UIViewController

@property (strong) NSManagedObject *material;
@property (nonatomic) BOOL editMaterial;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
