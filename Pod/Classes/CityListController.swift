//
//  BXCityPickerController.swift
//  Pods
//
//  Created by Haizhen Lee on 15/12/22.
//
//

import Foundation
import CoreLocation

// Build for target uicontroller
//locale (None, None)
import UIKit
import SwiftyJSON
import BXModel
import PinAuto
// -BXCityPickerController:vc
// _[hor0,t0,h44]:sb
// currentCity[hor0,t0,h44]:v
// otherCityHeader[hor0,t0,h44]
// _[hor0,b0,t0]:c

open class CityListController<P:BXProvince> : UIViewController,UISearchResultsUpdating,UISearchControllerDelegate,UISearchBarDelegate, UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,CLLocationManagerDelegate where P.CityType: protocol<BXCity,Equatable>{
  typealias C = P.CityType
  open lazy var currentCityHeader :CurrentCityHeaderView  = {
    let header = CurrentCityHeaderView(frame:CGRect.zero)
    return header
  }()
  
  open lazy var otherCityHeader: OtherCityHeaderView = {
    let header = OtherCityHeaderView(frame:CGRect.zero)
    return header
  }()

  fileprivate let flowLayout:UICollectionViewFlowLayout = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.minimumInteritemSpacing = 4
    let itemWidth = (UIScreen.main.bounds.width - 4 * 3  - 1) / 4
    flowLayout.itemSize = CGSize(width:floor(itemWidth),height:36)
    flowLayout.minimumLineSpacing = 8
    flowLayout.sectionInset = UIEdgeInsets.zero
    flowLayout.scrollDirection = .vertical
    return flowLayout
  }()
  
  lazy var collectionView :UICollectionView = {
    let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.flowLayout)
    return cv
  }()

  fileprivate var provinces:[P] = []
  
  open func updateProvinces(_ provinces:[P]){
    self.provinces.removeAll()
    self.provinces.append(contentsOf: provinces)
    if isViewLoaded{
      collectionView.reloadData()
    }
  }
  
  public convenience init(){
    self.init(nibName:nil,bundle:nil)
  }
  // must needed for iOS 8
  public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  var allOutlets :[UIView]{
    return [searchBar,currentCityHeader,otherCityHeader,collectionView]
  }
  var allUICollectionViewOutlets :[UICollectionView]{
    return [collectionView]
  }
  var allUISearchBarOutlets :[UISearchBar]{
    return [searchBar]
  }
  var allUIViewOutlets :[UIView]{
    return [currentCityHeader]
  }
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func commonInit(){
    for childView in allOutlets{
      self.view.addSubview(childView)
      childView.translatesAutoresizingMaskIntoConstraints = false
    }
    installConstaints()
    setupAttrs()
  }
  
  func installConstaints(){
    searchBar.pa_height.eq(44).install()
    searchBar.pac_horizontal(0)
    searchBar.pa_below(topLayoutGuide, offset: 0).install()
   
    currentCityHeader.pa_height.eq(36).install()
    currentCityHeader.pac_horizontal(0)
    currentCityHeader.pa_below(searchBar, offset: 0).install()
    
    otherCityHeader.pa_height.eq(36).install()
    otherCityHeader.pac_horizontal(0)
    otherCityHeader.pa_below(currentCityHeader, offset: 0).install()
    
    collectionView.pac_horizontal(0)
    collectionView.pa_below(otherCityHeader, offset: 0).install()
    collectionView.pa_above(bottomLayoutGuide, offset: 0).install()
  }
  
  func setupAttrs(){
    collectionView.backgroundColor = .white
  }
  override open func loadView(){
    super.loadView()
    self.view.backgroundColor = .white
    commonInit()
  }
  
  
  
  let provinceSectionHeaderIdentifier = "provinceSectionHeader"
  
  override open func viewDidLoad() {
    super.viewDidLoad()
    title = "选择城市"
    navigationItem.title = title
    
    collectionView.keyboardDismissMode = .onDrag
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(CityCell.self, forCellWithReuseIdentifier: "cityCell")
    collectionView.register(ProvinceSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: provinceSectionHeaderIdentifier)
   
    requestLocationIfNeeded()
    setupSearchController()
    
    navigationItem.leftBarButtonItem = cancelButton
  }
  
  lazy var selectDoneButton : UIBarButtonItem = {
    let item = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(selectDone(_:)))
    return item
  }()
  
  lazy var cancelButton : UIBarButtonItem = {
    let item = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel(_:)))
    return item
  }()
  
  func cancel(_ sender:AnyObject){
    dismiss()
  }
  
  func dismiss(){
    let poped = navigationController?.popViewController(animated: true)
    if poped == nil{
      dismiss(animated: true, completion: nil)
    }
  }
  
  func selectDone(_ sender:AnyObject){
    if let province = currentProvince, let city = currentCity{
      onSelectCity(province: province, city: city)
    }
  }
  
  var currentProvince:P? // 定位找出来的城市
 
  var currentCity:C?{
    didSet{
      if currentCity != nil{
        navigationItem.rightBarButtonItem = selectDoneButton
      }
    }
  }
  
  open var onSelectCityBlock: ((P, C) -> Void)?
  
  func onSelectCity(province:P, city:C){
    onSelectCityBlock?(province, city)
    dismiss()
  }
  
  // MARK: UICollectionViewDelegateFlowLayout
  
  // MARK:UICollectionViewDataSource
  open func numberOfSections(in collectionView: UICollectionView) -> Int {
    return provinces.count
  }
  
  open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    let plist = self.provinces
    let province = plist[section]
    return province.cityList().count
  }
  
  open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cityCell", for: indexPath) as! CityCell
    let item = cityAtIndexPath(indexPath)
    cell.bind(item)
    return cell
  }
  
  open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    if kind == UICollectionElementKindSectionHeader{
      let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: provinceSectionHeaderIdentifier, for: indexPath) as! ProvinceSectionHeaderView
      let province = provinceAtSection((indexPath as NSIndexPath).section)
      header.bind(province.name)
      return header
    }else{
      return UICollectionReusableView()
    }
    
  }
  
  // MARK: UICollectionViewDelegate
  
  open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return CGSize(width: collectionView.bounds.width, height: 30)
  }
  
  open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let province = provinceAtSection(indexPath.section)
    let city = cityAtIndexPath(indexPath)
    onSelectCity(province: province, city: city)
  }
 
  // MARK: SearchSupport
  lazy var searchController : UISearchController = { [unowned self] in
    let controller = UISearchController(searchResultsController: self.searchResultsController)
    controller.delegate = self
    controller.searchResultsUpdater = self
    controller.dimsBackgroundDuringPresentation = true
    controller.navigationItem.title = "搜索"
    controller.hidesNavigationBarDuringPresentation = true
    controller.automaticallyAdjustsScrollViewInsets = true
    return controller
  }()
 
  // Fake searchbar
  lazy var searchBar:UISearchBar = { [unowned self] in
    let searchBar = UISearchBar()
    searchBar.placeholder = "搜索"
    searchBar.barTintColor = UIColor(white: 0.937, alpha: 1.0)
    searchBar.delegate = self
    searchBar.sizeToFit() // iOS 8 中不调用此选项。搜索框不显示。
    return searchBar
  }()
  
  lazy var searchResultsController = SimpleGenericTableViewController<C,SearchResultCell>(style: .plain)
  
  
 


  func setupSearchController(){
    definesPresentationContext = false
    let searchBar = searchController.searchBar
    searchBar.placeholder = "搜索城市"
    searchBar.showsCancelButton = true
    searchBar.isTranslucent = false
    searchResultsController.didSelectedItemBlock = {
      item,index in
      self.searchController.isActive = false
      if let province = self.findProvince(byCity: item){
        self.onSelectCity(province:province, city:item)
      }
    }
    
  }
  
  func findProvince(byCity city:C) -> P?{
    for p in provinces{
      let cityList = p.cityList()
      for c in cityList{
        if c == city{
          return p
        }
      }
    }
    return nil
  }
  
  // MARK: UISearchBarDelegate
  
  open func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
    searchController.isActive = true
    return false
  }
  
   // MARK:  UI UISearchControllerDelegate
  open func presentSearchController(_ searchController: UISearchController) {
    NSLog("\(#function)")
    present(searchController, animated: true, completion: nil)
  }
  
  
  // MARK: UISearchResultsUpdating
  open func updateSearchResults(for searchController: UISearchController) {
    let text = searchController.searchBar.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) ?? ""
    NSLog("\(#function) \(text)")
    if text.isEmpty{
      searchResultsController.updateItems([])
    }else{
      let items = queryCityListByText(text)
      searchResultsController.updateItems(items)
    }
  }
 
  func queryCityListByText(_ text:String) -> [C]{
    var list :[C] = []
    for p in provinces{
      let cities = p.search(city: text)
      if !cities.isEmpty{
        list.append(contentsOf: cities)
      }
    }
    return list
  }
  
  
  //MARK: Locate Support
  let locationManager = CLLocationManager()
  var currentLocation:CLLocation?
  var currentPlacemark:CLPlacemark?
  lazy var geocoder = CLGeocoder()
  
  var locateState = LocateState.locating
  
  // MARK: CLLocationManagerDelegate:
  
  open func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let recentLocation = locations.last!
    NSLog("\(#function) recentLocation is \(recentLocation)")
    //    if recentLocation.horizontalAccuracy < 0 {
    //      transitionToState(.LocateFailed)
    //      // test that the horizontal accuracy does not indicate an invalid measurement
    //      return
    //    }
    currentLocation = recentLocation
    stopRequestLocation()
    queryPlacemarkByLocation(recentLocation){ placemark in
      self.currentPlacemark = placemark
      self.transitionToState(.located)
      self.updateCurrentCityByPlacemark(placemark)
    }
  }
  
  open func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    NSLog("\(#function) \(error)")
    stopRequestLocation()
    transitionToState(.locateFailed)
  }
  
  open func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    NSLog("\(#function) status:\(status)")
  }

}

extension CityListController{
  
  func provinceAtSection(_ section:Int) -> P{
    return provinces[section]
  }
  
  func cityAtIndexPath(_ indexPath:IndexPath) -> C{
    let cityList =  provinceAtSection((indexPath as NSIndexPath).section).cityList()
    return cityList[(indexPath as NSIndexPath).row] as! C
  }
}



enum LocateState{
  case locating,located,locateFailed
  
  var title:String{
    switch self{
    case .locating:return "正在定位..."
    case .located: return "定位成功"
    case .locateFailed: return "定位失败"
    }
  }
}

extension CityListController{
  func relocate(){
    requestLocationIfNeeded()
  }
  
  func requestLocationIfNeeded(){
    if currentCity != nil{
      return
    }
    transitionToState(.locating)
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    locationManager.requestWhenInUseAuthorization()
    if #available(iOS 9.0, *) {
        locationManager.requestLocation()
    } else {
      locationManager.startUpdatingLocation()
    }
  }
  
  func stopRequestLocation(){
    locationManager.stopUpdatingLocation()
    locationManager.delegate = nil
  }
  
  func transitionToState(_ state:LocateState){
    self.locateState = state
    currentCityHeader.updateContent(state.title)
  }
  
  func queryPlacemarkByLocation(_ location:CLLocation,resultHandler:@escaping ((CLPlacemark) -> Void)){
    geocoder.reverseGeocodeLocation(location){ (placemarks, error) -> Void in
      if placemarks == nil{
        NSLog("ERROR placemarks is nil")
        return
      }
      if let placemark = placemarks?.first{
        NSLog("\(placemark.administrativeArea)-\(placemark.locality)-\(placemark.subLocality)")
        resultHandler(placemark)
      }
    }
  }
  

  
  func updateCurrentCityByPlacemark(_ placemark:CLPlacemark){
    if let cityName = placemark.locality{
      if let (province,city) = selectCityByName(cityName){
        currentProvince = province
        currentCity = city
        currentCityHeader.updateContent(cityName)
      }else{
        currentCityHeader.updateContent(cityName+"暂不支持此城市,请选择下面其他城市")
      }
    }
  }
  
  func selectCityByName(_ name:String) -> (P, C)?{
    for p in provinces{
      for c in p.cityList(){
        let city = c as! C
        let c1 = city.name.replacingOccurrences(of: "市", with: "")
        let c2 = name.replacingOccurrences(of: "市", with: "")
        if c1 == c2{
          return (p,city)
        }
      }
    }
    return nil
  }
  


}


