//
//  DetailledTarget.swift
//  ReperageFleche
//
//  Created by Rémy Vermeersch  on 23/04/2016.
//  Copyright © 2016 Rémy Vermeersch . All rights reserved.
//

import UIKit

class DetailledTarget: UIViewController {
    
    
    var arrow : Arrow!
    
    var reperageViews = [CrossMarkerView]()
    
    var targetImageView: UIImageView!
    
    var endCountLabel: UILabel!
    var scoreLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func updateUI() {
    
        
        self.title = "箭落点: \((arrow?.arrowId)!+1)"
    
        targetImageView = UIImageView.init(frame: CGRect.init(x: 20, y: 84, width: self.view.frame.size.width-40, height: self.view.frame.size.width-40))
        targetImageView.image = UIImage.init(named: "TargetImage")
        self.view.addSubview(targetImageView)

        var scoreTotal : Int = 0
        for i in (arrow?.shots)! {
            let x:NSString = String(i.value) as NSString
            if x.isEqual(to: "11") {
                scoreTotal += 10
            }
            else
            {
                scoreTotal += i.value
            }
        }
        
        endCountLabel = UILabel.init()
        endCountLabel.textAlignment = .center
        endCountLabel.text = "射击点数量: " + String(arrow.shots.count)
        self.view.addSubview(endCountLabel)
        endCountLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.height.equalTo(30)
            make.bottom.equalTo(self.view.snp.bottom).offset(-150)
        }

        scoreLabel = UILabel.init()
        scoreLabel.textAlignment = .center
        scoreLabel.text = "得分 : \(scoreTotal)"
        self.view.addSubview(scoreLabel)
        scoreLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.height.equalTo(30)
            make.top.equalTo(endCountLabel.snp.bottom)
        }

        
        updateMarkers((arrow?.shots)!)
    }
    
    func updateMarkers(_ shots : [Shot]){
        
        for i in reperageViews {
            i.removeFromSuperview()
        }
        reperageViews.removeAll()
        
        for currentShot in shots {
            reperageViews.append(CrossMarkerView(shot: currentShot, frame: targetImageView.bounds))
            
            targetImageView.addSubview(reperageViews.last!)
        }
    }
    
    
}
