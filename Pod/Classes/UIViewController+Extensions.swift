//
//  UIViewController+Extensions.swift
//  Pods
//
//  Created by Haizhen Lee on 11/22/16.
//
//

import UIKit
import BXForm

let pinyinSet: CharacterSet = {
  let lowerRange = UnicodeScalar("a")...UnicodeScalar("z")
  return CharacterSet(charactersIn: lowerRange)
}()


extension String{
  var isPinyin:Bool{
    for unicodeScalar in unicodeScalars{
      if pinyinSet.contains(unicodeScalar){
        continue
      }else{
        return false
      }
    }
    return true
  }
}

extension Province:ParentPickerItem{
  
}

extension City: ChildPickerItem{
  
}

extension City: BXCity{
  
}

extension Province: BXProvince{
  public typealias CityType = City
  
  public func cityList() -> [City] {
    return children
  }
  
  public func search(city:String) -> [City]{
    let text = city.lowercased()
    if text.isPinyin{
      return  children.filter{ $0.pinyinAbbr.contains(text) }
    }else{
      return children.filter{ $0.name.contains(text) }
    }
  }
}

public extension UIViewController{
  
  public typealias OnSelectedProvinceHandler = (Province) -> Void
  public typealias OnSelectedCityHandler = (Province, City) -> Void
  public typealias OnSelectedDistrictHandler = (Province, City, District) -> Void
  
  public func chooseProvince(handler onSelectHandler: @escaping OnSelectedProvinceHandler){
    let provinces = loadLocalProvinces()
    chooseProvince(provinces: provinces, handler: onSelectHandler)
  }
 
  public func chooseProvince(provinces:[Province],handler onSelectHandler: @escaping OnSelectedProvinceHandler){
    let controller = SelectPickerController(options: provinces)
    controller.onSelectOption = { p in
      onSelectHandler(p)
    }
    present(controller, animated: true, completion: nil)
  }
  
  
  public func chooseCity(handler onSelectHandler: @escaping OnSelectedCityHandler){
    let provinces = loadLocalProvinces()
    chooseCity(provinces: provinces, handler: onSelectHandler)
  }
 
  public func chooseCity(provinces:[Province],handler onSelectHandler: @escaping OnSelectedCityHandler){
    var dict :Dictionary<Province,[City]> = [:]
    provinces.forEach{ dict[$0] = $0.children }
    let vc = TwoStageCascadeSelectPickerController<Province,City>(parents: provinces, dict:dict)
    
    vc.onSelectOption = { p,city in
      onSelectHandler(p,city)
    }
    present(vc, animated: true, completion: nil)
  }
  
  public func selectCity(handler onSelectHandler: @escaping OnSelectedCityHandler){
    let provinces = loadLocalProvinces()
    selectCity(provinces: provinces, handler: onSelectHandler)
  }
 
  public func selectCity(provinces:[Province],handler onSelectHandler: @escaping OnSelectedCityHandler){
    let vc = CityListController<Province>()
    vc.updateProvinces(provinces)
    vc.onSelectCityBlock = { (p,city) in
      onSelectHandler(p,city)
    }
    present(vc, animated: true, completion: nil)
  }
  
  public func chooseDistrict(handler onSelectHandler:@escaping OnSelectedDistrictHandler){
    let provinces = loadLocalProvinces()
    chooseDistrict(province: provinces, handler: onSelectHandler)
  }
  
  public func chooseDistrict(province:[Province], handler onSelectHandler:@escaping OnSelectedDistrictHandler){
      let controller = DistrictPickerController()
      controller.plist = province
      controller.didSelectDistrict = { pcd  in
        onSelectHandler(pcd.province, pcd.city, pcd.district)
      }
      present(controller, animated: true, completion: nil)
  }
  
  
}
