//
//  AppfullscreenController.swift
//  AppStore
//
//  Created by Abdalah Omar on 11/25/20.
//  Copyright © 2020 Abdallah. All rights reserved.
//

import UIKit

class AppfullscreenController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    
    var dismissHandler: (() ->())?
    var todayItem : TodayItem?
    let floatingContainerView = UIView()
    
    let tableView = UITableView(frame: .zero, style: .plain)
    override func viewDidLoad() {
        super.viewDidLoad()
        handelTableView()
        // this code mean when i hiden the tabbar i need view take all hight of all screen and take high of tabbar
        let hight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        tableView.contentInset = .init(top: 0, left: 0, bottom: hight, right: 0)
        setupCloseButton()
        setupFloatingControls()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
     // navigationController?.isNavigationBarHidden = true

    }
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "close_button"), for: .normal)
        return button
    }()
    
    
    @objc fileprivate func handleTap(){
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            self.floatingContainerView.transform = .init(translationX: 0, y: -90)
        })
    }
    
    fileprivate func handelTableView(){
        view.addSubview(tableView)
        tableView.fillSuperview()
        view.clipsToBounds = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.contentInsetAdjustmentBehavior = .never
    }
    
    fileprivate func setupFloatingControls() {
        floatingContainerView.clipsToBounds = true
        floatingContainerView.layer.cornerRadius = 16
        view.addSubview(floatingContainerView)
     
        floatingContainerView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 16, bottom: -90 , right: 16), size: .init(width: 0, height: 90))
        
        let blurVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        floatingContainerView.addSubview(blurVisualEffectView)
        blurVisualEffectView.fillSuperview()
        
        //Gesture
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        // add our subviews
        let imageView = UIImageView(cornerRadius: 16)
        imageView.image = todayItem?.image
        imageView.constrainHeight(constant: 68)
        imageView.constrainWidth(constant: 68)
        
        let getButton = UIButton(title: "GET")
        getButton.setTitleColor(.white, for: .normal)
        getButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        getButton.backgroundColor = .darkGray
        getButton.layer.cornerRadius = 16
        getButton.constrainWidth(constant: 80)
        getButton.constrainHeight(constant: 32)
        let stackView = UIStackView(arrangedSubviews: [
            imageView,
            VerticalStackView(arrangedSubviews: [
                UILabel(text: todayItem?.category ?? "", font: .boldSystemFont(ofSize: 18)),
                UILabel(text: "Utilizing your Time", font: .systemFont(ofSize: 16))
            ], spacing: 4),
            getButton
        ])
        stackView.setCustomSpacing(16,after:imageView)
        floatingContainerView.addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        stackView.alignment = .center
    }
    fileprivate func  setupCloseButton(){
        view.addSubview(closeButton)
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 12, left: 0, bottom: 0, right: 0), size: .init(width: 80, height: 40))
        closeButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        
    }
    
    
    
    //     MARK: - Table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            // hack
            // to call celloftodayof collection view
            let headerCell = AppFullscreenHeaderCell()
            // button to close the view
            headerCell.todayCell.todayItem = todayItem
            headerCell.todayCell.layer.cornerRadius = 0
            headerCell.clipsToBounds = true
            headerCell.todayCell.backgroundView = nil
            return headerCell
        }
        
        let cell = AppFullscreenDescriptionCell()
        return cell
    }
    
    @objc fileprivate func handleDismiss(button: UIButton) {
        button.isHidden = true
        dismissHandler?()
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 500
        }
        return UITableView.automaticDimension
    }
    
    //MARK: - ScrollView
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //hna when i dimss el view bw2f el scroll 34an el size yfdel sabt we ba3den true leny mmoken a3mal dismss we arge tany bel view w el scroll y4t8al
        if scrollView.contentOffset.y  < 0{
            scrollView.isScrollEnabled = false
            scrollView.isScrollEnabled = true
        }
        //here when i scroll down the view it show
        // lma ascroll zyda 3n 100
        //        if scrollView.contentOffset.y  > 100{
        //            UIView.animate(withDuration: 0.7, delay: 0,usingSpringWithDamping: 0.7,initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
        //                let translationY = -90 - ((self.view.window?.windowScene?.statusBarManager?.statusBarFrame.height)! )
        //                self.floatingContainerView.transform = .init(translationX: 0, y: translationY)
        //            })
        //        }else {
        //            UIView.animate(withDuration: 0.7, delay: 0,usingSpringWithDamping: 0.7,initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
        //                self.floatingContainerView.transform = .identity
        //            })
        //        }
        // the same code
        let translationY = -90 - (self.view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0 )
        let transform = scrollView.contentOffset.y > 100 ? CGAffineTransform(translationX: 0, y: translationY) : .identity
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            
            self.floatingContainerView.transform = transform
        })
    }
}
