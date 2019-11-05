//
//  MirrorUtils.swift
//  Cdemo
//
//  Created by 聂飞安 on 2019/8/9.
//  Copyright © 2019 聂飞安. All rights reserved.
//

import UIKit

class MirrorUtils {
    
    //model 转 字典
    class func jsonMirrorsMains(_ models : [NSObject]) -> [[String:Any]]{
         return jsonMirrors(models)
    }
    
    class func jsonMirrorsMain(_ model : NSObject) -> [String:Any]{
        return jsonMirror(model,mirror: Mirror(reflecting: model))
    }
    
    
    //获得model 印射
    class func modelMirror(_ objClass : AnyClass) -> [String:AnyObject.Type]{
        var attribute = [String:AnyObject.Type]()
        if let obj = NSClassFromString(NSStringFromClass(objClass)) as? BaseModel.Type{
            let mirror = Mirror(reflecting: obj.init(nil))
            for case let (label?, value) in mirror.children {
                if let subMirrorString = subType(value) {
                    attribute["\(label)"] = subMirrorString
                }
            }
        }
        return attribute
    }
    
   private class func subType(_ obj : Any) -> AnyObject.Type?{
        var valueType = "\(Mirror(reflecting: obj).subjectType)"
        //这边主要是获得model对应的类名 所以这边需要进行字符串截取
        if valueType.contains("Array"){
            valueType = valueType.replacingOccurrences(of: "Array", with: "")
            valueType = valueType.replacingOccurrences(of: "<", with: "")
            valueType = valueType.replacingOccurrences(of: ">", with: "")
        }
        return isModelWith(valueType)
    }
    
    private class func isModelWith(_ valueType : String) -> AnyObject.Type? {
        if let projectName = Bundle.main.infoDictionary?["CFBundleName"] as? String {
            return NSClassFromString(projectName + "." + valueType)
        }
        return nil
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
            }else if model.value(forKey: label) is BaseModel || model.value(forKey: label) is [BaseModel]{
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
    
    
    
}
