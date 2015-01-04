//
//  AroundMapDetailController.m
//  ICES
//
//  Created by 徐宝桥 on 14/12/24.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "AroundMapDetailController.h"

@interface AroundMapDetailController ()<BMKMapViewDelegate>

@property (nonatomic, strong) IBOutlet BMKMapView *mapView;

@end

@implementation AroundMapDetailController

- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
}

#pragma mark - UI

- (void)initAndLayoutUI {
    CGRect rect = self.view.bounds;
    rect.size.height -= [[UIApplication sharedApplication] statusBarFrame].size.height;
    if (kDeviceVersion >= 7.0) {
        rect.size.height -= self.navigationController.navigationBar.frame.size.height;
    }
    _mapView = [[BMKMapView alloc] initWithFrame:rect];
//    _mapView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_mapView];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_mapView
//                                                          attribute:NSLayoutAttributeTop
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:self.view
//                                                          attribute:NSLayoutAttributeTop
//                                                         multiplier:1.0
//                                                           constant:0]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_mapView
//                                                          attribute:NSLayoutAttributeLeft
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:self.view
//                                                          attribute:NSLayoutAttributeLeft
//                                                         multiplier:1.0
//                                                           constant:0]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_mapView
//                                                          attribute:NSLayoutAttributeRight
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:self.view
//                                                          attribute:NSLayoutAttributeRight
//                                                         multiplier:1.0
//                                                           constant:0]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_mapView
//                                                          attribute:NSLayoutAttributeBottom
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:self.view
//                                                          attribute:NSLayoutAttributeBottom
//                                                         multiplier:1.0
//                                                           constant:0]];
    _mapView.mapType = BMKMapTypeStandard;
    _mapView.zoomLevel = 16;
    _mapView.delegate = self;
}

#pragma mark - Data

- (void)showLocationInMap {
    [_mapView setCenterCoordinate:_coor animated:YES];
    [self addAnnotation];
}

- (void)addAnnotation {
    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
    annotation.coordinate = _coor;
    annotation.title = _name;
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
