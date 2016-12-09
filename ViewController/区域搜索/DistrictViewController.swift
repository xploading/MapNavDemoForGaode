//
//  DistrictViewController.swift
//  XPMapForGaoDe
//
//  Created by qianfeng on 2016/12/9.
//  Copyright © 2016年 耿晓鹏. All rights reserved.
//

import UIKit

class DistrictViewController: UIViewController {
    var tableView :UITableView?
    var map:MAMapView?//地图
    var manager:AMapLocationManager?
    var searchApi :AMapSearchAPI?
    var request : AMapPOIAroundSearchRequest?

    //存放附近信息的数组
    var dataSource : Array<Any>?

    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.automaticallyAdjustsScrollViewInsets = false
        let rightBtn = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(rightClick))
        self.navigationItem.rightBarButtonItem = rightBtn
        self.cteateTableView()
        self.loadNewInfo()

        
    }
    func rightClick(){
        self.createManager()
    }
    //布局tableView
    func cteateTableView(){
        dataSource = [AMapPOI]()
        request = AMapPOIAroundSearchRequest()


        tableView = UITableView(frame: CGRect.init(x: 0, y: 64, width:Tools.ScreenW , height: Tools.ScreenH-64-44), style: .plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        self.view.addSubview(tableView!)
    }
    func createManager(){
        
        dataSource?.removeAll()
        searchApi = AMapSearchAPI()
        searchApi?.delegate = self
        manager = AMapLocationManager()
        manager?.delegate = self
        manager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
        manager?.locatingWithReGeocode = true
        manager?.requestLocation(withReGeocode: true, completionBlock: { (location, reGeoCode, error) in
            
            self.request?.location = AMapGeoPoint.location(withLatitude: CGFloat((location?.coordinate.latitude)!), longitude: CGFloat((location?.coordinate.longitude)!))
            self.request?.page = 1
            self.request?.keywords = "海鲜"
            self.searchApi?.aMapPOIAroundSearch(self.request)
        })
    }
    func loadNewInfo(){
        self.tableView?.footer = MJRefreshAutoNormalFooter(refreshingBlock: { 
            self.request?.page += 1
            self.searchApi?.aMapPOIAroundSearch(self.request)
        })
    }

    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
//tableView的协议方法
extension  DistrictViewController :UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.dataSource?.count)!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "map")
        if cell == nil{
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "map")
        }
        let poi = dataSource?[indexPath.row] as! AMapPOI
        cell?.textLabel?.text = poi.name
        cell?.detailTextLabel?.text = poi.address
        return cell!
    }
    
    
}

//mapLocationManager代理方法
extension DistrictViewController:AMapLocationManagerDelegate{
    
}
//searchApi的代理方法
extension DistrictViewController:AMapSearchDelegate{
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        for poi in response.pois{
            dataSource?.append(poi)
        }
        self.tableView?.reloadData()
        self.tableView?.footer.endRefreshing()
    }
}












