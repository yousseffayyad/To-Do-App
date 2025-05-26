//
//  Task.h
//  ToDo_App
//
//  Created by User on 07/05/2025.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Task : NSObject <NSSecureCoding>

@property NSString *taskName;
@property NSString *taskDescription;
@property int taskPriority;
@property NSString *taskDate;
@property NSString *taskTime;
@property NSString *taskStatus;

- (instancetype)initWithTaskName:(NSString *)taskName
                 taskDescription:(NSString *)taskDescription
                     taskPriority:(int)taskPriority
                        taskDate:(NSString *)taskDate
                        taskTime:(NSString *)taskTime
                     taskStatus:(NSString *)taskStatus;

@end

NS_ASSUME_NONNULL_END
