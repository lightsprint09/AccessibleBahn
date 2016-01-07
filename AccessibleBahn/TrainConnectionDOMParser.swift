//
//  TrainConnectionDOMParser.swift
//  AccessibleBahn
//
//  Created by Lukas Schmidt on 07.01.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import Foundation
import WebKit

class TrainConnectionDOMParser {
    let jslogicString = "function addStationsNames(className, stationsList, stationsSet) {   var stationNodes = document.getElementsByClassName(className);  for(var i= 0; i < stationNodes.length; i++){        var name = stationNodes[i].getElementsByClassName('bold')[0].innerHTML;         if(stationsSet[name]) {             continue        }       var station = {name: name};         stationsList.push(station);         stationsSet[name] = true;   } } var stationsList = []; var stationsSet = {}; addStationsNames('routeStart', stationsList, stationsSet); addStationsNames('routeChange', stationsList, stationsSet); addStationsNames('routeEnd', stationsList, stationsSet); JSON.stringify(stationsList);"
    
    func fetchStations(webView: WKWebView, onSucces:([Station])->(), onError:(NSError)->()) {
        webView.evaluateJavaScript(jslogicString) {data, error in
            if let error = error {
                onError(error)
                return
            }
            guard let result = data as? String, let data = result.dataUsingEncoding(NSUTF8StringEncoding) else {
                onError(NSError(domain: "", code: 0, userInfo: nil))
                return }
            do {
                let jsonList = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as! [[String: AnyObject]]
                let stations: [Station] = jsonList.map {stationobj in
                    let name = stationobj["name"] as! String
                    return Station(name: name, elevators: nil)
                }
                onSucces(stations)
            } catch {
                onError(NSError(domain: "", code: 0, userInfo: nil))
                return
            }
        }
        
        
    }
}
