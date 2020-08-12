//
//  CacheUtils.swift
//  Cdemo
//
//  Created by 聂飞安 on 2019/8/9.
//  Copyright © 2019 聂飞安. All rights reserved.
//

import UIKit
class CacheUtils:NSObject {
    
    static private var  mirrorMaps = [String:[String:AnyObject.Type]]()
    static private var  modelMap = [String:[String:AnyObject.Type]]()

    class func getMirrorMap(_ obj : AnyClass)-> [String:AnyObject.Type] {
        if let dic = mirrorMaps["\(obj)"] {
            return dic
        }
        mirrorMaps["\(obj)"] = MirrorUtils.modelMirror(obj)
        #if DEBUG
        print(mirrorMaps)
        #endif
        return getMirrorMap(obj)
    }
    
}
