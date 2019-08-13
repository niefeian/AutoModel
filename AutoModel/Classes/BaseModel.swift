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
    
    override public init() {
        super.init()
    }
    
    public func toJosn() -> [String:Any]{
        return MirrorUtils.jsonMirrorsMain(self)
    }
    
    func addValuesForKeys(_ dic : Any?){
        if let d = dic as? [String: Any]{
            setValuesForKeys(d)
        }
    }
    
    //如果期望在  setValue(_ value: Any?, forKey key: String) 中生效  那么数据 的key 应当与 model 中子model的属性名命名i一致  如 list :[{}] 对应model 就是 list : [subModel] map : {} 则是 mpa : subModel
    override open func setValue(_ value: Any?, forKey key: String) {
        if value is NSDictionary &&  value is [NSDictionary] {
            if let dics = value as? [NSDictionary] {
                if  let objName = CacheUtils.getMirrorMap(self.classForCoder)[key] {
                    let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String;
                    if let objClass = NSClassFromString(namespace + "." + objName){
                        if let obj = NSClassFromString(NSStringFromClass(objClass)) as? BaseModel.Type{
                            var ojcArray = [BaseModel]()
                            for dic in dics{
                                ojcArray.append(obj.init(dic))
                            }
                            super.setValue(ojcArray, forKeyPath: key)
                        }
                    }
                }
            }else if let dic = value as? NSDictionary {
                if  let objName = CacheUtils.getMirrorMap(self.classForCoder)[key] {
                    let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String;
                    if let objClass = NSClassFromString(namespace + "." + objName){
                        if let obj = NSClassFromString(NSStringFromClass(objClass)) as? BaseModel.Type{
                            super.setValue(obj.init(dic), forKeyPath: key)
                        }
                    }
                }
            }
        }else{
            super.setValue(value, forKey: key)
        }
    }
    
      
    // MARK: 安全设置
    //如果期望在  setValue(_ value: Any?, forUndefinedKey key: String)中生效  那么数据 的key 应当与 model 中子subModel的属性名命名 + 命名空间  一致  如 list :[{}] 对应model 就是 listModels : [subModel] 如 map : {} 则是 mapModel : subModel
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
