//
//  StreamFlowData.swift
//  CalculateWaterFlow
//
//  Created by Shiva Nayakanti on 14/06/19.
//  Copyright © 2019 Shiva Nayakanti. All rights reserved.
//

import Foundation

class StreamFlowData{
    var siteName: String?
    var siteCode: String?
    var minValue: Double?
    var maxValue: Double?
    var averageValue: Double?
    var streamValues: [Double]?
    
    init(){
        siteName = ""
        siteCode = ""
        minValue = 0.0
        maxValue = 0.0
        averageValue = 0.0
    }
}
