//
//  TaskTableViewCell.h
//  ToDo_App
//
//  Created by User on 07/05/2025.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TaskTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *taskTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *taskDateLabel;

@property (weak, nonatomic) IBOutlet UIImageView *taskImage;

@property (weak, nonatomic) IBOutlet UIImageView *priorityImage;


@end

NS_ASSUME_NONNULL_END
