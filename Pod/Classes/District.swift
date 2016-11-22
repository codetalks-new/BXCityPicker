//
//  District.swift
//  Pods
//
//  Created by Haizhen Lee on 11/22/16.
//
//

import Foundation

import SwiftyJSON
import BXModel
//District(tos,eq,hash, public):
//name;code;pinyin
public   struct District :BXModel{
  public   let name : String
  public   let code : String
  public   let pinyin : String
  
  public   init(json:JSON){
    self.name =  json["name"].stringValue
    self.code =  json["code"].stringValue
    self.pinyin =  json["pinyin"].stringValue
  }
  
  public   func toDict() -> [String:Any]{
    var dict : [String:Any] = [ : ]
    dict["name"] = self.name
    dict["code"] = self.code
    dict["pinyin"] = self.pinyin
    return dict
  }
}

extension District: Equatable{
}
public   func ==(lhs:District,rhs:District) -> Bool{
  return lhs.code == rhs.code
}


extension  District : Hashable{
  public   var hashValue:Int{ return code.hashValue   }
}

extension District : CustomStringConvertible{
  public   var description:String {  return name }
}


