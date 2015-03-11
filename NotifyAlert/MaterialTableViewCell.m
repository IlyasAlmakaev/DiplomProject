//
//  MaterialTableViewCell.m
//  NotifyAlert
//
//  Created by intent on 11/03/15.
//  Copyright (c) 2015 intent. All rights reserved.
//

#import "MaterialTableViewCell.h"


@implementation MaterialTableViewCell

// Configure the cell
- (void)setup:(NSManagedObject *)material
{
    [self.textLabel setText:[material valueForKey:@"nameMaterial"]];
    [self.detailTextLabel setText:[material valueForKey:@"countMaterial"]];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
