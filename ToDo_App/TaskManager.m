#import "TaskManager.h"

static NSString * const TASKS_KEY = @"tasks";

@implementation TaskManager

+ (instancetype)sharedManager {
    static TaskManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _tasks = [NSMutableArray array];
        [self loadTasks];
    }
    return self;
}

- (void)saveTask:(Task *)task {
    [self.tasks addObject:task];
    [self saveTasks];
}

- (void)removeTask:(Task *)task {
    [self.tasks removeObject:task];
    [self saveTasks];
}

- (void)updateTask:(Task *)updatedTask {
    NSUInteger index = [self.tasks indexOfObjectPassingTest:^BOOL(Task *task, NSUInteger idx, BOOL *stop) {
        return [task.taskName isEqualToString:updatedTask.taskName];
    }];
    
    if (index != NSNotFound) {
        self.tasks[index] = updatedTask;
        [self saveTasks];
    }
}


- (NSArray<Task *> *)getAllTasks {
    return [self.tasks copy];
}

- (NSArray<Task *> *)getTasksByStatus:(NSString *)status {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"taskStatus == %@", status];
    return [self.tasks filteredArrayUsingPredicate:predicate];
}

- (void)saveTasks {
    NSMutableArray *taskData = [NSMutableArray array];
    for (Task *task in self.tasks) {
        NSData *encodedTask = [NSKeyedArchiver archivedDataWithRootObject:task requiringSecureCoding:YES error:nil];
        [taskData addObject:encodedTask];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:taskData forKey:TASKS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadTasks {
    NSArray *savedTaskData = [[NSUserDefaults standardUserDefaults] objectForKey:TASKS_KEY];
    if (savedTaskData) {
        [self.tasks removeAllObjects];
        for (NSData *taskData in savedTaskData) {
            Task *decodedTask = [NSKeyedUnarchiver unarchivedObjectOfClass:[Task class] fromData:taskData error:nil];
            [self.tasks addObject:decodedTask];
        }
    }
}

@end
