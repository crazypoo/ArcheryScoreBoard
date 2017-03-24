//
//  TargetImageCell.swift
//  ReperageFleche
//
//  Created by Rémy Vermeersch  on 21/04/2016.
//  Copyright © 2016 Rémy Vermeersch . All rights reserved.
//

import UIKit

class TargetImageCell: UICollectionViewCell {

    
    var arrow : Arrow! {
        didSet{
            arrowIDLAbel.textColor = UIColor.blue
            arrowIDLAbel.text = "落点" + String(arrow.arrowId + 1)
            updateMarkers(arrow.shots)
        }
    }
    
    var targetImageView: UIImageView!
    var arrowIDLAbel: UILabel!
    var reperageViews : [CrossMarkerView] = [CrossMarkerView]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
        
        targetImageView = UIImageView.init(frame: CGRect.init(x: 2.5, y: 2.5, width: self.frame.size.width-5, height: self.frame.size.width-5))
        targetImageView.image = UIImage.init(named: "TargetImage")
        self.contentView.addSubview(targetImageView)
        
        arrowIDLAbel = UILabel.init(frame: CGRect.init(x: 0, y: targetImageView.frame.size.height+2.5, width: self.frame.size.width, height: self.frame.size.height-self.frame.size.width-5))
        arrowIDLAbel.textAlignment = .center
        arrowIDLAbel.numberOfLines = 0
        arrowIDLAbel.lineBreakMode = .byCharWrapping
        self.contentView.addSubview(arrowIDLAbel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
