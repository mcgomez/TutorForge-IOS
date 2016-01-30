//
//  StudentScheduleViewController.m
//  TutorForge
//
//  Created by Marisa Gomez on 01/29/16.
//  Copyright © 2015 Learnsmith Solutions. All rights reserved.
//

#import "StudentScheduleViewController.h"

@interface StudentScheduleViewController () <SACalendarDelegate>

@property (strong, nonatomic) NSMutableArray *TutorArray;
@property (strong, nonatomic) NSMutableArray *TutorIDArray;
@property (strong, nonatomic) NSMutableArray *SubjectArray;
@property (strong, nonatomic) NSArray *TimeArray;
@property (strong, nonatomic) NSString *selectedTutorID;

//dummy data
@property (strong, nonatomic) NSMutableArray *mySavedEvents;
@property (strong, nonatomic) NSMutableArray *myEventDate;
@property (strong, nonatomic) NSMutableArray *myEventTime;
@end

@implementation StudentScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *currentStudentID = @"800606792";
    
    _TutorArray = [[NSMutableArray alloc]init];
    _TutorIDArray = [[NSMutableArray alloc]init];
    _SubjectArray = [[NSMutableArray alloc]initWithObjects:@"", nil];
    _selectedTutorID = [[NSString alloc]init];
    
    [_TutorArray addObject:@""];
    [_TutorIDArray addObject:@""];
    
    //dummy data
    _mySavedEvents = [[NSMutableArray alloc]init];
    _myEventDate = [[NSMutableArray alloc]init];
    _myEventTime = [[NSMutableArray alloc]init];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // DEPENDING ON SUBJECT OF STUDENT IS WHAT IS PASSEED BELOW *** Then added into
        //Tutor array
        NSString *myURL = @"https://tutorme.stetson.edu/api/tutors/getAll";
        NSURL *myNSURL = [NSURL URLWithString:myURL];
        NSMutableURLRequest *myRequest = [NSMutableURLRequest requestWithURL:myNSURL];
        
        NSString *eTyp = @"FooErrType";
        int eID = 0xf00;
        NSError *eErr = [NSError errorWithDomain:eTyp
                                            code:eID userInfo:nil];
        
        //Recieve the JSON data from the PHP file
        NSError *error = [[NSError alloc]init];
        NSHTTPURLResponse *response = nil;
        NSData *urlData = [NSURLConnection sendSynchronousRequest:myRequest returningResponse:&response error:&eErr];
        NSMutableURLRequest *rq = [NSMutableURLRequest requestWithURL:myNSURL];
        
        /* IOS 9
         NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
         [[session dataTaskWithRequest:myRequest
         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
         if (!data) {
         NSLog(@"%@", error);
         } else {
         // ...
         NSLog(@"dataaaa %@", data);
         }
         }] resume];
         
         */ NSLog(@"Response code : %ld", (long) [response statusCode]); //Print out response codes
        
        if([response statusCode] >= 200 && [response statusCode] < 300)
        {
            NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
            NSLog(@"Response ===> %@", responseData);
            
            NSDictionary *myData = [NSJSONSerialization
                                    JSONObjectWithData:urlData options:NSJSONReadingMutableContainers error:&error];
            
            //Loop through NSDictionary object at result which returns each tutor in there own index, add
            //them to appropriate array either name or id for later use.
            for(int i = 0; i < [[myData objectForKey:@"result"] count]; i++)
            {
                [_TutorArray addObject:[[[myData objectForKey:@"result"] objectAtIndex:i] objectForKey:@"FullName"]];
                [_TutorIDArray addObject:[[[myData objectForKey:@"result"] objectAtIndex:i] objectForKey:@"ID"]];
                
            }
        }
        
        //Populate tutors array
        
        // DEPENDING ON SUBJECT OF STUDENT IS WHAT IS PASSEED BELOW *** Then added into ** need when more tutors are made
        //Tutor array
        NSString *myURL2 = [NSString stringWithFormat:@"https://tutorme.stetson.edu/api/students/getStudentCourses?StudentID=%@", currentStudentID];
        NSURL *myNSURL2 = [NSURL URLWithString:myURL2];
        NSMutableURLRequest *myRequest2 = [NSMutableURLRequest requestWithURL:myNSURL2];
        
        
        //Recieve the JSON data from the PHP file
        //error = [[NSError alloc]init];
        NSHTTPURLResponse *response2 = nil;
        NSData *urlData2 = [NSURLConnection sendSynchronousRequest:myRequest2 returningResponse:&response2 error:&eErr];
        
        
        /* IOS 9
         NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
         [[session dataTaskWithRequest:myRequest
         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
         if (!data) {
         NSLog(@"%@", error);
         } else {
         // ...
         NSLog(@"dataaaa %@", data);
         }
         }] resume];
         
         */ NSLog(@"Response code : %ld", (long) [response2 statusCode]); //Print out response codes
        
        if([response2 statusCode] >= 200 && [response2 statusCode] < 300)
        {
            NSString *responseData = [[NSString alloc]initWithData:urlData2 encoding:NSUTF8StringEncoding];
            NSLog(@" student courses Response ===> %@", responseData);
            
            NSDictionary *myData = [NSJSONSerialization
                                    JSONObjectWithData:urlData2 options:NSJSONReadingMutableContainers error:&error];
            
            //Loop through NSDictionary object at result which returns each tutor in there own index, add
            //them to appropriate array either name or id for later use.
            for(int i = 0; i < [[myData objectForKey:@"result"] count]; i++)
            {
                //Fill subjects into subject array
                [_SubjectArray addObject:[[[myData objectForKey:@"result"]objectAtIndex:i] objectForKey:@"CourseSubject"]];
                
            }
        }
        
        
    });
    //Create the SACalendar
    SACalendar *myCalendar = [[SACalendar alloc]initWithFrame:CGRectMake(0, 20, 316, 441)];
    
    myCalendar.delegate = self;
    
    [_myView addSubview:myCalendar];
    
    /*
     * Set up Tutor Picker for Tutor selection in UIAlertController
     */
    
    tutorPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, 320, 215)];
    tutorPicker.delegate = self;
    tutorPicker.dataSource = self;
    [tutorPicker setShowsSelectionIndicator:YES];
    
    tutorPickerToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 56)];
    [tutorPickerToolbar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc]init];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(ShowSelectedTutor)];
    
    [barItems addObject:doneBtn];
    
    [tutorPickerToolbar setItems:barItems animated:YES];
    
    /*
     * Setup subject picker
     */
    subjectPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, 320, 215)];
    subjectPicker.delegate = self;
    subjectPicker.dataSource = self;
    [subjectPicker setShowsSelectionIndicator:YES];
    
    subjectToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 56)];
    [subjectToolbar sizeToFit];
    
    NSMutableArray *barItems3 = [[NSMutableArray alloc]init];
    
    UIBarButtonItem *flexSpace3 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    [barItems3 addObject:flexSpace3];
    
    UIBarButtonItem *doneBtn2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(ShowSelectedSubject)];
    
    [barItems3 addObject:doneBtn2];
    
    [subjectToolbar setItems:barItems3 animated:YES];
    
    
    /*
     * Set up Time Picker for Time selection in UIAlertController - Populated with Tutor schedules depending which tutor is selected
     */
    _TimeArray = [[NSArray alloc]initWithObjects:@"", @"1:00", @"1:30", @"2:00", nil];
    
    timePicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, 320, 215)];
    timePicker.delegate = self;
    timePicker.dataSource = self;
    [timePicker setShowsSelectionIndicator:YES];
    
    timePickerToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 56)];
    [timePickerToolbar sizeToFit];
    
    NSMutableArray *timeBarItems = [[NSMutableArray alloc]init];
    
    UIBarButtonItem *timeFlexSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    [timeBarItems addObject:timeFlexSpace];
    
    UIBarButtonItem *timeDoneBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(ShowSelectedTime)];
    
    [timeBarItems addObject:timeDoneBtn];
    
    [timePickerToolbar setItems:timeBarItems animated:YES];
    
    
    /*
     * Set up Date Picker for DOB
     */
    datePicker = [[UIDatePicker alloc]init];
    datePicker.datePickerMode=UIDatePickerModeDate;
    
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(ShowSelectedDate)];
    UIBarButtonItem *space= [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space, doneButton, nil]];
    
    [datePicker setMinimumDate:[NSDate date]];
    
}

/*
 * Method to show the selected Tutor
 */
#pragma mark - Picker Show Methods
-(void)ShowSelectedTutor
{
    [self.TutorTextField resignFirstResponder];
}
/*
 * Method to show the selected Time
 */
-(void)ShowSelectedTime
{
    [self.TimeTextField resignFirstResponder];
}
/*
 * Method for Date Picker to display Date properly when selected with correct format
 * in the Date Text Field.
 */
-(void)ShowSelectedDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MMM dd YYYY"];
    self.DateTextField.text = [NSString stringWithFormat:@"%@", [formatter stringFromDate:datePicker.date]];
    [self.DateTextField resignFirstResponder];
    
}
-(void)ShowSelectedSubject
{
    [_SubjectTextField resignFirstResponder];
}

/*
 * Methods needed by picker view to control the selection of the picker.
 *
 */
#pragma mark - Picker Data Source Methods
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
/*
 * Method is used to create each cell in the picker view.
 */
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if([pickerView isEqual:tutorPicker]) return [_TutorArray count];
    else if([pickerView isEqual:subjectPicker]) return [_SubjectArray count];
    else return [_TimeArray count];
}
/*
 * Method is used to determinet the array at the certain index.
 */
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if([pickerView isEqual:tutorPicker])
    {
        _selectedTutorID = [_TutorIDArray objectAtIndex:row];
        return [_TutorArray objectAtIndex:row];
    }
    else if([pickerView isEqual:subjectPicker]) return [_SubjectArray objectAtIndex:row];
    else return [_TimeArray objectAtIndex:row];
}
/*
 * Method Required by PickerView to set the text field to the current selected value in the picker view.
 */
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if([pickerView isEqual:tutorPicker]) _TutorTextField.text = [_TutorArray objectAtIndex:row];
    else if([pickerView isEqual:subjectPicker]) _SubjectTextField.text = [_SubjectArray objectAtIndex:row];
    else if([pickerView isEqual:timePicker]){
        _TimeTextField.text = [_TimeArray objectAtIndex:row];
    } else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"MMM dd YYYY"];
        self.DateTextField.text = [NSString stringWithFormat:@"%@", [formatter stringFromDate:datePicker.date]];
        
        
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - SACalendar Delegates
/*
 * Method is used when user clicks on a certain date. Displays events if any otherwise displays message
 * @"No Events".
 */
-(void) SACalendar:(SACalendar *)calendar didSelectDate:(int)day month:(int)month year:(int)year
{
    NSMutableArray *events = [[NSMutableArray alloc]init];
    NSMutableArray *myData = [[NSMutableArray alloc]init];
    NSString *newDay = [[NSString alloc]init];
    NSString *newMonth = [[NSString alloc]init];
    //    UIColor *textColor = [[UIColor alloc]init]; LATER WHEN CHANGING TO GREEN IF ACCEPTED
    //Format date correctly to fit datePicker values when looping
    
    if(day == 1 || day == 2 || day == 3 || day == 4 || day == 5 || day == 6 || day == 7 || day == 8 || day == 9) newDay = [NSString stringWithFormat:@"0%d", day];
    else newDay = [NSString stringWithFormat:@"%d", day];
    
    //Set month to MMM styling like value saved for javascript date function required by database.
    if(month == 1) newMonth = @"Jan";
    else if(month == 2) newMonth = @"Feb";
    else if(month == 3) newMonth = @"Mar";
    else if(month == 4) newMonth = @"Apr";
    else if(month == 5) newMonth = @"May";
    else if(month == 6) newMonth = @"Jun";
    else if(month == 7) newMonth = @"Jul";
    else if(month == 8) newMonth = @"Aug";
    else if(month == 9) newMonth = @"Sep";
    else if(month == 10) newMonth = @"Oct";
    else if(month == 11) newMonth = @"Nov";
    else if(month == 12) newMonth = @"Dec";
    
    
    
    NSString *myURL = @"https://tutorme.stetson.edu/api/getAppointmentRequests";
    NSURL *myNSURL = [NSURL URLWithString:myURL];
    NSMutableURLRequest *rq = [NSMutableURLRequest requestWithURL:myNSURL];
    [rq setHTTPMethod:@"GET"];
    NSString *post2 = [NSString stringWithFormat:@"as=Student&ID=%@", @"800606792"];
    NSData *postData2 = [post2 dataUsingEncoding:NSASCIIStringEncoding];
    [rq setHTTPBody:postData2];
    [rq setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //Recieve the JSON data from the PHP file
    NSError *error = [[NSError alloc]init];
    NSHTTPURLResponse *response = nil;
    NSData *urlData = [NSURLConnection sendSynchronousRequest:rq returningResponse:&response error:&error];
    
    NSLog(@"Response code : %ld", (long) [response statusCode]); //Print out response codes
    
    if([response statusCode] >= 200 && [response statusCode] < 300)
    {
        NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
        NSLog(@"Response ===> %@", responseData);
        
        
        NSError *error = nil;
        
        //Populate tutor array with tutors from database
        myData = [NSJSONSerialization
                  JSONObjectWithData:urlData options:NSJSONReadingMutableContainers error:&error];
        
        //Loop through mydata and add to tutors with same subject as student and then add to timeArray **
    }
    
    //Add each event into NSMutuableArray
    if(_myEventDate.count > 0)
    {
        for(int i = 0; i < _myEventDate.count; i++)
        {
            if([[_myEventDate objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"%@ %@ %d", newMonth, newDay, year]])
            {
                [events addObject:[NSString stringWithFormat:@"%@ with %@ @ %@",[_mySavedEvents objectAtIndex:i], [_TutorArray objectAtIndex:i + 1], [_myEventTime objectAtIndex:i]]];
            }
        }
        
        //Check if no events added
        if(events.count == 0) [events addObject:@"No Events"];
    } else {
        [events addObject:@"No Events"];
    }
    
    
    //Format events into string to display in message
    NSMutableString *eventString = [[NSMutableString alloc] init];
    for (NSObject * obj in events)
    {
        [eventString appendString:[NSString stringWithFormat:@"\n %@",[obj description]]];
    }
    //Display alert controller
    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Selected Date: %d/%@/%d",month, newDay, year] message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    //Set color of message text *** NOT WORKING RN WHY?
    NSMutableAttributedString *requestedString = [[NSMutableAttributedString alloc]initWithString:eventString];
    [requestedString addAttribute:NSForegroundColorAttributeName
                            value:[UIColor redColor]
                            range:NSMakeRange(0, [requestedString length])];
    [myAlertController setValue:requestedString forKey:@"attributedMessage"];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction *myAction)
                                    {
                                        //SAVE IN DATABASE HERE*
                                    }];
    
    [myAlertController addAction:defaultAction];
    [self presentViewController:myAlertController animated:YES completion:nil];
    
}

/*
 * Method is used when user slides to the next month or displaying the years
 */
-(void) SACalendar:(SACalendar *)calendar didDisplayCalendarForMonth:(int)month year:(int)year
{
    //    NSLog(@"%02/%i",month,year);
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark - Add Button
/*
 * Method is used when user clicks on Request button so that they can request appoitments.
 * Grabs all data from textfields and passes them through POST call to the database page.
 */
- (IBAction)AddButton:(id)sender
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Request an Appoitment"
                                                                   message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Request" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                    {
                                        NSString *Subject = ((UITextField *)[alert.textFields objectAtIndex:0]).text;
                                        //                                        NSString *myTutorID = ((UITextField *)[alert.textFields objectAtIndex:1]).text;
                                        NSString *myDate = ((UITextField *)[alert.textFields objectAtIndex:2]).text;
                                        NSString *myTime = ((UITextField *)[alert.textFields objectAtIndex:3]).text;
                                        
                                        if([Subject isEqualToString:@""] || [myDate isEqualToString:@""] || [myTime isEqualToString:@""])
                                        {
                                            UIAlertController *sentAlert = [UIAlertController alertControllerWithTitle:nil message:@"Please fill all fields" preferredStyle:UIAlertControllerStyleAlert];
                                            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}];
                                            [sentAlert addAction:okAction];
                                            [self presentViewController:sentAlert animated:YES completion:nil];
                                            
                                        } else {
                                            
                                            //                                        Fri Nov 27 2015 02:59:52 GMT-0500 (Eastern Standard Time)
                                            /*
                                             NSString *location = @"Elizabeth 208";
                                             
                                             NSDateFormatter *myFormatter = [[NSDateFormatter alloc] init];
                                             [myFormatter setDateFormat:@"EE"]; // day, like "Saturday"
                                             NSString *weekDay =  [myFormatter stringFromDate:datePicker.date];
                                             
                                             NSString *myRequestStart = [NSString stringWithFormat:@"%@ %@ %@:00 GMT-0500 (Eastern Standard Time)", weekDay,myDate, myTime];
                                             
                                             NSLog(@"Myrequest start is %@", myRequestStart);
                                             
                                             NSString *myURL = @"https://tutorme.stetson.edu/api/appointments/makeRequest";
                                             NSURL *myNSURL = [NSURL URLWithString:myURL];
                                             NSMutableURLRequest *rq = [NSMutablUeRLRequest requestWithURL:myNSURL];
                                             [rq setHTTPMethod:@"POST"];
                                             NSString *post2 = [NSString stringWithFormat:@"StudentField=%@&Student=%@&TutorField=%@&Tutor=%@&RequestedStart=%@&Location=%@&Subject=%@", @"ID", @"800606792", @"ID", _selectedTutorID, myRequestStart, location, Subject];
                                             NSData *postData2 = [post2 dataUsingEncoding:NSASCIIStringEncoding];
                                             [rq setHTTPBody:postData2];
                                             [rq setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                                             
                                             //Recieve the JSON data from the PHP file
                                             NSError *error = [[NSError alloc]init];
                                             NSHTTPURLResponse *response = nil;
                                             NSData *urlData = [NSURLConnection sendSynchronousRequest:rq returningResponse:&response error:&error];
                                             
                                             NSLog(@"Response code : %ld", (long) [response statusCode]); //Print out response codes
                                             
                                             if([response statusCode] >= 200 && [response statusCode] < 300)
                                             {
                                             NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
                                             NSLog(@"Request sent response ===> %@", responseData);
                                             
                                             NSMutableArray *myData = [[NSMutableArray alloc]init];
                                             NSError *error = nil;
                                             
                                             //Populate tutor array with tutors from database
                                             myData = [NSJSONSerialization
                                             JSONObjectWithData:urlData options:NSJSONReadingMutableContainers error:&error];
                                             
                                             //Loop through mydata and add to tutors with same subject as student and then add to timeArray **
                                             }
                                             */
                                            
                                            [_mySavedEvents addObject:Subject];
                                            [_myEventDate addObject:myDate];
                                            [_myEventTime addObject:myTime];
                                            
                                            UIAlertController *sentAlert = [UIAlertController alertControllerWithTitle:nil message:@"Request Sent!" preferredStyle:UIAlertControllerStyleAlert];
                                            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}];
                                            [sentAlert addAction:okAction];
                                            [self presentViewController:sentAlert animated:YES completion:nil];
                                        }
                                        
                                        
                                    }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    
    
    //1. Field
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         //Assign the subjectpicker
         _SubjectTextField = textField;
         textField.inputView = subjectPicker;
         textField.inputAccessoryView = subjectToolbar;
         textField.placeholder = NSLocalizedString(@"Select Subject", @"Select Subject");
         
     }];
    //2. Field
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         //Assign the tutorPicker and tutorPickerToolBar to textfield to display properly
         _TutorTextField = textField;
         textField.inputView = tutorPicker;
         textField.inputAccessoryView = tutorPickerToolbar;
         textField.placeholder = NSLocalizedString(@"Select Tutor", @"Select Tutor");
         
     }];
    //3. Field
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         //Assign the datePicker and toolBar to the textfield to display properly
         _DateTextField = textField;
         textField.inputView = datePicker;
         textField.inputAccessoryView = toolBar;
         textField.placeholder = NSLocalizedString(@"Select Date", @"Select Date");
         
     }];
    //4. Field
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         //Assign the timePicker and timePickerToolbar to the textfield to display properly
         _TimeTextField = textField;
         textField.inputView = timePicker;
         textField.inputAccessoryView = timePickerToolbar;
         textField.placeholder = NSLocalizedString(@"Select Time", @"Select Time");
         
     }];
    
    [alert addAction:cancelAction];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}


@end
