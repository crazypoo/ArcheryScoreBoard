//
//  HomePageViewController.swift
//  ReperageFleche
//
//  Created by Rémy Vermeersch  on 22/04/2016.
//  Copyright © 2016 Rémy Vermeersch . All rights reserved.
//

import UIKit
import SnapKit
import SJFluidSegmentedControl

class HomePageViewController: BaseViewController,SJFluidSegmentedControlDelegate,SJFluidSegmentedControlDataSource{

    var nbrsArrowLabel:UILabel! = nil
    var nameText:UITextField! = nil
    var bowArr:[String]! = ["反曲","复合","馆弓","美猎","光弓","传统"]
    var distanceArr:[String]! = ["10","18","30","50","70","90"]
    var targetArr:[String]! = ["122全","80全","80半","60全","40全","40半"]
    var bowSegmentedControl:SJFluidSegmentedControl? = nil
    var distanceSegmentedControl:SJFluidSegmentedControl? = nil
    var targetSegmentedControl:SJFluidSegmentedControl? = nil
    var bowStr:String!
    var distanceStr:String!
    var targetStr:String!
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = UIColor.cyan
    
        let nameTitle = UILabel.init()
        nameTitle.backgroundColor = .yellow
        nameTitle.textAlignment = .center
        nameTitle.textColor = .red
        nameTitle.text = "名称"
        self.view.addSubview(nameTitle)
        nameTitle.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.size.width-20)
            make.height.equalTo(30)
            make.centerX.equalTo(self.view)
            make.top.equalTo(0)
        }
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY/MM/dd HH:mm"
        let dateString: String = dateFormatter.string(from: currentDate)
        nameText = UITextField.init()
        nameText.backgroundColor = .yellow
        nameText.textColor = .red
        nameText.text = dateString
        nameText.clearButtonMode = .whileEditing
        self.view.addSubview(nameText)
        nameText.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.size.width-20)
            make.height.equalTo(30)
            make.centerX.equalTo(self.view)
            make.top.equalTo(nameTitle.snp.bottom).offset(10)
        }
        
        let bowTitle = UILabel.init()
        bowTitle.backgroundColor = .red
        bowTitle.textAlignment = .center
        bowTitle.textColor = .white
        bowTitle.text = "弓种"
        self.view.addSubview(bowTitle)
        bowTitle.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.size.width-20)
            make.height.equalTo(30)
            make.centerX.equalTo(self.view)
            make.top.equalTo(nameText.snp.bottom).offset(10)
        }
        bowSegmentedControl = SJFluidSegmentedControl()
        bowSegmentedControl?.delegate = self
        bowSegmentedControl?.dataSource = self
        bowSegmentedControl?.tag = 1000
        self.view.addSubview(bowSegmentedControl!)
        bowSegmentedControl?.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.size.width-20)
            make.height.equalTo(50)
            make.centerX.equalTo(self.view)
            make.top.equalTo(bowTitle.snp.bottom).offset(10)
        }
        
        let distanceTitle = UILabel.init()
        distanceTitle.backgroundColor = .blue
        distanceTitle.textAlignment = .center
        distanceTitle.textColor = .white
        distanceTitle.text = "距离"
        self.view.addSubview(distanceTitle)
        distanceTitle.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.size.width-20)
            make.height.equalTo(30)
            make.centerX.equalTo(self.view)
            make.top.equalTo((bowSegmentedControl?.snp.bottom)!).offset(10)
        }
        distanceSegmentedControl = SJFluidSegmentedControl()
        distanceSegmentedControl?.delegate = self
        distanceSegmentedControl?.dataSource = self
        bowSegmentedControl?.tag = 1001
        self.view.addSubview(distanceSegmentedControl!)
        distanceSegmentedControl?.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.size.width-20)
            make.height.equalTo(50)
            make.centerX.equalTo(self.view)
            make.top.equalTo(distanceTitle.snp.bottom).offset(10)
        }

        let targetTitle = UILabel.init()
        targetTitle.backgroundColor = .black
        targetTitle.textAlignment = .center
        targetTitle.textColor = .white
        targetTitle.text = "靶形"
        self.view.addSubview(targetTitle)
        targetTitle.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.size.width-20)
            make.height.equalTo(30)
            make.centerX.equalTo(self.view)
            make.top.equalTo((distanceSegmentedControl?.snp.bottom)!).offset(10)
        }
        targetSegmentedControl = SJFluidSegmentedControl()
        targetSegmentedControl?.delegate = self
        targetSegmentedControl?.dataSource = self
        targetSegmentedControl?.tag = 1001
        self.view.addSubview(targetSegmentedControl!)
        targetSegmentedControl?.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.size.width-20)
            make.height.equalTo(50)
            make.centerX.equalTo(self.view)
            make.top.equalTo(targetTitle.snp.bottom).offset(10)
        }
        
        let arrowTitle = UILabel.init()
        arrowTitle.backgroundColor = .white
        arrowTitle.textAlignment = .center
        arrowTitle.textColor = .black
        arrowTitle.text = "箭量"
        self.view.addSubview(arrowTitle)
        arrowTitle.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.size.width-20)
            make.height.equalTo(30)
            make.centerX.equalTo(self.view)
            make.top.equalTo((targetSegmentedControl?.snp.bottom)!).offset(10)
        }
        
        let stepper = UIStepper.init()
        stepper.wraps = false
        stepper.maximumValue = 72
        stepper.minimumValue = 6
        stepper.stepValue = 6
        stepper.addTarget(self, action: #selector(stepperAction), for: .valueChanged)
        self.view.addSubview(stepper)
        stepper.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(30)
            make.centerX.equalTo(self.view)
            make.top.equalTo(arrowTitle.snp.bottom).offset(10)
        }
        
        nbrsArrowLabel = UILabel.init()
        nbrsArrowLabel.text = String(nbrsArrow)
        nbrsArrowLabel.textAlignment = .center
        self.view.addSubview(nbrsArrowLabel)
        nbrsArrowLabel.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.size.width)
            make.height.equalTo(30)
            make.left.equalTo(self.view)
            make.top.equalTo(stepper.snp.bottom)
        }
        
        let btn:UIButton = UIButton.init(type: .custom)
        btn.backgroundColor = .white
        btn.setTitleColor(.blue, for: .normal)
        btn.setTitle("下一步", for: .normal)
        btn.addTarget(self, action: #selector(self.nextAction(sender:)), for: .touchUpInside)
        self.view.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.size.width)
            make.height.equalTo(50)
            make.left.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
        
        bowStr = "反曲"
        distanceStr = "10"
        targetStr = "122全"
        
    }
    
//按钮动作
    @objc func nextAction(sender:UIButton) {
        let targetVC:TargetViewController = TargetViewController()
        targetVC.title = nameText.text
        targetVC.nbrsArrow = nbrsArrow
        targetVC.nbrsEnd = 0
        targetVC.shooterName = nameText.text
        targetVC.bowName = bowStr
        targetVC.distanceName = distanceStr
        targetVC.targetName = targetStr
        self.navigationController?.pushViewController(targetVC, animated: true)
    }
    
//数据操作
    var nbrsArrow : Int = 6 {
        didSet {
            nbrsArrowLabel.text = String(nbrsArrow)
        }
    }
    
    @objc func stepperAction(_ sender: UIStepper) {
        nbrsArrow = Int(sender.value)
    }
    
//分段控制delegate&&datasource
    func numberOfSegmentsInSegmentedControl(_ segmentedControl: SJFluidSegmentedControl) -> Int {

        switch segmentedControl {
        case bowSegmentedControl!:
            return bowArr.count
        case distanceSegmentedControl!:
            return distanceArr.count
        case targetSegmentedControl!:
            return targetArr.count
        default:
            return 0
        }
        
    }
    
    func segmentedControl(_ segmentedControl: SJFluidSegmentedControl,
                          titleForSegmentAtIndex index: Int) -> String? {
        switch segmentedControl {
        case bowSegmentedControl!:
            return bowArr[index].uppercased()
        case distanceSegmentedControl!:
            return distanceArr[index].uppercased()
        case targetSegmentedControl!:
            return targetArr[index].uppercased()

        default:
            return "".uppercased()
        }
    }
    
    func segmentedControl(_ segmentedControl: SJFluidSegmentedControl,
                          gradientColorsForSelectedSegmentAtIndex index: Int) -> [UIColor] {

        return [UIColor(red: 51 / 255.0, green: 149 / 255.0, blue: 182 / 255.0, alpha: 1.0),
                UIColor(red: 97 / 255.0, green: 199 / 255.0, blue: 234 / 255.0, alpha: 1.0)]
    }
    
    func segmentedControl(_ segmentedControl: SJFluidSegmentedControl,
                          gradientColorsForBounce bounce: SJFluidSegmentedControlBounce) -> [UIColor] {
        switch bounce {
        case .left:
            return [UIColor(red: 51 / 255.0, green: 149 / 255.0, blue: 182 / 255.0, alpha: 1.0)]
        case .right:
            return [UIColor(red: 9 / 255.0, green: 82 / 255.0, blue: 107 / 255.0, alpha: 1.0)]
        }
    }
    
    func segmentedControl(_ segmentedControl: SJFluidSegmentedControl, didChangeFromSegmentAtIndex fromIndex: Int, toSegmentAtIndex toIndex: Int) {
        switch segmentedControl {
        case bowSegmentedControl!:
            bowStr = bowArr[toIndex].uppercased()
        case distanceSegmentedControl!:
            distanceStr = distanceArr[toIndex].uppercased()
        case targetSegmentedControl!:
            targetStr = targetArr[toIndex].uppercased()
        default: break
        }
    }
    
}
