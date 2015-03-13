//
//  NotifyTableViewCell.m
//  NotifyAlert
//
//  Created by intent on 30/01/15.
//  Copyright (c) 2015 intent. All rights reserved.
//

#import "NotifyTableViewCell.h"

@interface NotifyTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameRemind;
@property (weak, nonatomic) IBOutlet UILabel *dateRemind;
@property (weak, nonatomic) IBOutlet UILabel *workerRemind;
@property (weak, nonatomic) IBOutlet UILabel *materialRemind;

@end

@implementation NotifyTableViewCell

// Configure the cell
- (void)setup:(NSManagedObject *)notification
{
    [self.nameRemind setText:[notification valueForKey:@"descript"]];
    
    // DateFormat
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"HH:mm / dd.MM.yy"];
    NSString *string = [format stringFromDate:[notification valueForKey:@"date"]];
    [self.dateRemind setText:string];
    
    [self.workerRemind setText:[notification valueForKey:@"worker"]];
    [self.materialRemind setText:[notification valueForKey:@"material"]];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
