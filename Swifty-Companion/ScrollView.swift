
//
//  ScrollView.swift
//  Swifty-Companion
//
//  Created by Hnat DANYLEVYCH on 11/2/18.
//  Copyright © 2018 Hnat DANYLEVYCH. All rights reserved.
//

import UIKit
import Charts

class ScrollView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var us: User? = nil
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var projectsView: UITableView! {
        didSet {
            projectsView.delegate = self
            projectsView.dataSource = self
            projectsView.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    @IBOutlet weak var chartbar: BarChartView!
    
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var userphotoImage: UIImageView!
    @IBOutlet weak var displaynameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var corpointsLabel: UILabel!
    @IBOutlet weak var walletLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load_first_view()
        load_second_view()
        projectsView.layer.cornerRadius = 15
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (us?.projects_users.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "projects")
        cell?.textLabel?.text = us?.projects_users[indexPath.row].project.slug
        if let m = us?.projects_users[indexPath.row].final_mark {
            cell?.detailTextLabel?.text = "\(m)"
        }
        
        if let v = us?.projects_users[indexPath.row].validated {
            
            if v {
                cell?.backgroundColor = UIColor(red: 0.5098, green: 1, blue: 0.6392, alpha: 1.0)
            } else {
                cell?.backgroundColor = UIColor(red: 1, green: 0.5961, blue: 0.5098, alpha: 1.0)
            }
        } else {
            cell?.backgroundColor = .white
            cell?.detailTextLabel?.text = "in progress"
        }

        return cell!
    }
    
    func load_first_view()
    {
        let url = URL(string: (us?.image_url!)!)
        let date = NSData(contentsOf: url!)
        self.userphotoImage.image = UIImage(data: date! as Data)
        userphotoImage.layer.cornerRadius = userphotoImage.frame.height / 2
        firstView.layer.cornerRadius = 15
        print(displaynameLabel)
        displaynameLabel.text = "Name: " + (us?.displayname)!
        phoneLabel.text = "Phone: "
        if let ph = us?.phone {
            phoneLabel.text = phoneLabel.text! + ph
        }
        levelLabel.text = "Level: "
        if (us?.cursus_users.count)! > 0 {
            if let lvl = us?.cursus_users[0].level {
                levelLabel.text = levelLabel.text! + "\(String(format: "%.2f", lvl))"
            }
        }
        emailLabel.text = "Email: " + (us?.email)!
        corpointsLabel.text = "Correction Points: " + "\(String(format: "%i", (us?.correction_point!)!))"
        walletLabel.text = "Wallet: " + "\(String(format: "%i", (us?.wallet!)!))"
    }
    
    func load_second_view() {
        var names: [String] = []
        var level: [Double] = []
        
        if (us?.cursus_users.count)! > 0 {
            for key in (us?.cursus_users[0].skills)! {
                names.append(key.name!)
            }
            
            for key in (us?.cursus_users[0].skills)! {
                level.append(key.level!)
            }
        }
        setChart(dataPoints: names, values: level)
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        chartbar.noDataText = "no data"

        var dataEntries = [BarChartDataEntry]()
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Skills")
        chartDataSet.valueFont = UIFont(name: "Verdana", size: 8.0)!
        let chartData = BarChartData()
        chartData.addDataSet(chartDataSet)
        chartbar.xAxis.labelFont = UIFont(name: "Verdana", size: 6.0)!
        chartbar.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        chartbar.xAxis.labelRotationAngle = -30
        chartbar.xAxis.wordWrapEnabled = true
        chartbar.xAxis.labelCount = dataPoints.count
        chartbar.sizeToFit()
        chartbar.legend.enabled = false
        chartbar.animate(yAxisDuration: 2.0)
        chartbar.xAxis.labelPosition = .bottom
        chartbar.data = chartData
    }
}
