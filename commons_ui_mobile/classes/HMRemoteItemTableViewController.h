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

#import "Dependencies.h"

#import "HMItemTableView.h"
#import "HMItemTableViewDelegate.h"
#import "HMItemTableViewProvider.h"

/**
 * The http post method name.
 */
#define HTTP_POST_METHOD @"POST"

/**
 * The http application url encoded mime type.
 */
#define HTTP_APPLICATION_URL_ENCODED @"application/x-www-form-urlencoded"

/**
 * Enumeration defining the various item
 * operations available.
 */
typedef enum {
    HMItemOperationCreate = 1,
    HMItemOperationRead,
    HMItemOperationUpdate
} HMItemOperationType;

@interface HMRemoteItemTableViewController : UITableViewController<HMItemTableViewProvider, HMItemTableViewDelegate> {
    @private
    NSMutableData *_receivedData;
    HMNamedItemGroup *_remoteGroup;
    HMItemOperationType _operationType;
}

/**
 * The buffer for received data.
 */
@property (retain) NSMutableData *receivedData;

/**
 * The generated remote group.
 */
@property (retain) HMNamedItemGroup *remoteGroup;

/**
 * The property that defined the king of table
 * view to be presented.
 * The ui of the table view is presented according to
 * the type of operation in defined.
 */
@property (assign) HMItemOperationType operationType;

/**
 * Constructor of the class.
 *
 * @param nibNameOrNil The name of the nib to be used.
 * @param nibBundleOrNil The nib bundle to be used.
 * @param operationType The type of operation.
 */
- (id)initWithNibNameAndType:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil operationType:(HMItemOperationType)operationType;

/**
 * Initializes the structures.
 */
- (void)initStructures;

/**
 * Retrieves the remote url.
 */
- (NSString *)getRemoteUrl;

/**
 * Updates the remote reference.
 */
- (void) updateRemote;

/**
 * Constructs the internal data structures.
 */
- (void)constructStructures;

/**
 * Constructs the create operation stuctures.
 */
- (void)constructCreateStructures;

/**
 * Constructs the update operation stuctures.
 */
- (void)constructUpdateStructures;

/**
 * Processes the remote data hanlding it and constructing
 * the final adapted object item.
 * The object item is set in the remote group.
 *
 * @param remoteData The remote data to be processed.
 */
- (void)processRemoteData:(NSDictionary *)remoteData;

/**
 * Converts the remote group to the must up to date
 * information.
 * This method is called before persistence of the data
 * to obtain the must updated values.
 *
 * @return The converted remote group as remote data.
 */
- (NSMutableDictionary *)convertRemoteGroup;

/**
 * Callback handler called when the edit button is
 * clicked.
 *
 * @param sender The sender object.
 @ @param extra The extra parameters values.
 */
- (void)editButtonClick:(id)sender extra:(id)extra;

/**
 * Shows the bottom toolbar.
 */
- (void)showToolbar;

/**
 * Hides the bottom toolbar.
 */
- (void)hideToolbar;

/**
 * Deletes the item.
 */
- (void)deleteButtonClicked:(id)sender;

/**
 * Keeps the class valid for export at link time.
 */
+ (void)_keepAtLinkTime;

@end