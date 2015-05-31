//
//  MaterialData.h
//  NotifyAlert
//
//  Created by intent on 31/05/15.
//  Copyright (c) 2015 intent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NotifyData;

@interface MaterialData : NSManagedObject

@property (nonatomic, retain) NSNumber * countMaterial;
@property (nonatomic, retain) NSString * nameMaterial;
@property (nonatomic, retain) NotifyData *taskMaterial;

@end
