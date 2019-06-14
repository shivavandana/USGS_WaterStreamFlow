//
//  WaterDetailsViewController.swift
//  CalculateWaterFlow
//
//  Created by Shiva Nayakanti on 14/06/19.
//  Copyright © 2019 Shiva Nayakanti. All rights reserved.
//

import UIKit

class WaterDetailsViewController: UIViewController {
    var streamFlowObject = StreamFlowData()
    lazy var minValue:Double = 0
    lazy var maxValue:Double = 0
    lazy var avgValue:Double = 0
    lazy var siteName:String = ""
    lazy var siteNumber:String = ""
    
    @IBOutlet weak var siteNameTV: UITextField!
    @IBOutlet weak var minValueTV: UITextField!
    @IBOutlet weak var maxValueTV: UITextField!
    @IBOutlet weak var avgValueTV: UITextField!
    
    
    @IBAction func viewGraph(_ sender: Any) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "showLineGraph", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //update layout on the main thread
        DispatchQueue.main.async {
                if(self.siteNumber == Constants.ChamaNumber.rawValue){
                    self.view.backgroundColor = UIColor.cyan
                }else{
                    self.view.backgroundColor = UIColor.yellow
                }
            
            self.siteNameTV.text = self.siteName
            self.minValueTV.text = String(Double(round(100*self.minValue)/1000))+" ft3/s"
            self.maxValueTV.text = String(Double(round(100*self.maxValue)/100))+" ft3/s"
            self.avgValueTV.text = String(Double(round(100*self.avgValue)/100))+" ft3/s"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLineGraph" {
            if let toViewController = segue.destination as? ChartViewController {
                toViewController.streamFlowObject = streamFlowObject
            }
        }
        
    }
}
