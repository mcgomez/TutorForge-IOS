//
//  FeedbackViewController.h
//  TutorForge
//
//  Created by Marisa Gomez on 01/29/16.
//  Copyright © 2015 Learnsmith Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>


//Properties for tableView
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property(nonatomic, retain) NSMutableArray *tableData;

@end
