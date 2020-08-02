//
//  HomeViewController.swift
//  schoology
//
//  Created by Ujjwal Nadhani on 9/30/18.
//  Copyright © 2018 Manoj M. All rights reserved.
//

import UIKit

class HomeViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        print("didAppear")
        if (UserDefaults.standard.string(forKey: "userId") == nil){
            print("go to setup")
            let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "setup")
            self.present(newViewController, animated: true, completion: nil)
            self.performSegue(withIdentifier: "setupSegue", sender: self)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

