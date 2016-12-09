//
//  WalkNaviViewController.swift
//  XPMapForGaoDe
//
//  Created by qianfeng on 2016/12/8.
//  Copyright © 2016年 耿晓鹏. All rights reserved.
//

import UIKit

class WalkNaviViewController: UIViewController {
    
    //导航起点
    var startPoint :AMapNaviPoint?
    //导航终点
    var endPoint:AMapNaviPoint?
    //步行管理
    var manager: AMapNaviWalkManager?
    //步行导航地图
    var walkMap :AMapNaviWalkView?
    //播报语音
    var speech : AVSpeechSynthesizer?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.calculateRoute()
    }
    
    //通过起点和终点规划路径
    
    
    
    func calculateRoute(){
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        //初始化步行管理者
        manager = AMapNaviWalkManager()
        self.manager?.calculateWalkRoute(withStart: [self.startPoint!], end: [self.endPoint!])
        //创建导航地图
        walkMap = AMapNaviWalkView(frame: CGRect.init(x: 0, y: 64, width: w, height: h-64))
        self.view.addSubview(walkMap!)
        walkMap?.delegate = self
        manager?.addDataRepresentative(walkMap!)
        manager?.delegate = self
        self.speech = AVSpeechSynthesizer()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension WalkNaviViewController:AMapNaviWalkManagerDelegate{
    //规划完成执行的方法
    func walkManager(onCalculateRouteSuccess walkManager: AMapNaviWalkManager) {
        manager?.startEmulatorNavi()
    }
    func walkManager(_ walkManager: AMapNaviWalkManager, playNaviSound soundString: String, soundStringType: AMapNaviSoundType) {
        if soundStringType == .surroundingTraffic{
            
            
        }else{
            DispatchQueue.global().async {
                let utterance = AVSpeechUtterance(string: soundString)
                utterance.voice = AVSpeechSynthesisVoice.init(language: "zh-CN")
                self.speech?.speak(utterance)
                
            }
        }
    }

}

extension WalkNaviViewController:AMapNaviWalkViewDelegate{
    func walkViewMoreButtonClicked(_ walkView: AMapNaviWalkView) {
        DispatchQueue.global().async {
            let utterance = AVSpeechUtterance(string: "更多按钮被点击")
            utterance.voice = AVSpeechSynthesisVoice.init(language: "zh-CN")
            self.speech?.speak(utterance)

            
        }
    }
    func walkViewCloseButtonClicked(_ walkView: AMapNaviWalkView) {
        let loView = LocationViewController()
        self.navigationController?.pushViewController(loView, animated: true)
    }
}





