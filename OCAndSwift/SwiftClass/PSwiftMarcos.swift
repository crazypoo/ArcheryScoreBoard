//
//  PSwiftMarcos.swift
//  OCAndSwift
//
//  Created by crazypoo on 2019/9/2.
//  Copyright © 2019 邓杰豪. All rights reserved.
//

import UIKit

class PSwiftMarcos: NSObject {
    
    @objc func navHeight() -> CGFloat {
            return 44
    }
    
    @objc func landSpaceLeftOrRightNavHeight() -> CGFloat{
        return 32
    }
    
    @objc func statusBarHeight() -> CGFloat {
        return isIPhoneXSeries() ? 44 : 20
    }
    
    @objc func navBarHeight() -> CGFloat {
        return self.statusBarHeight()+self.navHeight()
    }
    
    @objc func tabbarSafeareHeight() -> CGFloat{
        return isIPhoneXSeries() ? 34 : 0
    }
    
    @objc func tabbarHeight() -> CGFloat {
        return 49
    }
    
    @objc func tabbarTotalHeight() -> CGFloat {
        return self.tabbarSafeareHeight()+self.tabbarHeight()
    }
    
    @objc func tabbarNavbarTotalHeight() -> CGFloat {
        return self.tabbarTotalHeight()+self.navBarHeight()
    }
}
