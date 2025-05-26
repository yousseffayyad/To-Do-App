//
//  TaskManager.h
//  ToDo_App
//
//  Created by User on 06/05/2025.
//

#import <Foundation/Foundation.h>
#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@interface TaskManager : NSObject

@property (nonatomic, strong) NSMutableArray<Task *> *tasks;
+ (instancetype)sharedManager;
- (void)saveTask:(Task *)task;
- (void)removeTask:(Task *)task;
- (void)updateTask:(Task *)updatedTask;
- (NSArray<Task *> *)getAllTasks;
- (NSArray<Task *> *)getTasksByStatus:(NSString *)status;
- (void)saveTasks;
- (void)loadTasks;

@end

NS_ASSUME_NONNULL_END
