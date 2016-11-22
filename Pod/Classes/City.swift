//
//  City.swift
//  Pods
//
//  Created by Haizhen Lee on 11/22/16.
//
//

import Foundation

import SwiftyJSON
import BXModel
//City(tos,eq,hash):
//name;code;pinyin;District:[r
public struct City :BXModel{
 public let name : String
 public let code : String
 public let pinyin : String
 public let children : [District]
  
  public init(json:JSON){
    self.name =  json["name"].stringValue
    self.code =  json["code"].stringValue
    self.pinyin =  json["pinyin"].stringValue
    self.children = District.arrayFrom(json["children"])
  }
  
  public func toDict() -> [String:Any]{
    var dict : [String:Any] = [ : ]
    dict["name"] = self.name
    dict["code"] = self.code
    dict["pinyin"] = self.pinyin
    dict["children"] = self.children.map{ $0.toDict() }
    return dict
  }
}

extension City: Equatable{
}
public func ==(lhs:City,rhs:City) -> Bool{
  return lhs.code == rhs.code
}


extension  City : Hashable{
  public var hashValue:Int{ return code.hashValue   }
}

extension City : CustomStringConvertible{
  public var description:String {  return name }
}

