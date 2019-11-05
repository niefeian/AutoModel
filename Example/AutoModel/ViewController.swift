//
//  ViewController.swift
//  AutoModel
//
//  Created by niefeian on 08/12/2019.
//  Copyright (c) 2019 niefeian. All rights reserved.
//

import UIKit
import AutoModel
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let json =  Bundle.main.path(forResource: "josn.json", ofType: nil)
        let url = URL(fileURLWithPath: json!)
        do {
            let data = try Data(contentsOf: url)
            let jsonData:Any = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            if let dic = jsonData as? NSDictionary{
                let  start  = Date()
//                print(CtiyModel(dic).url)
//                print(CtiyModelLast(dic).link.first?.url)
                let  model  = CtiyModelLast(dic)
                print(model.toJosn())
                print(start.timeIntervalSinceNow)
            }
        } catch let error {
            
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

