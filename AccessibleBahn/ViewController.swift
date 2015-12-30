//
//  ViewController.swift
//  AccessibleBahn
//
//  Created by Lukas Schmidt on 29.12.15.
//  Copyright © 2015 Lukas Schmidt. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    let elevatorFetcher = ElevatorFetcher()

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = NSURL(string: "http://mobile.bahn.de/bin/mobil/query.exe/dox?country=DEU&rt=1&use_realtime_filter=1&webview=&searchMode=NORMAL")!
        let request = NSURLRequest(URL: url)
       webView.loadRequest(request)
 
    }

    @IBAction func checkElevators(sender: AnyObject) {
        let test = "function addStationsNames(className, stationSet) {  var stationNodes = document.getElementsByClassName(className);  for(var i= 0; i < stationNodes.length; i++){        var name = stationNodes[i].getElementsByClassName('bold')[0].innerHTML;         stationSet[name] = true;    } } var stationsSet = {}; addStationsNames('routeChange', stationsSet); addStationsNames('routeEnd', stationsSet); addStationsNames('routeStart', stationsSet); console.log(stationsSet); JSON.stringify(stationsSet);"
        guard let result = webView.stringByEvaluatingJavaScriptFromString(test), let data = result.dataUsingEncoding(NSUTF8StringEncoding) else { return }
        
        let jsonObject = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as! [String: AnyObject]
        let stations: [Station] = jsonObject.keys.map {name in
            return Station(name: name, elevators: nil)
        }
        elevatorFetcher.fetchElevatorsForTrip(stations, onSucces: {elevators, status in
            print(elevators, status)
            }, onError: {_ in
        })
        
    }
}

