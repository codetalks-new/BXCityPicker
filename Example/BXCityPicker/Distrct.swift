//
//  Distrct.swift
//  BXCityPicker
//
//  Created by Haizhen Lee on 15/12/22.
//  Copyright © 2015年 CocoaPods. All rights reserved.
//

import Foundation


import SwiftyJSON
import BXModel
// Model Class Generated from templates
// -Distrct, "id", "name"
class Distrct:BXModel {
        let id:String 
    let name:String 

    required init(json:JSON){
            self.id = json["id"].stringValue
    self.name = json["name"].stringValue
    }

    func toDict() -> [String:AnyObject]{
      var dict : [String:AnyObject] = [ : ]
         dict["id"] = self.id
   dict["name"] = self.name
      return dict
    }

}
    