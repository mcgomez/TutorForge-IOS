//
//  StudentRequestsViewController.m
//  TutorForge
//
//  Created by Marisa Gomez on 01/29/16.
//  Copyright © 2015 Learnsmith Solutions. All rights reserved.
//

#import "StudentRequestsViewController.h"

@interface StudentRequestsViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *myEditButton;
@property int Editing;

@end

@implementation StudentRequestsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _Editing = 0;
    _tableData = [[NSMutableArray alloc]init];
    
    //dummy data
    _tableData = [[NSMutableArray alloc]initWithObjects:@"CSI with Ashley @ 2:00pm", @"Math with Jacob @ 3:00pm", @"Science with John @ 4:00pm", nil];

    //Run task in background off main thread and return it back to main thread.
    dispatch_async(dispatch_get_main_queue(), ^{
        //Populate tutors array
        
        // DEPENDING ON SUBJECT OF STUDENT IS WHAT IS PASSEED BELOW *** Then added into
        //Tutor array
        NSString *myURL = @"https://tutorme.stetson.edu/api/getAppointmentRequests";
        NSURL *myNSURL = [NSURL URLWithString:myURL];
        
        NSString *eTyp = @"FooErrType";
        int eID = 0xf00;
        NSError *eErr = [NSError errorWithDomain:eTyp
                                            code:eID userInfo:nil];
        
        NSMutableURLRequest *rq = [NSMutableURLRequest requestWithURL:myNSURL];
        [rq setHTTPMethod:@"POST"];
        NSString *post2 = [NSString stringWithFormat:@"Student&ID=%@", @"800606792"]; // ***CHANGE TO CURRENT LOGGED IN STUDENT
        NSData *postData2 = [post2 dataUsingEncoding:NSASCIIStringEncoding];
        [rq setHTTPBody:postData2];
        [rq setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        

        
        //Recieve the JSON data from the PHP file
        NSError *error = [[NSError alloc]init];
        NSHTTPURLResponse *response = nil;
        NSData *urlData = [NSURLConnection sendSynchronousRequest:rq returningResponse:&response error:&eErr];
        
        
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
                [_tableData addObject:[[[myData objectForKey:@"result"] objectAtIndex:i] objectForKey:@"FullName"]];
                
            }
        }
        
        
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Delegate Methods
/*
 * Method to display number of cells in table based off tableData count.
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tableData count];
}
/*
 * Method is used to populate the table veiw for each cell using the tabledata NSMutuableArray.
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myTableIdentifier = @"TableItem";
    
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:myTableIdentifier];
    
    if(myCell == nil)
    {
        myCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTableIdentifier];
    }
    
    myCell.textLabel.text = [_tableData objectAtIndex:indexPath.row];
    
    //    myCell.imageView.image = [UIImage imageNamed:@""]; if we want to use a image with each cell
    return myCell;
}
/*
 * Method used to enable editing on table view.
 */
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
/*
 * Method used when deleting row in table to delete in database as well.
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //DELETE IN DATABASE AND ARRAY
        //Remove item from array but need to remove from database!
        [_tableData removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
    }
}
/*
- (IBAction)editButton:(UIBarButtonItem *)sender {
    if(_Editing == 0)
    {
        _Editing = 1;
        _myEditButton.title = @"Cancel";
        [self.myTableView setEditing:YES animated:YES];
    } else {
        _Editing = 0;
        _myEditButton.title = @"Edit";
        [self.myTableView setEditing:NO animated:NO];
    }
} */

/*
 * Method tableview delegate is used when user selects a row in the table view.
 * Displays an alert with request sent & with option to resend the request.
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"Request" message:[NSString stringWithFormat:@"%@", [_tableData objectAtIndex:indexPath.row]] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *resendRequest = [UIAlertAction actionWithTitle:@"Resend Request" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                    {
                                        //NEED TO RESEND REQUEST THROUGH DATABASE OR CHANGE TO BE ABLE TO DELETE REQUEST FROM DATABASE?
                                        //NO NEED TO RESEND?
                                        UIAlertController *sentAlert = [UIAlertController alertControllerWithTitle:nil message:@"Request Resent!" preferredStyle:UIAlertControllerStyleAlert];
                                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}];
                                        [sentAlert addAction:okAction];
                                        [self presentViewController:sentAlert animated:YES completion:nil];
                                    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){}];
    
    [myAlert addAction:resendRequest];
    [myAlert addAction:cancel];
    [self presentViewController:myAlert animated:YES completion:nil];
    
}

@end
