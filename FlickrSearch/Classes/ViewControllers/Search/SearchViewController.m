//
//  SearchViewController.m
//  FlickrSearch
//
//  Created by TaHyKu on 16.06.17.
//  Copyright © 2017 IvanoffApps. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchTableViewCellsBuilder.h"
#import "NetworkManager.h"
#import "SVProgressHUD.h"

@interface SearchViewController () <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) SearchTableViewCellsBuilder *builder;
@property (nonatomic, strong) NetworkManager *networkManager;

@property (nonatomic, strong) NSMutableArray *flickrPhotos;
@property (nonatomic, strong) NSArray *searchRequests;
@property (nonatomic, strong) NSMutableArray *historySearchRequests;

@property (nonatomic) BOOL loadingInProgress;
@property (nonatomic) BOOL autocompleteIsInUse;
@property (nonatomic) BOOL forceSearchRequest;

@end

@implementation SearchViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initialSetup];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma mark - Override
- (void)setAutocompleteIsInUse:(BOOL)autocompleteIsInUse {
    _autocompleteIsInUse = autocompleteIsInUse;
    if (autocompleteIsInUse) {
        [self.tableView reloadData];
    } else {
        [self.flickrPhotos removeAllObjects];
        [self loadSearchResultsPage];
    }
}


#pragma mark - Setup
- (void)initialSetup {
    [self setupSearchController];
    [self setupBuilder];
    [self setupNetworkManager];
    [self setupDataSource];
}

- (void)setupSearchController {
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleProminent;
    self.searchController.searchBar.backgroundColor = [UIColor blueColor];
    self.searchController.searchBar.barTintColor = [UIColor blueColor];
    UIView *subviewsContainer = self.searchController.searchBar.subviews[0];
    for (UIView *subview in subviewsContainer.subviews) {
        if ([subview isKindOfClass:[UITextField class]]) {
            subview.backgroundColor = [UIColor whiteColor];
            break;
        }
    }
    
    self.searchController.searchBar.tintColor = [UIColor whiteColor];
    [self.searchController.searchBar setValue:@"Cancel" forKey:@"_cancelButtonText"];
    
    CGRect frame = self.searchController.searchBar.frame;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, (frame.size.height - 1), frame.size.width, 1)];
    lineView.backgroundColor = [UIColor redColor];
    
    self.definesPresentationContext = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.searchController.searchBar.translucent = NO;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
}

- (void)setupBuilder {
    self.builder = [[SearchTableViewCellsBuilder alloc] initWith:self.tableView];
}

- (void)setupNetworkManager {
    self.networkManager = [NetworkManager sharedInstance];
}

- (void)setupDataSource {
    self.flickrPhotos = [NSMutableArray array];
    self.historySearchRequests = [NSMutableArray array];
    self.searchRequests = [NSArray array];
    self.autocompleteIsInUse = YES;
}


#pragma mark - Action


#pragma mark - Network
- (void)loadSearchResultsPage {
    if (self.loadingInProgress) { return; }
    self.loadingInProgress = YES;
    
    NSInteger pageForLoading = self.flickrPhotos.count / 99 + 1;
    if (pageForLoading == 1) {
        if (![self.historySearchRequests containsObject:self.searchController.searchBar.text]) {
            [self.historySearchRequests addObject:self.searchController.searchBar.text];
        }
        [self showInitialLoader];
    }
    
    [self.networkManager searchFlickrImagesWith:self.searchController.searchBar.text page:pageForLoading success:^(BOOL success, NSArray *photos) {
        self.loadingInProgress = NO;
        if (!success) { [SVProgressHUD showWithStatus:@"So sad! An error occurred while searching..."]; return; }
        
        self.descriptionLabel.hidden = YES;
        [self.flickrPhotos addObjectsFromArray:photos];
        [self.tableView reloadData];
        if (pageForLoading == 1) { [self hideInitialLoader]; }
    }];
}


#pragma mark - Support
- (void)showInitialLoader {
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [SVProgressHUD show];
    }];
}

- (void)hideInitialLoader {
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [SVProgressHUD dismiss];
    }];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.autocompleteIsInUse ? self.searchRequests.count : self.flickrPhotos.count / 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.autocompleteIsInUse) {
        return [self.builder autocompleteCellWith:self.searchRequests[indexPath.row] boldLenght:self.searchController.searchBar.text.length];
    }
    
    NSInteger index = indexPath.row * 3;
    if (self.flickrPhotos.count - index < 24) {
        [self loadSearchResultsPage];
    }
    
    return [self.builder searchCellWith:@[self.flickrPhotos[index], self.flickrPhotos[index + 1], self.flickrPhotos[index + 2]]];
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.autocompleteIsInUse ? [self.builder autocompleteCellHeight] : [self.builder searchCellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.autocompleteIsInUse) { return; }
    self.forceSearchRequest = YES;
    self.searchController.searchBar.text = self.searchRequests[indexPath.row];
}


#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    self.descriptionLabel.hidden = (searchController.searchBar.text.length > 0);
    if (searchController.searchBar.text.length > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@", self.searchController.searchBar.text];
        self.searchRequests = [self.historySearchRequests filteredArrayUsingPredicate:predicate];
        if (self.forceSearchRequest) {
            self.forceSearchRequest = NO;
            self.autocompleteIsInUse = NO;
        } else {
            self.autocompleteIsInUse = (self.searchRequests.count > 0);
        }
    }
}

@end

