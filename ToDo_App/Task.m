#import "Task.h"

@implementation Task

static NSString * const TaskNameKey = @"taskName";
static NSString * const TaskDescriptionKey = @"taskDescription";
static NSString * const TaskPriorityKey = @"taskPriority";
static NSString * const TaskDateKey = @"taskDate";
static NSString * const TaskTimeKey = @"taskTime";
static NSString * const TaskStatusKey = @"taskStatus";

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)initWithTaskName:(NSString *)taskName
                  taskDescription:(NSString *)taskDescription
                      taskPriority:(int)taskPriority
                         taskDate:(NSString *)taskDate
                         taskTime:(NSString *)taskTime
                      taskStatus:(NSString *)taskStatus {
    self = [super init];
    if (self) {
        _taskName = taskName;
        _taskDescription = taskDescription;
        _taskPriority = taskPriority;
        _taskDate = taskDate;
        _taskTime = taskTime;
        _taskStatus = taskStatus;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.taskName forKey:TaskNameKey];
    [coder encodeObject:self.taskDescription forKey:TaskDescriptionKey];
    [coder encodeInt:self.taskPriority forKey:TaskPriorityKey];
    [coder encodeObject:self.taskDate forKey:TaskDateKey];
    [coder encodeObject:self.taskTime forKey:TaskTimeKey];
    [coder encodeObject:self.taskStatus forKey:TaskStatusKey];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    NSString *taskName = [coder decodeObjectOfClass:[NSString class] forKey:TaskNameKey];
    NSString *taskDescription = [coder decodeObjectOfClass:[NSString class] forKey:TaskDescriptionKey];
    int taskPriority = [coder decodeIntForKey:TaskPriorityKey];
    NSString *taskDate = [coder decodeObjectOfClass:[NSString class] forKey:TaskDateKey];
    NSString *taskTime = [coder decodeObjectOfClass:[NSString class] forKey:TaskTimeKey];
    NSString *taskStatus = [coder decodeObjectOfClass:[NSString class] forKey:TaskStatusKey];

    return [self initWithTaskName:taskName
                  taskDescription:taskDescription
                      taskPriority:taskPriority
                         taskDate:taskDate
                         taskTime:taskTime
                      taskStatus:taskStatus];
}

@end
