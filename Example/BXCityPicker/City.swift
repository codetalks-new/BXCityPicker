//
//  City.swift
//  BXCityPicker
//
//  Created by Haizhen Lee on 15/12/22.
//  Copyright © 2015年 CocoaPods. All rights reserved.
//

import Foundation


import SwiftyJSON
import BXModel
// Model Class Generated from templates
// -City, "id", "name", "distrct":[r
class City:BXModel {
  let id:String 
  let name:String 
  let distrct:[Distrct]
  
  required init(json:JSON){
    self.id = json["id"].stringValue
    self.name = json["name"].stringValue
    self.distrct = Distrct.arrayFrom(json["distrct"])
  }
  
  func toDict() -> [String:Any]{
    var dict : [String:Any] = [ : ]
    dict["id"] = self.id
    dict["name"] = self.name
    dict["distrct"] = self.distrct.map{ $0.toDict() }
    return dict
  }
  
}
    
