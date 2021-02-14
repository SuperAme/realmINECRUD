//
//  SecondViewController.swift
//  realmINECRUD
//
//  Created by IDS Comercial on 11/02/21.
//  Copyright © 2021 Americo MQ. All rights reserved.
//

import UIKit
import RealmSwift

struct jsonStruct: Decodable {
    let name: String
}

class SecondViewController: UIViewController {
    
    let realm = try! Realm()
    var personData: Results<PersonalInfo>?
    
    var countriesArray = [jsonStruct]()
    var pickerCountryName = ""
    
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var ageTxtField: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var countryPicker: UIPickerView!
    
    override func viewDidLoad() {
        print(Realm.Configuration.defaultConfiguration.fileURL)
        super.viewDidLoad()
        saveBtn.layer.cornerRadius = 10
        saveBtn.clipsToBounds = true
        countryPicker.dataSource = self
        countryPicker.delegate = self
        getData()
    }
    @IBAction func saveBtnPressed(_ sender: UIButton) {
        let newPerson = PersonalInfo()
        //        var selectedValue = countryPicker![pickerView.selectedRowInComponent(0)]
        newPerson.fullName = nameTxtField.text!
        newPerson.email = emailTxtField.text!
        newPerson.age = ageTxtField.text!
        newPerson.country = pickerCountryName
        saveData(person: newPerson)
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
    func saveData(person: PersonalInfo) {
        do {
            try realm.write {
                realm.add(person)
            }
        } catch {
            print("error saving data \(error)")
        }
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
