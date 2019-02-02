//
//  SmallcaseDetailViewController.swift
//  smallcase
//
//  Created by Siddharth Paneri on 02/02/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import UIKit
import Charts
import WebKit

class SmallcaseDetailViewController: SuperViewController {

    //MARK:-
    var scid: String!
    // controllers
    let smallcaseController = SmallcaseController()
    let historicalController = HistoricalDataController()
    //MARK:- Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label_Name: UILabel!
    @IBOutlet weak var label_IndexValue: UILabel!
    @IBOutlet weak var label_Yearly: UILabel!
    @IBOutlet weak var label_1YearReturn: UILabel!
    @IBOutlet weak var label_Monthly: UILabel!
    @IBOutlet weak var label_1MonthReturn: UILabel!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var layoutConstraint_Height_ViewWeb: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!

    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "smallcase"
        // Do any additional setup after loading the view.
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.scrollView.isScrollEnabled = false
        self.imageView.layer.cornerRadius = 5
        self.imageView.layer.masksToBounds = true
        
        self.configureChart()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        updateSmallscale(nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchSmallcaseData()
    }
    
    //MARK:- Fetch data
    
    /** Used to fetch the smallcase data from API/DB */
    private func fetchSmallcaseData() {
        smallcaseController.getSmallcaseData(for: scid) { [weak self] (smallcase, error) in
            if let sc = smallcase {
                DispatchQueue.main.async {
                    self?.updateSmallscale(sc)
                }
            }
            self?.fetchHistoricalData()
        }
    }
    
    /** Used to fetch the historical data from API/DB */
    private func fetchHistoricalData() {
        historicalController.getHistoricalData(for: scid, and: ._4y) { [weak self] (smallcaseHistoryData, error) in
            DispatchQueue.main.async {
                self?.updateChart(smallcaseHistoryData)
            }
            
        }
    }
    
    //MARK:- Configure and update UI
    
    /** Initial configuration of chart view */
    private func configureChart() {
        chartView.delegate = self
        chartView.noDataText = "No data available"
        chartView.noDataTextColor = UIColor.lightGray
        chartView.dragEnabled = true
        chartView.setScaleEnabled(false)
        chartView.pinchZoomEnabled = false
        chartView.highlightPerDragEnabled = true
        chartView.legend.enabled = false
        chartView.leftAxis.enabled = true
        chartView.rightAxis.enabled = false
        chartView.chartDescription?.enabled = false
        
        
        let xAxis = chartView.xAxis
        xAxis.drawAxisLineEnabled = true
        xAxis.drawGridLinesEnabled = false
        xAxis.centerAxisLabelsEnabled = true
        //        xAxis.granularityEnabled = true
        xAxis.labelPosition = .bottom
        xAxis.valueFormatter = DateValueFormatter()
        xAxis.gridColor = UIColor.gray
        xAxis.labelTextColor = UIColor.black
        xAxis.drawLimitLinesBehindDataEnabled = true
        
        let leftAxis = chartView.leftAxis
        //        leftAxis.granularityEnabled = true
        leftAxis.gridLineDashLengths = [5, 5]
        leftAxis.drawLimitLinesBehindDataEnabled = true
        leftAxis.gridColor = UIColor.lightGray
        leftAxis.labelTextColor = UIColor.black
        //        leftAxis.valueFormatter = UnitValueFormatter()
        
        
        let marker = BalloonMarker(color: UIColor.darkGray,
                                   font: .systemFont(ofSize: 12, weight: .bold),
                                   textColor: UIColor.white,
                                   insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        marker.chartView = chartView
        marker.minimumSize = CGSize(width: 80, height: 40)
        chartView.marker = marker
        
    }
    
    /** Update UI based on smallcase data */
    private func updateSmallscale(_ smallcase: Smallcase?) {
        print(#function)
        guard let sc = smallcase else {
            // show loader
            scrollView.isHidden = true
            activityIndicator.isHidden = false
            return
        }
        activityIndicator.isHidden = true
        scrollView.isHidden = false
        
        let redColor = UIColor(red: 192/255, green: 10/255, blue: 13/255, alpha: 1)
        let greeColor = UIColor(red: 40/255, green: 174/255, blue: 86/255, alpha: 1)
        
        if let value = sc.name {
            label_Name.text = value
        } else {
            label_Name.text = ""
        }
        
        if let indexValue = sc.indexValue {
            label_IndexValue.text = UNIT + indexValue.format(f: ".2")
        } else {
            label_IndexValue.text = "--"
        }
        
        if let value = sc.yearlyReturn {
            label_1YearReturn.text =  value.format(f: ".2") + "%"
            label_1YearReturn.textColor = value > 0 ? greeColor:redColor
        } else {
            label_1YearReturn.text = "--"
        }
        
        if let value = sc.monthlyReturn {
            label_1MonthReturn.text =  value.format(f: ".2") + "%"
           label_1MonthReturn.textColor = value > 0 ? greeColor:redColor
        } else {
            label_1MonthReturn.text = "--"
        }
        
        if let value = sc.rationale {
            webView.loadHTMLString(prepareHTML(value), baseURL: nil)
        } else {
            webView.loadHTMLString("", baseURL: nil)
        }
        
        imageView.af_setImage(withURL: URL(string: BASE_URL_IMAGES+"/187/\(self.scid!).png")!, placeholderImage: UIImage(named: "smallcase_Placeholder"))
        
        // hide loader
    }
    
    /** prepare html string to display */
    private func prepareHTML(_ string: String) -> String {
        var bgColor = UIColor.clear
        if let scollViewBG = scrollView.backgroundColor {
            bgColor = scollViewBG
        }
        return "<html><head><style> body {font-family: -apple-system, Helvetica; sans-serif;}</style> <meta name =  \"viewport\" content =\"width=device-width, initial-scale=1\"></head><body bgcolor=\"\(bgColor.toHexString())\">\( string) </body></html>"
    }

    /** Call this method to update the historical data when required */
    private func updateChart(_ stocks: [SmallcaseHistory]) {
        print(#function)
        let chartData = stocks.map { (item) -> ChartDataEntry in
            return ChartDataEntry(x: item.date.timeIntervalSince1970, y: item.indexValue)
        }
        
        if chartData.isEmpty {
            chartView.data = nil
            chartView.animate(xAxisDuration: 1)
            return
        }
        
        let color = UIColor(hexString: HEX_SMALLCASE_BLUE)
        let dataSet = LineChartDataSet(values: chartData, label: nil)
        dataSet.axisDependency = .left
        dataSet.setColor(color)
        dataSet.setCircleColor(.white)
        dataSet.lineWidth = 2
        dataSet.circleRadius = 3
        dataSet.fillAlpha = 0.5
        dataSet.fillColor = color//.withAlphaComponent()
        dataSet.drawCircleHoleEnabled = false
        dataSet.drawCirclesEnabled = false
        dataSet.drawValuesEnabled = false
        dataSet.drawFilledEnabled = false
        
        let data = LineChartData(dataSets: [dataSet])
        data.setValueTextColor(.black)
        data.setValueFont(UIFont.systemFont(ofSize: 9))
        
        chartView.data = data
        chartView.animate(xAxisDuration: 1)
    }
    
    //MARK:- Actions
    @IBAction func didSelectSegment(_ sender: UISegmentedControl) {
        
        if segmentControl == sender {
            if let title = segmentControl.titleForSegment(at: segmentControl.selectedSegmentIndex) {
                if let duration = Duration(rawValue: title) {
                    historicalController.getHistoricalData(for: scid, and: duration) { [weak self] (smallcaseHistoryData, error) in
                        DispatchQueue.main.async {
                            self?.updateChart(smallcaseHistoryData)
                        }
                    }
                } else {
                    self.updateChart([])
                }
            }
        }
    }
    
}

//MARK:- WKUIDelegate & WKNavigationDelegate
extension SmallcaseDetailViewController: WKUIDelegate, WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.readyState", completionHandler: { [weak self] (complete, error) in
            if complete != nil {
                webView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
                    DispatchQueue.main.async {
                        self?.layoutConstraint_Height_ViewWeb.constant = height as! CGFloat
                        self?.view.setNeedsDisplay()
                    }
                })
            }
            
        })
    }
}

//MARK:- ChartViewDelegate
extension SmallcaseDetailViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        chartView.drawMarkers = true
        print("\(entry.x)")
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        chartView.drawMarkers = false
    }
}

//MARK:-
class DateValueFormatter: NSObject, IAxisValueFormatter {
    
    private var dateFormatter: DateFormatter?
    
    override init() {
        dateFormatter = DateFormatter()
        dateFormatter?.dateFormat = "MMM yy"
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if let epoch = TimeInterval(exactly: value) {
            let date = Date(timeIntervalSince1970: epoch)
            if let string = dateFormatter?.string(from: date) {
                return string
            }
        }
        return ""
    }
}


