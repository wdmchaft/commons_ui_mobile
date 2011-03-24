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
// __date__      = $LastChangedDate: 2009-04-02 08:36:50 +0100 (qui, 02 2009) $
// __copyright__ = Copyright (c) 2008 Hive Solutions Lda.
// __license__   = GNU General Public License (GPL), Version 3

#import "HMRemoteAbstraction.h"

@implementation HMRemoteAbstraction

@synthesize view = _view;
@synthesize remoteDelegate = _remoteDelegate;
@synthesize activity = _activity;
@synthesize activityIndicator = _activityIndicator;
@synthesize url = _url;
@synthesize connection = _connection;
@synthesize receivedData = _receivedData;

- (id)init {
    // calls the super
    self = [super init];

    // returns self
    return self;
}

- (id)initWithUrl:(NSString *)url {
    // calls the super
    self = [super init];

    // sets the attributes
    self.url = url;

    // returns self
    return self;
}

- (void)dealloc {
    // releases the activity
    [_activity release];

    // releases the activity indicator
    [_activityIndicator release];

    // releases the url
    [_url release];

    // releases the connection
    [_connection release];

    // releases the connection
    [_receivedData release];

    // calls the super
    [super dealloc];
}

- (void)updateRemote {
    // shows the activity indicator
    [self showActivityIndicator];

    // creates the request
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:HM_REMOTE_TABLE_VIEW_CONNECTION_TIMEOUT];

    // creates the connection with the intance as delegate
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];

    // creates the received data
    NSMutableData *receivedData = [[NSMutableData alloc] init];

    // sets the attributes
    self.connection = connection;
    self.receivedData = receivedData;

    // releases the objects
    [connection release];
    [receivedData release];
}

- (void)cancelRemote {
    // cancels the connection
    [self.connection cancel];

    // hides the activity indicator
    [self hideActivityIndicator];
}

- (void)createActivityIndicator {
    // creates the activity
    UIView *activity = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    activity.backgroundColor = [UIColor blackColor];
    activity.alpha = 0.75;

    // creates the activity indicator
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake(self.view.bounds.size.width / 2 - 12, self.view.bounds.size.height / 2 - 12, 24, 24)];
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    activityIndicator.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);

    // creates the activity structure
    [activity addSubview:activityIndicator];
    [self.view addSubview:activity];

    // sets the attributes
    self.activity = activity;
    self.activityIndicator = activityIndicator;

    // releases the objects
    [activity release];
    [activityIndicator release];
}

- (void)showActivityIndicator {
    // in case the activity indicator is not set
    if(self.activityIndicator == nil) {
        // creates the activity indicator
        [self createActivityIndicator];
    }

    // shows the activity
    self.activity.hidden = NO;

    // starts animating the activity indicator
    [self.activityIndicator startAnimating];
}

- (void)hideActivityIndicator {
    // in case the activity indicator is not set
    if(self.activityIndicator == nil) {
        // creates the activity indicator
        [self createActivityIndicator];
    }

    // creates the fade out animation
    [UIView beginAnimations:@"fadeOut" context: nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(hideActivityIndicatorComplete)];
    [UIView setAnimationDuration:0.5];
    [self.activity setAlpha:0.0];
    [UIView commitAnimations];

    // stops animating the activity indicator
    [self.activityIndicator stopAnimating];
}

- (void)hideActivityIndicatorComplete {
    // hides the activity
    self.activity.hidden = YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // adds the data to the received data
    [self.receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // calls the remote did succeed method in the remote delegate
    [self.remoteDelegate remoteDidSucceed:self data:self.receivedData connection:self.connection];

    // hides the activity indicator
    [self hideActivityIndicator];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // retrieves the (localized) base error message
    NSString *baseErrorMessage = NSLocalizedString(@"ConnectionError", @"ConnectionError");

    // retrieves the localized error description
    NSString *localizedErrorDescription = [error localizedDescription];

    // creates the error message from the base error message and the
    // localized error description
    NSString *errorMessage = [NSString stringWithFormat:@"%@\n%@", baseErrorMessage, localizedErrorDescription];

    // creates the action sheet
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:errorMessage delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel") destructiveButtonTitle:NSLocalizedString(@"Retry", @"Retry") otherButtonTitles:nil];
    actionSheet.alpha = 0.75;

    // sets the action sheet style
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;

    // shows the action sheet in the table view
    [actionSheet showInView:self.view];

    // releases the action sheet
    [actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // in case the button click was retry
    if(buttonIndex == 0) {
        // updates the remote
        [self updateRemote];
    }
    // in case the button click was cancel
    else {
        // calls the remote did fail method in the remote delegate
        [self.remoteDelegate remoteDidFail:self error:nil];

        // hides the activity indicator
        [self hideActivityIndicator];
    }
}

@end