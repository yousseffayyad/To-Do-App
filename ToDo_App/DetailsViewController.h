//
//  DetailsViewController.h
//  ToDo_App
//
//  Created by User on 07/05/2025.
//

#import <UIKit/UIKit.h>
#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController
@property (nonatomic, strong) Task *task;
@end

NS_ASSUME_NONNULL_END
