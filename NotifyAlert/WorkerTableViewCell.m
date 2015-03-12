//
//  WorkerTableViewCell.m
//  NotifyAlert
//
//  Created by intent on 12/03/15.
//  Copyright (c) 2015 intent. All rights reserved.
//

#import "WorkerTableViewCell.h"

@implementation WorkerTableViewCell

// Configure the cell
- (void)setup:(NSManagedObject *)worker
{
    [self.textLabel setText:[worker valueForKey:@"nameWorker"]];
    [self.detailTextLabel setText:[worker valueForKey:@"statusWorker"]];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
