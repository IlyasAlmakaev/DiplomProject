//
//  WorkerTableViewCell.h
//  NotifyAlert
//
//  Created by intent on 12/03/15.
//  Copyright (c) 2015 intent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkerTableViewController.h"

@interface WorkerTableViewCell : UITableViewCell

- (void)setup:(NSManagedObject *)worker;

@end
