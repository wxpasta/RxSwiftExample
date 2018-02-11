//
//  BJOtherViewController.swift
//  RxSwiftExample
//
//  Created by 巴糖 on 2018/1/3.
//  Copyright © 2018年 巴糖. All rights reserved.
//

import UIKit

class BJOtherViewController: UIViewController {

    var array = [1, 2, 3]
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        for number in array {
//            print(number)
//            array = [4, 5, 6]
//        }
//        print(array)
        
    }

    //this method is connected in IB to a button
    @IBAction func printNext(_ sender: Any) {
        print(array[currentIndex])
        if currentIndex != array.count-1 {
            currentIndex += 1
        }
    }

}
