
//
//  PushNotificationSender.swift
//  StudyHub
//
//  Created by Andreas Ink on 8/23/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import UIKit

class PushNotificationSender {
    func sendPushNotification(to token: String, title: String, body: String, user: String) {
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let paramString: [String : Any] = ["to" : token,
                                           "notification" : ["title" : title, "body" : body],
                                           "data" : ["user" : user]
        ]

        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AAAArGyKLow:APA91bEML0-9unoUNCWLiyx6IOBgPzRDc5J-KZ_bdhH3CfQyGuLoT3SI5KqNwI2WxebW1MFbCjGxyjs3tsqiBzB9WG908gtvpfUBS_eKyZX65I42GCDCUPfz_V36w5dzLG1gYHkalF3X", forHTTPHeaderField: "Authorization")

        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
}
