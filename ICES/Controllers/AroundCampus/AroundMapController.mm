//
//  AroundMapController.m
//  ICES
//
//  Created by 徐宝桥 on 14/12/23.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "AroundMapController.h"

@interface AroundMapController ()<BMKMapViewDelegate>

@property (nonatomic, strong) BMKMapView *mapView;

@end

@implementation AroundMapController

- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if (kDeviceVersion >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor clearColor];
    [self initAndLayoutUI];
    [self showLocationInMap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark - UI

- (void)initAndLayoutUI {
    _mapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
    _mapView.mapType = BMKMapTypeStandard;
    _mapView.zoomLevel = 16;
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(15, 20, 60, 44);
    [back setTitle:@"Back" forState:UIControlStateNormal];
    [back setTitleColor:kColor(134, 175, 201, 1) forState:UIControlStateNormal];
    [back setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    back.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 28);
    [self.view addSubview:back];
}

#pragma mark - Data

- (void)showLocationInMap {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([_latitude floatValue], [_longitude floatValue]);
    [_mapView setCenterCoordinate:coordinate animated:YES];
    [self addAnnotation];
}

- (void)addAnnotation {
    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
    CLLocationCoordinate2D coor;
    coor.latitude = [_latitude floatValue];
    coor.longitude = [_longitude floatValue];
    annotation.coordinate = coor;
    annotation.title = _addressName;
    [_mapView addAnnotation:annotation];
}

#pragma mark - Action

- (IBAction)back:(id)sender {
    [UIView animateWithDuration:.5 animations:^{
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
        [self.navigationController popViewControllerAnimated:NO];
    }];
}

#pragma mark - BMKMapView

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    static NSString *ID = @"annotation";
    BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ID];
        annotationView.pinColor = BMKPinAnnotationColorRed;
    }
    return annotationView;
}

@end
