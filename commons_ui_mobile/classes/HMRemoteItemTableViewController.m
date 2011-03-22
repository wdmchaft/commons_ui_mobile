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

#import "HMRemoteItemTableViewController.h"

@implementation HMRemoteItemTableViewController

@synthesize receivedData = _receivedData;
@synthesize remoteGroup = _remoteGroup;
@synthesize operationType = _operationType;

- (id)init {
    // calls the super
    self = [super init];

    // initializes the structures
    [self initStructures];

    // constructs the structures
    [self constructStructures];

    // returns self
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    // calls the super
    self = [super initWithCoder:aDecoder];

    // initializes the structures
    [self initStructures];

    // constructs the structures
    [self constructStructures];

    // returns self
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    // calls the super
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    // initializes the structures
    [self initStructures];

    // constructs the structures
    [self constructStructures];

    // returns self
    return self;
}

- (id)initWithNibNameAndType:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil operationType:(HMItemOperationType)operationType {
    // calls the super
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    // initializes the structures
    [self initStructures];

    // sets the operation type
    self.operationType = operationType;

    // constructs the structures
    [self constructStructures];

    // returns self
    return self;
}

- (void)dealloc {
    // releases the received data
    [self.receivedData release];

    // releases the remote group
    [self.remoteGroup release];

    // calls the super
    [super dealloc];
}

- (void)viewDidAppear:(BOOL)animated {
    // shows the toolbar
    [self showToolbar];
}

- (void)viewWillDisappear:(BOOL)animated {
    // hides the toolbar
    [self hideToolbar];
}

- (void)initStructures {
    // sets the table view as editable
    self.operationType = HMItemOperationUpdate;
}

- (NSString *)getRemoteUrl {
    return nil;
}

- (void)buttonClicked:(NSString *)buttonName {
}

- (void)constructStructures {
    // creates the item table view and sets the item table
    // view provider and the item delegate
    HMItemTableView *itemTableView = (HMItemTableView *) self.tableView;
    itemTableView.itemTableViewProvider = self;
    itemTableView.itemDelegate = self;

    // switches over the operation type
    // in order to create the apropriate
    // components
    switch (self.operationType) {
        // in case it's a create operation
        case HMItemOperationCreate:
            // constructs the create structures
            [self constructCreateStructures];

            // breaks the swtich
            break;

        // in case it's an update operation
        case HMItemOperationUpdate:
            // constructs the update structures
            [self constructUpdateStructures];

            // breaks the switch
            break;

        default:
            break;
    }
}

- (void)constructCreateStructures {
    // creates the cancel bar button
    UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action: @selector(cancelButtonClick:extra:)];

    // creates the done button
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action: @selector(doneButtonClick:extra:)];

    // sets the bar buttons
    self.navigationItem.leftBarButtonItem = cancelBarButton;
    self.navigationItem.rightBarButtonItem = doneBarButton;

    // releases the objects
    [cancelBarButton release];
    [doneBarButton release];
}

- (void)constructUpdateStructures {
    // creates the edit bar button
    UIBarButtonItem *editBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action: @selector(editButtonClick:extra:)];

    // sets the bar buttons
    self.navigationItem.rightBarButtonItem = editBarButton;

    // releases the objects
    [editBarButton release];
}

- (void)processRemoteData:(NSDictionary *)remoteData {
}

- (NSMutableDictionary *)convertRemoteGroup {
    // allocates the remote data
    NSMutableDictionary *remoteData = [[NSMutableDictionary alloc] init];

    // returns the remote data in auto release
    return [remoteData autorelease];
}

- (void)editButtonClick:(id)sender extra:(id)extra {
    // in case the table view is in editing mode
    if(self.tableView.editing) {
        // sets the table view as not editing
        [self.tableView setEditing:NO animated:YES];

        // casts the table view as item table view
        HMItemTableView *itemTableView = (HMItemTableView *) self.tableView;

        // flushes the item specification
        [itemTableView flushItemSpecification];

        // converts the remote group, retrieving the remote
        // data
        NSDictionary *remoteData = [self convertRemoteGroup];

        // creates the http data from the remote data
        NSData *httpData = [HMHttpUtil createHttpData:remoteData];

        // retrieves the object id
        NSString *objectId = [remoteData objectForKey:@"object_id"];

        // creates the update url
        NSString *updateUrl = [NSString stringWithFormat:@"http://172.16.0.24:8080/colony_mod_python/rest/mvc/omni/users/%@/update", objectId];

        // creates the request
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:updateUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];

        // sets the http request properties, for a post request
        [request setHTTPMethod: HTTP_POST_METHOD];
        [request setHTTPBody:httpData];
        [request setValue:HTTP_APPLICATION_URL_ENCODED forHTTPHeaderField:@"content-type"];

        // creates the connection with the intance as delegate
        NSConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:nil];

        // releases the connection
        [connection release];
    }
    // otherwise it must not be editing
    else {
        // sets the table view as editing
        [self.tableView setEditing:YES animated:YES];
    }
}

- (void)cancelButtonClick:(id)sender extra:(id)extra {
    // dismisses the modal view controller in animated mode
    [self dismissModalViewControllerAnimated:YES];
}

- (void) updateRemote {
    // retrieves the remote url
    NSString *remoteUrl = [self getRemoteUrl];

    // creates the request
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:remoteUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];

    // creates the connection with the intance as delegate
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];

    // creates the received data
    NSMutableData *receivedData = [[NSMutableData alloc] init];

    // creates a "new" remote data and initializes it
    NSArray *remoteData = [[NSArray alloc] init];

    // sets the attributes
    //self.connection = connection;
    self.receivedData = receivedData;
    //self.remoteData = remoteData;

    // unsets the remote dirty flag
    //remoteDirty = NO;

    // releases the objects
    [connection release];
    [receivedData release];
    [remoteData release];
}

- (HMNamedItemGroup *)getItemSpecification {
    return self.remoteGroup;
}

- (void)didSelectItemRowWithItem:(HMItem *)item {
}

- (void)didDeselectItemRowWithItem:(HMItem *)item {
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // adds the data to the received data
    [self.receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // creates a new json parser
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];

    // parses the received (remote) data and sets it into the intance
    NSDictionary *remoteData = [jsonParser objectWithData:self.receivedData];

    // processes the remote data, setting the remote group
    [self processRemoteData:remoteData];

    // reloads the data
    [self.tableView reloadData];

    // releases the json parser
    [jsonParser release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
}

- (void)showToolbar {
    // shows the navigation controller toolbar
    [self.navigationController setToolbarHidden:NO animated:YES];

    // sets the navigation toolbar tint color
    self.navigationController.toolbar.tintColor = self.navigationController.navigationBar.tintColor;

    // creates the trash item
    UIBarButtonItem *trashItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteButtonClicked:)];

    // sets the trash item style
    trashItem.style = UIBarButtonItemStylePlain;

    // flexible item used to separate the left groups items and right grouped items
    UIBarButtonItem *flexibleSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    // create the system-defined refresh button
    UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:nil];

    // sets the system item style
    refreshItem.style = UIBarButtonItemStylePlain;

    // creates the toolbar items list
    NSArray *items = [NSArray arrayWithObjects: trashItem, flexibleSpaceItem, refreshItem, nil];

    // sets the toolbar items in the toolbar
    [self.navigationController.toolbar setItems:items animated:NO];
}

- (void)hideToolbar {
    // hides the navigation controller toolbar
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)deleteButtonClicked:(id)sender {
    CATransition *animation = [CATransition animation];
    animation.type = @"suckEffect";
    animation.duration = 2.0f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    [self.view.layer addAnimation:animation forKey:@"transitionViewAnimation"];
}

+ (void)_keepAtLinkTime {
}

@end