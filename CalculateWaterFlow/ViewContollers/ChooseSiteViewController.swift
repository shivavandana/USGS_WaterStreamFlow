//
//  ChooseSiteViewController.swift
//  CalculateWaterFlow
//
//  Created by Shiva Nayakanti on 14/06/19.
//  Copyright © 2019 Shiva Nayakanti. All rights reserved.
//

import UIKit

class ChooseSiteViewController: UIViewController {
    var minValue: Double = Double.greatestFiniteMagnitude
    var maxValue: Double = Double.leastNonzeroMagnitude;
    var avgValue: Double = 0.0
    var sum: Double = 0.0
    var siteName = ""
    var siteNumber = ""
    var streamValueArray:[Double] = []
    var streamFlowObject: StreamFlowData = StreamFlowData();
    
    
    @IBOutlet weak var descriptionMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //description for the label
        descriptionMessage.text = Constants.description.rawValue
        
        //check if internet is active on the device
        if ConnectionCheck.isConnectedToNetwork() {
            print("Internet Connected")
        }
        else{
            let alert = UIAlertController(title: "No Intenet", message: "Please turn on your wifi/cellular data", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func getDataFromSite(siteName: String, siteNumber: String, doneGettingInfo: @escaping (Bool, String)->()){
        let siteUrl = "https://waterservices.usgs.gov/nwis/iv/?sites=\(siteNumber)&period=P7D&format=json"
        print(siteUrl)
        
        let url = NSURL(string: siteUrl)
        
        //fetching the data from the url
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
            
            
            if let siteInfoJsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                   let rootJson = siteInfoJsonObj.value(forKey: "value")
                   if let timeSeriesDict = rootJson as? NSDictionary {
                        if let timeSeriesValue = timeSeriesDict.value(forKey: "timeSeries") as? NSArray {
                            let timeSeriesObject = timeSeriesValue[0] as? NSDictionary
                            let valuesJsonArray = timeSeriesObject?.value(forKey: "values") as? NSArray
                            let eachValue = valuesJsonArray?[0] as? NSDictionary
                            let valueObjects = eachValue?.value(forKey: "value") as? NSArray
                            
                            if let checkValueObjs = valueObjects{
                            let numberOfValueObjs = Double(checkValueObjs.count)
                            for valueObject in checkValueObjs{
                                let tempValueObject = valueObject as? NSDictionary
                                let eachValueObject = tempValueObject?.value(forKey: "value")
                                
                                if let doubleValue = (eachValueObject as? NSString)?.doubleValue {
                                    self.minValue = self.minValue > doubleValue ? doubleValue : self.minValue
                                    self.maxValue = self.maxValue < doubleValue ? doubleValue : self.maxValue
                                    
                                    self.streamValueArray.append(doubleValue)
                                    self.sum += doubleValue;
                                }
                            }
                            self.avgValue = self.sum/numberOfValueObjs
                            }
                        }
                    self.streamFlowObject.siteName = siteName
                    self.streamFlowObject.siteCode = siteNumber
                    self.streamFlowObject.minValue = self.minValue
                    self.streamFlowObject.maxValue = self.maxValue
                    self.streamFlowObject.averageValue = self.avgValue
                    self.streamFlowObject.streamValues = self.streamValueArray
                    }
                    //send success to closure
                    doneGettingInfo(true,"success")
            }else{
                 //send error to closure
                if(error != nil){
                    doneGettingInfo(false, error as! String)
                }
            }
        }).resume()
    }

    @IBAction func firstSiteClick(_ sender: Any) {
        siteName = Constants.ChamaName.rawValue
        siteNumber = Constants.ChamaNumber.rawValue
         //closure gets the data after successful dowloading of data
        getDataFromSite(siteName:siteName, siteNumber:siteNumber){(success, data) in
            if(success){
                self.performSegueToDetails()
            }else{
                self.errorMessage(error: data)
            }
        }
        
    }

    @IBAction func secondSiteClick(_ sender: Any) {
        siteName = Constants.PuebloName.rawValue
        siteNumber = Constants.PuebloNumber.rawValue
        //closure gets the data after successful dowloading of data
        getDataFromSite(siteName:siteName, siteNumber:siteNumber){(success, data) in
            if(success){
                   self.performSegueToDetails()
            }else{
                self.errorMessage(error: data)
            }
        }
    }
    
    func errorMessage(error: String){
        DispatchQueue.main.async {
        let alert = UIAlertController(title: "Data Download Failed", message: error, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        }
    }
    
    func performSegueToDetails(){
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "showWaterFlowDetails", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWaterFlowDetails" {
            if let toViewController = segue.destination as? WaterDetailsViewController {
                toViewController.streamFlowObject = streamFlowObject
                toViewController.minValue = minValue
                toViewController.maxValue = maxValue
                toViewController.avgValue = avgValue
                toViewController.siteName = siteName
                toViewController.siteNumber = siteNumber
            }
        }
    
    }
}
