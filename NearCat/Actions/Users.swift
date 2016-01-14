//
//  User.swift
//  NearCat
//
//  Created by huchunbo on 16/1/15.
//  Copyright © 2016年 Bijiabo. All rights reserved.
//

import Foundation
import SwiftyJSON

extension Action {
    public class users {
        public class func informationFor(userId userId: Int, completeHandler: (success: Bool, data: JSON, description: String)->Void) {
            let path = "users/\(userId).json?token=\(FHelper.token)"
            print(path)
            FNetManager.sharedInstance.GET(path: path) { (request, response, json, error) -> Void in
                Action.requestCompleteHandler(json: json["user"], error: error, completeHandler: { (success, data, description) -> Void in
                    completeHandler(success: success, data: data, description: description)
                })
            }
        }
    }
}