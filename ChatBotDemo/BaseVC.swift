//
//  BaseVC.swift
//  ChatBotDemo
//
//  Created by John on 17/02/23.
//

import UIKit
import Lottie

class BaseVC: UIViewController {
    
    private var  newLoader : LottieAnimationView = {
        var loader = LottieAnimationView()
        
//        loader = .init(name: "97156-typing-loader.json")
//        loader = .init(name: "Loader_v4.json")
        loader = .init(name: "pO5YPVcuyr.json")
        
        loader.contentMode = .scaleAspectFit
        loader.loopMode = .loop
        loader.animationSpeed = 1.5
        loader.backgroundColor = .clear
        loader.layer.zPosition = 999999999999999999
        return loader
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        newLoader.isHidden = true
        view.addSubview(newLoader)
      
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        newLoader.frame = CGRect(x: view.center.x-100,
                               y: view.center.y-50,
                               width: 200,
                               height: 100)    }
    func ShowLoader(){
       
        newLoader.isHidden = false
        self.view.isUserInteractionEnabled = false
        newLoader.play()
    }
    func HideLoader(){
        newLoader.isHidden = true
        
        self.view.isUserInteractionEnabled = true
        
    }

}
