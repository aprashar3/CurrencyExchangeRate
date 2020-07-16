//
//  HomeCurrencyViewController.swift
//  CurrencyExchangeRate
//
//  Created by 121outsource on 16/07/20.
//  Copyright © 2020 AshishKumar. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HomeCurrencyViewController: UIViewController {

    @IBOutlet weak var baseCurrencyTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func nextButton(_ sender: UIButton) {
        if baseCurrencyTextField.text!.count > 0 {
            checkCurrencyCode(code: baseCurrencyTextField.text!)
        }else {
            // Show Alert to user
            showErrorAlert(message: "Please enter a currency code")
        }
    }
    
// Check if entered code is valid
    
    func checkCurrencyCode(code : String) {
        AF.request("https://api.exchangeratesapi.io/latest?base=\(code)",method: .get).response { response in
            do{
                if let json = try JSON(data: response.data!).dictionary?["error"]{
                    // Show Alert
                    DispatchQueue.main.async {
                        
                        self.showErrorAlert(message: "Given currency code is not valid")
                    }
                }else{
                    // Save base currency
                    UserDefaults.standard.set(code, forKey: "baseCurrency")
                    
                // Go to next view controller
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "ConvertCurrencySegue", sender: nil)
                    }
                }
             
            }catch{
                //show alert
                print("error converting to json \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.showErrorAlert(message: "Given currency code is not valid")
                }
            }
            
        }
    }
    
// Show alert to user
    
    func showErrorAlert(message : String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Click", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
