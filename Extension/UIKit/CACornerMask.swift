import UIKit

extension CACornerMask {
    
    static var topLeft: CACornerMask {
        return .layerMinXMinYCorner
    }
    
    static var topRight: CACornerMask {
        return .layerMaxXMinYCorner
    }
    
    static var bottomLeft: CACornerMask {
        return .layerMinXMaxYCorner
    }
    
    static var bottomRight: CACornerMask {
        return .layerMaxXMaxYCorner
    }
    
    static var all: CACornerMask {
        return [topLeft, topRight, bottomLeft, bottomRight]
    }
}