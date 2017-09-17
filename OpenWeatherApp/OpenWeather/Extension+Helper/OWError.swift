//
//  OWError.swift
//  OpenWeather
//
//  Created by Jebamani, Sivaram [GCB-OT NE] on 9/17/17.
//  Copyright © 2017 Jebamani, Sivaram. All rights reserved.
//

import Foundation
enum VWError: Error {
    case InvalidUrl
    case NetworkFailed(code: Int, description: String)
    case InvalidJson(code: Int, description: String)
}
