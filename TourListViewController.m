//
//  TourListViewController.m
//  WalkingTours
//
//  Created by Alberto Vega Gonzalez on 12/15/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

#import "TourListViewController.h"
#import "Location.h"
#import "Tour.h"
#import "POIDetailTableViewCell.h"
@interface TourListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tourListTableView;
@property (strong, nonatomic) NSArray <Tour*>*tours;

@end

@implementation TourListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupViewController
{
    //Setup tableView
    [self.tourListTableView setDelegate:self];
    [self.tourListTableView setDataSource:self];
    
    UINib *nib = [UINib nibWithNibName:@"POIDetailTableViewCell" bundle:nil];
    [[self tourListTableView] registerNib:nib forCellReuseIdentifier:@"POIDetailTableViewCell"];
}


#pragma mark - UITableView protocol functions.

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.tours != nil) {
        return self.tours.count;
        
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    POIDetailTableViewCell *cell = (POIDetailTableViewCell*) [self.tourListTableView dequeueReusableCellWithIdentifier:@"POIDetailTableViewCell"];
    [cell setTour:[self.tours objectAtIndex:indexPath.row]];
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
