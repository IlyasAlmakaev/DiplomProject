//
//  WorkerData.h
//  NotifyAlert
//
//  Created by intent on 12/03/15.
//  Copyright (c) 2015 intent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface WorkerData : NSManagedObject

@property (nonatomic, retain) NSString * nameWorker;
@property (nonatomic, retain) NSString * statusWorker;

@end
