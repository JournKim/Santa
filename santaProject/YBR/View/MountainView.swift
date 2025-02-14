//
//  MountainView.swift
//  santaProject
//
//  Created by yeongbinRo on 2021/06/05.
//

import Foundation
import MapKit

class MountainView: MKAnnotationView {
    
    var favoriteButton = UIImageView()
    var isFavorite = false {
        didSet {
            favoriteButton.isHidden = !isFavorite
        }
    }
    
    override var annotation: MKAnnotation? {
        willSet {
            guard let mountain = newValue as? Mountain else {
                return
            }
            
            if mountain.isVisit ?? false {
                image = #imageLiteral(resourceName: "SantaFlag")
            } else {
                image = #imageLiteral(resourceName: "SantaMt")
            }
            
            addFavoriteButton()
            self.isFavorite = mountain.isFavorite ?? false
            setupCalloutView(mountain)

        }
    }
    
    func addFavoriteButton() {
        let imgView = UIImageView.init(frame: CGRect(x: self.frame.width - 10, y: 0, width: 16, height: 16))
        imgView.image = #imageLiteral(resourceName: "SantaBm")
        self.addSubview(imgView)
        favoriteButton = imgView
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: false)

        guard let mountain = annotation as? Mountain, let isVisit = mountain.isVisit else { return }
        
        var imgName = ""
        
        if selected {
            if isVisit {
                imgName = "SantaFlagBig"
            } else {
                imgName = "SantaMtBig"
            }
        } else {
            if isVisit {
                imgName = "SantaFlag"
            } else {
                imgName = "SantaMt"
            }
        }
        
        image = UIImage(named: imgName)

    }
    
    func setupCalloutView(_ annotation: MKAnnotation) {
        
        self.canShowCallout = true
        
//        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
////        btn.setBackgroundImage(UIImage(named: "santaIconArrow"), for: .normal)
//        let origImage = UIImage(named: "santaIconArrow")
//        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
//        btn.setImage(tintedImage, for: .normal)
//        btn.tintColor = .white
//        btn.addTarget(self, action: #selector(touchRightButton), for: .touchUpInside)
//        self.rightCalloutAccessoryView = btn

    }
    
    @objc
    func touchRightButton(sender: UIButton) {
        print("callout Button touch!")
    }
    
    
    //FIXME: 임시코드. 개선할 것
    override func layoutSubviews() {
        if !self.isSelected {
            return
        }
        
        for v in self.subviews {
            setLabelOfCallout(view: v)
        }

    }

    func setLabelOfCallout(view: UIView) {
        
        //UILabel만 찾아 superView background color 바꾸기
        for v in view.subviews {
            
            if v.isKind(of: UILabel.self) {
                view.backgroundColor = UIColor.stGreen30
                
                guard let label = v as? UILabel, let text = label.text else { return }

                label.attributedText = setToAttributedString(str: text)
                
                
                return
            }
            
            setLabelOfCallout(view: v)
        }
    }
    
    
    
    func setToAttributedString(str: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: (str), attributes: [.font: UIFont.systemFont(ofSize: 15, weight: .medium), .foregroundColor: UIColor.white, .kern: 1.0])
        
        if let idx = str.firstIndex(of: " ") {
            
            let pos = str.distance(from: str.startIndex, to: idx)
            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 12), range: NSMakeRange(pos, str.count-pos))
            
        }

        return attributedString
    }
    
}
