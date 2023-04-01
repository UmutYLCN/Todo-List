//
//  ViewController.swift
//  todo
//
//  Created by umut yalçın on 6.03.2023.
//

import UIKit
import SnapKit
import FSCalendar
import CoreData

class MainVC: UIViewController {

    var selectedDate = String()
    let tableView = UITableView()
    let floatingBtn = UIButton()
    let titleLbl = UILabel()
    var calender : FSCalendar!
    var noDataFoundImg = UIImageView()
    var notyetaddedLbl = UILabel()
    var oopsLbl = UILabel()
    var todosArr = [Todo]()
    var sortedTodoArr = [Todo]()
    var settingBtn = UIButton()
    var noDataFoundBtn = UIButton()
    
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newData"), object: nil)
        sortedGetData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetupUI()
        getData()
        if selectedDate == "" {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            selectedDate = formatter.string(from: Date())
            sortedGetData()
        }
        sortedGetData()
        
    }
    
    func SetupUI(){
        view.backgroundColor = .systemGray6
        createFloatingBtn()
        createTitle()
        createCalender()
        createTableView()
        createNoDataFound()
        
    }
    
    @objc func getData(){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoItem")
        fetchRequest.returnsObjectsAsFaults = false
        
        todosArr.removeAll()
        
        do {
            let results = try context.fetch(fetchRequest)
                
            var newTodo = Todo()
                        
            for result in results as! [NSManagedObject]{
                
                if let name = result.value(forKey: "name") as? String {
                    newTodo.name = name
                }
                
                if let id = result.value(forKey: "id") as? UUID {
                    newTodo.id = id
                }
                
                if let desc = result.value(forKey: "desc") as? String {
                    newTodo.desc = desc
                }
                
                if let date = result.value(forKey: "date") as? String {
                    newTodo.date = date
                }
                
                if let isCompleted = result.value(forKey: "isCompleted") as? Bool {
                    newTodo.isCompleted = isCompleted
                }
                todosArr.append(newTodo)
                
                self.tableView.reloadData()
            }
            
        }catch{}
    }
    
    private func createTitle(){
        titleLbl.text = "Todo List"
        titleLbl.textAlignment = .center
        titleLbl.textColor = .black
        titleLbl.font = UIFont.boldSystemFont(ofSize: 28)
        
        view.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(35)
            make.top.equalTo(60)
            make.left.equalTo(120)
        }
    }
    
    func createCalender(){
        calender = FSCalendar(frame: CGRect(x: 0, y: 120, width: view.bounds.width, height: 300))
        calender.delegate = self
        calender.dataSource = self
        calender.scope = .week
        calender.appearance.todayColor = .black
        calender.appearance.selectionColor = .systemRed
        calender.appearance.weekdayTextColor = .black
        calender.appearance.headerTitleColor = .black
        calender.appearance.headerTitleFont = UIFont.systemFont(ofSize: 20, weight: .bold)
        calender.appearance.weekdayFont = .systemFont(ofSize: 15, weight: .bold)
        view.addSubview(calender)
    }
    
    func createTableView(){
        view.addSubview(tableView)
        tableView.backgroundColor = .systemGray6
        tableView.register(TodoCell.self, forCellReuseIdentifier: TodoCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(250)
            make.right.equalTo(-8)
            make.left.equalTo(8)
            make.bottom.equalToSuperview().offset(-100)
        }
    }
    
    func createNoDataFound(){
        view.addSubview(noDataFoundImg)
        noDataFoundImg.layer.masksToBounds = true
        
        noDataFoundImg.layer.cornerRadius = 30
        noDataFoundImg.snp.makeConstraints { make in
            
            make.width.equalTo(280)
            make.height.equalTo(280)
            make.bottom.equalTo(-310)
            make.right.equalTo(-60)
        }
        noDataFoundImg.image = UIImage(named: "no-data")
        
        
        view.addSubview(oopsLbl)
        oopsLbl.text = "OOPS!"
        oopsLbl.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        oopsLbl.snp.makeConstraints { make in
            make.top.equalTo(noDataFoundImg.snp.bottom).offset(-50)
            make.left.equalTo(150)
        }
        
        notyetaddedLbl.text = "Not data found"
        notyetaddedLbl.textColor = .black
        notyetaddedLbl.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        view.addSubview(notyetaddedLbl)
        notyetaddedLbl.snp.makeConstraints { make in
            make.left.equalTo(125)
            make.top.equalTo(oopsLbl.snp.bottom).offset(10)
        }
        
        view.addSubview(noDataFoundBtn)
        noDataFoundBtn.backgroundColor = .systemRed
        noDataFoundBtn.setTitle("Let's add Task", for: UIControl.State.normal)
        noDataFoundBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        noDataFoundBtn.layer.cornerRadius = 20
        noDataFoundBtn.addTarget(self, action: #selector(floatingBtnTarget), for: .touchUpInside)
        noDataFoundBtn.snp.makeConstraints { make in
            make.width.equalTo(180)
            make.height.equalTo(50)
            make.left.equalTo(100)
            make.bottom.equalTo(-60)
        }
        
    }
    
    private func createFloatingBtn(){
        floatingBtn.backgroundColor = .black
        floatingBtn.setImage(UIImage(systemName: "plus")?.withTintColor(UIColor.white, renderingMode: .alwaysOriginal), for: UIControl.State.normal)
        floatingBtn.layer.cornerRadius = 30
        floatingBtn.addTarget(self, action: #selector(floatingBtnTarget), for: UIControl.Event.touchUpInside)
        
        view.addSubview(floatingBtn)
        floatingBtn.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.right.equalTo(-30)
            make.bottom.equalTo(-30)
        }
    }
    
    @objc func floatingBtnTarget(){
        let destinationVC = AddTodoVC()
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func sortedGetData(){
        if selectedDate != "" {
            sortedTodoArr = todosArr.filter { $0.date == selectedDate}
            if sortedTodoArr.count == 0 {
                noDataFoundImg.isHidden = false
                noDataFoundBtn.isHidden = false
                notyetaddedLbl.isHidden = false
                oopsLbl.isHidden = false
                floatingBtn.isHidden = true
            }else {
                oopsLbl.isHidden = true
                noDataFoundBtn.isHidden = true
                noDataFoundImg.isHidden = true
                notyetaddedLbl.isHidden = true
                floatingBtn.isHidden = false
            }
        }
        tableView.reloadData()
    }
    
    @objc func cellTappedMethod(_ sender:AnyObject){
         print("you tap image number: \(sender.view.tag)")
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoItem")
        
        let idString = sortedTodoArr[sender.view.tag].id.uuidString
        fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
        fetchRequest.returnsObjectsAsFaults = false
        
        
        if sortedTodoArr[sender.view.tag].isCompleted == true {
            do {
                let result = try context.fetch(fetchRequest)
                for data in result as! [NSManagedObject] {
                    
                    data.setValue(false, forKeyPath: "isCompleted")
                    
                    do { try context.save()}catch{}
                    
                }
                
            } catch {
                print("Failed")
            }
        }else {
            do {
                let result = try context.fetch(fetchRequest)
                for data in result as! [NSManagedObject] {
                    
                    data.setValue(true, forKeyPath: "isCompleted")
                    
                    do { try context.save()}catch{}
                    
                }
                
            } catch {
                print("Failed")
            }
          
        }
        
        
        getData()
        sortedGetData()
        tableView.reloadData()
        
        
       
    }
    
    
}

extension MainVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedTodoArr.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoCell.identifier, for: indexPath) as? TodoCell else {  fatalError("The tableview could not") }
        
        cell.backgroundColor = .systemGray6
        
        if (sortedTodoArr[indexPath.row].isCompleted == true) {
            cell.imageCompleted.image = UIImage(systemName: "checkmark.circle.fill")
        }else{
            cell.imageCompleted.image = UIImage(systemName: "circle")
        }
       
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTappedMethod(_:)))
        cell.imageCompleted.isUserInteractionEnabled = true
        cell.imageCompleted.tag = indexPath.row
        cell.imageCompleted.addGestureRecognizer(tapGestureRecognizer)
        
       
        cell.nameLbl.text = "\(sortedTodoArr[indexPath.row].name)"
        cell.dateLbl.text = "\(sortedTodoArr[indexPath.row].date)"
        return cell
    }
    
   
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoItem")
        
        let idString = todosArr[indexPath.row].id.uuidString
        fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
        fetchRequest.returnsObjectsAsFaults = false
        

        do{
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject] {
                if let _ = result.value(forKey: "id") as? UUID {
                    context.delete(result)
                    

                    todosArr.remove(at: indexPath.row)
                    
                    
        
                    do { try context.save()
                        print("\(indexPath.row) silindi")
                        
                    }catch{}
                }
            }
            
            //fix
            self.tableView.reloadData()
            sortedGetData()
            
        }catch{}
    }
    
}

extension MainVC : FSCalendarDataSource , FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        selectedDate = formatter.string(from: date)
        
        sortedGetData()
        
    }
    
}
