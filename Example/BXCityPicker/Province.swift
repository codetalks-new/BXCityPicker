//
//  Province.swift
//  BXCityPicker
//
//  Created by Haizhen Lee on 15/12/22.
//  Copyright © 2015年 CocoaPods. All rights reserved.
//

import Foundation


import SwiftyJSON
import BXModel
// Model Class Generated from templates
// -Province, "id", "name", "city":[r
class Province:BXModel {
  let id:String 
  let name:String 
  let city:[City]
  
  required init(json:JSON){
    self.id = json["id"].stringValue
    self.name = json["name"].stringValue
    self.city = City.arrayFrom(json["city"])
  }
  
  func toDict() -> [String:AnyObject]{
    var dict : [String:AnyObject] = [ : ]
    dict["id"] = self.id
    dict["name"] = self.name
    dict["city"] = self.city.map{ $0.toDict() }
    return dict
  }
  
}
    