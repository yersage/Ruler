//
//  ViewController.swift
//  Ruler
//
//  Created by Yersage on 22.10.2022.
//

import UIKit

class RulerViewController: UIViewController {
    
    private lazy var increaseButton: UIButton = {
        let button = UIButton()
        button.setTitle("Increase", for: .normal)
        button.setTitleColor(UIColor.tintColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 25)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var decreaseButton: UIButton = {
        let button = UIButton()
        button.setTitle("Decrease", for: .normal)
        button.setTitleColor(UIColor.tintColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 25)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var currentValueLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.font = UIFont.systemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var center: UIView = {
        let centerView = UIView()
        centerView.backgroundColor = .red
        centerView.translatesAutoresizingMaskIntoConstraints = false
        return centerView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        return scrollView
    }()
    
    private lazy var rulerView: RulerView = {
        let ruler = RulerView()
        ruler.backgroundColor = .white
        ruler.isUserInteractionEnabled = true
        ruler.translatesAutoresizingMaskIntoConstraints = false
        return ruler
    }()
    
    private var currentMinutes: CGFloat = 0.0
    
    private var rulerWidthConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        increaseButton.addTarget(self,
                                 action: #selector(increaseButtonPressed),
                                 for: .touchUpInside)
        decreaseButton.addTarget(self,
                                 action: #selector(decreaseButtonPressed),
                                 for: .touchUpInside)
        
        view.addSubview(increaseButton)
        view.addSubview(decreaseButton)
        view.addSubview(currentValueLabel)
        view.addSubview(center)
        
        view.addSubview(scrollView)
        scrollView.addSubview(rulerView)
        
        scrollView.addGestureRecognizer(UIPinchGestureRecognizer(target: self,
                                                            action: #selector(didPinch(_:))))
        
        view.bringSubviewToFront(center)
                
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            increaseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            increaseButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            increaseButton.widthAnchor.constraint(equalToConstant: 120),
            increaseButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        NSLayoutConstraint.activate([
            decreaseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            decreaseButton.topAnchor.constraint(equalTo: increaseButton.bottomAnchor),
            decreaseButton.widthAnchor.constraint(equalToConstant: 120),
            decreaseButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        NSLayoutConstraint.activate([
            currentValueLabel.topAnchor.constraint(equalTo: decreaseButton.bottomAnchor),
            currentValueLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            center.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            center.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: -20),
            center.heightAnchor.constraint(equalToConstant: 30),
            center.widthAnchor.constraint(equalToConstant: 1),
        ])
        
        NSLayoutConstraint.activate([
            scrollView.heightAnchor.constraint(equalToConstant: 100),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
        
        NSLayoutConstraint.activate([
            rulerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            rulerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            rulerView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            rulerView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
        ])

        rulerWidthConstraint = rulerView.widthAnchor.constraint(equalToConstant: rulerView.currentScaleLength + UIScreen.main.bounds.width)

        NSLayoutConstraint.activate([
            rulerView.heightAnchor.constraint(equalToConstant: 100),
            rulerWidthConstraint
        ])
    }
}

extension RulerViewController {
    @objc func increaseButtonPressed() {
//        rulerView.increaseDistance()
//        rulerWidthConstraint.constant = rulerView.totalLength
//        rulerView.setNeedsDisplay()
//        let pointToScroll = CGPoint(x: (currentValue*rulerView.getDistance()),
//                                    y: 0)
//        scrollView.setContentOffset(pointToScroll, animated: false)
    }
    
    @objc func decreaseButtonPressed() {
//        rulerView.decreaseDistance()
//        rulerWidthConstraint.constant = rulerView.totalLength
//        rulerView.setNeedsDisplay()
//        let pointToScroll = CGPoint(x: (currentValue*rulerView.getDistance()),
//                                    y: 0)
//        scrollView.setContentOffset(pointToScroll, animated: false)
//        print((60.0*1440)/ruler.totalLength)
    }
    
    @objc func didPinch(_ gestureRecognizer : UIPinchGestureRecognizer) {
        
        guard gestureRecognizer.view != nil else { return }
        
        if gestureRecognizer.state == .changed {
            
            rulerView.currentScaleLength *= gestureRecognizer.scale
            
            rulerWidthConstraint.constant = rulerView.currentScaleLength + UIScreen.main.bounds.width
            gestureRecognizer.scale = 1.0
            rulerView.setNeedsDisplay()
            
            let pointToScroll = CGPoint(x: (currentMinutes*rulerView.distanceBetweenScales),
                                        y: 0)
            scrollView.setContentOffset(pointToScroll, animated: false)
        }
    }
}

extension RulerViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentMinutes = scrollView.contentOffset.x / rulerView.distanceBetweenScales
        let currentMinutes = Int(Float(currentMinutes) * 60)
        currentValueLabel.text = String(format: "%02d:%02d:%02d", currentMinutes / 3600, (currentMinutes / 60) % 60, currentMinutes % 60)
    }
}

