//
//  UIViewController+Extensions.swift
//  Pods
//
//  Created by Haizhen Lee on 11/22/16.
//
//

import UIKit
import BXForm

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
}

public extension UIViewController{
  
  public typealias OnSelectedCityHandler = (Province, City) -> Void
  public typealias OnSelectedDistrictHandler = (Province, City, District) -> Void
  
  
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
