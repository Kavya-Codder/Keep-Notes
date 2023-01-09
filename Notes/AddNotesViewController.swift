//
//  ViewController.swift
//  Notes
//
//  Created by Sunil Developer on 08/01/23.
//

import UIKit

enum NotesValidation: String {
    case title = "Please enter title"
    case body = "Please enter body"
    case date = "Please select date"
    case status = "Please select status"
    case description = "Please enter description"
    
}

class AddNotesViewController: UIViewController {
    
    @IBOutlet weak var lblTopTitle: UILabel!
    @IBOutlet weak var viewTitle: UIView!
    @IBOutlet weak var viewPriority: UIView!
    @IBOutlet weak var viewDate: UIView!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var viewDescription: UIView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPriority: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtPriority: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtStatus: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
    
    
    @IBOutlet weak var btnAdd: UIButton!
    
    var dbHelperObj: DBHelper = DBHelper()
    var datePicker = UIDatePicker()
    var statusPicker: UIPickerView!
    var priorityPicker: UIPickerView!
    var obj: NotesModel?
    
    var statusArray = ["Pending", "In Progress", "Completed"]
    var priorityArray = ["Low", "Normal", "High", "Urgent"]
    var currentTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
        
        // set update text
        txtTitle.text = obj?.title
        txtDate.text = obj?.date
        txtPriority.text = obj?.priority
        txtStatus.text = obj?.status
        txtDescription.text = obj?.description
        
        //DatePickerView
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        }
        datePicker.backgroundColor = .lightGray
        datePicker.datePickerMode =  .date
        datePicker.maximumDate = Date()
        
        //ToolBar
        let toolbar = UIToolbar()
        toolbar.barTintColor = UIColor.darkGray
        toolbar.isTranslucent = true
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneDatePicker))
        doneButton.tintColor = .white
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        cancelButton.tintColor = .white
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        txtDate.inputAccessoryView = toolbar
        txtDate.inputView = datePicker
        
        // status pickerview
        statusPicker = UIPickerView()
        statusPicker.delegate = self
        statusPicker.dataSource = self
        
        txtStatus.inputView = statusPicker
        txtStatus.text = statusArray.first
        txtStatus.delegate = self
        
        // Priority pickerview
        priorityPicker = UIPickerView()
        priorityPicker.delegate = self
        priorityPicker.dataSource = self
        
        txtPriority.inputView = priorityPicker
        txtPriority.text = priorityArray.first
        txtPriority.delegate = self
    }
    
    @objc func doneDatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM YYYY 'at' HH:mm"
        txtDate.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker() {
        self.view.endEditing(true)
    }
    
    @IBAction func onClickCancleBtn(_ sender: Any) {
        
        let listVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyNotesListVC") as! MyNotesListVC
        self.navigationController?.pushViewController(listVC, animated: true)
    }
    
    @IBAction func onClickAddBtn(_ sender: Any) {
        
        let validation = doValidation()
        if validation.0 {
            if self .obj != nil {
                dbHelperObj.updateItem(id: Int32(obj?.id ?? 0), status: txtStatus.text ?? "")
                
                showAlert(title: "Update", message: "update successfully") { (alert) in
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
            dbHelperObj.insertData(notesList: NotesModel(id: Int.random(in: 0..<6), title: txtTitle.text ?? "", priority: txtPriority.text ?? "", date: txtDate.text ?? "", status: txtStatus.text ?? "", description: txtDescription.text ?? ""))
            print(self.dbHelperObj.featchItemList())
            let data = dbHelperObj.featchItemList()
            for i in data {
                print(i.title)
                
                showAlert(title: "Success", message: "add notes successfully") { (str) in
                    let listVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyNotesListVC") as! MyNotesListVC
                    self.navigationController?.pushViewController(listVC, animated: true)
                }
            }
        }
        }
        else {
            showAlert(title: "error", message: validation.1, hendler: nil)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        changeText()
    }
}

// Extension
extension AddNotesViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
        if textField == txtStatus {
            txtStatus.inputView = statusPicker
        } else {
            txtPriority.inputView = priorityPicker
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if currentTextField == txtStatus {
            return statusArray.count
        } else if currentTextField == txtPriority {
            return priorityArray.count
        }
        else {
            return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if currentTextField == txtStatus {
            return statusArray[row]
        } else if currentTextField == txtPriority {
            return priorityArray[row]
        }
        else {
            return "0"
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if currentTextField == txtStatus {
            txtStatus.text = statusArray[row]
            self.view.endEditing(true)
        } else if currentTextField == txtPriority {
            txtPriority.text = priorityArray[row]
            self.view.endEditing(true)
        }
        
    }
    
    func initialSetUp() {
        viewTitle.clipsToBounds = true
        viewTitle.layer.cornerRadius = 20
        
        viewPriority.clipsToBounds = true
        viewPriority.layer.cornerRadius = 20
        
        viewDate.clipsToBounds = true
        viewDate.layer.cornerRadius = 20
        
        viewStatus.clipsToBounds = true
        viewStatus.layer.cornerRadius = 20
        
        viewDescription.clipsToBounds = true
        viewDescription.layer.cornerRadius = 20
        
        btnAdd.clipsToBounds = true
        btnAdd.layer.cornerRadius = 25
        btnAdd.layer.borderWidth = 1.5
        btnAdd.layer.borderColor = UIColor.white.cgColor
    }
    
    func doValidation() -> (Bool, String) {
        if (txtTitle.text?.isEmpty ?? false) {
            return (false, NotesValidation.title.rawValue)
        } else if (txtPriority.text?.isEmpty ?? false) {
            return (false, NotesValidation.body.rawValue)
        } else if (txtDate.text?.isEmpty ?? false) {
            return (false, NotesValidation.date.rawValue)
        } else if (txtStatus.text?.isEmpty ?? false) {
            return (false, NotesValidation.status.rawValue)
        } else if (txtDescription.text?.isEmpty ?? false) {
            return (false, NotesValidation.description.rawValue)
        }
        return (true, "")
    }
    func changeText() {
        if self.obj != nil {
            btnAdd.setTitle("Update", for: .normal)
            lblTopTitle.text = "Update note"
        }
    }
}
