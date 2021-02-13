//
//  SecondViewController.swift
//  realmINECRUD
//
//  Created by IDS Comercial on 11/02/21.
//  Copyright © 2021 Americo MQ. All rights reserved.
//

import UIKit

struct jsonStruct: Decodable {
    let name: String
}

class SecondViewController: UIViewController {
    
    var countriesArray = [jsonStruct]()
    var pickerCountryName = ""
    
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var ageTxtField: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var countryPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveBtn.layer.cornerRadius = 10
        saveBtn.clipsToBounds = true
        countryPicker.dataSource = self
        countryPicker.delegate = self
        getData()
    }
    @IBAction func saveBtnPressed(_ sender: UIButton) {
        //        var selectedValue = countryPicker![pickerView.selectedRowInComponent(0)]
        print("name: \(nameTxtField.text!), email: \(emailTxtField.text!), age:\(ageTxtField.text!), country: \(pickerCountryName)")
    }
    
    func getData() {
        let url = URL(string: "https://restcountries.eu/rest/v2/all")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            do {
                self.countriesArray = try JSONDecoder().decode([jsonStruct].self, from: data!)
                for names in self.countriesArray {
                    DispatchQueue.main.async {
                        self.countryPicker.reloadAllComponents()
                    }
                }
            } catch {
                print("error to get json data \(error)")
            }
            
        }.resume()
    }
    func getCountryName(with countryName: String) -> String {
        pickerCountryName = countryName
        return countryName
    }
}

extension SecondViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countriesArray.count
    }
}

extension SecondViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerCountryName = countriesArray[row].name
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countriesArray[row].name
    }
}
