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

class ResultViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {
    
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

//    var items:NSArray!
//    var targetCollectionView: UICollectionView!
    var tbView:UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        items = [
//            PNRadarChartDataItem.init(value: xStr, description: "X"),
//            PNRadarChartDataItem.init(value: tenStr, description: "10"),
//            PNRadarChartDataItem.init(value: nineStr, description: "9"),
//            PNRadarChartDataItem.init(value: eightStr, description: "8"),
//            PNRadarChartDataItem.init(value: sevenStr, description: "7"),
//            PNRadarChartDataItem.init(value: sixStr, description: "6"),
//            PNRadarChartDataItem.init(value: fiveStr, description: "5"),
//            PNRadarChartDataItem.init(value: fourStr, description: "4"),
//            PNRadarChartDataItem.init(value: threeStr, description: "3"),
//            PNRadarChartDataItem.init(value: twoStr, description: "2"),
//            PNRadarChartDataItem.init(value: oneStr, description: "1"),
//            PNRadarChartDataItem.init(value: MStr, description: "M")]

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "统计"
        
        self.navigationItem.setRightBarButton(UIBarButtonItem.init(title: "更多操作", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.goBack(_:))), animated: true)
        
        tbView = UITableView.init(frame: self.view.bounds, style: .plain)
        tbView.delegate = self
        tbView.dataSource = self
        self.view.addSubview(tbView)
        
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 200))
        
        let radar = PNBarChart.init(frame: CGRect.init(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height-20))
        //            radar.yLabelFormatter = {(yValue) in
        //                let yValueParsed = yValue
        //                let labelText = String(format: "%1.f", yValueParsed)
        //                return labelText
        //            }
        radar.labelMarginTop = 5
        radar.xLabels = ["M","1","2","3","4","5","6","7","8","9","10","X"]
        radar.rotateForXAxisText = false
        radar.yValues = [MStr,oneStr,twoStr,threeStr,fourStr,fiveStr,sixStr,sevenStr,eightStr,nineStr,tenStr,xStr]
        radar.barColorGradientStart = .blue
        radar.stroke()
        view.addSubview(radar)
        
        let headerLabel = UILabel.init(frame: CGRect.init(x: 0, y: radar.frame.size.height, width: view.frame.size.width, height: 20))
        headerLabel.textAlignment = .center
        headerLabel.textColor = UIColor.init(red: 77/255, green: 186/255, blue: 122/255, alpha: 1)
        headerLabel.text = "M------------------->X"
        view.addSubview(headerLabel)
        
        tbView.tableHeaderView = view
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrowTab.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: PResultTableViewCell? = nil
        if cell == nil {
            cell = PResultTableViewCell(style: .default, reuseIdentifier: "CELL")
        }
        else {
            while cell?.contentView.subviews.last != nil {
                (cell?.contentView.subviews.last)?.removeFromSuperview()
            }
        }
        cell?.arrow = arrowTab[indexPath.item]
        cell?.selectionStyle = .none
        cell?.accessoryType = .disclosureIndicator

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailledVC:DetailledTarget = DetailledTarget()
        detailledVC.arrow = arrowTab[indexPath.item]
        self.navigationController?.pushViewController(detailledVC, animated: true)
    }
    
    func goBack(_ sender: Any)
    {
        let actionsheet = ALActionSheetView.init(title: "你要选择那样?", cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: ["保存当前界面截图到相册","返回主界面"]) { (aViews, buttonIndex) in
            if buttonIndex == 0
            {
                PSaveTools.saveScroll(self.tbView)
            }
            else if buttonIndex == 1
            {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        actionsheet?.show()
    }
}
