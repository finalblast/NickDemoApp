//
//  ToDoItemDetailViewController.m
//  NickDemoApp
//
//  Created by Nam (Nick) N. HUYNH on 9/9/15.
//  Copyright (c) 2015 Nam (Nick) N. HUYNH. All rights reserved.
//

#import "ToDoItemDetailViewController.h"
#import "SmileWeatherDownLoader.h"
#import "SearchTableViewController.h"

@interface ToDoItemDetailViewController () <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating>

@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) SearchTableViewController *searchTableVC;
@property (nonatomic, strong) NSArray *searchResults;


@end

@implementation ToDoItemDetailViewController {
    
    SmileWeatherDemoVC *demoVC;
    NSUserDefaults *userDefaults;
    
}

#define IS_OS_7    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
static NSString * const reuseIdentifier = @"searchCell";
static NSString * const searchTableIdentifier = @"SearchTable";
static NSString * const demoLocation_key = @"demoLocation";

- (void) firstLaunchRegister {

    userDefaults = [NSUserDefaults standardUserDefaults];
    CLLocationCoordinate2D coordinate = self.itemToShow.travelPlace.location.coordinate;
    NSNumber *lat = [NSNumber numberWithDouble:coordinate.latitude];
    NSNumber *lon = [NSNumber numberWithDouble:coordinate.longitude];
    NSDictionary *userLocation = @{
                                   @"lat":lat,
                                   @"long":lon
                                   };
    [userDefaults registerDefaults:userLocation];
}

- (CLLocation *) locationInUserDefaults {
    if (!userDefaults) {
        userDefaults = [NSUserDefaults standardUserDefaults];
    }
    NSNumber *lat = [userDefaults objectForKey:@"lat"];
    NSNumber *lon = [userDefaults objectForKey:@"long"];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[lat doubleValue] longitude:[lon doubleValue]];
    return location;
}

- (void) saveLocationInUserDefaults:(CLLocation *)location {
    if (!userDefaults) {
        userDefaults = [NSUserDefaults standardUserDefaults];
    }
    CLLocationCoordinate2D coordinate = location.coordinate;
    NSNumber *lat = [NSNumber numberWithDouble:coordinate.latitude];
    NSNumber *lon = [NSNumber numberWithDouble:coordinate.longitude];
    [userDefaults setObject:lat forKey:@"lat"];
    [userDefaults setObject:lon forKey:@"long"];
                     
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self saveLocationInUserDefaults:self.itemToShow.travelPlace.location];
    if (!IS_OS_7) {
        [self configureSearchControllerAndSearchResultsController];
    }
    demoVC = [SmileWeatherDemoVC DemoVCToView:self.contentView];
    [self getWeatherData];
}

- (void) getWeatherData {
    CLLocation *location = [self locationInUserDefaults];
    [[SmileWeatherDownLoader sharedDownloader] getWeatherDataFromLocation:location completion:^(SmileWeatherData *data, NSError *error) {
        if (error) {
            NSLog(@"ERROR--->: %@", error);
        } else {
            demoVC.data = data;
        }
    }];
}

- (void) configureSearchControllerAndSearchResultsController {
    self.searchTableVC = [self.storyboard instantiateViewControllerWithIdentifier:searchTableIdentifier];
    self.searchTableVC.tableView.delegate = self;
    self.searchTableVC.tableView.dataSource = self;
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchTableVC];
    self.searchController.searchResultsUpdater = self;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.dimsBackgroundDuringPresentation = YES;
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.navigationItem.titleView = self.searchController.searchBar;
    self.definesPresentationContext = true;
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = searchController.searchBar.text;
    [[SmileWeatherDownLoader sharedDownloader] getPlacemarksForSearchDisplayFromString:searchString completion:^(NSArray *placeMarks, NSError *error) {
        self.searchResults = placeMarks;
        [self.searchTableVC.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.searchResults) {
        return self.searchResults.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if (self.searchResults.count > 0) {
        CLPlacemark *placemark = self.searchResults[indexPath.row];
        cell.textLabel.text = [SmileWeatherDownLoader placeNameForSearchDisplay:placemark];
    } else {
        cell.textLabel.text = @"";
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    CLPlacemark *placeMark = self.searchResults[indexPath.row];
    [self saveLocationInUserDefaults:placeMark.location];
    self.searchController.active = NO;
    demoVC.loading = YES;

    [[SmileWeatherDownLoader sharedDownloader] getWeatherDataFromPlacemark:placeMark completion:^(SmileWeatherData *data, NSError *error) {
        if (error) {
            NSLog(@"Error -- > : %@", error);
        } else {
            demoVC.data = data;
            self.searchResults = [NSArray new];
        }
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
