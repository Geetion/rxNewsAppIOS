//
//  AboutViewController.swift
//  rxNewsApp
//
//  Created by Geetion on 15/11/22.
//  Copyright © 2015年 Geetion. All rights reserved.
//

import UIKit

class AboutViewController: UITableViewController {
       
    override func viewWillAppear(animated: Bool) {
        UIView.animateWithDuration(0.5) { () -> Void in
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 89/255.0, green: 166/255.0, blue: 223/255.0, alpha: 1)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        UIView.animateWithDuration(0.5) { () -> Void in
            self.navigationController?.navigationBar.barTintColor=UIColor(red: 0/255.0, green: 150/255.0, blue: 136/255.0, alpha: 1.0)
        }
    }    
    
}