//
//  ViewController.swift
//  ReperageFleche
//
//  Created by Rémy Vermeersch  on 11/04/2016.
//  Copyright © 2016 Rémy Vermeersch . All rights reserved.
//

import UIKit
import MobileCoreServices
import SnapKit
import AssetsLibrary

class TargetViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    //MARK: -Arrow Gesture
    var nbrsEnd : Int!
    
    var nbrsArrow : Int! {
        didSet{
            for i in 0...nbrsArrow-1 {
                arrowTab.append(Arrow(id: i))
            }
        }
    }
    
    var arrowTab = [Arrow]() 
    
    var markers = [CrossMarkerView]()
    
    var arrowId : Int = 0
    
    var pointStr:[String]!
    
    var shooterName:String!
    var bowName:String!
    var distanceName:String!
    var targetName:String!
    var totlalLabel:UILabel!
    var xLabel:UILabel!
    var tenLabel:UILabel!
    var nineLabel:UILabel!
    var eightLabel:UILabel!
    var sevenLabel:UILabel!
    var sixLabel:UILabel!
    var fiveLabel:UILabel!
    var fourLabel:UILabel!
    var threeLabel:UILabel!
    var twoLabel:UILabel!
    var oneLabel:UILabel!
    var mLabel:UILabel!
    var arrowCountLabel:UILabel!
    var backBtn:UIButton!
    var xFloat:CGFloat!
    var tenFloat:CGFloat!
    var nineFloat:CGFloat!
    var eightFloat:CGFloat!
    var sevenFloat:CGFloat!
    var sixFloat:CGFloat!
    var fiveFloat:CGFloat!
    var fourFloat:CGFloat!
    var threeFloat:CGFloat!
    var twoFloat:CGFloat!
    var oneFloat:CGFloat!
    var mFloat:CGFloat!
    var CorrectButton:UIButton!
    var SendButton:UIButton!
    var cameraBtn: UIButton!
    
    func setArrowPosition(_ sender: UIPanGestureRecognizer) {
        
        if arrowId < nbrsArrow {
            let location = sender.location(in: TargetView)
            let currentArrow = arrowTab[arrowId]
            switch sender.state {
            case .began:
                currentArrow.shots.append(Shot(location: location))
            case .changed:
                currentArrow.shots.last?.location = location
            case .ended:
                arrowId += 1
            default:
                break
            }
            
            updateUI()
        }

    }
    
    //MARK: -UI
    var TargetView: UIImageView!

    func combinator(accumulator: Int, current: Int) -> Int {
        return accumulator + current
    }
    
    func ButtonAction(_ sender: UIButton) {
        
        if sender.titleLabel?.text == "更正" {
            arrowTab[arrowId-1].shots.removeLast()
            arrowId -= 1
            updateUI()
        }
        
        if sender.titleLabel?.text == "查看更多数据" {
            
            let resultVC:ResultViewController = ResultViewController()
            resultVC.arrowTab = self.arrowTab
            resultVC.nbrsEnd = self.nbrsEnd
            resultVC.xStr = xFloat
            resultVC.tenStr = tenFloat
            resultVC.nineStr = nineFloat
            resultVC.eightStr = eightFloat
            resultVC.sevenStr = sevenFloat
            resultVC.sixStr = sixFloat
            resultVC.fiveStr = fiveFloat
            resultVC.fourStr = fourFloat
            resultVC.threeStr = threeFloat
            resultVC.twoStr = twoFloat
            resultVC.oneStr = oneFloat
            resultVC.MStr = mFloat
            self.navigationController?.pushViewController(resultVC, animated: true)
            
            var bbbbbb:[Int]! = []
            for i in 0...nbrsArrow-1 {
                let aaaa:NSString = pointStr[i] as NSString
                if aaaa.isEqual(to: "") {
                    bbbbbb.append(Int(0))
                }
                else if aaaa.isEqual(to: "11")
                {
                    bbbbbb.append(Int(10))
                }
                else
                {
                    bbbbbb.append(Int(aaaa as String)!)
                }
            }
            let sum = bbbbbb.reduce(0,self.combinator)
            
            print("\(sum)")
        }
    }
    
    func updateUI() {
        
        for i in 0...nbrsArrow-1 {
            pointStr[i] = ""
            let shots = arrowTab[i].shots
            if shots.count == nbrsEnd+1
            {
                pointStr[i] = String(shots[nbrsEnd].value)
            }
        }
        
        var completedEnd : Bool = false
        var isAnyArrowShot : Bool = false
        for arrow in arrowTab {
            if  arrow.shots.count != nbrsEnd + 1 {
                completedEnd = false
                break
            }
            completedEnd = true
        }
        for arrow in arrowTab {
            if arrow.shots.count == nbrsEnd + 1 {
                isAnyArrowShot = true
                break
            }
        }
        
        var bbbbbb:[Int]! = []
        for i in 0...nbrsArrow-1 {
            let aaaa:NSString = pointStr[i] as NSString
            if aaaa.isEqual(to: "") {
                bbbbbb.append(Int(0))
            }
            else if aaaa.isEqual(to: "11")
            {
                bbbbbb.append(Int(10))
            }
            else
            {
                bbbbbb.append(Int(aaaa as String)!)
            }
        }
        let sum = bbbbbb.reduce(0,self.combinator)
        totlalLabel.text = "总分:" + String(sum)
        
        let cArr = NSMutableArray.init()
        for s:NSString in pointStr as [NSString]
        {
            if !s.isEqual(to: "")
            {
                cArr.add(s)
            }
        }
        arrowCountLabel.text = String(cArr.count) + "/" + String(nbrsArrow)

        let xArr = NSMutableArray.init()
        let tenArr = NSMutableArray.init()
        let nineArr = NSMutableArray.init()
        let eightArr = NSMutableArray.init()
        let sevenArr = NSMutableArray.init()
        let sixArr = NSMutableArray.init()
        let fiveArr = NSMutableArray.init()
        let fourArr = NSMutableArray.init()
        let threeArr = NSMutableArray.init()
        let twoArr = NSMutableArray.init()
        let oneArr = NSMutableArray.init()
        let mArr = NSMutableArray.init()
        for s:NSString in pointStr as [NSString]
        {
            if s.isEqual(to: "11")
            {
                xArr.add(s)
            }
            else if s.isEqual(to: "10")
            {
                tenArr.add(s)
            }
            else if s.isEqual(to: "9")
            {
                nineArr.add(s)
            }
            else if s.isEqual(to: "8")
            {
                eightArr.add(s)
            }
            else if s.isEqual(to: "7")
            {
                sevenArr.add(s)
            }
            else if s.isEqual(to: "6")
            {
                sixArr.add(s)
            }
            else if s.isEqual(to: "5")
            {
                fiveArr.add(s)
            }
            else if s.isEqual(to: "4")
            {
                fourArr.add(s)
            }
            else if s.isEqual(to: "3")
            {
                threeArr.add(s)
            }
            else if s.isEqual(to: "2")
            {
                twoArr.add(s)
            }
            else if s.isEqual(to: "1")
            {
                oneArr.add(s)
            }
            else if s.isEqual(to: "0")
            {
                mArr.add(s)
            }
        }
        xLabel.text = "X个数:" + String(xArr.count) + "个"
        tenLabel.text = "10个数:" + String(tenArr.count) + "个"
        nineLabel.text = "9个数:" + String(nineArr.count) + "个"
        eightLabel.text = "8个数:" + String(eightArr.count) + "个"
        sevenLabel.text = "7个数:" + String(sevenArr.count) + "个"
        sixLabel.text = "6个数:" + String(sixArr.count) + "个"
        fiveLabel.text = "5个数:" + String(fiveArr.count) + "个"
        fourLabel.text = "4个数:" + String(fourArr.count) + "个"
        threeLabel.text = "3个数:" + String(threeArr.count) + "个"
        twoLabel.text = "2个数:" + String(twoArr.count) + "个"
        oneLabel.text = "1个数:" + String(oneArr.count) + "个"
        mLabel.text = "M个数:" + String(mArr.count) + "个"
        xFloat = CGFloat(xArr.count)
        tenFloat = CGFloat(tenArr.count)
        nineFloat = CGFloat(nineArr.count)
        eightFloat = CGFloat(eightArr.count)
        sevenFloat = CGFloat(sevenArr.count)
        sixFloat = CGFloat(sixArr.count)
        fiveFloat = CGFloat(fiveArr.count)
        fourFloat = CGFloat(fourArr.count)
        threeFloat = CGFloat(threeArr.count)
        twoFloat = CGFloat(twoArr.count)
        oneFloat = CGFloat(oneArr.count)
        mFloat = CGFloat(mArr.count)

        
        if completedEnd { SendButton.isEnabled = true } else { SendButton.isEnabled = false }
        if isAnyArrowShot{ CorrectButton.isEnabled = true } else { CorrectButton.isEnabled = false }
        
        updateMarkers()
    }
    
    func updateMarkers() {
        for i in markers {
            i.removeFromSuperview()
        }
        markers.removeAll()
        
        for arrow in arrowTab {
            if arrow.shots.count == nbrsEnd+1 {
                
                let shot = arrow.shots[nbrsEnd]
                
                markers.append(CrossMarkerView(shot: shot, frame: TargetView.bounds))
                
                TargetView.addSubview(markers.last!)

            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.title = "XXXXXXXX";
        
        let touch = UIPanGestureRecognizer.init(target: self, action: #selector(self.setArrowPosition(_:)))
        self.view.addGestureRecognizer(touch)
        
        pointStr = [String]()
        for i in 0...nbrsArrow-1 {
            let llll:String = ""
            pointStr.append(llll)
            print("\(i)")
        }
        
        let titleLabel = UILabel.init()
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.textColor = .blue
        titleLabel.text = shooterName
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.centerX.equalTo(self.view)
            make.width.equalTo(200)
            make.height.equalTo(44)
        }
        
        backBtn = UIButton.init(type: .custom)
        backBtn.setTitleColor(UIColor.blue, for: .normal)
        backBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        backBtn.setTitle("返回", for: .normal)
        backBtn.addTarget(self, action: #selector(self.goBack(sender:)), for: .touchUpInside)
        self.view.addSubview(backBtn)
        backBtn.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.top.equalTo(20)
            make.width.equalTo(50)
            make.height.equalTo(44)
        }

        TargetView = UIImageView.init()
        TargetView.image = UIImage.init(named: "TargetImage")
        self.view.addSubview(TargetView)
        TargetView.snp.makeConstraints { (make) in
            make.top.equalTo(70)
            make.left.equalTo(20)
            make.width.equalTo(self.view.frame.size.width-40)
            make.height.equalTo(self.view.frame.size.width-40)
        }
        
        let bowLabel = UILabel.init()
        bowLabel.textAlignment = .center
        bowLabel.font = UIFont.systemFont(ofSize: 18)
        bowLabel.textColor = .blue
        bowLabel.text = "弓种:" + bowName
        self.view.addSubview(bowLabel)
        bowLabel.snp.makeConstraints { (make) in
            make.top.equalTo(TargetView.snp.bottom).offset(10)
            make.left.equalTo(self.view)
            make.width.equalTo(self.view.frame.size.width/3)
            make.height.equalTo(20)
        }

        let distanceLabel = UILabel.init()
        distanceLabel.textAlignment = .center
        distanceLabel.font = UIFont.systemFont(ofSize: 18)
        distanceLabel.textColor = .blue
        distanceLabel.text = "距离:" + distanceName + "米"
        self.view.addSubview(distanceLabel)
        distanceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(TargetView.snp.bottom).offset(10)
            make.left.equalTo(bowLabel.snp.right)
            make.width.equalTo(self.view.frame.size.width/3)
            make.height.equalTo(20)
        }
        
        totlalLabel = UILabel.init()
        totlalLabel.textAlignment = .center
        totlalLabel.font = UIFont.systemFont(ofSize: 18)
        totlalLabel.textColor = .blue
        totlalLabel.text = "总分:0"
        self.view.addSubview(totlalLabel)
        totlalLabel.snp.makeConstraints { (make) in
            make.top.equalTo(TargetView.snp.bottom).offset(10)
            make.left.equalTo(distanceLabel.snp.right)
            make.width.equalTo(self.view.frame.size.width/3)
            make.height.equalTo(20)
        }
        
        let targetLabel = UILabel.init()
        targetLabel.textAlignment = .center
        targetLabel.font = UIFont.systemFont(ofSize: 18)
        targetLabel.textColor = .blue
        targetLabel.text = "靶型:" + targetName + "靶"
        self.view.addSubview(targetLabel)
        targetLabel.snp.makeConstraints { (make) in
            make.top.equalTo(totlalLabel.snp.bottom).offset(5)
            make.left.equalTo(self.view)
            make.width.equalTo(self.view.frame.size.width/2)
            make.height.equalTo(20)
        }
        
        arrowCountLabel = UILabel.init()
        arrowCountLabel.textAlignment = .center
        arrowCountLabel.font = UIFont.systemFont(ofSize: 18)
        arrowCountLabel.textColor = .blue
        arrowCountLabel.text = "0/" + String(nbrsArrow)
        self.view.addSubview(arrowCountLabel)
        arrowCountLabel.snp.makeConstraints { (make) in
            make.top.equalTo(totlalLabel.snp.bottom).offset(5)
            make.left.equalTo(targetLabel.snp.right)
            make.width.equalTo(self.view.frame.size.width/2)
            make.height.equalTo(20)
        }
        
        xLabel = UILabel.init()
        xLabel.textAlignment = .center
        xLabel.font = UIFont.systemFont(ofSize: 18)
        xLabel.textColor = .blue
        xLabel.text = "X个数:0个"
        self.view.addSubview(xLabel)
        xLabel.snp.makeConstraints { (make) in
            make.top.equalTo(targetLabel.snp.bottom).offset(5)
            make.left.equalTo(self.view)
            make.width.equalTo(self.view.frame.size.width/3)
            make.height.equalTo(20)
        }
        
        tenLabel = UILabel.init()
        tenLabel.textAlignment = .center
        tenLabel.font = UIFont.systemFont(ofSize: 18)
        tenLabel.textColor = .blue
        tenLabel.text = "10个数:0个"
        self.view.addSubview(tenLabel)
        tenLabel.snp.makeConstraints { (make) in
            make.top.equalTo(targetLabel.snp.bottom).offset(5)
            make.left.equalTo(xLabel.snp.right)
            make.width.equalTo(self.view.frame.size.width/3)
            make.height.equalTo(20)
        }
        
        nineLabel = UILabel.init()
        nineLabel.textAlignment = .center
        nineLabel.font = UIFont.systemFont(ofSize: 18)
        nineLabel.textColor = .blue
        nineLabel.text = "9个数:0个"
        self.view.addSubview(nineLabel)
        nineLabel.snp.makeConstraints { (make) in
            make.top.equalTo(targetLabel.snp.bottom).offset(5)
            make.left.equalTo(tenLabel.snp.right)
            make.width.equalTo(self.view.frame.size.width/3)
            make.height.equalTo(20)
        }

        eightLabel = UILabel.init()
        eightLabel.textAlignment = .center
        eightLabel.font = UIFont.systemFont(ofSize: 18)
        eightLabel.textColor = .blue
        eightLabel.text = "8个数:0个"
        self.view.addSubview(eightLabel)
        eightLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nineLabel.snp.bottom).offset(5)
            make.left.equalTo(self.view)
            make.width.equalTo(self.view.frame.size.width/3)
            make.height.equalTo(20)
        }
        
        sevenLabel = UILabel.init()
        sevenLabel.textAlignment = .center
        sevenLabel.font = UIFont.systemFont(ofSize: 18)
        sevenLabel.textColor = .blue
        sevenLabel.text = "7个数:0个"
        self.view.addSubview(sevenLabel)
        sevenLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nineLabel.snp.bottom).offset(5)
            make.left.equalTo(eightLabel.snp.right)
            make.width.equalTo(self.view.frame.size.width/3)
            make.height.equalTo(20)
        }
        
        sixLabel = UILabel.init()
        sixLabel.textAlignment = .center
        sixLabel.font = UIFont.systemFont(ofSize: 18)
        sixLabel.textColor = .blue
        sixLabel.text = "6个数:0个"
        self.view.addSubview(sixLabel)
        sixLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nineLabel.snp.bottom).offset(5)
            make.left.equalTo(sevenLabel.snp.right)
            make.width.equalTo(self.view.frame.size.width/3)
            make.height.equalTo(20)
        }
        
        fiveLabel = UILabel.init()
        fiveLabel.textAlignment = .center
        fiveLabel.font = UIFont.systemFont(ofSize: 18)
        fiveLabel.textColor = .blue
        fiveLabel.text = "5个数:0个"
        self.view.addSubview(fiveLabel)
        fiveLabel.snp.makeConstraints { (make) in
            make.top.equalTo(sixLabel.snp.bottom).offset(5)
            make.left.equalTo(self.view)
            make.width.equalTo(self.view.frame.size.width/3)
            make.height.equalTo(20)
        }
        
        fourLabel = UILabel.init()
        fourLabel.textAlignment = .center
        fourLabel.font = UIFont.systemFont(ofSize: 18)
        fourLabel.textColor = .blue
        fourLabel.text = "4个数:0个"
        self.view.addSubview(fourLabel)
        fourLabel.snp.makeConstraints { (make) in
            make.top.equalTo(sixLabel.snp.bottom).offset(5)
            make.left.equalTo(fiveLabel.snp.right)
            make.width.equalTo(self.view.frame.size.width/3)
            make.height.equalTo(20)
        }
        
        threeLabel = UILabel.init()
        threeLabel.textAlignment = .center
        threeLabel.font = UIFont.systemFont(ofSize: 18)
        threeLabel.textColor = .blue
        threeLabel.text = "3个数:0个"
        self.view.addSubview(threeLabel)
        threeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(sixLabel.snp.bottom).offset(5)
            make.left.equalTo(fourLabel.snp.right)
            make.width.equalTo(self.view.frame.size.width/3)
            make.height.equalTo(20)
        }
        
        twoLabel = UILabel.init()
        twoLabel.textAlignment = .center
        twoLabel.font = UIFont.systemFont(ofSize: 18)
        twoLabel.textColor = .blue
        twoLabel.text = "2个数:0个"
        self.view.addSubview(twoLabel)
        twoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(threeLabel.snp.bottom).offset(5)
            make.left.equalTo(self.view)
            make.width.equalTo(self.view.frame.size.width/3)
            make.height.equalTo(20)
        }
        
        oneLabel = UILabel.init()
        oneLabel.textAlignment = .center
        oneLabel.font = UIFont.systemFont(ofSize: 18)
        oneLabel.textColor = .blue
        oneLabel.text = "1个数:0个"
        self.view.addSubview(oneLabel)
        oneLabel.snp.makeConstraints { (make) in
            make.top.equalTo(threeLabel.snp.bottom).offset(5)
            make.left.equalTo(twoLabel.snp.right)
            make.width.equalTo(self.view.frame.size.width/3)
            make.height.equalTo(20)
        }
        
        mLabel = UILabel.init()
        mLabel.textAlignment = .center
        mLabel.font = UIFont.systemFont(ofSize: 18)
        mLabel.textColor = .blue
        mLabel.text = "M个数:0个"
        self.view.addSubview(mLabel)
        mLabel.snp.makeConstraints { (make) in
            make.top.equalTo(threeLabel.snp.bottom).offset(5)
            make.left.equalTo(oneLabel.snp.right)
            make.width.equalTo(self.view.frame.size.width/3)
            make.height.equalTo(20)
        }
        
        CorrectButton = UIButton.init(type: .custom)
        CorrectButton.setTitleColor(UIColor.blue, for: .normal)
        CorrectButton.setTitleColor(UIColor.lightGray, for: .disabled)
        CorrectButton.setTitle("更正", for: .normal)
        CorrectButton.isEnabled = false
        CorrectButton.addTarget(self, action: #selector(TargetViewController.ButtonAction(_:)), for: .touchUpInside)
        self.view.addSubview(CorrectButton)
        CorrectButton.snp.makeConstraints { (make) in
            make.width.equalTo(50)
            make.left.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
        
        SendButton = UIButton.init(type: .custom)
        SendButton.setTitleColor(UIColor.blue, for: .normal)
        SendButton.setTitleColor(UIColor.lightGray, for: .disabled)
        SendButton.setTitle("查看更多数据", for: .normal)
        SendButton.isEnabled = false
        SendButton.addTarget(self, action: #selector(TargetViewController.ButtonAction(_:)), for: .touchUpInside)
        self.view.addSubview(SendButton)
        SendButton.snp.makeConstraints { (make) in
            make.width.equalTo(120)
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }

        cameraBtn = UIButton.init(type: .custom)
        cameraBtn.setTitleColor(UIColor.blue, for: .normal)
        cameraBtn.setTitleColor(UIColor.lightGray, for: .disabled)
        cameraBtn.setTitle("拍照", for: .normal)
        cameraBtn.addTarget(self, action: #selector(TargetViewController.takePhoto), for: .touchUpInside)
        self.view.addSubview(cameraBtn)
        cameraBtn.snp.makeConstraints { (make) in
            make.width.equalTo(50)
            make.bottom.equalTo(self.view)
            make.right.equalTo(self.view)
        }
    }

    
    func goBack(sender:UIButton)
    {
        let homeVC:HomePageViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomePageViewController") as! HomePageViewController
        self.present(homeVC, animated: true) { 
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    var image = UIImage()
    
    func takePhoto() {
        
        CorrectButton.isHidden = true
        SendButton.isHidden = true
        cameraBtn.isHidden = true
        backBtn.isHidden = true
        let saveimage = self.view.screenshot()
        let libary = ALAssetsLibrary.init()
        let data = UIImagePNGRepresentation(saveimage!)
        libary.writeImageData(toSavedPhotosAlbum: data, metadata: nil) { (url, error) in
            self.CorrectButton.isHidden = false
            self.SendButton.isHidden = false
            self.cameraBtn.isHidden = false
            self.backBtn.isHidden = false
        }
    }
}

