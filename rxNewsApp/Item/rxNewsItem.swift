//
//  rxNewsItem.swift
//  rxNewsApp
//
//  Created by Geetion on 15/12/24.
//  Copyright © 2015年 Findys. All rights reserved.
//

import Foundation

class rxNewsItem:NSObject {
    
    var click = NSNumber()
    var title = String()
    var info = String()
    var id = NSNumber()
    var thumb = String()
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder){
        self.click = aDecoder.decodeObjectForKey("click") as! NSNumber
        self.title = aDecoder.decodeObjectForKey("title") as! String
        self.info = aDecoder.decodeObjectForKey("info") as! String
        self.id = aDecoder.decodeObjectForKey("id") as! NSNumber
        self.thumb = aDecoder.decodeObjectForKey("thumb") as! String
    }
    
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encodeObject(click, forKey: "click")
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(info, forKey: "info")
        aCoder.encodeObject(id, forKey: "id")
        aCoder.encodeObject(thumb, forKey: "thumb")
    }
}

