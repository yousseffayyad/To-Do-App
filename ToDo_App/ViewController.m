
#import "ViewController.h"
#import "Task.h"
#import "TaskTableViewCell.h"
#import "AddViewController.h"
#import "TaskManager.h"
#import "DetailsViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *todoTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property NSMutableArray<Task *> *highPriorityTasks;
@property NSMutableArray<Task *> *mediumPriorityTasks;
@property NSMutableArray<Task *> *lowPriorityTasks;
@property NSMutableArray<Task *> *filteredHighPriorityTasks;
@property NSMutableArray<Task *> *filteredMediumPriorityTasks;
@property NSMutableArray<Task *> *filteredLowPriorityTasks;
@property BOOL isFiltering;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.todoTableView.delegate = self;
    self.todoTableView.dataSource = self;
    self.searchBar.delegate = self;
    
    //self.searchBar.showsCancelButton = YES;

    
    self.todoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.todoTableView.separatorInset = UIEdgeInsetsZero;
    self.todoTableView.layoutMargins = UIEdgeInsetsZero;

    
    self.highPriorityTasks = [NSMutableArray array];
    self.mediumPriorityTasks = [NSMutableArray array];
    self.lowPriorityTasks = [NSMutableArray array];
    
    self.filteredHighPriorityTasks = [NSMutableArray array];
    self.filteredMediumPriorityTasks = [NSMutableArray array];
    self.filteredLowPriorityTasks = [NSMutableArray array];
    self.isFiltering = NO;

    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
        initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                              target:self
                              action:@selector(navigateToAddScreen)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.text = @"ToDo";
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textColor = [UIColor systemBlueColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    TaskManager *manager = [TaskManager sharedManager];
    NSArray<Task *> *allTasks = [manager getAllTasks];
    
    [self.highPriorityTasks removeAllObjects];
    [self.mediumPriorityTasks removeAllObjects];
    [self.lowPriorityTasks removeAllObjects];
    
    for (Task *task in allTasks) {
        if ([task.taskStatus isEqualToString:@"ToDo"]) {
            if (task.taskPriority == 0) {
                [self.highPriorityTasks addObject:task];
            } else if (task.taskPriority == 1) {
                [self.mediumPriorityTasks addObject:task];
            } else if (task.taskPriority == 2) {
                [self.lowPriorityTasks addObject:task];
            }
        }
    }

    
    [self.todoTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isFiltering) {
        switch (section) {
            case 0: return self.filteredHighPriorityTasks.count;
            case 1: return self.filteredMediumPriorityTasks.count;
            case 2: return self.filteredLowPriorityTasks.count;
        }
    } else {
        switch (section) {
            case 0: return self.highPriorityTasks.count;
            case 1: return self.mediumPriorityTasks.count;
            case 2: return self.lowPriorityTasks.count;
        }
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"TaskCell";
    TaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TaskTableViewCell" owner:self options:nil];
        cell = [nib firstObject];
    }

    Task *task;
    if (self.isFiltering) {
        switch (indexPath.section) {
            case 0: task = self.filteredHighPriorityTasks[indexPath.row]; break;
            case 1: task = self.filteredMediumPriorityTasks[indexPath.row]; break;
            case 2: task = self.filteredLowPriorityTasks[indexPath.row]; break;
        }
    } else {
        switch (indexPath.section) {
            case 0: task = self.highPriorityTasks[indexPath.row]; break;
            case 1: task = self.mediumPriorityTasks[indexPath.row]; break;
            case 2: task = self.lowPriorityTasks[indexPath.row]; break;
        }
    }


    cell.taskTitleLabel.text = task.taskName;
    cell.taskDateLabel.text = [NSString stringWithFormat:@"%@", task.taskDate];
    cell.taskImage.image = [UIImage systemImageNamed:@"chevron.right"];
    cell.taskImage.tintColor = [UIColor systemBlueColor];
    
    if (task.taskPriority == 0) {
        cell.priorityImage.image = [UIImage imageNamed:@"high"];
    } else if (task.taskPriority == 1) {
        cell.priorityImage.image = [UIImage imageNamed:@"medium"];
    } else {
        cell.priorityImage.image = [UIImage imageNamed:@"low"];
    }


    cell.backgroundColor = UIColor.clearColor;
    cell.contentView.backgroundColor = UIColor.whiteColor;
    
    cell.contentView.layer.cornerRadius = 32;
    cell.contentView.layer.masksToBounds = YES;


    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *spacer = [UIView new];
    spacer.backgroundColor = [UIColor blueColor];
    return spacer;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"High Priority";
        case 1:
            return @"Medium Priority";
        case 2:
            return @"Low Priority";
        default:
            return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
     headerView.backgroundColor = [UIColor clearColor];

     UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, tableView.frame.size.width - 30, 25)];
     headerLabel.font = [UIFont boldSystemFontOfSize:18];
     headerLabel.backgroundColor = [UIColor clearColor];
    
    switch (section) {
        case 0:
            headerLabel.text = @"High Priority";
            headerLabel.textColor = [UIColor systemRedColor];
            break;
        case 1:
            headerLabel.text = @"Medium Priority";
            headerLabel.textColor = [UIColor systemOrangeColor];
            break;
        case 2:
            headerLabel.text = @"Low Priority";
            headerLabel.textColor = [UIColor systemGreenColor];
            break;
        default:
            headerLabel.text = @"";
            headerLabel.textColor = [UIColor blackColor];
            break;
    }
    [headerView addSubview:headerLabel];
    return headerView;
}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Delete";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete Task"
            message:@"Are you sure you want to delete this task?"
            preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete"
        style:UIAlertActionStyleDestructive
        handler:^(UIAlertAction * _Nonnull action) {
            Task *taskToDelete = nil;

            switch (indexPath.section) {
                case 0:
                    taskToDelete = self.highPriorityTasks[indexPath.row];
                    [self.highPriorityTasks removeObjectAtIndex:indexPath.row];
                    break;
                case 1:
                    taskToDelete = self.mediumPriorityTasks[indexPath.row];
                    [self.mediumPriorityTasks removeObjectAtIndex:indexPath.row];
                    break;
                case 2:
                    taskToDelete = self.lowPriorityTasks[indexPath.row];
                    [self.lowPriorityTasks removeObjectAtIndex:indexPath.row];
                    break;
            }

            TaskManager *manager = [TaskManager sharedManager];
            [manager removeTask:taskToDelete];

            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];

        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                               style:UIAlertActionStyleCancel
                                                             handler:nil];

        [alert addAction:deleteAction];
        [alert addAction:cancelAction];

        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Task *selectedTask;
    
    if (self.isFiltering) {
        switch (indexPath.section) {
            case 0:
                selectedTask = self.filteredHighPriorityTasks[indexPath.row];
                break;
            case 1:
                selectedTask = self.filteredMediumPriorityTasks[indexPath.row];
                break;
            case 2:
                selectedTask = self.filteredLowPriorityTasks[indexPath.row];
                break;
        }
    } else {
        switch (indexPath.section) {
            case 0:
                selectedTask = self.highPriorityTasks[indexPath.row];
                break;
            case 1:
                selectedTask = self.mediumPriorityTasks[indexPath.row];
                break;
            case 2:
                selectedTask = self.lowPriorityTasks[indexPath.row];
                break;
        }
    }
    [self navigateToTaskDetails:selectedTask];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)navigateToAddScreen {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddViewController *addVC = [storyboard instantiateViewControllerWithIdentifier:@"addTask"];
    
    addVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:addVC animated:YES];
}

- (void)navigateToTaskDetails:(Task *)selectedTask {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailsViewController *detailVC = [storyboard instantiateViewControllerWithIdentifier:@"detailsTask"];
    
    detailVC.task = selectedTask;

    [self.navigationController pushViewController:detailVC animated:YES];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSString *trimmedText = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    self.isFiltering = trimmedText.length > 0;

    [self.filteredHighPriorityTasks removeAllObjects];
    [self.filteredMediumPriorityTasks removeAllObjects];
    [self.filteredLowPriorityTasks removeAllObjects];

    if (self.isFiltering) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"taskName CONTAINS[cd] %@", searchText];

        [self.filteredHighPriorityTasks addObjectsFromArray:[self.highPriorityTasks filteredArrayUsingPredicate:predicate]];
        [self.filteredMediumPriorityTasks addObjectsFromArray:[self.mediumPriorityTasks filteredArrayUsingPredicate:predicate]];
        [self.filteredLowPriorityTasks addObjectsFromArray:[self.lowPriorityTasks filteredArrayUsingPredicate:predicate]];
    }

    [self.todoTableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.isFiltering = NO;
    [self.searchBar resignFirstResponder];
    [self.todoTableView reloadData];
}


@end
