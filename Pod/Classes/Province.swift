//
//  Province.swift
//  Pods
//
//  Created by Haizhen Lee on 11/22/16.
//
//

import Foundation

import SwiftyJSON
import BXModel
//Province(tos,eq,hash,public):
//name;code;pinyin;City:[r
public   struct Province :BXModel,RegionInfo{
  public   let name : String
  public   let code : String
  public   let pinyin : String
  public   let children : [City]
  
  public   init(json:JSON){
    self.name =  json["name"].stringValue
    self.code =  json["code"].stringValue
    self.pinyin =  json["pinyin"].stringValue
    self.children = City.arrayFrom(json["children"])
  }
  
  public   func toDict() -> [String:Any]{
    var dict : [String:Any] = [ : ]
    dict["name"] = self.name
    dict["code"] = self.code
    dict["pinyin"] = self.pinyin
    dict["children"] = self.children.map{ $0.toDict() }
    return dict
  }
}

extension Province: Equatable{
}
public   func ==(lhs:Province,rhs:Province) -> Bool{
  return lhs.code == rhs.code
}


extension  Province : Hashable{
  public   var hashValue:Int{ return code.hashValue   }
}

extension Province : CustomStringConvertible{
  public   var description:String {  return name }
}

public func loadLocalProvinces() -> [Province]{
    let mainBundle = Bundle.init(for: DistrictPickerController.classForCoder())
    let resourceURL = mainBundle.resourcePath
    let resourceBundle = Bundle(path: mainBundle.bundlePath + "/BXCityPicker.bundle")
    if let jsonUrl = resourceBundle?.url(forResource: "area", withExtension: "json"){
      if let content = try? String(contentsOf:jsonUrl, encoding: String.Encoding.utf8) {
        let jsonObject =  JSON.parse(content)
        return Province.arrayFrom(jsonObject)
      }
    }else{
        NSLog("failed to locate area.json in \(resourceBundle?.bundlePath)")
    }
  

    return []
}
