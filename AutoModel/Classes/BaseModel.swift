//
//  BaseModel.swift
//  Cdemo
//
//  Created by 聂飞安 on 2019/8/9.
//  Copyright © 2019 聂飞安. All rights reserved.
//

import UIKit

open class BaseModel: NSObject {
    
    @objc var id : String = ""
    
    //MARK:- 自定义构造函数
    required public init(_ dic : Any? = nil){
        super.init()
        if let d = dic as? [String: Any]{
            setValuesForKeys(d)
        }
    }
    
    override init() {
        super.init()
    }
    
    func addValuesForKeys(_ dic : Any?){
        if let d = dic as? [String: Any]{
            setValuesForKeys(d)
        }
    }
    
      
    // MARK: 安全设置
    override open func setValue(_ value: Any?, forUndefinedKey key: String) {
        //根据自定义规则增加尾号字段
        if let dics = value as? [NSDictionary] {
            if  let objName = CacheUtils.getMirrorMap(self.classForCoder)[key + "Models"] {
                let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String;
                if let objClass = NSClassFromString(namespace + "." + objName){
                    if let obj = NSClassFromString(NSStringFromClass(objClass)) as? BaseModel.Type{
                        var ojcArray = [BaseModel]()
                        for dic in dics{
                            ojcArray.append(obj.init(dic))
                        }
                        setValue(ojcArray, forKeyPath: key + "Models")
                    }
                }
            }
        }else if let dic = value as? NSDictionary {
            if  let objName = CacheUtils.getMirrorMap(self.classForCoder)[key + "Model"] {
                let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String;
                if let objClass = NSClassFromString(namespace + "." + objName){
                    if let obj = NSClassFromString(NSStringFromClass(objClass)) as? BaseModel.Type{
                        setValue(obj.init(dic), forKeyPath: key + "Model")
                    }
                }
            }
        }
    }
    
    override open func setNilValueForKey(_ key: String) {
        
    }
}
