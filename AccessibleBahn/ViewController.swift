//
//  ViewController.swift
//  AccessibleBahn
//
//  Created by Lukas Schmidt on 29.12.15.
//  Copyright © 2015 Lukas Schmidt. All rights reserved.
//

import UIKit
import SafariServices
import WebKit

class ViewController: UIViewController, WKNavigationDelegate{
    @IBOutlet weak var webViewContainer: UIView!
    var webView: WKWebView!
    
    let elevatorFetcher = ElevatorFetcher()
    @IBOutlet weak var statusBar: UIView!
    @IBOutlet weak var statusBarHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var checkRouteButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var statusTextLabel: UILabel!
    @IBOutlet weak var elevatoCountLabel: UILabel!
    
    var stops: [Station]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       createWKWebView()
        let url = NSURL(string: "http://mobile.bahn.de/bin/mobil/query.exe/dox?country=DEU&rt=1&use_realtime_filter=1&webview=&searchMode=NORMAL")!
        let request = NSURLRequest(URL: url)
        webView.loadRequest(request)
    }
    
    func createWKWebView() {
        webView = WKWebView(frame: webViewContainer.frame)
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webViewContainer.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        let contraint = NSLayoutConstraint.constraintsWithVisualFormat("H:|[subview]|", options:.DirectionLeadingToTrailing, metrics: nil, views: ["subview": webView])
        webViewContainer.addConstraints(contraint)
        let contraint2 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[subview]|", options:.DirectionLeadingToTrailing, metrics: nil, views: ["subview": webView])
        webViewContainer.addConstraints(contraint2)
        
    }
    @IBAction func back(sender: AnyObject) {
        webView.goBack()
        self.statusBarHeightContraint.constant = 0
        UIView.animateWithDuration(0.3) {
            self.view.layoutIfNeeded()
        }
    }

    @IBAction func checkElevators(sender: AnyObject) {
        let jsString = "function addStationsNames(className, stationSet) {  var stationNodes = document.getElementsByClassName(className);  for(var i= 0; i < stationNodes.length; i++){        var name = stationNodes[i].getElementsByClassName('bold')[0].innerHTML;         stationSet[name] = true;    } } var stationsSet = {}; addStationsNames('routeChange', stationsSet); addStationsNames('routeEnd', stationsSet); addStationsNames('routeStart', stationsSet); JSON.stringify(stationsSet);"
        webView.evaluateJavaScript(jsString, completionHandler: didGetStationsData)
    }
    
    func didGetStationsData(data: AnyObject?, error: NSError?) {
        guard let result = data as? String, let data = result.dataUsingEncoding(NSUTF8StringEncoding) else { return }
        let jsonObject = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as! [String: AnyObject]
        let stations: [Station] = jsonObject.keys.map {name in
            return Station(name: name, elevators: nil)
        }
        self.elevatorFetcher.fetchElevatorsForTrip(stations, onSucces: didFetchStationWithElevators) { _ in}
    }
    
    func didFetchStationWithElevators(statins: [Station], status: ElevatorStatus) {
        stops = statins
        statusBarHeightContraint.constant = 58
        statusTextLabel.text = status.text
        statusBar.backgroundColor = status.color
        let elevatorsCount = stops.reduce(0) { return $0 + ($1.elevators?.count ?? 0)}
        elevatoCountLabel.text = "\(elevatorsCount) Fahrstühle geprüft"
        UIView.animateWithDuration(0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        if let urlString = webView.URL?.absoluteString where  urlString.containsString("details=opened") {
           checkRouteButtonHeightConstraint.constant = 52
        }else {
            checkRouteButtonHeightConstraint.constant = 0
            self.statusBarHeightContraint.constant = 0
        }
        UIView.animateWithDuration(0.18) {
            self.view.layoutIfNeeded()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let stationsTableViewController = segue.destinationViewController as? StationTableViewController{
            stationsTableViewController.stations = stops
        }
    }
}

