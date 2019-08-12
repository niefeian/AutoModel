//
//  MirrorUtils.swift
//  Cdemo
//
//  Created by 聂飞安 on 2019/8/9.
//  Copyright © 2019 聂飞安. All rights reserved.
//

import UIKit

open class MirrorUtils {
    
    //model 转 字典
   open class func jsonMirrorsMain(_ models : [NSObject] , maps : ( [[String:Any]]?) -> Void){
        autoreleasepool { () -> () in
            maps(jsonMirrors(models))
        }
    }
    
    private class func jsonMirrors(_ models : [NSObject]) -> [[String:Any]]{
         var array = [[String:Any]]()
          autoreleasepool { () -> () in
            if models.count > 0 {
                let mirror = Mirror(reflecting: models[0])
                for model in models {
                    array.append(jsonMirror(model, mirror: mirror))
                }
            }
        }
        return array
    }
    
   
    
   private class func jsonMirror(_ model : NSObject , mirror : Mirror) -> [String:Any]{
        var dic = [String:Any]()
        for case let (label?, _) in mirror.children {
            if label.contains("Model") {
                if let array  = model.value(forKey: label) as? [NSObject]{
                     dic[label] = jsonMirrors(array)
                }else if let obj = model.value(forKey: label) as? NSObject{
                     dic[label] = jsonMirror(obj,mirror: Mirror(reflecting: obj))
                }
            }else if model.value(forKey: label) != nil && "\(String(describing: model.value(forKey: label)))" != ""{
                dic[label] = "\(model.value(forKey: label)!)"
            }
        }
        return dic
    }
    
    
    //获得model 印射
    class  func modelMirror(_ objClass : AnyClass) -> [String:String]{
        var attribute = [String:String]()
        autoreleasepool { () -> () in
            if let obj = NSClassFromString(NSStringFromClass(objClass)) as? NSObject.Type{
                let mirror = Mirror(reflecting: obj.init())
                for case let (label?, value) in mirror.children {
                    if let subMirrorString = subType(value) {
                        attribute["\(label)"] = subMirrorString
                    }
                }
            }
        }
        return attribute
    }
    
   private class func subType(_ obj : Any) -> String?{
        let subMirror = Mirror(reflecting: obj)
        var subMirrorString = "\(subMirror.subjectType)"
        //这边主要是获得model对应的类名 所以这边需要进行字符串截取
        if subMirrorString.contains("Array"){
            subMirrorString = subMirrorString.replacingOccurrences(of: "Array", with: "")
            subMirrorString = subMirrorString.replacingOccurrences(of: "<", with: "")
            subMirrorString = subMirrorString.replacingOccurrences(of: ">", with: "")
            return subMirrorString
        }
        return nil
    }
    
    
}
