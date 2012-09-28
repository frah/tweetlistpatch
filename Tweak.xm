#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>

@interface TLBrowserController <UIWebViewDelegate>
{
    NSURL *url_;
    NSString *documentTitle_;
    unsigned int activeRequestCount_;
    BOOL busy_;
    BOOL ignoreMedia_;
    UIWebView *webView_;
    UIBarButtonItem *toolbarBackButtonItem_;
    UIBarButtonItem *toolbarForwardButtonItem_;
}

@property(nonatomic) BOOL ignoreMedia; // @synthesize ignoreMedia=ignoreMedia_;
@property(retain,nonatomic) UIBarButtonItem *toolbarForwardButtonItem; // @synthesize toolbarForwardButtonItem=toolbarForwardButtonItem_;
@property(retain,nonatomic) UIBarButtonItem *toolbarBackButtonItem; // @synthesize toolbarBackButtonItem=toolbarBackButtonItem_;
@property(retain, nonatomic) UIWebView *webView; // @synthesize webView=webView_;
@property(nonatomic) BOOL busy; // @synthesize busy=busy_;
@property(readonly, nonatomic) unsigned int activeRequestCount; // @synthesize activeRequestCount=activeRequestCount_;
@property(copy, nonatomic) NSString *documentTitle; // @synthesize documentTitle=documentTitle_;
@property(copy, nonatomic) NSURL *url; // @synthesize url=url_;
- (id)otherActionSheet;
- (void)updateSpinnerUI;
- (void)updateUI;
- (BOOL)checkForMediaWithURL:(id)arg1 ignoreRaw:(BOOL)arg2;
- (BOOL)isCurrentURLMobilized;
- (id)unmobilizeURL:(id)arg1;
- (BOOL)isMobilizerEnabled;
- (void)openURL:(id)arg1;
- (void)readLaterService:(id)arg1 didFailToAddURL:(id)arg2 error:(id)arg3;
- (void)readLaterService:(id)arg1 didAddURL:(id)arg2;
- (void)toggleMobilizerAction;
- (void)tweetLinkAction;
- (void)readLaterAction;
- (void)openInSafariAction;
- (void)emailLinkAction;
- (void)reloadAction;
- (void)forwardAction;
- (void)closeAction;
- (void)backAction;
- (void)mailComposeController:(id)arg1 didFinishWithResult:(int)arg2 error:(id)arg3;
- (void)webView:(id)arg1 didFailLoadWithError:(id)arg2;
- (void)webViewDidFinishLoad:(id)arg1;
- (void)webViewDidStartLoad:(id)arg1;
- (BOOL)webView:(id)arg1 shouldStartLoadWithRequest:(id)arg2 navigationType:(unsigned int)arg3;
- (void)presentFromViewController:(id)arg1;
- (BOOL)shouldAutorotateToInterfaceOrientation:(int)arg1;
- (void)viewDidLoad;
- (void)viewDidUnload;
- (id)initWithURL:(id)arg1;
- (void)dealloc;

@end
@interface TLDraft
{
    NSString *text_;
}

+ (id)draftDirectMessageToUsername:(id)arg1;
+ (id)draftStatusInReplyTo:(id)arg1 withText:(id)arg2;
+ (id)draftStatusWithText:(id)arg1;
@property(copy, nonatomic) NSString *text; // @synthesize text=text_;
- (id)subtitle;
- (id)title;
- (void)didFailToSendDM:(id)arg1;
- (void)didSendDM:(id)arg1;
- (void)didFailToSendTweet:(id)arg1;
- (void)didSendTweet:(id)arg1;
- (void)photoService:(id)arg1 didFailToUploadWithError:(id)arg2;
- (void)photoService:(id)arg1 didUploadPhotoWithURLString:(id)arg2;
- (void)longTweetService:(id)arg1 didFailWithError:(id)arg2;
- (void)longTweetService:(id)arg1 didShortenOriginalText:(id)arg2 shortenedText:(id)arg3;
- (void)showAlertWithMessage:(id)arg1;
- (void)sendFailedWithMessage:(id)arg1;
- (void)send;
- (BOOL)isDirectMessage;
- (BOOL)hasLocation;
- (int)charactersRemaining;
- (id)embeddedURLsAsStrings:(BOOL)arg1;
- (BOOL)isEmpty;
- (int)compare:(id)arg1;
@property(readonly) NSString *headerText;
- (unsigned int)attachmentCount;
- (void)addAttachment:(id)arg1;
- (id)description;
- (unsigned int)hash;
- (BOOL)isEqual:(id)arg1;
- (void)encodeWithCoder:(id)arg1;
- (id)initWithCoder:(id)arg1;
- (id)init;
- (void)dealloc;

@end
@interface ComposeController_iPhone
{
    TLDraft *draft_;
}

+ (void)initialize;
@property(retain, nonatomic) TLDraft *draft; // @synthesize draft=draft_;
- (id)unmobilizeURL:(id)arg1;
@end

%hook TLBrowserController

- (void)tweetLinkAction {
    %log;
    /* Get page title from HTML */
    /*
    NSURL *url = (NSURL *)[self unmobilizeURL:[self url]];
    NSStringEncoding usedEncoding;
    NSError *error = nil;
    [self webView] 
    NSString *htmlData = [NSString stringWithContentsOfURL:url usedEncoding:&usedEncoding error:&error];
    if (error != nil) {
        NSLog(@"Failed to fetch html: %@", error);
        return %orig;
    }
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<title>(.+)</title>" options:0 error:&error];
    if (error != nil) {
        NSLog(@"Failed to initialize RegularExpression: %@", error);
        return %orig;
    }
    NSTextCheckingResult *match = [regex firstMatchInString:htmlData options:0 range:NSMakeRange(0, 200)];
    if (match.numberOfRanges != 2) {
        NSLog(@"Failed to parse html: %@", match);
        return %orig;
    }
    NSString *title = [htmlData substringWithRange:[match rangeAtIndex:1]];
    [match release];
    [regex release];
    [htmlData release];
    */
    NSString *url = [[self webView] stringByEvaluatingJavaScriptFromString:@"location.href"];
    NSString *title = [[self webView] stringByEvaluatingJavaScriptFromString:@"document.title"];

    NSString *text = [NSString stringWithFormat:@" -- %@ %@", title, url];
    NSLog(@"Default Text: %@", text);

    //[[[[UIAlertView alloc] initWithTitle:@"debug" message:text delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] autorelease] show];
    TWTweetComposeViewController* vc = [[TWTweetComposeViewController alloc] init];
    [vc setInitialText:[NSString stringWithFormat:@" -- %@", title]];
    [vc addURL:[NSURL URLWithString:url]];
    [(UIViewController *)self presentViewController:vc animated:YES completion:^{
        UIWindow *win = [[UIApplication sharedApplication] keyWindow];
        UITextView *textView = [win performSelector:@selector(firstResponder)];
        textView.selectedRange = NSMakeRange(0, 0);
    }];
    [vc release];

    /* Show compose window */
    /*
    ComposeController_iPhone *ccc = [[%c(ComposeController_iPhone) alloc] init];
    [ccc setDraft:[%c(TLDraft) draftStatusWithText:text]];
    NSLog(@"set draft: %@", ccc);
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:(UIViewController *)self];
    NSLog(@"init nav controller: %@", nc);
    [nc presentModalViewController:(UIViewController *)ccc animated:YES];
    [nc release];
    */
}

%end

%hook AppDelegate_iPhone
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL*)url {
    %log;
    NSString *msg = [NSString stringWithFormat:@"[URL]%@\n[scheme]%@\n[Query]%@", [url absoluteString], [url scheme], [url query]];
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"debug" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] autorelease];
    [alert show];
    return %orig;
}
%end

