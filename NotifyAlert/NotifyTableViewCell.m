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
    // REVIEW Использовать timeRemind, ведь это та же переменная.
    // ANSWER Убрал timeRemind, всвязи с ненадобностью.
    [self.dateRemind setText:string];
    
    NSString *repeat = [notification valueForKey:@"worker"];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
