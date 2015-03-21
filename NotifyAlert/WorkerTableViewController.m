//
//  WorkerTableViewController.m
//  NotifyAlert
//
//  Created by intent on 09/03/15.
//  Copyright (c) 2015 intent. All rights reserved.
//

#import "WorkerTableViewController.h"
#import "WorkerTableViewCell.h"
#import "Common.h"


@interface WorkerTableViewController ()

@property (strong, nonatomic) AppDelegate *appD;

@property (strong, nonatomic) NSMutableArray *workers;
@property (strong, nonatomic) Common *com;

@end

@implementation WorkerTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        self.navigationItem.title = NSLocalizedString(@"WorkerTableView_Title", nil);
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                               target:self
                                                                                               action:@selector(addWorker)];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.appD = [[AppDelegate alloc] init];
    self.com = [[Common alloc] init];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WorkerTableViewCell" bundle:nil] forCellReuseIdentifier:@"IdCellWorker"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Load data "NotifyData" in tableView
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"WorkerData"];
    self.workers = [[self.appD.managedOCTableWorker executeFetchRequest:fetchRequest error:nil] mutableCopy];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.workers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *worker = [self.workers objectAtIndex:indexPath.row];
    
    WorkerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IdCellWorker"];
    [cell setup:worker];
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source
        [self.appD.managedOCTableWorker deleteObject:[self.workers objectAtIndex:indexPath.row]];
        
        NSString *notDelete = NSLocalizedString(@"TableView_Error", nil);
        NSError *error = nil;
        NSString *text = [NSString stringWithFormat:@"%@ %@ %@", notDelete, error, [error localizedDescription]];
        
        [self.workers removeObjectAtIndex:indexPath.row];
        
        if (![self.appD.managedOCTableWorker save:&error])
        {
            [self.com showToast:text view:self];
            return;
        }
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.appD addObjectWorker:[self.workers objectAtIndex:indexPath.row]
                      controller:self
                        testBool:YES];
}

- (void)addWorker
{
    [self.appD addObjectWorker:nil
                      controller:self
                        testBool:NO];
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
