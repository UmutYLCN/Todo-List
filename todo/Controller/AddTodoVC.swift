//
//  AddTodoViewController.swift
//  todo
//
//  Created by umut yalçın on 7.03.2023.
//

import UIKit
import SnapKit
import CoreData

class AddTodoVC: UIViewController {

    let todoTitleTextField = UITextField()
    let todoDescTextField = UITextField()
    let todoDatePickerTextField = UITextField()
    let datepicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
            SetupUI()
    }
    
    func SetupUI(){
        view.backgroundColor = .systemGray6
        self.title = "Add Todo"
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(addData)), animated: true)
       

        navigationController?.navigationBar.tintColor = .black
        self.navigationItem.backBarButtonItem?.tintColor = .black
        self.navigationItem.rightBarButtonItem?.tintColor = .black
        
        createTodoTitle()
        createTodoDesc()
        createdatePickerTextField()
        createDatePicker()
        
    }
    
    @objc func addData(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let saveData = NSEntityDescription.insertNewObject(forEntityName: "TodoItem", into: context)

        
        if todoTitleTextField.text != "" && todoDatePickerTextField.text != "" && todoDescTextField.text != ""{
            
            saveData.setValue(UUID(), forKey: "id")
            saveData.setValue(todoTitleTextField.text!, forKey: "name")
            saveData.setValue(todoDescTextField.text!, forKey: "desc")
            saveData.setValue(false, forKey: "isCompleted")
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            saveData.setValue(formatter.string(from: datepicker.date), forKey: "date")
            
            do {
                try context.save()
                print("Succes")
                todoTitleTextField.text = ""
                todoDescTextField.text = ""
                todoDatePickerTextField.text = ""
                
            }catch{
               print("saved fail")
            }
            
            NotificationCenter.default.post(name: NSNotification.Name.init("newData"), object: nil)
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    
    //MARK: Todo Name TextField
    func createTodoTitle(){
        let titleLbl = UILabel()
        view.addSubview(titleLbl)
        titleLbl.text = "Title"
        titleLbl.textColor = .black
        titleLbl.snp.makeConstraints { make in
            make.top.equalTo(150)
            make.left.equalTo(10)
        }
        view.addSubview(todoTitleTextField)
        todoTitleTextField.backgroundColor = .white
        todoTitleTextField.layer.cornerRadius = 4.0
        todoTitleTextField.layer.borderWidth = 2.0
        todoTitleTextField.layer.borderColor = UIColor.white.cgColor
        todoTitleTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLbl.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.width.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        todoTitleTextField.placeholder = "Enter todo title"
        todoTitleTextField.toStyledTxtField()
    }
    
    //MARK: Description TextField
    func createTodoDesc(){
        let descLbl = UILabel()
        view.addSubview(descLbl)
        descLbl.text = "Description"
        descLbl.textColor = .black
        descLbl.snp.makeConstraints { make in
            make.top.equalTo(todoTitleTextField.snp.bottom).offset(20)
            make.left.equalTo(10)
        }

        view.addSubview(todoDescTextField)
        todoDescTextField.backgroundColor = .white
        todoDescTextField.layer.cornerRadius = 4.0
        todoDescTextField.layer.borderWidth = 2.0
        todoDescTextField.layer.borderColor = UIColor.white.cgColor
        todoDescTextField.snp.makeConstraints { make in
            make.top.equalTo(descLbl.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.width.equalToSuperview().offset(-20)
            make.height.equalTo(100)
        }
        todoDescTextField.toStyledTxtField()
        todoDescTextField.placeholder = "Enter todo description"
    
    }

    
    //MARK: Date Picker
    func createdatePickerTextField(){
        let pickerLbl = UILabel()
        view.addSubview(pickerLbl)
        pickerLbl.text = "Date"
        pickerLbl.textColor = .black
        pickerLbl.snp.makeConstraints { make in
            make.top.equalTo(todoDescTextField.snp.bottom).offset(20)
            make.left.equalTo(10)
        }
        
        view.addSubview(todoDatePickerTextField)
        todoDatePickerTextField.backgroundColor = .white
        todoDatePickerTextField.layer.cornerRadius = 4.0
        todoDatePickerTextField.layer.borderWidth = 2.0
        todoDatePickerTextField.layer.borderColor = UIColor.white.cgColor
        todoDatePickerTextField.placeholder = ""
        todoDatePickerTextField.snp.makeConstraints { make in
            make.top.equalTo(pickerLbl.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.width.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        
    }
    
    
    func createToolBar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done
                                      , target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        return toolbar
        
    }
    
    func createDatePicker(){
        datepicker.preferredDatePickerStyle = .wheels
        datepicker.datePickerMode = .date
        todoDatePickerTextField.toStyledTxtField()
        todoDatePickerTextField.placeholder = "Selected Date"
        todoDatePickerTextField.inputView = datepicker
        todoDatePickerTextField.inputAccessoryView = createToolBar()
    }
    
    
    @objc func donePressed(){
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        self.todoDatePickerTextField.text = formatter.string(from: datepicker.date)
        self.view.endEditing(true)
    }


}
