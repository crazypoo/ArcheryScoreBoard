//
//  PResultTableViewCell.swift
//  Archery Score
//
//  Created by 邓杰豪 on 2017/3/25.
//  Copyright © 2017年 邓杰豪. All rights reserved.
//

import UIKit

class PResultTableViewCell: UITableViewCell {

    var arrow : Arrow! {
        didSet{
            arrowIDLAbel.textColor = UIColor.blue
            arrowIDLAbel.text = "落点" + String(arrow.arrowId + 1)
            updateMarkers(arrow.shots)
            var scoreTotal : Int = 0
            for i in (arrow?.shots)! {
                let x:NSString = String(i.value) as NSString
                if x.isEqual(to: "11") {
                    scoreTotal += 10
                }
                else
                {
                    scoreTotal += i.value
                }
            }
            scoreLabel.text = "该点得分 : \(scoreTotal)"
        }
    }
    
    var targetImageView: UIImageView!
    var arrowIDLAbel: UILabel!
    var reperageViews : [CrossMarkerView] = [CrossMarkerView]()
    var scoreLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        targetImageView = UIImageView.init(frame: CGRect.init(x: 5, y: 2.5, width: 145, height: 145))
        targetImageView.image = UIImage.init(named: "TargetImage")
        self.contentView.addSubview(targetImageView)

        arrowIDLAbel = UILabel.init(frame: CGRect.init(x: self.contentView.frame.size.width-120, y: 0, width: 120, height: 75))
        arrowIDLAbel.textAlignment = .right
        arrowIDLAbel.numberOfLines = 0
        arrowIDLAbel.lineBreakMode = .byCharWrapping
        self.contentView.addSubview(arrowIDLAbel)
        
        scoreLabel = UILabel.init(frame: CGRect.init(x: self.contentView.frame.size.width-120, y: 75, width: 120, height: 75))
        scoreLabel.textAlignment = .right
        scoreLabel.numberOfLines = 0
        scoreLabel.lineBreakMode = .byCharWrapping
        self.contentView.addSubview(scoreLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateMarkers(_ shots : [Shot]){
        
        for i in reperageViews {
            i.removeFromSuperview()
        }
        reperageViews.removeAll()
        
        for currentShot in shots {
            reperageViews.append(CrossMarkerView(shot: currentShot, frame: targetImageView.bounds))
            
            targetImageView.addSubview(reperageViews.last!)
        }
        
    }
    
}
