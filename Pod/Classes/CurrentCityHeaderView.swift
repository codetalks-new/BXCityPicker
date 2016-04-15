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

public class CurrentCityHeaderView : UIView{
  public let titleLabel = UILabel(frame:CGRectZero)
  public let contentLabel = UILabel(frame:CGRectZero)
  
  public lazy var divider:CAShapeLayer = {
    let line = CAShapeLayer()
    self.layer.addSublayer(line)
    return line
  }()
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  
  public override func awakeFromNib() {
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
    
    contentLabel.setContentHuggingPriority(200, forAxis: .Horizontal)
    
  }
  
  func setupAttrs(){
    titleLabel.textColor = UIColor(white: 0.6, alpha: 1.0)
    titleLabel.font = UIFont.systemFontOfSize(15)
    titleLabel.textAlignment = .Left
    titleLabel.text = "当前城市"
    
    contentLabel.textColor = UIColor.darkTextColor()
    contentLabel.font = UIFont.systemFontOfSize(15)
    contentLabel.textAlignment = .Left
    contentLabel.text = "正在定位..."
    divider.backgroundColor = UIColor(white: 0.937, alpha: 1.0).CGColor
  }
  
  public func updateContent(content:String){
    contentLabel.text = content
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    divider.frame = bounds.divide(1, fromEdge: CGRectEdge.MaxYEdge).slice.insetBy(dx: 10, dy: 0)
  }
}
