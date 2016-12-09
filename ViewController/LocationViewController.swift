//
//  LocationViewController.swift
//  XPMapForGaoDe
//
//  Created by qianfeng on 2016/12/9.
//  Copyright © 2016年 耿晓鹏. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController ,AMapLocationManagerDelegate{
    var manager:AMapLocationManager?
    var map:MAMapView?
    var myPoint :MAPointAnnotation?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = CGRect(x: 0, y: 64, width: Tools.ScreenW, height: Tools.ScreenH-44-64)
        self.locationService()
        
    }
    
    func locationService(){
        map = MAMapView(frame: self.view.bounds)
        self.view.addSubview(map!)
        
        
        manager = AMapLocationManager()
        manager?.delegate = self
        manager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.manager?.requestLocation(withReGeocode: true, completionBlock: { (cllLocation, code, error) in
            print(code?.formattedAddress as Any)
        })
        self.manager?.locatingWithReGeocode = true
//        self.manager?.startUpdatingLocation()

    }
    
    
    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!, reGeocode: AMapLocationReGeocode!) {
        let annocation = MAPointAnnotation()
        annocation.coordinate = location.coordinate
        if self.myPoint != nil{
            self.map?.removeAnnotation(self.myPoint)
        }
        self.myPoint = annocation
        self.map?.addAnnotation(annocation)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
