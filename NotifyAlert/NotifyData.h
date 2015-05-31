//
//  NotifyData.h
//  NotifyAlert
//
//  Created by intent on 31/05/15.
//  Copyright (c) 2015 intent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MaterialData, WorkerData;

@interface NotifyData : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * descript;
@property (nonatomic, retain) NSSet *materialData;
@property (nonatomic, retain) NSSet *workerData;
@end

@interface NotifyData (CoreDataGeneratedAccessors)

- (void)addMaterialDataObject:(MaterialData *)value;
- (void)removeMaterialDataObject:(MaterialData *)value;
- (void)addMaterialData:(NSSet *)values;
- (void)removeMaterialData:(NSSet *)values;

- (void)addWorkerDataObject:(WorkerData *)value;
- (void)removeWorkerDataObject:(WorkerData *)value;
- (void)addWorkerData:(NSSet *)values;
- (void)removeWorkerData:(NSSet *)values;

@end
