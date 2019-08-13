//
//  CtiyModel.swift
//  Cdemo
//
//  Created by 聂飞安 on 2019/8/9.
//  Copyright © 2019 聂飞安. All rights reserved.
//

import UIKit
import AutoModel
class CtiyModel: BaseModel {
    @objc var url : String = ""
    @objc var page : Int = 0
    @objc var linkModels : [SubModel] = [SubModel]()
    //使用命名空间查找model

}

class CtiyModelLast: BaseModel {
    @objc var url : String = ""
    @objc var page : Int = 0
    @objc var link : [SubModel] = [SubModel]()
    //对应josn 数据命名
}
