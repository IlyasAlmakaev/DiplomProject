//
//  NotifyViewController.h
//  NotifyAlert
//
//  Created by intent on 29/01/15.
//  Copyright (c) 2015 intent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
// REVIEW Зачем?
// ANSWER Для связи с NSManagedObject, функцией удаления.

@interface NotifyViewController : UIViewController
// REVIEW Список реализуемых протоколов перенести в файл реализации.
// REVIEW Заменить на property в файле реализации.
@property (strong) NSManagedObject *notify;
@property (nonatomic) BOOL edit;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

// REVIE Перенести все свойства, что можно, в файл реализации.
// ANSWER Оставил публичные свойства.
@end
