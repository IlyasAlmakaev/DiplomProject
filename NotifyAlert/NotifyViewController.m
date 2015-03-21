//
//  NotifyViewController.m
//  NotifyAlert
//
//  Created by intent on 29/01/15.
//  Copyright (c) 2015 intent. All rights reserved.
//

#import "NotifyViewController.h"
#import "NotifyData.h"
#import "MaterialData.h"
#import "WorkerData.h"
#import "DisableTextFieldEdit.h"
#import "Common.h"


@interface NotifyViewController ()
<UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

    @property (strong, nonatomic) Common *com;
    @property (strong, nonatomic) AppDelegate *appD;

    @property (strong, nonatomic) NSFetchedResultsController *fetchedResultsControllerWorker;
    @property (strong, nonatomic) NSFetchedResultsController *fetchedResultsControllerMaterial;

    @property (strong, nonatomic) UIPickerView *pickerViewMaterial, *pickerViewWorker;
    @property (strong, nonatomic) UIDatePicker *datePickerView;
    @property (strong, nonatomic) NSMutableArray *repeatOptions;
    @property (strong, nonatomic) NSDate *notifyDate;
    @property (strong, nonatomic) NSString *dateF, *repeatF, *materialFQ, *materialF, *workerF, *nilString;

    @property (weak, nonatomic) IBOutlet UITextField *nameField;
    @property (weak, nonatomic) IBOutlet UITextField *materialField;
    @property (weak, nonatomic) IBOutlet DisableTextFieldEdit *dateField;
    @property (weak, nonatomic) IBOutlet DisableTextFieldEdit *workerField;
    @property (weak, nonatomic) IBOutlet UISwitch *switcher;

    - (IBAction)switcherPressed:(id)sender;

@end

@implementation NotifyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        self.navigationItem.title = NSLocalizedString(@"View_Title", nil);

        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                              target:self
                                                                                              action:@selector(back)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                               target:self
                                                                                               action:@selector(save)];
        
        self.materialFQ = NSLocalizedString(@"MaterialField_PlaceHolderHide", nil);
        self.materialF = NSLocalizedString(@"MaterialField_PlaceHolder", nil);
        self.workerF = NSLocalizedString(@"WorkerField_PlaceHolder", nil);
        self.dateF = NSLocalizedString(@"DateField_PlaceHolder", nil);
        self.nilString = @"";
        
        self.repeatOptions = [[NSMutableArray alloc] init];
        // REVIEW Переименовать в repeatOptions. Какой смысл называть массивом массив?
     /*   [self.repeatOptions addObject:self.notRepeat];
        [self.repeatOptions addObject:self.everyMinute];
        [self.repeatOptions addObject:self.everyHour];
        [self.repeatOptions addObject:self.everyDay];
        [self.repeatOptions addObject:self.everyWeek];*/
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Show PickerView
    CGRect pickerFrame = CGRectZero;

    self.pickerViewMaterial = [[UIPickerView alloc] initWithFrame:pickerFrame];

    self.pickerViewMaterial.delegate = self;
    self.pickerViewMaterial.dataSource = self;
    
    // Show PickerView
    self.pickerViewWorker = [[UIPickerView alloc] initWithFrame:pickerFrame];
    
    self.pickerViewWorker.delegate = self;
    self.pickerViewWorker.dataSource = self;
    
    // Show DatePikerView
    CGRect datePickerFrame = CGRectZero;
    self.datePickerView = [[UIDatePicker alloc] initWithFrame:datePickerFrame];
    [self.datePickerView setDatePickerMode:UIDatePickerModeDateAndTime];

    [self.datePickerView setMinimumDate:[NSDate date]];
    
    self.workerField.delegate = self;
    self.materialField.delegate = self;
    
    self.nameField.placeholder = NSLocalizedString(@"NameField_PlaceHolder", nil);
    self.materialField.placeholder = self.materialFQ;
    
    self.appD = [[AppDelegate alloc] init];
    self.com = [[Common alloc] init];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Do any additional setup after loading the view from its nib.

    BOOL indicator;
    
    if (self.edit)
    {
        indicator = YES;
        
        [self.nameField setText:[self.notify valueForKey:@"descript"]];
        [self dateFormatter:[self.notify valueForKey:@"date"]];
        
        if ([self.notify valueForKey:@"date"] != nil)
        [self.datePickerView setDate:[self.notify valueForKey:@"date"]];
        
        self.notifyDate = [self.notify valueForKey:@"date"];
        [self.workerField setText:[self.notify valueForKey:@"worker"]];
        self.workerField.placeholder = nil;
        
        [self.materialField setText:[self.notify valueForKey:@"material"]];
        self.materialField.placeholder = nil;
        
        if ([self.notify valueForKey:@"material"] == nil)
        {
            indicator = NO;
            
            self.materialField.text = nil;
            self.materialField.placeholder = self.materialFQ;
            
            NSUserDefaults *usrDefaults = [NSUserDefaults standardUserDefaults];
            [usrDefaults setInteger:0 forKey:@"Index"];
        }
    }
    else
    {
        indicator = NO;
        
        self.nameField.text = nil;
        self.dateField.text = nil;
        self.workerField.text = nil;
        self.dateField.placeholder = self.dateF;
        self.workerField.placeholder = self.workerF;
        
        NSUserDefaults *usrDefaults = [NSUserDefaults standardUserDefaults];
        [usrDefaults setInteger:0 forKey:@"Index"];
    }
    self.switcher.on = indicator;
    self.materialField.enabled = indicator;
}

- (IBAction)switcherPressed:(id)sender
{
    BOOL indicator;
    if (self.switcher.on)
    {
        indicator = YES;
        
        self.materialField.text = nil;
        self.materialField.placeholder = self.materialF;
    }
    else
    {
        indicator = NO;

        self.materialField.text = nil;
        self.materialField.placeholder = self.materialFQ;
    }
    
    self.materialField.enabled = indicator;
}

    // Hide Keyboard/DateBoard/RepeatOptions
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

    // Block text for repeatField and dateField
- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return NO;
}

    // Shake textField-method
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (event.type == UIEventSubtypeMotionShake)
        self.nameField.text=nil;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if (textField == self.workerField)
    {
 /*       if ([self.repeatField.text isEqual: self.notRepeat] || self.repeatField.placeholder == [self.repeatOptions objectAtIndex:0])
        {
            self.repeatField.placeholder = nil;
            self.repeatField.text = self.notRepeat;
            [self.pickerView selectRow:0 inComponent:0 animated:NO];
        }
        else if ([self.repeatField.text isEqual: self.everyMinute])
            [self.pickerView selectRow:1 inComponent:0 animated:NO];
        
        else if ([self.repeatField.text isEqual: self.everyHour])
            [self.pickerView selectRow:2 inComponent:0 animated:NO];
        
        else if ([self.repeatField.text isEqual: self.everyDay])
            [self.pickerView selectRow:3 inComponent:0 animated:NO];
        
        else if ([self.repeatField.text isEqual: self.everyWeek])
            [self.pickerView selectRow:4 inComponent:0 animated:NO];*/
        
        // REVIEW Никогда нельзя сравнивать с конечным локализованным значением
        // REVIEW Поменять на сравнение с внутренней переменной, никак
        // REVIEW не связанной со строкой отображения.
        // ANSWER Исправил. Прослеживается связь, но, надеюсь, так можно.
        self.pickerViewMaterial.tag = 0;
        self.workerField.inputView = self.pickerViewWorker;
    }
    else if (textField == self.materialField)
    {
        self.pickerViewMaterial.tag = 1;
        self.materialField.inputView = self.pickerViewMaterial;
    }
    else if (textField == self.dateField)
    {
        self.notifyDate = [self.datePickerView date];
        [self dateFormatter:self.notifyDate];
        
        self.dateField.inputView = self.datePickerView;
        
        [self.datePickerView addTarget:self action:@selector(didChangeDate:) forControlEvents:UIControlEventValueChanged];
    }
}

- (void)didChangeDate:(id)sender
{
    self.notifyDate = [self.datePickerView date];
    [self dateFormatter:self.notifyDate];
}

    // DateFormat to string
- (void)dateFormatter:(NSDate *)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"HH:mm / dd.MM.yy"];
    [self.dateField setText:[format stringFromDate:date]];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger countPicker = 0;
    if (self.pickerViewMaterial.tag == 1)
    {
        countPicker = [[[self fetcherResultsControllerForMaterial] fetchedObjects] count];
    }
    else if (self.pickerViewMaterial.tag == 0)
    {
        countPicker = [[[self fetcherResultsControllerForWorker] fetchedObjects] count];
    }
    return countPicker;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSManagedObject *Fetch = nil;
    NSString *nameFetch = nil;
    
    if (self.pickerViewMaterial.tag == 1)
    {
        Fetch = [[[self fetcherResultsControllerForMaterial] fetchedObjects] objectAtIndex:row];
    nameFetch = (NSString *)[Fetch valueForKey:@"nameMaterial"];
    }
    else if (self.pickerViewMaterial.tag == 0)
    {
        Fetch = [[[self fetcherResultsControllerForWorker] fetchedObjects] objectAtIndex:row];
    nameFetch = (NSString *)[Fetch valueForKey:@"nameWorker"];
    }
    
    return nameFetch;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSManagedObject *Fetch;
    NSString *nameFetch;
    
    if (self.pickerViewMaterial.tag == 1)
    {
        Fetch = [[[self fetcherResultsControllerForMaterial] fetchedObjects] objectAtIndex:row];
        nameFetch = (NSString *)[Fetch valueForKey:@"nameMaterial"];
        self.materialField.text = nameFetch;
    }
    else if (self.pickerViewMaterial.tag == 0)
    {
        Fetch = [[[self fetcherResultsControllerForWorker] fetchedObjects] objectAtIndex:row];
        nameFetch = (NSString *)[Fetch valueForKey:@"nameWorker"];
        self.workerField.text = nameFetch;
    }
}

// Add/Edit notification
- (void)save
{
    NSString *ErrorString = NSLocalizedString(@"View_Error", nil);
    // Not empty field
    if ((self.nameField.text && self.nameField.text.length > 0 && [self.nameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length!=0)
        && (self.workerField.text && self.workerField.text.length > 0 && [self.workerField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length!=0)
        && (self.dateField.text && self.dateField.text.length > 0 && [self.dateField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length!=0))
    {
        // Switch on
        if (self.switcher.on)
        {
            // Edit notification
            if (self.notify && self.edit == YES)
            {
                NSDate *notificationDate = [self.notify valueForKey:@"date"];
                NSString *notificationName = [self.notify valueForKey:@"descript"];
                
                [self.appD deleteNotification:notificationDate name:notificationName];

                [self.notify setValue:self.nameField.text forKey:@"descript"];
                [self.notify setValue:self.notifyDate forKey:@"date"];
                
                if ([self.workerField.text isEqual:self.nilString])

                    [self.notify setValue:self.workerField.placeholder forKey:@"worker"];
                
                else
                    [self.notify setValue:self.workerField.text forKey:@"worker"];
                    [self.notify setValue:self.materialField.text forKey:@"material"];
            }
            // Add new notification
            else
            {
                NotifyData * notifyAdd = [NSEntityDescription insertNewObjectForEntityForName:@"NotifyData"
                                                                       inManagedObjectContext:self.appD.managedOC];
                
                notifyAdd.descript = self.nameField.text;
                [notifyAdd setValue:self.notifyDate forKey:@"date"];
                
                if ([self.workerField.text isEqual:self.nilString])
                    // REVIEW Опять же...
                    // ANSWER Исправил
                    notifyAdd.worker = self.workerField.placeholder;
                
                else
                    notifyAdd.worker = self.workerField.text;
                    notifyAdd.material = self.materialField.text;
            }
            
            NSError *error = nil;
            NSString *text = [NSString stringWithFormat:@"%@: %@ %@", ErrorString, error, [error localizedDescription]];
            if (![self.appD.managedOC save:&error])
            {
                [self.com showToast:text view:self];
                return;
            }
        }
        // Switch off
        else
        {
            // Edit notification
            if (self.notify && self.edit == YES)
            {
                
                // Delete local notification
                NSDate *notificationDate = [self.notify valueForKey:@"date"];
                NSString *notificationName = [self.notify valueForKey:@"descript"];
                
                [self.appD deleteNotification:notificationDate name:notificationName];
                
                [self.notify setValue:self.nameField.text forKey:@"descript"];
                [self.notify setValue:nil forKey:@"material"];
                [self.notify setValue:self.workerField.text forKey:@"worker"];
                [self.notify setValue:self.notifyDate forKey:@"date"];
                
                NSError *error = nil;
                NSString *text = [NSString stringWithFormat:@"%@: %@ %@", ErrorString, error, [error localizedDescription]];
                if (![self.appD.managedOC save:&error])
                {
                    [self.com showToast:text view:self];
                    return;
                }
            }
            // Add new notification
            else
            {
                NotifyData *notifyAdd = [NSEntityDescription insertNewObjectForEntityForName:@"NotifyData"
                                                                      inManagedObjectContext:self.appD.managedOC];
                notifyAdd.descript = self.nameField.text;
                notifyAdd.worker = self.workerField.text;
                [notifyAdd setValue:self.notifyDate forKey:@"date"];
                
                NSError *error = nil;
                NSString *text = [NSString stringWithFormat:@"%@: %@ %@", ErrorString, error, [error localizedDescription]];
                
                if (![self.appD.managedOC save:&error])
                {
                    [self.com showToast:text view:self];
                    return;
                }
            }
        }
        
        // register Notification
        [self.appD dateField: self.notifyDate nameField: self.nameField.text repeatField: self.workerField.text];
        
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

- (NSFetchedResultsController *)fetcherResultsControllerForWorker
{
    if (self.fetchedResultsControllerWorker != nil)
    {
        return self.fetchedResultsControllerWorker;
    }
    
    NSEntityDescription *workerBase = [NSEntityDescription entityForName:@"WorkerData" inManagedObjectContext:self.appD.managedOC];
    NSSortDescriptor *sortWorker = [NSSortDescriptor sortDescriptorWithKey:@"nameWorker" ascending:YES];
    NSFetchRequest *requestWorker = [[NSFetchRequest alloc] init];
    [requestWorker setEntity:workerBase];
    [requestWorker setSortDescriptors:[NSArray arrayWithObject:sortWorker]];
    self.fetchedResultsControllerWorker = [[NSFetchedResultsController alloc] initWithFetchRequest:requestWorker managedObjectContext:self.appD.managedOC sectionNameKeyPath:nil cacheName:nil];
    
    NSError *error = nil;
    NSString *text = [NSString stringWithFormat:@"fetch error: %@", error];
    
    if (![self.fetchedResultsControllerWorker performFetch:&error])
    {
    [self.com showToast:text view:self];
    abort();
    }
    
    return self.fetchedResultsControllerWorker;
}

- (NSFetchedResultsController *)fetcherResultsControllerForMaterial
{
    if (self.fetchedResultsControllerMaterial != nil)
    {
        return self.fetchedResultsControllerMaterial;
    }
    
    NSEntityDescription *materialBase = [NSEntityDescription entityForName:@"MaterialData" inManagedObjectContext:self.appD.managedOC];
    NSSortDescriptor *sortMaterial = [NSSortDescriptor sortDescriptorWithKey:@"nameMaterial" ascending:YES];
    NSFetchRequest *requestMaterial = [[NSFetchRequest alloc] init];
    [requestMaterial setEntity:materialBase];
    [requestMaterial setSortDescriptors:[NSArray arrayWithObject:sortMaterial]];
    self.fetchedResultsControllerMaterial = [[NSFetchedResultsController alloc] initWithFetchRequest:requestMaterial managedObjectContext:self.appD.managedOC sectionNameKeyPath:nil cacheName:nil];
    
    NSError *error = nil;
    NSString *text = [NSString stringWithFormat:@"fetch error: %@", error];
    
    if (![self.fetchedResultsControllerMaterial performFetch:&error])
    {
        [self.com showToast:text view:self];
        abort();
    }
    
    return self.fetchedResultsControllerMaterial;
}

@end
