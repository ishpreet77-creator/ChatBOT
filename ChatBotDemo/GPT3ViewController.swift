

//
//  GPT3ViewController.swift
//  Dall-E 2
//
//  Created by John on 17/02/23.
//

import UIKit

class GPT3ViewController: BaseVC {
    let gptLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24,weight: .regular)
        label.text = "CHAT GPT DEMO"
        label.textAlignment = .center
        label.backgroundColor = .gray
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()
    
     lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
         table.register(ChatTableViewCell.self, forCellReuseIdentifier: ChatTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        
         table.separatorStyle = .none
         table.backgroundColor = .clear
        return table
    }()

    let promptTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.autocapitalizationType = .none
        textView.font = .systemFont(ofSize: 20,weight: .regular)
        textView.autocorrectionType = .no
        textView.layer.cornerRadius = 10
        textView.clipsToBounds = true
        textView.backgroundColor = .gray
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.secondaryLabel.cgColor
        textView.returnKeyType = .done
        return textView
    }()
    
    lazy var submitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sub", for: .normal)
        button.backgroundColor = .systemMint
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapSubmit), for: .touchUpInside)
        return button
    }()
    
    
    var chat = [String]()
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       

        view.backgroundColor = .black
        
        
        configUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        updateTableContentInset()
    }
    
    private func  configUI(){
        view.addSubview(gptLabel)
        view.addSubview(tableView)
        view.addSubview(promptTextView)
        view.addSubview(submitButton)
      
        updateTableContentInset()
        NSLayoutConstraint.activate([
            gptLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            gptLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gptLabel.widthAnchor.constraint(equalToConstant: 300),
            gptLabel.heightAnchor.constraint(equalToConstant: 100),
            
            tableView.topAnchor.constraint(equalTo: gptLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
//            tableView.heightAnchor.constraint(equalToConstant: 500),
            tableView.bottomAnchor.constraint(equalTo: promptTextView.topAnchor),
            
//            promptTextView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 70),
            promptTextView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor,constant: -16),
            promptTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            promptTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -60),
            promptTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            promptTextView.widthAnchor.constraint(equalToConstant: 200),
            promptTextView.heightAnchor.constraint(equalToConstant: 50),
            
//            submitButton.topAnchor.constraint(equalTo: view.keyboardLayoutGuide.bottomAnchor, constant: -20),
            
            submitButton.topAnchor.constraint(equalTo: promptTextView.topAnchor),
            submitButton.bottomAnchor.constraint(equalTo: promptTextView.bottomAnchor),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.widthAnchor.constraint(equalToConstant: 50),
            submitButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
    }
    
    func updateTableContentInset() {
        let numRows = self.tableView.numberOfRows(inSection: 0)
        var contentInsetTop = self.tableView.bounds.size.height
        for i in 0..<numRows {
            let rowRect = self.tableView.rectForRow(at: IndexPath(item: i, section: 0))
            contentInsetTop -= rowRect.size.height
            if contentInsetTop <= 0 {
                contentInsetTop = 0
                break
            }
        }
        self.tableView.contentInset = UIEdgeInsets(top: contentInsetTop,left: 0,bottom: 0,right: 0)
    }
 
    private func fetchGPTChatResponse(prompt: String){
        Task{
            do{
                ShowLoader()

                let gptText = try await  APIService().sendPromtToGpt(promt: prompt)
             
                await MainActor.run{
                    chat.append(prompt)
                    chat.append(gptText.replacingOccurrences(of: "\n\n", with: ""))
                    tableView.reloadData()
                    tableView.scrollToRow(at: IndexPath(row: chat.count-1, section: 0), at: .bottom, animated: true)
                    promptTextView.text = ""
                    HideLoader()
                }
            }catch(let error){
                HideLoader()
                print(error)
            }
        }
    }
    @objc func didTapSubmit (){
  
        promptTextView.resignFirstResponder()
        
        if let promptText = promptTextView.text, promptText.count > 3 {
            fetchGPTChatResponse(prompt: promptText)
//            chatBot.sendMessage(promptText)
        } else {
            print("please check textfield")
        }
        
    }
   

}
extension GPT3ViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.identifier, for: indexPath) as! ChatTableViewCell
 
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
       
       let text = chat[indexPath.row]
       
        
        
        if indexPath.row % 2 == 0{
            cell.configure(text: text, isUser: true)
        }else{
            cell.configure(text: text, isUser: false)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let refreshAlert = UIAlertController(title: "Copy", message: "you have Selected Cell have been Copy", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            let cell = self.tableView.cellForRow(at: indexPath) as? ChatTableViewCell
            UIPasteboard.general.string = cell?.chatLabel.text
              print("Handle Ok logic here")
        }))

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
              print("Handle Cancel Logic here")
        }))

        present(refreshAlert, animated: true, completion: nil)
      
     
    }
    
}
