//
//  HomeViewController.swift
//  BilliardsUSA
//
//  Created by Tommy Bartocci on 4/21/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    
    let imageArr = [UIImage(named: "billiards"), UIImage(named: "poolhall-dark"), UIImage(named: "poolplayer"), UIImage(named: "8ball")]
    
    let pageControl: UIPageControl = {
       let pageControl = UIPageControl()
        
        return pageControl
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    var timer = Timer()
    var counter = 0
    var contentOffset: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl.addTarget(self, action: #selector(pageControlDidChange), for: .valueChanged)
        scrollView.delegate = self
        view.addSubview(pageControl)
        view.addSubview(scrollView)
        
//        timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(changeImage), userInfo: nil, repeats: true)
    }
    
    @objc func
    changeImage() {
        let scrollWidth: CGFloat = scrollView.frame.size.width
        
        if counter < imageArr.count - 1 {
            contentOffset += scrollWidth
            self.scrollView.setContentOffset(CGPoint(x: contentOffset, y: 0), animated: true)
            counter += 1
        } else {
            contentOffset = 0
            counter = 0
            self.scrollView.setContentOffset(CGPoint(x: contentOffset, y: 0), animated: true)
        }
        
    }
    
    @objc func
    pageControlDidChange(_ sender: UIPageControl) {
        let current = sender.currentPage
        scrollView.setContentOffset(CGPoint(x: CGFloat(current) * view.frame.size.width, y: 0), animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        pageControl.frame = CGRect(x: 10, y: view.frame.height - 100, width: view.frame.width - 20, height: 70)
        pageControl.backgroundColor = .systemBlue
        pageControl.numberOfPages = imageArr.count
        
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 100)
        scrollView.backgroundColor = .red
    
        
        if scrollView.subviews.count == 2 {
            setScrollViewContent()
            
        }
    }
    
    private func setScrollViewContent() {
        scrollView.contentSize = CGSize(width: view.frame.size.width * CGFloat(imageArr.count), height: scrollView.frame.size.height)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        
        let colors: [UIColor] = [.black, .blue, .cyan, .green]
        
        for x in 0..<imageArr.count {
            let page = UIView(frame: CGRect(x: CGFloat(x) * view.frame.size.width, y: 0, width: view.frame.size.width, height: scrollView.frame.size.height))
            let imageView = UIImageView(frame: CGRect(x: CGFloat(x) * view.frame.size.width, y: 175, width: view.frame.size.width,
                                                      height: scrollView.frame.size.height - 350))
            imageView.backgroundColor = .brown
            imageView.image = imageArr[x]
            
            page.backgroundColor = colors[x]
            
            scrollView.addSubview(page)
            scrollView.addSubview(imageView)
        }
    }
    
    
    
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(floor(Float(scrollView.contentOffset.x) / Float(scrollView.frame.size.width)))
    }
}
