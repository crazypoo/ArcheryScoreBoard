//
//  File.swift
//  ReperageFleche
//
//  Created by Rémy Vermeersch  on 22/04/2016.
//  Copyright © 2016 Rémy Vermeersch . All rights reserved.
//

import UIKit

class Shot {
    
    var location : CGPoint{
        didSet{
            newLocationByCenter = CGPoint(x: location.x - Constante.TargetSize, y: location.y - Constante.TargetSize)
            setValue()
        }
    }
    var value : Int!
    
    var newLocationByCenter : CGPoint{
        didSet{
            setValue()
        }
    }
    
    init(location : CGPoint){
        self.location = location
        newLocationByCenter = CGPoint(x: location.x - Constante.TargetSize, y: location.y - Constante.TargetSize)
        setValue()
    }
    
    func setValue() {
        let targetSize = Constante.TargetSize
        let xPos = newLocationByCenter.x
        let yPos = newLocationByCenter.y
    
        let r = sqrt(xPos*xPos + yPos*yPos)
        let result = Int((((targetSize - r)/targetSize) * 10)+1)
        print("\(result)")
        value = max(0,min(10,result))
    }
    
    struct Constante {
        static let TargetSize : CGFloat = (UIScreen.main.bounds.size.width-40)/2
    }
}
