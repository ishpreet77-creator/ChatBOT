//
//  ChatTableViewCell.swift
//  Dall-E 2
//
//  Created by John on 17/02/23.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    static let identifier = "ChatTableViewCell"
    
    let chatLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        return label
    }()
    let BubbleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        return view
    }()
    
    var Lead: NSLayoutConstraint!
    var trail:NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        ConfigUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private  func ConfigUI(){
        addSubview(BubbleView)
        addSubview(chatLabel)
      
        NSLayoutConstraint.activate([
            chatLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            chatLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            chatLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 275),
            
            BubbleView.topAnchor.constraint(equalTo: chatLabel.topAnchor, constant: -8),
            BubbleView.leadingAnchor.constraint(equalTo: chatLabel.leadingAnchor, constant: -8),
            BubbleView.trailingAnchor.constraint(equalTo: chatLabel.trailingAnchor, constant: 8),
            BubbleView.bottomAnchor.constraint(equalTo: chatLabel.bottomAnchor, constant: 8)
            
        ])
        Lead = chatLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        trail = chatLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
    }
    func configure(text:String, isUser: Bool){
        chatLabel.text = text
        if isUser{
            BubbleView.backgroundColor = .systemBlue
            Lead.isActive = false
            trail.isActive = true
        }else{
            BubbleView.backgroundColor = .systemGray
            Lead.isActive = true
            trail.isActive = false
        }
    }
}
