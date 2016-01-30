//
//  AdminScheduleViewController.m
//  TutorForge
//
//  Created by Marisa Gomez on 01/29/16.
//  Copyright © 2015 Learnsmith Solutions. All rights reserved.
//

#import "AdminScheduleViewController.h"

@interface AdminScheduleViewController () <SACalendarDelegate>

@property (strong, nonatomic) NSArray *TutorArray;
@property (strong, nonatomic) NSArray *TimeArray;
@property (strong, nonatomic) NSMutableArray *mySavedEvents;
@property (strong, nonatomic) NSMutableArray *myEventDate;
@property (strong, nonatomic) NSMutableArray *myEventTime;

@end

@implementation AdminScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Create the SACalendar
    SACalendar *myCalendar = [[SACalendar alloc]initWithFrame:CGRectMake(0, 20, 316, 483)];
    
    myCalendar.delegate = self;
    
    [_myView addSubview:myCalendar];
    
    _mySavedEvents = [[NSMutableArray alloc]init];
    _myEventDate = [[NSMutableArray alloc]init];
    _myEventTime = [[NSMutableArray alloc]init];
    
    /*
     * Set up Tutor Picker for Tutor selection in UIAlertController
     */
    _TutorArray = [[NSArray alloc]initWithObjects:@"", @"Josh John", @"Ashley Combs", @"Dylan Roberts", nil];
    
    tutorPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 43, 320, 480)];
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
     * Set up Time Picker for Time selection in UIAlertController
     */
    _TimeArray = [[NSArray alloc]initWithObjects:@"", @"1:00pm", @"1:30pm", @"2:00pm", nil];
    
    timePicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 43, 320, 480)];
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
    
    //Set min date for date picker
    [datePicker setMinimumDate:[NSDate date]];
    
}

/*
 * Method to show the selected Tutor
 */
#pragma mark - Picker Show Selected Methods
-(void)ShowSelectedTutor
{
    [_TutorTextField resignFirstResponder];
}
/*
 * Method to show the selected Time
 */
-(void)ShowSelectedTime
{
    [_TimeTextField resignFirstResponder];
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
    else return [_TimeArray count];
}
/*
 * Method is used to determinet the array at the certain index.
 */
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if([pickerView isEqual:tutorPicker]) return [_TutorArray objectAtIndex:row];
    else return [_TimeArray objectAtIndex:row];
}
/*
 * Method Required by PickerView to set the text field to the current selected value in the picker view.
 */
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if([pickerView isEqual:tutorPicker]) _TutorTextField.text = [_TutorArray objectAtIndex:row];
    else _TimeTextField.text = [_TimeArray objectAtIndex:row];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SACalendar Delegate Methods
/*
 * Method is used when user clicks on a certain date, displays any events if there is any otherwise
 * it displays message @"No Events".
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
    
    
    /*
     NSString *myURL = @"https://tutorme.stetson.edu/api/getAppointmentRequests";
     NSURL *myNSURL = [NSURL URLWithString:myURL];
     NSMutableURLRequest *rq = [NSMutableURLRequest requestWithURL:myNSURL];
     [rq setHTTPMethod:@"POST"];
     NSString *post2 = [NSString stringWithFormat:@"as=Student&ID=%@", @"800679878"];
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
     */
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
    NSLog(@"%02/%i",month,year);
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }*/

@end
