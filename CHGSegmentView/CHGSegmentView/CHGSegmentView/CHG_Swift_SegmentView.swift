//
// CHG_Swift_SegmentView.swift
// ChatBird
//
// Created by 嘉爸爸 on 2024/5/18.
//

import UIKit

@objc protocol CHG_Swift_SegmentViewDelegate {
    func segmentedControlDidSelectIndex(_ index: Int)
}

@objc class CHG_Swift_SegmentView: UIView {
    
    @objc weak var delegate: CHG_Swift_SegmentViewDelegate?
    
    @objc var selectedLabelColor: UIColor?
    @objc var unselectedLabelColor: UIColor?
    
    @objc var titleSpacing: CGFloat = 10 // 新增属性: title之间的间距
    @objc var sidePadding: CGFloat = 15 // 新增属性: 第一个和最后一个title距离左右侧的间距
    
    private var labels: [UILabel] = []
    private var indicatorView: UIView!
    private var indicatorCenterView: UIView!
    private var selectedIndex: Int = 0
    
    @objc override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = kColorHexStrA("#18171C", 1)
        
        labels = []
        indicatorView = UIView()
        indicatorView.backgroundColor = UIColor.clear
        
        indicatorCenterView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 4))
        indicatorCenterView.backgroundColor = UIColor(hue: 0.64, saturation: 0.73, brightness: 1, alpha: 0.6)
        indicatorCenterView.layer.cornerRadius = 2
        indicatorCenterView.layer.masksToBounds = true
        indicatorView.addSubview(indicatorCenterView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func setButtonTitles(_ titles: [String]) {
        labels.forEach { $0.removeFromSuperview() }
        labels.removeAll()
        
        var titleWidths: [CGFloat] = []
        var totalTitleWidth: CGFloat = 0
        
        for title in titles {
            let label = UILabel()
            label.text = title
            label.font = UIFont.systemFont(ofSize: 16)
            label.sizeToFit()
            titleWidths.append(label.bounds.size.width)
            totalTitleWidth += label.bounds.size.width
        }
        
        let totalSpacingWidth = titleSpacing * CGFloat(titles.count - 1)
        let totalContentWidth = totalTitleWidth + totalSpacingWidth
        
        if totalContentWidth < self.bounds.size.width {
            sidePadding = (self.bounds.size.width - totalContentWidth) / 2
        }
        
        var titleX = sidePadding
        
        for (i, title) in titles.enumerated() {
            let label = UILabel()
            label.text = title
            label.textAlignment = .center
            label.isUserInteractionEnabled = true
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = UIColor(white: 1.0, alpha: 0.9)
            label.sizeToFit()
            
            // 设置label的frame
            var frame = label.frame
            frame.origin.x = titleX
            frame.origin.y = 0
            frame.size.height = self.bounds.size.height - 4
            label.frame = frame
            
            titleX += frame.size.width + titleSpacing // 加上间距
            label.tag = i
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
            label.addGestureRecognizer(tapGesture)
            
            self.addSubview(label)
            labels.append(label)
        }
        
        if let firstLabel = labels.first {
            indicatorView.frame = CGRect(x: firstLabel.frame.origin.x, y: self.bounds.size.height - 4, width: firstLabel.frame.size.width, height: 4)
            indicatorCenterView.center = CGPoint(x: firstLabel.frame.size.width / 2, y: 2) // Adjust the center view position within the indicator view
            self.addSubview(indicatorView)
        }
        
        setSelectedIndex(0, animated: false)
    }
    
    @objc func setSelectedIndex(_ index: Int, animated: Bool) {
        if index >= 0 && index < labels.count {
            selectedIndex = index
            moveIndicatorToIndex(index, animated: animated)
        }
    }
    
    @objc private func moveIndicatorToIndex(_ index: Int, animated: Bool) {
        guard index >= 0 && index < labels.count else {
            return
        }
        
        let selectedLabel = labels[index]
        var frame = indicatorView.frame
        frame.origin.x = selectedLabel.frame.origin.x
        frame.size.width = selectedLabel.frame.size.width
        
        for (i, label) in labels.enumerated() {
            if i == index {
                label.textColor = selectedLabelColor ?? UIColor.white
            } else {
                label.textColor = unselectedLabelColor ?? UIColor(white: 1.0, alpha: 0.9)
            }
        }
        
        if animated {
            UIView.animate(withDuration: 0.15) {
                self.indicatorView.frame = frame
            }
        } else {
            self.indicatorView.frame = frame
        }
    }
    
    @objc private func labelTapped(_ gesture: UITapGestureRecognizer) {
        if let index = gesture.view?.tag, index != selectedIndex {
            setSelectedIndex(index, animated: true)
            delegate?.segmentedControlDidSelectIndex(index)
        }
    }
    
    @objc func setbgColor(_ color: UIColor) {
        self.backgroundColor = color
    }
    
    @objc func setSelectedLabelColor(_ selectedColor: UIColor, unselectedLabelColor unselectedColor: UIColor, indicatorCenterColor indicatorColor: UIColor) {
        self.selectedLabelColor = selectedColor
        self.unselectedLabelColor = unselectedColor
        self.indicatorCenterView.backgroundColor = indicatorColor
        
        // 更新当前选中的标签颜色
        for (i, label) in labels.enumerated() {
            if i == selectedIndex {
                label.textColor = selectedLabelColor ?? UIColor.white
            } else {
                label.textColor = unselectedLabelColor ?? UIColor(white: 1.0, alpha: 0.9)
            }
        }
    }
}

// 这个kColorHexStrA函数可以独立实现
private func kColorHexStrA(_ hexStr: String, _ alpha: CGFloat) -> UIColor {
    var hex = hexStr.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int = UInt64()
    Scanner(string: hex).scanHexInt64(&int)
    let a, r, g, b: UInt64
    switch hex.count {
    case 3: // RGB (12-bit)
        (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
    case 6: // RGB (24-bit)
        (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
    case 8: // ARGB (32-bit)
        (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
    default:
        return UIColor.clear
    }
    return UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255 * alpha)
}
