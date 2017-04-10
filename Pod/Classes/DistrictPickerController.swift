//
//  DistrictPickerController.swift
//  Pods
//
//  Created by Haizhen Lee on 11/22/16.
//

import UIKit

// Build for target uicontroller
//locale (None, None)
import UIKit
import SwiftyJSON
import BXModel
import BXForm
import BXiOSUtils

// Build for target enum
//locale (None, None)
//AreaComponent:i
//province:省;city:城市;district:地区;
enum AreaComponent :Int {
        case province =  0

        case city =  1

        case district =  2

    var isProvince:Bool{
        return self == .province
    }
    var isCity:Bool{
        return self == .city
    }
    var isDistrict:Bool{
        return self == .district
    }
    var title:String{
        switch self{
        case .province:return "省"
        case .city:return "城市"
        case .district:return "地区"
        }
    }

    static let allCases:[AreaComponent] = [province,.city,.district]
}



public struct ProvinceCityDistrict{
  public var province:Province
  public var city:City
  public var district:District
  
  public init(province:Province,city:City,district:District){
    self.province = province
    self.city = city
    self.district = district
  }
  
  public var addr:String{
    return province.name + city.name + district.name
  }
}

// -PCRPickerController(req):vc
// _[e0]:p


open class DistrictPickerController: PickerController {
  
  var plist = [Province]()
  fileprivate var clist = [City]()
  fileprivate var rlist = [District]()
  
  override open func viewDidLoad() {
    super.viewDidLoad()
    picker.delegate = self
    picker.dataSource = self
    picker.showsSelectionIndicator = true
  
    if !plist.isEmpty{
      show(provinces: plist)
    }
    
  }
  
  var province:Province?
  var city:City?
  var district:District?
  
  public var didSelectDistrict:((ProvinceCityDistrict) -> Void)?

  
  open override func onPickDone() {
    guard let province = self.province,let city = self.city,let district = self.district else{
      return
    }
    
    let pcd = ProvinceCityDistrict(province: province, city: city, district: district)
    self.didSelectDistrict?(pcd)
  }
  
  @IBAction func onOkButtonPressed(sender:AnyObject){
  }
  
  func show(provinces:[Province]){
    plist = provinces
    picker.reloadComponent(0)
    if let p = plist.first{
      onSelectProvince(p)
    }
  }
  
  func onSelectProvince(_ province:Province){
    self.province = province
    clist = province.children
    if let city = province.children.first {
      onSelectCity(city)
    }
  }
  
  func onSelectCity(_ city:City){
    self.city = city
    rlist = city.children
    self.picker.reloadComponent(1)
    if let district = city.children.first{
        self.district = district
        self.picker.reloadComponent(2)
    }
  }
  
}


// MARK: UIPickerViewDataSource

extension DistrictPickerController :UIPickerViewDataSource{
  
  public func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 3
  }
  
  public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
    switch component{
    case 0: return plist.count
    case 1: return clist.count
    case 2: return rlist.count
    default:return 0
    }
  }
  
  
}

// MARK: UIPickerViewDelegate
extension DistrictPickerController:UIPickerViewDelegate{
  
  //    // returns width of column and height of row for each component.
  //    @available(iOS 2.0, *)
  //    optional public func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat
  //    @available(iOS 2.0, *)
  //    optional public func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat
  //
  //    // these methods return either a plain NSString, a NSAttributedString, or a view (e.g UILabel) to display the row for the component.
  //    // for the view versions, we cache any hidden and thus unused views and pass them back for reuse.
  //    // If you return back a different object, the old one will be released. the view will be centered in the row rect
  //    @available(iOS 2.0, *)
  
  public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    switch component{
    case 0: return plist[row].name
    case 1: return clist[row].name
    case 2: return rlist[row].name
    default:return ""
    }
  }
  //    @available(iOS 6.0, *)
  //    optional public func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? // attributed title is favored if both methods are implemented
  //    @available(iOS 2.0, *)
  //    optional public func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView
  //
  //    @available(iOS 2.0, *)
  
  public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    if let comp = AreaComponent(rawValue: component){
      switch comp{
      case .province:
        onSelectProvince(plist[row])
      case .city:
        onSelectCity(clist[row])
      case .district:
        self.district = rlist[row]
      }
    }
    
  }
}



