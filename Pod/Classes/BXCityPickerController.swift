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
import PinAutoLayout
// -BXCityPickerController:vc
// _[hor0,t0,h44]:sb
// currentCity[hor0,t0,h44]:v
// otherCityHeader[hor0,t0,h44]
// _[hor0,b0,t0]:c

public class BXCityPickerController<P:BXProvince,C:BXCity> : UIViewController,UISearchResultsUpdating,UISearchControllerDelegate,UISearchBarDelegate, UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,CLLocationManagerDelegate {
  
  public lazy var currentCityHeader :CurrentCityHeaderView  = {
    let header = CurrentCityHeaderView(frame:CGRectZero)
    return header
  }()
  
  public lazy var otherCityHeader: OtherCityHeaderView = {
    let header = OtherCityHeaderView(frame:CGRectZero)
    return header
  }()

  private let flowLayout:UICollectionViewFlowLayout = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.minimumInteritemSpacing = 4
    let itemWidth = (UIScreen.mainScreen().bounds.width - 4 * 3  - 1) / 4
    flowLayout.itemSize = CGSize(width:floor(itemWidth),height:36)
    flowLayout.minimumLineSpacing = 8
    flowLayout.sectionInset = UIEdgeInsetsZero
    flowLayout.scrollDirection = .Vertical
    return flowLayout
  }()
  
  lazy var collectionView :UICollectionView = {
    let cv = UICollectionView(frame: CGRectZero, collectionViewLayout: self.flowLayout)
    return cv
  }()

  private var provinces:[P] = []
  
  public func updateProvinces(provinces:[P]){
    self.provinces.removeAll()
    self.provinces.appendContentsOf(provinces)
    if isViewLoaded(){
      collectionView.reloadData()
    }
  }
  
  public convenience init(){
    self.init(nibName:nil,bundle:nil)
  }
  // must needed for iOS 8
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
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
    searchBar.pinHeight(44)
    searchBar.pinHorizontal(0)
    pinTopLayoutGuide(searchBar,margin:0)
    
    currentCityHeader.pinHeight(36)
    currentCityHeader.pinHorizontal(0)
    currentCityHeader.pinBelowSibling(searchBar, margin: 0)
    
    otherCityHeader.pinHeight(36)
    otherCityHeader.pinHorizontal(0)
    otherCityHeader.pinBelowSibling(currentCityHeader, margin: 0)
    
    collectionView.pinHorizontal(0)
    collectionView.pinBelowSibling(otherCityHeader, margin: 0)
    pinBottomLayoutGuide(collectionView,margin:0)
  }
  
  func setupAttrs(){
    collectionView.backgroundColor = .whiteColor()
  }
  override public func loadView(){
    super.loadView()
    self.view.backgroundColor = .whiteColor()
    commonInit()
  }
  
  
  
  let provinceSectionHeaderIdentifier = "provinceSectionHeader"
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    title = "选择城市"
    navigationItem.title = title
    
    collectionView.keyboardDismissMode = .OnDrag
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.registerClass(CityCell.self, forCellWithReuseIdentifier: "cityCell")
    collectionView.registerClass(ProvinceSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: provinceSectionHeaderIdentifier)
   
    requestLocationIfNeeded()
    setupSearchController()
    
    navigationItem.leftBarButtonItem = cancelButton
  }
  
  lazy var selectDoneButton : UIBarButtonItem = {
    let item = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "selectDone:")
    return item
  }()
  
  lazy var cancelButton : UIBarButtonItem = {
    let item = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancel:")
    return item
  }()
  
  func cancel(sender:AnyObject){
    dismiss()
  }
  
  func dismiss(){
    let poped = navigationController?.popViewControllerAnimated(true)
    if poped == nil{
      dismissViewControllerAnimated(true, completion: nil)
    }
  }
  
  func selectDone(sender:AnyObject){
    if let city = currentCity{
      onSelectCity(city)
    }
  }
 
  var currentCity:C?{
    didSet{
      if currentCity != nil{
        navigationItem.rightBarButtonItem = selectDoneButton
      }
    }
  }
  
  public var onSelectCityBlock: (C -> Void)?
  
  func onSelectCity(city:C){
    onSelectCityBlock?(city)
    dismiss()
  }
  
  // MARK: UICollectionViewDelegateFlowLayout
  
  // MARK:UICollectionViewDataSource
  public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return provinces.count
  }
  
  public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    let plist = self.provinces
    let province = plist[section]
    return province.cityList().count
  }
  
  public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cityCell", forIndexPath: indexPath) as! CityCell
    let item = cityAtIndexPath(indexPath)
    cell.bind(item)
    return cell
  }
  
  public func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
    if kind == UICollectionElementKindSectionHeader{
      let header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: provinceSectionHeaderIdentifier, forIndexPath: indexPath) as! ProvinceSectionHeaderView
      let province = provinceAtSection(indexPath.section)
      header.bind(province.name)
      return header
    }else{
      return UICollectionReusableView()
    }
    
  }
  
  // MARK: UICollectionViewDelegate
  
  public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return CGSize(width: collectionView.bounds.width, height: 30)
  }
  
  public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    let city = cityAtIndexPath(indexPath)
    onSelectCity(city)
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
  
  lazy var searchResultsController = SimpleGenericTableViewController<C,SearchResultCell>(style: .Plain)
  
  
 


  func setupSearchController(){
    definesPresentationContext = false
    let searchBar = searchController.searchBar
    searchBar.placeholder = "搜索城市"
    searchBar.showsCancelButton = true
    searchBar.translucent = false
    searchResultsController.didSelectedItemBlock = {
      item,index in
      self.searchController.active = false
      self.onSelectCity(item)
    }
    
  }
  
  // MARK: UISearchBarDelegate
  
  public func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
    searchController.active = true
    return false
  }
  
   // MARK:  UI UISearchControllerDelegate
  public func presentSearchController(searchController: UISearchController) {
    NSLog("\(__FUNCTION__)")
    presentViewController(searchController, animated: true, completion: nil)
  }
  
  
  // MARK: UISearchResultsUpdating
  public func updateSearchResultsForSearchController(searchController: UISearchController) {
    let text = searchController.searchBar.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) ?? ""
    NSLog("\(__FUNCTION__) \(text)")
    if text.isEmpty{
      searchResultsController.updateItems([])
    }else{
      let items = queryCityListByText(text)
      searchResultsController.updateItems(items)
    }
  }
  
  //MARK: Locate Support
  let locationManager = CLLocationManager()
  var currentLocation:CLLocation?
  var currentPlacemark:CLPlacemark?
  lazy var geocoder = CLGeocoder()
  
  var locateState = LocateState.Locating
  
  // MARK: CLLocationManagerDelegate:
  
  public func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let recentLocation = locations.last!
    NSLog("\(__FUNCTION__) recentLocation is \(recentLocation)")
    //    if recentLocation.horizontalAccuracy < 0 {
    //      transitionToState(.LocateFailed)
    //      // test that the horizontal accuracy does not indicate an invalid measurement
    //      return
    //    }
    currentLocation = recentLocation
    stopRequestLocation()
    queryPlacemarkByLocation(recentLocation){ placemark in
      self.currentPlacemark = placemark
      self.transitionToState(.Located)
      self.updateCurrentCityByPlacemark(placemark)
    }
  }
  
  public func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
    NSLog("\(__FUNCTION__) \(error)")
    stopRequestLocation()
    transitionToState(.LocateFailed)
  }
  
  public func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    NSLog("\(__FUNCTION__) status:\(status)")
  }

}

extension BXCityPickerController{
  
  func provinceAtSection(section:Int) -> P{
    return provinces[section]
  }
  
  func cityAtIndexPath(indexPath:NSIndexPath) -> C{
    let cityList =  provinceAtSection(indexPath.section).cityList()
    return cityList[indexPath.row] as! C
  }
}



enum LocateState{
  case Locating,Located,LocateFailed
  
  var title:String{
    switch self{
    case .Locating:return "正在定位..."
    case .Located: return "定位成功"
    case .LocateFailed: return "定位失败"
    }
  }
}

extension BXCityPickerController{
  func relocate(){
    requestLocationIfNeeded()
  }
  
  func requestLocationIfNeeded(){
    if currentCity != nil{
      return
    }
    transitionToState(.Locating)
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
  
  func transitionToState(state:LocateState){
    self.locateState = state
    currentCityHeader.updateContent(state.title)
  }
  
  func queryPlacemarkByLocation(location:CLLocation,resultHandler:(CLPlacemark -> Void)){
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
  

  
  func updateCurrentCityByPlacemark(placemark:CLPlacemark){
    if let cityName = placemark.locality{
      if let city = selectCityByName(cityName){
        currentCity = city
        currentCityHeader.updateContent(cityName)
      }else{
        currentCityHeader.updateContent(cityName+"暂不支持此城市,请选择下面其他城市")
      }
    }
  }
  
  func selectCityByName(name:String) -> C?{
    for p in provinces{
      for c in p.cityList(){
        let city = c as! C
        let c1 = city.name.stringByReplacingOccurrencesOfString("市", withString: "")
        let c2 = name.stringByReplacingOccurrencesOfString("市", withString: "")
        if c1 == c2{
          return city
        }
      }
    }
    return nil
  }
  
  func queryCityListByText(text:String) -> [C]{
    var list :[C] = []
    for p in provinces{
      for c in p.cityList(){
        let city = c as! C
        if city.name.containsString(text){
          list.append(city)
        }
      }
    }
    return list
  }
  

}


