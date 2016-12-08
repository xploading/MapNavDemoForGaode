//
//  NavViewController.swift
//  XPMapForGaoDe
//
//  Created by qianfeng on 2016/12/8.
//  Copyright © 2016年 耿晓鹏. All rights reserved.
//

import UIKit




class NavViewController: UIViewController {
    
    //导航地图
    var navMap :AMapNaviDriveView?
    
    //地图管理类
    var manager: AMapNaviDriveManager?
    var startPoint:AMapNaviPoint?
    var endPoint: AMapNaviPoint?
    var speecher: SpeechSynthesizer?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createNavMap()
        self.calculateRote()
        
    }
    //规划路径
    func calculateRote(){
        manager?.calculateDriveRoute(withStart: [self.startPoint!], end: [self.endPoint!], wayPoints: nil, drivingStrategy: .singleAvoidCongestion)
    }
    
    //初始化,创建导航地图
    func createNavMap(){
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        
        navMap = AMapNaviDriveView(frame: CGRect.init(x: 0, y: 64, width: w, height: h-64))
        self.view.addSubview(navMap!)
        manager = AMapNaviDriveManager()
        manager?.addDataRepresentative(self.navMap!)
        manager?.delegate = self
        self.speecher = SpeechSynthesizer()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension NavViewController:AMapNaviDriveManagerDelegate{
    func driveManager(onCalculateRouteSuccess driveManager: AMapNaviDriveManager) {
        driveManager.startEmulatorNavi()
    }
    func driveManager(_ driveManager: AMapNaviDriveManager, playNaviSound soundString: String, soundStringType: AMapNaviSoundType) {
        if soundStringType == .passedReminder{
            DispatchQueue.global().async {
                AudioServicesPlayAlertSound(1009)
                print(111)
            }
        }else{
            DispatchQueue.global().async {
                self.speecher?.speak(soundString)
            }
        }
    }
    
}













