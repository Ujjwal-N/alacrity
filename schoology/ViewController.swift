//
//  ViewController.swift
//  schoology
//
//  Created by Manoj M on 15/09/18.
//  Copyright © 2018 Manoj M. All rights reserved.
//

import UIKit

import OAuthSwift

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
class ViewController: UIViewController {
    var oauthswift:OAuth1Swift?
    @IBOutlet weak var lblOutput: UILabel!

    @IBOutlet var makeItClear: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(_ animated: Bool) {
        makeItClear.layer.borderColor = UIColor.clear.cgColor
        if let exists = UserDefaults.standard.string(forKey: "tokenSecret"){
            let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "authenticated")
            UIApplication.topViewController()?.present(newViewController, animated: true, completion: nil)

            self.performSegue(withIdentifier: "authenticated", sender: self);
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startOAuthTest(_ sender: Any) {
        print("startOAuthTest - START")
        self.lblOutput.text = ""

        let ClientID = "7c270332678c7a6b89071cd10710e9a005b90a3e0"
        let ClientSecret = "cdb78f5da6683593c4a8ae0729484d46"

        let requestTokenUrl = "https://api.schoology.com/v1/oauth/request_token"
        let authorizeUrl =    "https://pausd.schoology.com/oauth/authorize"
        let accessTokenUrl =  "https://api.schoology.com/v1/oauth/access_token"


        oauthswift = OAuth1Swift(
            consumerKey:    ClientID,
            consumerSecret: ClientSecret,
            requestTokenUrl: requestTokenUrl,
            authorizeUrl:    authorizeUrl,
            accessTokenUrl:  accessTokenUrl
        )

        oauthswift?.authorizeURLHandler = SafariURLHandler(viewController: self, oauthSwift: oauthswift!)
        oauthswift?.addCallbackURLToAuthorizeURL = true
        oauthswift?.allowMissingOAuthVerifier = true

        oauthswift?.authorize(
//            withCallbackURL: URL(string: "manoj://oauth-callback")!,
            withCallbackURL: URL(string: "https://staging.mynewtonhq.com/k/v6/testamit/redirect")!,
            success: { credential, response, parameters in
                let ret = "authToken: \(credential.oauthToken)\noauthTokenSecret: \(credential.oauthTokenSecret)"
                UserDefaults.standard.set(credential.oauthToken, forKey: "token")
                UserDefaults.standard.set(credential.oauthTokenSecret, forKey: "tokenSecret")
                self.lblOutput.text =  ret
                self.done()
            },
            failure: { error in
                print(error.localizedDescription)
                self.lblOutput.text = error.localizedDescription
        }
        )
        print("startOAuthTest - END")
    }
    func done() {
        DispatchQueue.global(qos: .background).async {
            sleep(10)
            //print("Active after 4 sec, and doesn't block main")
            DispatchQueue.main.async{
                print("time has passed")
                self.performSegue(withIdentifier: "authenticated", sender: self);
            }
        }

    }

}

