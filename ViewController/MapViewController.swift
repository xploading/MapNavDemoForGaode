//
//  MapViewController.swift
//  XPMapForGaoDe
//
//  Created by qianfeng on 2016/12/7.
//  Copyright © 2016年 耿晓鹏. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {
    @IBOutlet weak var headerView: UIView!

    @IBOutlet weak var startField: UITextField!
    
    @IBOutlet weak var endField: UITextField!
    @IBOutlet weak var selectorTrip: UISegmentedControl!
    
    var isDrive = true
    
    
    
    
    
    
    //开始导航
    @IBAction func startNav(_ sender: UIButton) {
        self.startField.resignFirstResponder()
        self.endField.resignFirstResponder()
        //判断startPoint和endPoint有值,并且请求完成后的地理编码和输入的地址一致时,开始导航
        
        if (startPoint != nil && startPoint?.district == self.startField.text)&&(endPoint != nil && endPoint?.district == self.endField.text){
        //选择出行方式
            if isDrive{
                //驾车
                let DriverView = NavViewController()
                DriverView.startPoint = AMapNaviPoint.location(withLatitude: (self.startPoint?.location.latitude)!, longitude: (self.startPoint?.location.longitude)!)
                DriverView.endPoint = AMapNaviPoint.location(withLatitude: (self.endPoint?.location.latitude)!, longitude: (self.endPoint?.location.longitude)!)
                self.navigationController?.pushViewController(DriverView, animated: true)
            }else{
                let walkView = WalkNaviViewController()
                walkView.startPoint = AMapNaviPoint.location(withLatitude: (self.startPoint?.location.latitude)!, longitude: (self.startPoint?.location.longitude)!)
                walkView.endPoint = AMapNaviPoint.location(withLatitude: (self.endPoint?.location.latitude)!, longitude: (self.endPoint?.location.longitude)!)
                self.navigationController?.pushViewController(walkView, animated: true)
            }
        }

    }
    
    @IBOutlet weak var mapView: UIView!
    
    var searchApi : AMapSearchAPI?
    //导航起点
    var startPoint: AMapGeocode?
    var endPoint: AMapGeocode?
    var map :MAMapView?
    var startAnnotation : MAPointAnnotation?
    var endAnnotation : MAPointAnnotation?

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray
        self.startField.text = "北京"
        self.endField.text = "首都机场"
        self.selectorTrip.addTarget(self, action: #selector(segmentAction), for: .valueChanged)
        self.createMapToMapView()
    }
    //segment发生改变时
    func segmentAction(segment:UISegmentedControl){
        switch segment.selectedSegmentIndex {
        case 0:
            isDrive = true
        default:
            isDrive = false
        }
    }
    //初始化
    func createMapToMapView(){
        map = MAMapView(frame: self.mapView.bounds)
        map?.showsUserLocation = true
        map?.zoomLevel = 10
        map?.delegate = self
        
        self.mapView.addSubview(map!)
        
        //搜索api初始化
        self.searchApi = AMapSearchAPI()
        //设置textField的代理
        self.startField.delegate = self
        self.endField.delegate = self
        //设置searchApi的代理
        self.searchApi?.delegate = self
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//textField的协议方法
extension MapViewController:UITextFieldDelegate{
    //输入完成执行代理方法,通过输入的内容获得地理编码
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        //输入完成放弃第一响应者
        
        if textField == startField{
            self.getLocationFrom(text: self.startField.text!, mapSearchApi: self.searchApi!)
        }else{
            self.getLocationFrom(text: self.endField.text!, mapSearchApi: self.searchApi!)
        }
    }

    //通过地理编码获取位置信息
    func getLocationFrom(text:String,mapSearchApi:AMapSearchAPI){
        let request = AMapGeocodeSearchRequest()
        
        request.address = text
        
        //发起地理编码请求
        mapSearchApi.aMapGeocodeSearch(request)
    }

}

//AMapSearchAPI的协议方法
extension MapViewController:AMapSearchDelegate{
    //地理编码完成后执行的方法
    func onGeocodeSearchDone(_ request: AMapGeocodeSearchRequest!, response: AMapGeocodeSearchResponse!) {
        for code in response.geocodes{
            let annotation = MAPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(code.location.latitude), longitude: CLLocationDegrees(code.location.longitude))
            annotation.title = code.formattedAddress
            if request.address == self.startField.text{
                //设置大头针
                if self.startAnnotation != nil{
                    self.map?.removeAnnotation(self.startAnnotation)
                }
                self.startPoint = code
                self.startAnnotation = annotation
            }else{
                if self.endAnnotation != nil{
                    self.map?.removeAnnotation(self.endAnnotation)
                }
                self.endPoint = code
                self.endAnnotation = annotation
            }
            code.district = request.address
            self.map?.addAnnotation(annotation)
        }
        
    }
}

extension MapViewController : MAMapViewDelegate{
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        var cell = mapView.dequeueReusableAnnotationView(withIdentifier: "map")
        
        if cell == nil{
            cell = MAPinAnnotationView(annotation: annotation, reuseIdentifier: "map")
            cell?.canShowCallout = true
        }
        cell?.annotation = annotation

        return cell!
        
    }
    
}




