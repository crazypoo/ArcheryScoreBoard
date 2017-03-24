//
//  File.swift
//  ReperageFleche
//
//  Created by Rémy Vermeersch  on 17/04/2016.
//  Copyright © 2016 Rémy Vermeersch . All rights reserved.
//

import UIKit
import PNChart.PNRadarChart
import PNChart.PNRadarChartDataItem
import AssetsLibrary

class ResultViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {
    
    var arrowTab : [Arrow]!
    var nbrsEnd : Int!
    var xStr:CGFloat!
    var tenStr:CGFloat!
    var nineStr:CGFloat!
    var eightStr:CGFloat!
    var sevenStr:CGFloat!
    var sixStr:CGFloat!
    var fiveStr:CGFloat!
    var fourStr:CGFloat!
    var threeStr:CGFloat!
    var twoStr:CGFloat!
    var oneStr:CGFloat!
    var MStr:CGFloat!

    var items:NSArray!
    @IBOutlet weak var targetCollectionView: UICollectionView!

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        items = [
            PNRadarChartDataItem.init(value: xStr, description: "X"),
            PNRadarChartDataItem.init(value: tenStr, description: "10"),
            PNRadarChartDataItem.init(value: nineStr, description: "9"),
            PNRadarChartDataItem.init(value: eightStr, description: "8"),
            PNRadarChartDataItem.init(value: sevenStr, description: "7"),
            PNRadarChartDataItem.init(value: sixStr, description: "6"),
            PNRadarChartDataItem.init(value: fiveStr, description: "5"),
            PNRadarChartDataItem.init(value: fourStr, description: "4"),
            PNRadarChartDataItem.init(value: threeStr, description: "3"),
            PNRadarChartDataItem.init(value: twoStr, description: "2"),
            PNRadarChartDataItem.init(value: oneStr, description: "1"),
            PNRadarChartDataItem.init(value: MStr, description: "M")]

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setRightBarButton(UIBarButtonItem.init(title: "还原设置", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.goBack(_:))), animated: true)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 180)
        let paddingY: CGFloat = 5
        let paddingX: CGFloat = 5
        layout.headerReferenceSize = CGSize.init(width: self.view.frame.size.width, height: 200)
        layout.sectionInset = UIEdgeInsetsMake(paddingY, paddingX, paddingY, paddingX)
        layout.minimumLineSpacing = paddingY
        
        let jobCollection = UICollectionView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: self.view.frame.size.width, height: self.view.frame.size.height), collectionViewLayout: layout)
        jobCollection.backgroundColor = UIColor.white
        jobCollection.dataSource = self
        jobCollection.delegate = self
        jobCollection.showsHorizontalScrollIndicator = false
        jobCollection.showsVerticalScrollIndicator = false
        jobCollection.register(TargetImageCell.self, forCellWithReuseIdentifier: "targetCellIdentifier")
        jobCollection.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "CELLHEADER")

        self.view.addSubview(jobCollection)

    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let collectionHeader:UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CELLHEADER", for: indexPath)
            
            let radar = PNRadarChart.init(frame: collectionHeader.bounds, items: items as! [Any], valueDivider: 2)
            radar?.stroke()
            collectionHeader.addSubview(radar!)
            
            return collectionHeader
        }
        return UICollectionReusableView()
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let targetCell = collectionView.dequeueReusableCell(withReuseIdentifier: "targetCellIdentifier", for: indexPath) as! TargetImageCell
        targetCell.arrow = arrowTab[indexPath.item]
        
        return targetCell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrowTab.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let detailledVC:DetailledTarget = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailledTarget") as! DetailledTarget
        detailledVC.arrow = arrowTab[indexPath.item]
        self.navigationController?.pushViewController(detailledVC, animated: true)
    }
    
    func goBack(_ sender: Any)
    {
        let homeVC:HomePageViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomePageViewController") as! HomePageViewController
        self.present(homeVC, animated: true) { 
            
        }
    }
}
