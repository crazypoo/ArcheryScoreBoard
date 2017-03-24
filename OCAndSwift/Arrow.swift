//
//  Arrow.swift
//  ReperageFleche
//
//  Created by Rémy Vermeersch  on 11/04/2016.
//  Copyright © 2016 Rémy Vermeersch . All rights reserved.
//

import UIKit

class Arrow: Hashable {
    
    var arrowId : Int
    var hashValue: Int{ return self.arrowId }
    
    var shots = [Shot]()
    
    init(id: Int) {
        self.arrowId = id
    }

}

func ==(lhs: Arrow, rhs: Arrow) -> Bool {
    return lhs.arrowId == rhs.arrowId
}
