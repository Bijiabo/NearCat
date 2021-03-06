//
//  CatArchiveDetailMapTableViewCell.swift
//  NearCat
//
//  Created by huchunbo on 16/1/1.
//  Copyright © 2016年 Bijiabo. All rights reserved.
//

import UIKit

class CatArchiveDetailMapTableViewCell: UITableViewCell, MAMapViewDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var separatorLineView: UIView!
    
    weak var delegate: CatArchiveDetailTableViewController?
    var location: CLLocationCoordinate2D? {
        didSet {
            guard let location = location else {return}
            mapView?.centerCoordinate = location
            addAnnotation(location)
        }
    }
    var catName: String = "Cat"
    var catAge: Int = 0
    
    var mapView:MAMapView?
    
    var title: String = String() {
        didSet {
            titleLabel.text = title
        }
    }
    
    var value: String = String() {
        didSet {
            valueLabel.text = value
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        initMapView()
        extension_setDefaultSelectedColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - init functions
    
    private func initMapView(){
        
        MAMapServices.sharedServices().apiKey = APIKey
        AMapSearchServices.sharedServices().apiKey = APIKey
        
        mapView = MAMapView(frame: mapContainerView.bounds)
        
        mapView!.delegate = self
        
        mapContainerView.addSubview(mapView!)
        
        let compassX = mapView?.compassOrigin.x
        
        let scaleX = mapView?.scaleOrigin.x
        
        //设置指南针和比例尺的位置
        mapView?.compassOrigin = CGPointMake(compassX!, 21)
        
        mapView?.scaleOrigin = CGPointMake(scaleX!, 21)
        
        // 开启定位
        mapView!.showsUserLocation = true
        
        // 设置跟随定位模式，将定位点设置成地图中心点
        mapView!.userTrackingMode = MAUserTrackingMode.None
        
        mapView?.showsCompass = true
        mapView?.compassOrigin = CGPointMake(contentView.bounds.width-50.0, contentView.bounds.height-50.0)
        mapView?.showsScale = false
        mapView?.zoomEnabled = true
        mapView?.rotateEnabled = true
        mapView?.zoomLevel = 15.0
        mapView?.customizeUserLocationAccuracyCircleRepresentation = true
        
        if let location = location {
            mapView?.centerCoordinate = location
            addAnnotation(location)
        }
    }
    
    func addAnnotation(location: CLLocationCoordinate2D) {
        let pointAnnotation: MAPointAnnotation = MAPointAnnotation()
        pointAnnotation.coordinate = location
        pointAnnotation.title = catName
        pointAnnotation.subtitle = "\(catAge)岁"
        
        mapView?.addAnnotation(pointAnnotation)
    }
    
    func mapView(mapView: MAMapView!, viewForAnnotation annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation.isKindOfClass(MAPointAnnotation) {
            let pointReuseIndentifier = "pointReuseIndentifier"
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(pointReuseIndentifier)
            
            if annotationView == nil {
                annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndentifier)
            }
            
            annotationView.image = UIImage(named: "pin") //custom pin image
            annotationView.canShowCallout = true
            annotationView.draggable = true
            return annotationView
        }
        
        return nil
    }
    
    func mapView(mapView: MAMapView!, didSelectAnnotationView view: MAAnnotationView!) {
    }
    
    func mapView(mapView: MAMapView!, didAnnotationViewCalloutTapped view: MAAnnotationView!) {
    }

}
