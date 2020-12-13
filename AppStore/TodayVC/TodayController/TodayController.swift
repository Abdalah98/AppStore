//
//  TodayController.swift
//  AppStore
//
//  Created by Abdalah Omar on 11/25/20.
//  Copyright © 2020 Abdallah. All rights reserved.
//

import UIKit

class TodayController: UICollectionViewController , UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate{
    
    var items = [TodayItem]()
    // make that to remove animate when close
    var appFullscreenController: AppfullscreenController!
  
    var startingFrame: CGRect?
    var anchorConstraints: AnchoredConstraints?
    var appFullscreenBeginoffset:CGFloat = 0

    //UIActivityIndicatorView
    let activity: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView()
        aiv.style = .large
        aiv.color = .black
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        return aiv
    }()
    // make viwe blur
    let blurVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    override func viewDidLoad() {

        view.addSubview(blurVisualEffectView)
        blurVisualEffectView.fillSuperview()
        blurVisualEffectView.alpha = 0
        super.viewDidLoad()
        configureConstantTodayCell()
        view.addSubview(activity)
        activity.centerInSuperview()
        snapHorizontal()
        fetchData()
        navigationController?.navigationBar.prefersLargeTitles = true

    }
    
    
    fileprivate func fetchData(){
        let  dispatchGroup = DispatchGroup()
        var topFree : AppGroup?
        var topGrossing : AppGroup?
        dispatchGroup.enter()
        NetworkManger.shared.topFree { (appGroup, err) in
            if let err = err{
                print("error fetch topfree Apps",err)
            }
            topFree = appGroup
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        NetworkManger.shared.topGrossing { (appGroup, err) in
            if let err = err {
                print("erorr fetch topGrossing Apps", err)
            }
            topGrossing = appGroup
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main){
            self.activity.stopAnimating()
            self.items = [
                TodayItem.init(category: "LIFE HACK", title: "Utilizing your Time", image: #imageLiteral(resourceName: "garden"), description: "All the tools and apps you need to intelligently organize your life the right way.", backgroundColor: .white ,cellType:.single, apps: []),
                TodayItem.init(category: "Daily List", title: topFree?.feed.title ?? "" , image: #imageLiteral(resourceName: "garden"), description: "", backgroundColor: .systemBackground,cellType:.multiple, apps: topFree?.feed.results ?? [])
                , TodayItem.init(category: "Daily List", title: topGrossing?.feed.title ?? "", image: #imageLiteral(resourceName: "garden"), description: "", backgroundColor: .systemBackground,cellType:.multiple,apps:topGrossing?.feed.results ?? []),
                  TodayItem.init(category: "HOLIDAYS", title: "Travel on a Budget", image: #imageLiteral(resourceName: "holiday"), description: "Find out all you need to know on how to travel without packing everything!", backgroundColor: #colorLiteral(red: 0.9838578105, green: 0.9588007331, blue: 0.7274674177, alpha: 1),cellType:.single,apps: []),

            ]
            self.collectionView.reloadData()
        }
    }
    
    let TodayMultipleAppCellID = "TodayMultipleAppCellID"
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.superview?.setNeedsLayout()
    }
    
    // make scroll snapHorizontal
    fileprivate func snapHorizontal(){
        collectionView.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.decelerationRate = .fast
        let layout = BetterSnappingLayout()
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
    }
    // call nib
    fileprivate func configureConstantTodayCell(){
        collectionView.register(TodayCell.self, forCellWithReuseIdentifier: TodayItem.CellType.single.rawValue)
        collectionView.register(TodayMultipleAppCell.self, forCellWithReuseIdentifier: TodayItem.CellType.multiple.rawValue)
    }
    // MARK: UICollectionView
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellID = items[indexPath.item].cellType.rawValue
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! BaseTodayCell
        cell.todayItem = items[indexPath.item]
     
        (cell as? TodayMultipleAppCell)?.multipleAppController.collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMultipleAppsTap)))
        
        return cell
    }
    
    @objc fileprivate func handleMultipleAppsTap(gesture: UIGestureRecognizer) {
        let collectionView = gesture.view
        var superview = collectionView?.superview
        
        while superview != nil {
            if let cell = superview as? TodayMultipleAppCell {
                guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
                let appFullscreenController = TodayMultipleAppController(mode: .fullscreen)
                let fullscreenNavigationController = BackEnabledNavigationController(rootViewController: appFullscreenController)
                appFullscreenController.apps = self.items[indexPath.item].apps
                fullscreenNavigationController.modalPresentationStyle = .fullScreen
                navigationController?.present(fullscreenNavigationController, animated: true)
                return
            }
            
            superview = superview?.superview
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 64 , height: 500)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 32, left: 0, bottom: 32, right: 0)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch items[indexPath.item].cellType {
        case .multiple:
            showDailyListFullScreen(indexPath)
        default:
            showSingleAppFullScreen(indexPath: indexPath)
        }

    }
    
    
    @objc func handleAppFullScreenDismissal() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            //3an a5li elview blue bzero w hwo dismss
            self.blurVisualEffectView.alpha = 0
            self.appFullscreenController.view.transform = .identity
            
            // when i dismss the table view the siaze cell in collection btrg3 nafs el size
            self.appFullscreenController.tableView.contentOffset = .zero
            self.appFullscreenController.floatingContainerView.isHidden = true
            guard let startingFrame = self.startingFrame else { return }
            self.anchorConstraints?.top?.constant = startingFrame.origin.y
            self.anchorConstraints?.leading?.constant = startingFrame.origin.x
            self.anchorConstraints?.width?.constant = startingFrame.width
            self.anchorConstraints?.height?.constant = startingFrame.height
            
            self.view.layoutIfNeeded()
            
            if let tabBarFrame = self.tabBarController?.tabBar.frame {
                self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height - tabBarFrame.height
            }
            guard let cell = self.appFullscreenController.tableView.cellForRow(at: [0, 0]) as? AppFullscreenHeaderCell else { return }
            self.appFullscreenController.closeButton.alpha = 0
            cell.todayCell.topConstraint.constant = 24
            cell.layoutIfNeeded()
            
        }, completion: { _ in
            self.appFullscreenController.view.removeFromSuperview()
            self.appFullscreenController.removeFromParent()
            self.collectionView.isUserInteractionEnabled = true
            
        })
    }
    
    // present
    fileprivate func showDailyListFullScreen(_ indexPath: IndexPath){
        let appFullscreenController = TodayMultipleAppController(mode: .fullscreen)
        let fullscreenNavigationController = BackEnabledNavigationController(rootViewController: appFullscreenController)
        appFullscreenController.apps = self.items[indexPath.item].apps
        fullscreenNavigationController.modalPresentationStyle = .fullScreen
        navigationController?.present(fullscreenNavigationController, animated: true)
    }
    
    fileprivate func setupSingleAppFullscreenControllern(indexPath: IndexPath){
        let appFullscreenController = AppfullscreenController()
        appFullscreenController.todayItem = items[indexPath.item ]
        appFullscreenController.dismissHandler = {
            self.handleAppFullScreenDismissal()
        }
        appFullscreenController.view.layer.cornerRadius = 16
        self.appFullscreenController = appFullscreenController
        
        // #1 setup our pan gesture
        // to makke dismss anmaite in view
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleDrag))
        gesture.delegate = self
        appFullscreenController.view.addGestureRecognizer(gesture)
        
        // #2 add blue effect  view
        
        //#3 not to interface with our uitableview scrolling
    }
    // make gesture and table view scroll the same time the both now ot one
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    @objc fileprivate func handleDrag(gesture:UIPanGestureRecognizer){
        
        if gesture.state == .began{
            appFullscreenBeginoffset = appFullscreenController.tableView.contentOffset.y
        }
        if appFullscreenController.tableView.contentOffset.y > 0 {
            return
        }
        let translationY = gesture.translation(in: appFullscreenController.view).y
        
        if gesture.state == .changed{
            // here when i scrol up dismiss
            if translationY > 0{
                let trueOffset = translationY - appFullscreenBeginoffset
                var scale = 1 - trueOffset / 1000
                // win i dismss the scroll stop here o work
                scale = min(1, scale)
                scale = max(0.5, scale)
                let transform :CGAffineTransform = .init(scaleX: scale, y: scale)
                appFullscreenController.view.transform = transform
                // bs hana lw bl mogab dismss 3ady
            }}else if gesture.state == .ended{
            // here when i scroldown no dimss so down it - bsalm lma ascrol le ta7t ana 3yz mn fo2 bs
            // y3ne lma bs7b mn t7at m2flsh el view
            if translationY > 0{
                handleAppFullScreenDismissal()
            }
        }
    }
    fileprivate func setupAppStartingCellFrame(indexPath: IndexPath){
        // selct cell
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        // open cell in view make convert
        // absolute coordindates of cell
        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
        
        // make  var to when dismiss cell return fall view in the same size of the cell
        self.startingFrame = startingFrame
    }
    
    fileprivate func setupAppFullscreenStartingPostion(indexPath: IndexPath){
        let fullScreenView = appFullscreenController.view!
        
        // 34an y5le el table in child in collection cell
        view.addSubview(fullScreenView)
        addChild(appFullscreenController)
        
        self.collectionView.isUserInteractionEnabled = false
        
        setupAppStartingCellFrame(indexPath: indexPath)
        guard let startingFrame = self.startingFrame else {return}
        // auto layout constraint animations
        // 4 anchors
        // betbt top & lead & width&hight of size of view and pic the same of the size in cell 34an kade basee el var startingFrame
        
        //do the same code ely fo2 but taht it cleancode and refuctor
        self.anchorConstraints = fullScreenView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil,padding: .init(top: startingFrame.origin.y, left: startingFrame.origin.x, bottom: 0, right: 0),size: .init(width: startingFrame.width, height: startingFrame.height))
        self.view.layoutIfNeeded()
    }
    
    fileprivate func beginAnimationAppFullScreen(){
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            //smae code but here with animate
            //do the same code ely fo2 but taht it cleancode and refuctor
            self.blurVisualEffectView.alpha = 1
            self.anchorConstraints?.top?.constant = 0
            self.anchorConstraints?.leading?.constant = 0
            self.anchorConstraints?.width?.constant = self.view.frame.width
            self.anchorConstraints?.height?.constant = self.view.frame.height
            
            self.view.layoutIfNeeded() // starts animation
            
            self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height
            guard let cell = self.appFullscreenController.tableView.cellForRow(at: [0, 0]) as? AppFullscreenHeaderCell else { return }
            
            cell.todayCell.topConstraint.constant = 48
            cell.layoutIfNeeded()
            
        }, completion: nil)
    }
    
    fileprivate func showSingleAppFullScreen(indexPath: IndexPath){
        // #1
        setupSingleAppFullscreenControllern(indexPath: indexPath)
        
        // #2 setup fullscreen in its starting position
        setupAppFullscreenStartingPostion(indexPath: indexPath)
        
        // #3 begin the fullscreen animation
        beginAnimationAppFullScreen()
        
    }
}
