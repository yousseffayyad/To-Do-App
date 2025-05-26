//
//  TaskTableViewCell.m
//  ToDo_App
//
//  Created by User on 07/05/2025.
//

#import "TaskTableViewCell.h"

@implementation TaskTableViewCell

- (void)awakeFromNib {

    [super awakeFromNib];
    
    
    self.preservesSuperviewLayoutMargins = NO;
    self.layoutMargins = UIEdgeInsetsZero;
    self.separatorInset = UIEdgeInsetsZero;
    
}

@end
