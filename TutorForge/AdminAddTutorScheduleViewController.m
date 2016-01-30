//
//  AdminAddTutorScheduleViewController.m
//  TutorForge
//
//  Created by Marisa Gomez on 11/28/15.
//  Copyright © 2015 Learnsmith Solutions. All rights reserved.
//

#import "AdminAddTutorScheduleViewController.h"
#import "Tutor.h"

@interface AdminAddTutorScheduleViewController ()

@end

@implementation AdminAddTutorScheduleViewController
@synthesize sundayLabel;
@synthesize mondayLabel;
@synthesize tuesdayLabel;
@synthesize wednesdayLabel;
@synthesize thursdayLabel;
@synthesize fridayLabel;
@synthesize saturdayLabel;
@synthesize timeSlotInformationView;
@synthesize selectATutorLabel;
@synthesize dayPicker;
@synthesize timeSlotLabel;
@synthesize timeSlotPicker;
@synthesize days;
@synthesize times;
@synthesize dayChosen;
@synthesize startTime;
@synthesize endTime;
@synthesize tutor;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Hide timeslot information view and components
    [timeSlotInformationView setHidden:YES];
    [selectATutorLabel setHidden:YES];
    [dayPicker setHidden:YES];
    [timeSlotLabel setHidden:YES];
    [timeSlotPicker setHidden:YES];
    
    //Declare days array and times array
    days = @[@"sunday", @"monday", @"tuesday", @"wednesday", @"thursday", @"friday", @"saturday"];
    times = @[@"9:00AM", @"10:00AM", @"11:00AM", @"12:00PM", @"1:00PM", @"2:00PM", @"3:00PM", @"4:00PM", @"5:00PM", @"6:00PM", @"7:00PM", @"8:00PM", @"9:00PM", @"10:00PM", @"11:00PM", @"12:00AM"];
    
    //Get tutor
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    tutor = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"tutor"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)addTimeSlotInformation:(id)sender {
    //Add schedule array to tutor object
    
    [timeSlotInformationView setHidden:NO];
    [selectATutorLabel setHidden:NO];
    [dayPicker setHidden:NO];
    [timeSlotLabel setHidden:NO];
    [timeSlotPicker setHidden:NO];
}

-(IBAction)addSlotInformation:(id)sender {
    //Check if the times are valid (ie, start time is not after end time)
    int startIndex = 0;
    int endIndex = 0;
    for (int i = 0; i < times.count; i++) {
        if ([startTime isEqualToString:times[i]]) {
            startIndex = i;
        }
        
        if ([endTime isEqualToString:times[i]]) {
            endIndex = i;
        }
    }
    
    if (startIndex > endIndex) {
        UIAlertController *errorAlert=   [UIAlertController
                                          alertControllerWithTitle:@"Error"
                                          message:[NSString stringWithFormat:@"Start time cannot be later than end time."]
                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *confirmation = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                       {
                                           [errorAlert dismissViewControllerAnimated:YES completion:nil];
                                       }];
        
        [errorAlert addAction:confirmation];
        [self presentViewController:errorAlert animated:YES completion:nil];
        return;
    } else if (startIndex == endIndex) {
        UIAlertController *errorAlert=   [UIAlertController
                                          alertControllerWithTitle:@"Error"
                                          message:[NSString stringWithFormat:@"Start time and end time cannot be the same."]
                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *confirmation = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                       {
                                           [errorAlert dismissViewControllerAnimated:YES completion:nil];
                                       }];
        
        [errorAlert addAction:confirmation];
        [self presentViewController:errorAlert animated:YES completion:nil];
        return;
    }
    
    //Add time slot to schedule array
    
    //Get current student schedule
    NSMutableDictionary *schedule = tutor.schedule;
    
    //Get current time slots on the day chosen
    NSMutableArray *timesOnSchedule = [schedule objectForKey:dayChosen];
    
    //Create new dictionary for the new slot
    NSMutableDictionary *timesChosen = [[NSMutableDictionary alloc] init];
    
    [timesChosen setObject:startTime forKey:@"startTime"];
    [timesChosen setObject:endTime forKey:@"endTime"];
    
    if (timesOnSchedule == nil) {
        timesOnSchedule = [[NSMutableArray alloc] init];
        [timesOnSchedule addObject:timesChosen];
        [schedule setObject:timesOnSchedule forKey:dayChosen];
    } else {
        [[schedule objectForKey:[NSString stringWithFormat:@"%@", dayChosen]] addObject:timesChosen];
    }
    
    //Update labels
    NSString *scheduleString = @"";
    NSArray *dailySchedule = [schedule objectForKey:dayChosen];
    
    for (NSDictionary *timesDictionary in dailySchedule) {
        NSString *timesString = [NSString stringWithFormat:@"%@-%@", [timesDictionary objectForKey:@"startTime"], [timesDictionary objectForKey:@"endTime"]];
        if ([scheduleString isEqualToString:@""]) {
            scheduleString = [NSString stringWithFormat:@"%@", timesString];
        } else {
            scheduleString = [NSString stringWithFormat:@"%@, %@", scheduleString, timesString];
        }
    }
    
    if ([dayChosen isEqualToString:@"sunday"]) {
        sundayLabel.text = scheduleString;
    } else if ([dayChosen isEqualToString:@"monday"]) {
        mondayLabel.text = scheduleString;
    } else if ([dayChosen isEqualToString:@"tuesday"]) {
        tuesdayLabel.text = scheduleString;
    } else if ([dayChosen isEqualToString:@"wednesday"]) {
        wednesdayLabel.text = scheduleString;
    } else if ([dayChosen isEqualToString:@"thursday"]) {
        thursdayLabel.text = scheduleString;
    } else if ([dayChosen isEqualToString:@"friday"]) {
        fridayLabel.text = scheduleString;
    } else if ([dayChosen isEqualToString:@"saturday"]) {
        saturdayLabel.text = scheduleString;
    }
    
    //Hide subview
    [timeSlotInformationView setHidden:YES];
    [selectATutorLabel setHidden:YES];
    [dayPicker setHidden:YES];
    [timeSlotLabel setHidden:YES];
    [timeSlotPicker setHidden:YES];
}

#pragma mark - UIPickerViewDelegate methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if ([pickerView isEqual:dayPicker]) {
        return 1;
    } else {
        return 2;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([pickerView isEqual:dayPicker]) {
        return days.count;
    } else {
        return times.count;
    }
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ([pickerView isEqual:dayPicker]) {
        //Set inital value
        if (row == 0) {
            dayChosen = days[row];
        }
        
        NSString *title = [days objectAtIndex:row];
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        
        return attString;
    } else {
        //Set inital value
        if (row == 0) {
            if (component == 0) {
                startTime = times[row];
            } else {
                endTime = times[row];
            }
        }
        
        NSString *title = [times objectAtIndex:row];
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        
        return attString;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if ([pickerView isEqual:dayPicker]) {
        dayChosen = days[row];
    } else {
        if (component == 0) {
            startTime = times[row];
        } else {
            endTime = times[row];
        }
    }
}

- (NSString *) formatDayString:(NSMutableArray *)daySchedule {
    NSString *day = @"";
    
    int count = daySchedule.count;
    for (int i = 0; i < count; i++) {
        NSString *singleSlot = [NSString stringWithFormat:@"{Start=%@&End=%@}", [daySchedule[i] objectForKey:@"startTime"], [daySchedule[i] objectForKey:@"endTime"]];
        
        if ([day isEqualToString:@""]) {
            day = [NSString stringWithFormat:@"%@", singleSlot];
        } else {
            day = [NSString stringWithFormat:@"%@&%@", day, singleSlot];
        }
    }
    
    return day;
}

- (IBAction)saveSchedule:(id)sender {
    //Format strings for post
    NSDictionary *schedule = tutor.schedule;
    NSMutableArray *daySchedule = [[NSMutableArray alloc] init];
    NSDate *currentDate = [NSDate date];
    
    //Sunday
    daySchedule = [schedule objectForKey:@"sunday"];
    NSString *sunday = [NSString stringWithFormat:@"[%@]", [self formatDayString:daySchedule]];
    
    //Monday
    daySchedule = [schedule objectForKey:@"monday"];
    NSString *monday = [NSString stringWithFormat:@"[%@]", [self formatDayString:daySchedule]];
    
    //Tuesday
    daySchedule = [schedule objectForKey:@"tuesday"];
    NSString *tuesday = [NSString stringWithFormat:@"[%@]", [self formatDayString:daySchedule]];
    
    //Wednesday
    daySchedule = [schedule objectForKey:@"wednesday"];
    NSString *wednesday = [NSString stringWithFormat:@"[%@]", [self formatDayString:daySchedule]];
    
    //Thursday
    daySchedule = [schedule objectForKey:@"thursday"];
    NSString *thursday = [NSString stringWithFormat:@"[%@]", [self formatDayString:daySchedule]];
    
    //Friday
    daySchedule = [schedule objectForKey:@"friday"];
    NSString *friday = [NSString stringWithFormat:@"[%@]", [self formatDayString:daySchedule]];
    
    //Saturday
    daySchedule = [schedule objectForKey:@"saturday"];
    NSString *saturday = [NSString stringWithFormat:@"[%@]", [self formatDayString:daySchedule]];
    
    //Connect to server and database
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://tutorme.stetson.edu/api/tutor/createSchedule"]]];
    [request setHTTPMethod:@"POST"];
    
    NSString *test = [NSString stringWithFormat:@"[{Start=%@&End=%@}]", currentDate, currentDate];
    
    NSString *postBodyStr = [NSString stringWithFormat:@"M=%@&T=%@&W=%@&R=%@&F=%@&S=%@&U=%@", test, tuesday, wednesday, thursday, friday, saturday, sunday];
    
    NSData *encodedPostBody = [postBodyStr dataUsingEncoding:NSASCIIStringEncoding];
    [request setHTTPBody:encodedPostBody];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //Setting up for response
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    //Get response
    id json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error: nil];
    NSLog(@"JSON: %@", json);
    
    if ([[json objectForKey:@"success"] isEqual:@YES]) {
        [self performSegueWithIdentifier:@"unwindFromSchedule" sender:self];
    } else {
        UIAlertController *requestError=   [UIAlertController
                                            alertControllerWithTitle:@"Error"
                                            message:[NSString stringWithFormat:@"Error inputing schedule. Try again later."]
                                            preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmation = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                       {
                                           [requestError dismissViewControllerAnimated:YES completion:nil];
                                           
                                       }];
        [requestError addAction:confirmation];
        [self presentViewController:requestError animated:YES completion:nil];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}

@end
