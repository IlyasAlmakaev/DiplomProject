//
//  NotifyViewController.m
//  NotifyAlert
//
//  Created by intent on 29/01/15.
//  Copyright (c) 2015 intent. All rights reserved.
//

#import "NotifyViewController.h"
#import "NotifyData.h"
#import "DisableTextFieldEdit.h"
#import "Common.h"


@interface NotifyViewController ()
<UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

    @property (strong, nonatomic) Common *com;
    @property (strong, nonatomic) AppDelegate *appD;
    @property (strong, nonatomic) UIPickerView *pickerView;
    @property (strong, nonatomic) UIDatePicker *datePickerView;
    @property (strong, nonatomic) NSMutableArray *repeatOptions;
    @property (strong, nonatomic) NSDate *notifyDate;
    @property (strong, nonatomic) NSString *dateF, *repeatF, *materialFQ, *materialF, *nilString;

    @property (weak, nonatomic) IBOutlet UITextField *nameField;
    @property (weak, nonatomic) IBOutlet UITextField *materialField;
    @property (weak, nonatomic) IBOutlet DisableTextFieldEdit *dateField;
    @property (weak, nonatomic) IBOutlet DisableTextFieldEdit *repeatField;
    @property (weak, nonatomic) IBOutlet UISwitch *switcher;

    - (IBAction)switcherPressed:(id)sender;
    // REVIEW Зачем?
    // ANSWER Для событий в момент переключения switcher
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

    self.pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];

    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    // Show DatePikerView
    CGRect datePickerFrame = CGRectZero;
    self.datePickerView = [[UIDatePicker alloc] initWithFrame:datePickerFrame];
    [self.datePickerView setDatePickerMode:UIDatePickerModeDateAndTime];

    [self.datePickerView setMinimumDate:[NSDate date]];
    
    self.repeatField.delegate = self;
    
    self.nameField.placeholder = NSLocalizedString(@"NameField_PlaceHolder", nil);
    self.materialField.placeholder = self.materialFQ;
    
    self.appD = [[AppDelegate alloc] init];
    self.com = [[Common alloc] init];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Do any additional setup after loading the view from its nib.
    
    // REVIEW Делать ровно один раз. Какой смысл при каждом показе?
    // ANSWER Сделал в AppDelegate.
    // ANSWER Исправил.
    BOOL indicator;
    
    if (self.edit)
    {
        // REVIEW Почему не if (self.edit)?
        // ANSWER Исправил.
        indicator = YES;
        
        [self.nameField setText:[self.notify valueForKey:@"descript"]];
        [self dateFormatter:[self.notify valueForKey:@"date"]];
        
        if ([self.notify valueForKey:@"date"] != nil && [self.notify valueForKey:@"worker"] != nil)
        [self.datePickerView setDate:[self.notify valueForKey:@"date"]];
        
        self.notifyDate = [self.notify valueForKey:@"date"];
        [self.repeatField setText:[self.notify valueForKey:@"worker"]];
        self.repeatField.placeholder = nil;
        
        if ([self.notify valueForKey:@"date"] == nil && [self.notify valueForKey:@"worker"] == nil)
        {
            // REVIEW Скобочка уехала.
            // ANSWER Исправил.
            indicator = NO;
            
            self.dateField.text = nil;
            self.repeatField.text = nil;
            self.dateField.placeholder = self.dateF;
            self.repeatField.placeholder = self.repeatF;
            
            NSUserDefaults *usrDefaults = [NSUserDefaults standardUserDefaults];
            [usrDefaults setInteger:0 forKey:@"Index"];
        }
    }
    else
    {
        // REVIEW Почему не просто else?
        // ANSWER Исправил.
        indicator = NO;
        
        self.nameField.text=nil;
        self.dateField.text = nil;
        self.repeatField.text = nil;
        self.dateField.placeholder = self.dateF;
        self.repeatField.placeholder = self.repeatF;
        
        NSUserDefaults *usrDefaults = [NSUserDefaults standardUserDefaults];
        [usrDefaults setInteger:0 forKey:@"Index"];
    }
    self.switcher.on = indicator;
    self.materialField.enabled = indicator;
    // REVIEW Сократить портянку в 2 раза. Например, если self.switcher.on
    // REVIEW зависит от self.edit и self.notify, то конечное значение BOOL
    // REVIEW достоточно получить ровно 1 раз, после чего его присвоить по
    // REVIEW одному разу каждому виджету (switcher, dateField и т.д.).
    // ANSWER Исправил.
    // REVIEW Гораздо лучше сразу в AppDelegate присвоить
    // REVIEW NSManagedObjectContext этому классу. Какой смысл
    // REVIEW при каждом действии с базой выполнять одно и то же?
    // ANSWER Готово.

    // REVIEW Делать лишь один раз.
    // ANSWER Готово.
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
// REVIEW Поправить отступы.
// REVIEW Сократить портянку в 2 раза описанным выше способом.
// ANSWER Сократил.
}

    // Hide Keyboard/DateBoard/RepeatOptions
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    // REVIEW Почему не [self.view endEditing]?
    // REVIEW В чём разница между endEditing и resignFirstResponder?
    // REVIEW Почему рекомендуется использовать endEditing?
    // ANSWER endEditing рекомендуется потому что используется для всех textFields во view,
    // ANSWER а resignFirstResponder только для одного textField.
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
    
    if (textField == self.repeatField)
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
        self.repeatField.inputView = self.pickerView;
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
    return self.repeatOptions.count;
    // REVIEW Почему в NotifyTVC используется self.notifications.count (свойство)
    // REVIEW а тут [pickerArray count] (метод)?
    // ANSWER Исправил метод на свойство.
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.repeatOptions objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.repeatField.text = [self.repeatOptions objectAtIndex:row];
}

// Add/Edit notification
- (void)save
{
    NSString *ErrorString = NSLocalizedString(@"View_Error", nil);
    // Not empty field
    if (self.nameField.text && self.nameField.text.length > 0 && [self.nameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length!=0)
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
                // REVIEW Опять же.
                // ANSWER Исправил.
                [self.notify setValue:self.nameField.text forKey:@"descript"];
                [self.notify setValue:self.notifyDate forKey:@"date"];
                
                if ([self.repeatField.text isEqual:self.nilString])
                    // REVIEW Опять же использовать внутреннюю переменную,
                    // REVIEW никак не связанную с отображением.
                    // ANSWER Исправил.
                    [self.notify setValue:self.repeatField.placeholder forKey:@"worker"];
                
                else
                    [self.notify setValue:self.repeatField.text forKey:@"worker"];
            }
            // Add new notification
            else
            {
                NotifyData * notifyAdd = [NSEntityDescription insertNewObjectForEntityForName:@"NotifyData"
                                                                       inManagedObjectContext:self.appD.managedOC];
                
                notifyAdd.descript = self.nameField.text;
                [notifyAdd setValue:self.notifyDate forKey:@"date"];
                
                if ([self.repeatField.text isEqual:self.nilString])
                    // REVIEW Опять же...
                    // ANSWER Исправил
                    notifyAdd.worker = self.repeatField.placeholder;
                
                else
                    notifyAdd.worker = self.repeatField.text;
            }
            
            NSError *error = nil;
            
            if (![self.appD.managedOC save:&error])
                [self.com showToast:(@"%@: %@ %@", ErrorString, error, [error localizedDescription]) view:self];
            // REVIEW Создать файл Common, в котором реализовать showToast(текст)
            // REVIEW Нет никакого прока от указания одних и тех же значений
            // REVIEW для duration и position при каждом вызове.
            // ANSWER Готово, но есть дополнительный параметр: showToast(текст) view(self)
            
            else
                // register Notification
                [self.appD dateField: self.notifyDate nameField: self.nameField.text repeatField: self.repeatField.text];
            // REVIEW Опять же реализовать это с помощью делегата в AppDelegate.
            // REVIEW Ни в коем случае не использовать Application НЕЯВНО.
            // ANSWER Исправил.
        }
        // Switch off
        else
        {
            // Edit notification
            if (self.notify && self.edit == YES)
            {
                [self.notify setValue:self.nameField.text forKey:@"descript"];
                [self.notify setValue:nil forKey:@"date"];
                [self.notify setValue:nil forKey:@"worker"];
                
                // Delete local notification
                NSDate *notificationDate = [self.notify valueForKey:@"date"];
                NSString *notificationName = [self.notify valueForKey:@"descript"];
                
                [self.appD deleteNotification:notificationDate name:notificationName];
                // REVIEW Опять же.
                // ANSWER Исправил.
                
                NSError *error = nil;
                if (![self.appD.managedOC save:&error])
                    [self.com showToast:(@"%@: %@ %@", ErrorString, error, [error localizedDescription]) view:self];
            }
            // Add new notification
            else
            {
                NotifyData *notifyAdd = [NSEntityDescription insertNewObjectForEntityForName:@"NotifyData"
                                                                      inManagedObjectContext:self.appD.managedOC];
                notifyAdd.descript = self.nameField.text;
                
                NSError *error = nil;
                if (![self.appD.managedOC save:&error])
                    [self.com showToast:(@"%@: %@ %@", ErrorString, error, [error localizedDescription]) view:self];
            }
        }
        
        // Dismiss the view controller
        [self performSelector:@selector(back) withObject:nil];
        // REVIEW Почему не сразу?
        // ANSWER Убрал из-за ненадобности. Задержка нужна была,
        // ANSWER когда всплывало сообщение об успешном добавлении напоминания, которое было убрано.
    }
    else
        [self.com showToast:NSLocalizedString(@"Toast_EmptyNameField", nil) view:self];
    // REVIEW Добавить shake поля ввода.
    // ANSWER Добавил для nameField.
}

// Exit
- (void)back
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    // REVIEW Зачем?
    // ANSWER Метод ухода со страницы: закрытие клавиатуры/даты/режима повторений и NotifyViewController
}

@end
