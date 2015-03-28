//
//  WorkerViewController.m
//  NotifyAlert
//
//  Created by intent on 09/03/15.
//  Copyright (c) 2015 intent. All rights reserved.
//

#import "WorkerViewController.h"
#import "WorkerData.h"
#import "Common.h"
#import "XMLReader.h"

static NSString *const BaseURLString = @"http://diplomproject.esy.es/workers.xml";

@interface WorkerViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameWorkerField;
@property (weak, nonatomic) IBOutlet UITextField *statusWorkerField;
@property (weak, nonatomic) IBOutlet UIButton *getWorker;
- (IBAction)getWorkerInfoFromSite:(id)sender;

@property (strong, nonatomic) AppDelegate *appD;
@property (strong, nonatomic) Common *com;

@end

@implementation WorkerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        self.navigationItem.title = NSLocalizedString(@"Worker_Title", nil);
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                              target:self
                                                                                              action:@selector(back)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                               target:self
                                                                                               action:@selector(save)];      
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.appD = [[AppDelegate alloc] init];
    self.com = [[Common alloc] init];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Do any additional setup after loading the view from its nib.
    
    if (self.editWorker)
    {
        
        [self.nameWorkerField setText:[self.worker valueForKey:@"nameWorker"]];
        [self.statusWorkerField setText:[self.worker valueForKey:@"statusWorker"]];
        
        //        self.nameMaterialField.placeholder = nil;
    }
    else
    {
        self.nameWorkerField.placeholder = NSLocalizedString(@"NameWorkerField_PlaceHolder", nil);
        self.statusWorkerField.placeholder = NSLocalizedString(@"StatusWorkerField_PlaceHolder", nil);
    }
}

// Add/Edit worker
- (void)save
{
    NSString *ErrorString = NSLocalizedString(@"View_Error", nil);
    // Not empty field
    if ((self.nameWorkerField.text && self.nameWorkerField.text.length > 0 &&
         [self.nameWorkerField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length!=0) &&
        (self.statusWorkerField.text && self.statusWorkerField.text.length > 0
         && [self.statusWorkerField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length!=0))
    {
        // Edit worker
        if (self.worker && self.editWorker == YES)
        {
            [self.worker setValue:self.nameWorkerField.text forKey:@"nameWorker"];
            [self.worker setValue:self.statusWorkerField.text forKey:@"statusWorker"];
        }
        // Add new worker
        else
        {
            WorkerData *workerAdd = [NSEntityDescription insertNewObjectForEntityForName:@"WorkerData"
                                                                      inManagedObjectContext:self.appD.managedOCWorker];
            
            workerAdd.nameWorker = self.nameWorkerField.text;
            workerAdd.statusWorker = self.statusWorkerField.text;
        }
        
        NSError *error = nil;
        NSString *text = [NSString stringWithFormat:@"%@: %@ %@", ErrorString, error, [error localizedDescription]];
        
        if (![self.appD.managedOCWorker save:&error])
            [self.com showToast:text view:self];
        
        // Dismiss the view controller
        [self performSelector:@selector(back) withObject:nil];
    }
    else
        [self.com showToast:NSLocalizedString(@"Toast_EmptyNameField", nil) view:self];
}

// Exit
- (void)back
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)getWorkerInfoFromSite:(id)sender
{
    NSString *string = BaseURLString;
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *response = nil;
    NSError *requestError = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
    
    NSError *error = nil;
    
    NSDictionary *dict = [XMLReader dictionaryForXMLData:responseData error:&error];
    
    for(int i=0; i<[[[dict valueForKey:@"workers"] valueForKey:@"worker"] count]; i++)
    {
        WorkerData *workerAdd = [NSEntityDescription insertNewObjectForEntityForName:@"WorkerData"
                                                                  inManagedObjectContext:self.appD.managedOCWorker];
        
        workerAdd.nameWorker = [[[[[dict valueForKey:@"workers"] valueForKey:@"worker"]objectAtIndex:i] objectForKey:@"name"] objectForKey:@"text"];
        workerAdd.statusWorker = [[[[[dict valueForKey:@"workers"] valueForKey:@"worker"]objectAtIndex:i] objectForKey:@"status"] objectForKey:@"text"];
    }
}
@end
