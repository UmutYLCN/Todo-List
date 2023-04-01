//
//  TodoCell.swift
//  todo
//
//  Created by umut yalçın on 21.03.2023.
//

import UIKit
import SnapKit

class TodoCell: UITableViewCell {

    static let identifier = "TodoCell"
    
    var imageCompleted = UIImageView()
    var nameLbl = UILabel()
    var dateLbl = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
        
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupUI(){
        createbtn()
        createLbl()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = .white
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0))
    }
    
    
    private func createbtn(){
        self.contentView.addSubview(imageCompleted)
        
        imageCompleted.image = UIImage(systemName: "circle")
        imageCompleted.tintColor = .black
        imageCompleted.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.left.equalTo(15)
            make.top.equalTo(20)
        } 
    }
    
    private func createLbl(){
        self.contentView.addSubview(nameLbl)
        nameLbl.text = "Fonksiyonlar Test Çöz"
        nameLbl.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        nameLbl.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(20)
            make.left.equalTo(imageCompleted.snp.right).offset(20)
            make.top.equalTo(25)
        }
        self.contentView.addSubview(dateLbl)
        dateLbl.text = "03/10/2023"
        dateLbl.font = UIFont.systemFont(ofSize: 13)
        dateLbl.textAlignment = .right
        dateLbl.textColor = .systemGray
        dateLbl.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(15)
            make.right.equalTo(-3)
            make.bottom.equalTo(-5)
        }
    }
    
}
