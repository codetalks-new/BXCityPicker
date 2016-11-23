//
//  RegionInfo.swift
//  Pods
//
//  Created by Haizhen Lee on 11/23/16.
//
//

import Foundation

protocol RegionInfo {
  var name:String { get }
  var code:String { get }
  var pinyin:String { get }
}


extension RegionInfo{
  var pinyinAbbr:String{
    let compos = pinyin.split(delimiter: "_")
    let chars = compos.flatMap{ $0.characters.first }
    return String(chars)
  }
}
