//
//  DrawingController.m
//  DrawLines
//
//  Created by Reetu Raj on 11/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DrawingController.h"


@implementation DrawingController
@synthesize tapRecognizer;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {

    [self.view setBackgroundColor:[UIColor whiteColor]];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    resData = [[NSMutableData alloc] init];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        drawScreen = [[MyLineDrawingView alloc]initWithFrame:CGRectMake(0, 0, 1024, 718)];
    } else {
        drawScreen = [[MyLineDrawingView alloc]initWithFrame:CGRectMake(0, 0, 568, 270)];
    }
    
    [self.view addSubview:drawScreen];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (IBAction)clear:(id)sender {
    [drawScreen clear];
}

-(IBAction)send:(id)sender {
    
    UIGraphicsBeginImageContext(drawScreen.frame.size);
    [drawScreen.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData* pngData = UIImagePNGRepresentation(resultImage);

    NSString *urlString = @"http://work.dsworld.net:8888/ocr";
	
	// setting up the request object now
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
    
	NSString *boundary = @"----WebKitFormBoundaryXHZ0f6AXrFTtNfrY";
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	/*
	 now lets create the body of the post
     */
    NSMutableData *body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Disposition: form-data; name=\"image\"; filename=\"image.png\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Type: image/png\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[NSData dataWithData:pngData]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	// setting the body of the post to the reqeust
	[request setHTTPBody:body];
    
    (void)[[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    [self clear:self];
    
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    //NSLog(@"HTTP get response");
    [resData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    //NSLog(@"HTTP got data");
    [resData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"HTTP Error" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:resData options:kNilOptions error:&error];
    
    NSLog(@"%@", json);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OCR Success" message:[json valueForKey:@"text"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}






@end
