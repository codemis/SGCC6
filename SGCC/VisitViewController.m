#import "VisitViewController.h"
#import <MapKit/MapKit.h>
#define SGCC_LAT 34.1040489
#define SGCC_LONG -118.0924604
#define SPAN_DELTA 0.1
#define MAPS_DOMAIN @"http://maps.apple.com/"
#define MAPS_SADDR @"Current+Location"

@interface VisitViewController ()
@property(weak,nonatomic)IBOutlet MKMapView *mapView;
@end

@implementation VisitViewController
-(IBAction)getDirections:(id)sender {
    NSString *directionsURL = [NSString stringWithFormat:@"%@?saddr=%@&daddr=%f,%f",
                               MAPS_DOMAIN,MAPS_SADDR,SGCC_LAT,SGCC_LONG];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:directionsURL]];
}
-(MKPointAnnotation *)addPinToMapAtLocation:(CLLocationCoordinate2D)location
                                  withTitle:(NSString *)title
                               withSubtitle:(NSString *)subtitle {
    MKPointAnnotation *point = MKPointAnnotation.new;
    point.coordinate = location;
    point.title = title;
    point.subtitle = subtitle;
    [self.mapView addAnnotation:point];
    return point;
}
-(void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    MKPointAnnotation *church =
    [self addPinToMapAtLocation:CLLocationCoordinate2DMake(SGCC_LAT,SGCC_LONG)
                      withTitle:@"San Gabriel Community Church"
                   withSubtitle:@"117 N Pine St, San Gabriel, CA 91775"];
    MKCoordinateRegion region;
    region.center = church.coordinate;
    region.span.longitudeDelta = SPAN_DELTA;
    region.span.latitudeDelta = SPAN_DELTA;
    [self.mapView setRegion:region animated:YES];
}
@end