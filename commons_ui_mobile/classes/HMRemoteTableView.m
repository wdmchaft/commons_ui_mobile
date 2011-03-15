// Hive Mobile
// Copyright (C) 2008 Hive Solutions Lda.
//
// This file is part of Hive Mobile.
//
// Hive Mobile is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Hive Mobile is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Hive Mobile. If not, see <http://www.gnu.org/licenses/>.

// __author__    = João Magalhães <joamag@hive.pt>
// __version__   = 1.0.0
// __revision__  = $LastChangedRevision: 2390 $
// __date__      = $LastChangedDate: 2009-04-02 08:36:50 +0100 (qui, 02 Abr 2009) $
// __copyright__ = Copyright (c) 2008 Hive Solutions Lda.
// __license__   = GNU General Public License (GPL), Version 3

#import "HMRemoteTableView.h"

#import "HMRemoteTableViewDataSource.h"

@implementation HMRemoteTableView

@synthesize remoteDataSource = _remoteDataSource;
@synthesize remoteDelegate = _remoteDelegate;

- (id)init {
    // calls the super
    self = [super init];

    // returns self
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    // calls the super
    self = [super initWithCoder:aDecoder];

    // returns self
    return self;
}

- (NSObject<HMRemoteTableViewProvider> *)remoteTableViewProvider {
    return _remoteTableViewProvider;
}

- (void)setRemoteTableViewProvider:(NSObject<HMRemoteTableViewProvider> *)remoteTableViewProvider {
    _remoteTableViewProvider = remoteTableViewProvider;

    // creates and sets the remote table view data source
    // from the remote table view provider
    self.remoteDataSource = [[HMRemoteTableViewDataSource alloc] initWithRemoteTableViewProvider:remoteTableViewProvider];
    self.dataSource = self.remoteDataSource;

    // sets the current instance as the delegate to the table view
    self.delegate = self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // retrieves the remote data
    NSMutableArray *remoteData = self.remoteDataSource.remoteData;

    // retrieves the index path row
    NSInteger row = indexPath.row;

    // retrieves the remote data item from the remote data at the row
    NSMutableDictionary *remoteDataItem = [remoteData objectAtIndex:row];

    // calls the did select remote row with data method
    [self.remoteDelegate didSelectRemoteRowWidthData:remoteDataItem];
}

+ (void)_keepAtLinkTime {
}

@end
