//
//  NotifyData.h
//  NotifyAlert
//
//  Created by intent on 10/03/15.
//  Copyright (c) 2015 intent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NotifyData : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * descript;
@property (nonatomic, retain) NSString * worker;
@property (nonatomic, retain) NSString * material;

@end
