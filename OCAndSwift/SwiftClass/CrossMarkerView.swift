//
//  CrossMarkerView.swift
//  ReperageFleche
//
//  Created by Rémy Vermeersch  on 18/04/2016.
//  Copyright © 2016 Rémy Vermeersch . All rights reserved.
//

import UIKit

class CrossMarkerView: UIView {
    
    var shot : Shot
    
    //scale depend de taille. frame.heigt => nouvelle taille, 350 taille de depart.
    var scale : CGFloat

    
    init(shot: Shot, frame: CGRect){
        self.shot = shot
        self.scale = frame.size.height/Constants.firstTargetSize

        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        UIColor.red.set()
        
        if shot.value == 7 || shot.value == 8 {
            UIColor.black.set()
        }
        
        setCrossPath().stroke()
    }
    
    struct  Constants {
        static let crossSize : CGFloat = (UIScreen.main.bounds.size.width-40)/70
        static let firstTargetSize : CGFloat = UIScreen.main.bounds.size.width-40
    }
    
    func setCrossPath() -> UIBezierPath {
        let crossSize = Constants.crossSize
        let path = UIBezierPath()
        
        let point = CGPoint(x: shot.location.x * scale, y: shot.location.y * scale)
        
        path.move(to: CGPoint(x: point.x - crossSize, y: point.y - crossSize))
        path.addLine(to: CGPoint(x: point.x, y: point.y))
        
        path.move(to: CGPoint(x: point.x + crossSize, y: point.y - crossSize))
        path.addLine(to: CGPoint(x: point.x , y: point.y))
        
        path.move(to: CGPoint(x: point.x , y: point.y + crossSize))
        path.addLine(to: CGPoint(x: point.x , y: point.y))
        
        path.lineWidth = 2.0

        setNeedsDisplay()
        
        return path
    }
    
}
