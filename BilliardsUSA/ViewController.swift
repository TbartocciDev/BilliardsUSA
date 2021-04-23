//
//  ViewController.swift
//  BilliardsUSA
//
//  Created by Tommy Bartocci on 3/17/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var homeTabBtn: UIButton!
    @IBOutlet weak var mapTabBtn: UIButton!
    @IBOutlet weak var videoTabBtn: UIButton!
    @IBOutlet weak var accountTabBtn: UIButton!
    
    @IBOutlet weak var homeScreenView: UIView!
    @IBOutlet weak var mapScreenView: UIView!
    @IBOutlet weak var videoScreenView: UIView!
    @IBOutlet weak var accountScreenView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureTabBarBtns()
        checkAllButtonsVisibility()
        
        
    }

    
    
    
    func configureTabBarBtns() {
        setCustomTabBtn(button: homeTabBtn, withImage: "house", withView: homeScreenView, andfunction: #selector(homeTabBtnPressed))
        setCustomTabBtn(button: mapTabBtn, withImage: "map", withView: mapScreenView, andfunction: #selector(mapTabBtnPressed))
        setCustomTabBtn(button: videoTabBtn, withImage: "play.rectangle", withView: videoScreenView, andfunction: #selector(videoTabBtnPressed))
        setCustomTabBtn(button: accountTabBtn, withImage: "person", withView: accountScreenView, andfunction: #selector(accountTabBtnPressed))
        
    }
    
    func checkSingleButtonVisibility(contentView: UIView, button: UIButton, color: UIColor) {
        if contentView.isHidden == false {
            button.backgroundColor = color
        } else {
            button.backgroundColor = UIColor.systemGray3
        }
    }
    
    func checkAllButtonsVisibility() {
        checkSingleButtonVisibility(contentView: homeScreenView, button: homeTabBtn, color: .systemBlue)
        checkSingleButtonVisibility(contentView: mapScreenView, button: mapTabBtn, color: .systemGreen)
        checkSingleButtonVisibility(contentView: videoScreenView, button: videoTabBtn, color: .systemRed)
        checkSingleButtonVisibility(contentView: accountScreenView, button: accountTabBtn, color: .systemYellow)
    }
    
    
    @objc func
    homeTabBtnPressed() {
        homeScreenView.isHidden = false
        mapScreenView.isHidden = true
        videoScreenView.isHidden = true
        accountScreenView.isHidden = true
        
        checkAllButtonsVisibility()
    }
    @objc func
    mapTabBtnPressed() {
        homeScreenView.isHidden = true
        mapScreenView.isHidden = false
        videoScreenView.isHidden = true
        accountScreenView.isHidden = true
        
        checkAllButtonsVisibility()
    }
    @objc func
    videoTabBtnPressed() {
        homeScreenView.isHidden = true
        mapScreenView.isHidden = true
        videoScreenView.isHidden = false
        accountScreenView.isHidden = true
        
        checkAllButtonsVisibility()
    }
    @objc func
    accountTabBtnPressed() {
        homeScreenView.isHidden = true
        mapScreenView.isHidden = true
        videoScreenView.isHidden = true
        accountScreenView.isHidden = false
        
        checkAllButtonsVisibility()
    }
    
    func setCustomTabBtn(button: UIButton, withImage imageName: String, withView contentView: UIView, andfunction function: Selector) {
        
        let buttonWidth = button.frame.width
        let buttonHeight = button.frame.height
        let imageSize = buttonHeight * 0.75
        let halfImageSize = imageSize / 2
        
        let imageView = UIImageView(frame: CGRect(x: buttonWidth / 2 - halfImageSize , y: buttonHeight / 2 - halfImageSize, width: imageSize, height: imageSize))
        imageView.image = UIImage(systemName: imageName)
        button.tintColor = .black
        
        button.addSubview(imageView)
        button.addTarget(self, action: function, for: .touchUpInside)
        
    }
}
