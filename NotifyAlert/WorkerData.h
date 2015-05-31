//
//  WorkerData.h
//  NotifyAlert
//
//  Created by intent on 31/05/15.
//  Copyright (c) 2015 intent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NotifyData;

@interface WorkerData : NSManagedObject

@property (nonatomic, retain) NSString * nameWorker;
@property (nonatomic, retain) NSString * statusWorker;
@property (nonatomic, retain) NotifyData *taskWorker;

@end
