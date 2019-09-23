//
//  ViewController.swift
//  Swifty-Companion
//
//  Created by Hnat DANYLEVYCH on 10/21/18.
//  Copyright © 2018 Hnat DANYLEVYCH. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loginText: UITextField!
    var user: User? = nil
    var accesToken: String?
    
    let uid = "593cb563d869847bd70e3e1e6aa40fcc4f4690ce7016d4a8c5c037686afd887e"
    let secret = "30135bb0b9aedd89d93b2f0608ce2fee3d04bfce8c65f4b5948b0862300929bf"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makePostrequest()
    }

    @IBAction func searchButton(_ sender: UIButton) {
        if (loginText.text?.contains(" "))! {
            self.displayAllert(message: "Invalid login")
        } else {
            getData()
        }
    }
    
    func makePostrequest() {
        Timer.scheduledTimer(timeInterval: 7100.0, target: self,
                             selector: #selector(settimer), userInfo: nil, repeats: false)
        let url = URL(string: "https://api.intra.42.fr/oauth/token")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "grant_type=client_credentials&client_id=" + self.uid + "&client_secret=" + self.secret
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but it is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary {
                let resul = json.value(forKey: "access_token");
                self.accesToken = String(describing: resul!)
            } else {
                self.displayAllert(message: "Sorry, can't receive a token :(")
            }
        }
        task.resume()
    }
    
    @objc func settimer() {
        makePostrequest()
    }
    
    func getData() {
        let url = "https://api.intra.42.fr/v2/users/" + loginText.text!
        if let nsurl = NSURL(string: url) {
            let request = NSMutableURLRequest(url: nsurl as URL)
            request.httpMethod = "GET"
            if accesToken != nil {
                request.addValue("Bearer " + accesToken!, forHTTPHeaderField: "Authorization")
                let task = URLSession.shared.dataTask(with: request as URLRequest) {
                    data, response, error in

                    do {
                        let jsonDecoder = JSONDecoder()
                        self.user = try jsonDecoder.decode(User.self, from: data!)
                        DispatchQueue.main.async {
                        let Scroll = self.storyboard?.instantiateViewController(withIdentifier: "scroll") as! ScrollView
                        Scroll.us = self.user
                            self.present(Scroll, animated: true, completion: nil)
                        }
                    } catch let error {
                        print("ERROR", error)
                        DispatchQueue.main.async {
                            self.displayAllert(message: "User not found")
                        }
                    }
                }
                task.resume()
            } else {
                displayAllert(message: "Sorry, something went wrong :(")
            }
        } else {
            self.displayAllert(message: "Sorry, something went wrong :(")
        }
    }
}

extension UIViewController {
    func displayAllert(message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            }}))
        self.present(alert, animated: true, completion: nil)
    }
}
