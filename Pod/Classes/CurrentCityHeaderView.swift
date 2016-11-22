//
//  CurrentCityHeaderView.swift
//  Pods
//
//  Created by Haizhen Lee on 16/1/18.
//
//

import Foundation

// Build for target uimodel
//locale (None, None)
import UIKit
import SwiftyJSON
import BXModel
import PinAuto

// -CurrentCityHeaderView:v
// title[l15,y](f15,cdt)

open class CurrentCityHeaderView : UIView{
  open let titleLabel = UILabel(frame:CGRect.zero)
  open let contentLabel = UILabel(frame:CGRect.zero)
  
  open lazy var divider:CAShapeLayer = {
    let line = CAShapeLayer()
    self.layer.addSublayer(line)
    return line
  }()
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  
  open override func awakeFromNib() {
    super.awakeFromNib()
    commonInit()
  }
  
  var allOutlets :[UIView]{
    return [titleLabel,contentLabel]
  }
  var allUILabelOutlets :[UILabel]{
    return [titleLabel,contentLabel]
  }
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func commonInit(){
    for childView in allOutlets{
      addSubview(childView)
      childView.translatesAutoresizingMaskIntoConstraints = false
    }
    installConstaints()
    setupAttrs()
    
  }
  
  func installConstaints(){
    titleLabel.pa_centerY.install()
    titleLabel.pa_leading.eq(15).install()
   
    contentLabel.pa_after(titleLabel, offset: 15).install()
    contentLabel.pa_trailing.eq(15).install()
    contentLabel.pa_centerY.install()
    
    contentLabel.setContentHuggingPriority(200, for: .horizontal)
    
  }
  
  func setupAttrs(){
    titleLabel.textColor = UIColor(white: 0.6, alpha: 1.0)
    titleLabel.font = UIFont.systemFont(ofSize: 15)
    titleLabel.textAlignment = .left
    titleLabel.text = "当前城市"
    
    contentLabel.textColor = UIColor.darkText
    contentLabel.font = UIFont.systemFont(ofSize: 15)
    contentLabel.textAlignment = .left
    contentLabel.text = "正在定位..."
    divider.backgroundColor = UIColor(white: 0.937, alpha: 1.0).cgColor
  }
  
  open func updateContent(_ content:String){
    contentLabel.text = content
  }
  
  open override func layoutSubviews() {
    super.layoutSubviews()
    divider.frame = bounds.divided(atDistance: 1, from: CGRectEdge.maxYEdge).slice.insetBy(dx: 10, dy: 0)
  }
}
