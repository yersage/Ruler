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
        label.text = "0.00"
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
    
    private lazy var ruler: RulerView = {
        let ruler = RulerView(leftMargin: UIScreen.main.bounds.width / 2,
                                  rightMargin: UIScreen.main.bounds.width / 2)
        ruler.backgroundColor = .white
        ruler.translatesAutoresizingMaskIntoConstraints = false
        return ruler
    }()
    
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
        scrollView.addSubview(ruler)
                
        layoutSubviews()
    }
    
    private func layoutSubviews() {
        
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
            center.bottomAnchor.constraint(equalTo: scrollView.topAnchor, constant: -10),
            center.heightAnchor.constraint(equalToConstant: 20),
            center.widthAnchor.constraint(equalToConstant: 2),
        ])
        
        NSLayoutConstraint.activate([
            scrollView.heightAnchor.constraint(equalToConstant: 100),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
        
        NSLayoutConstraint.activate([
            ruler.topAnchor.constraint(equalTo: scrollView.topAnchor),
            ruler.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            ruler.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            ruler.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
        ])

        rulerWidthConstraint = ruler.widthAnchor.constraint(equalToConstant: ruler.totalLength)

        NSLayoutConstraint.activate([
            ruler.heightAnchor.constraint(equalToConstant: 100),
            rulerWidthConstraint
        ])
    }
}

extension RulerViewController {
    @objc func increaseButtonPressed() {
        ruler.increaseDistance()
        rulerWidthConstraint.constant = ruler.totalLength
        ruler.setNeedsDisplay()
        // change currentValueLabel's
    }
    
    @objc func decreaseButtonPressed() {
        ruler.decreaseDistance()
        rulerWidthConstraint.constant = ruler.totalLength
        ruler.setNeedsDisplay()
    }
}

extension RulerViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentValue = scrollView.contentOffset.x / ruler.getDistance()
        currentValueLabel.text = String(format: "%.2f", currentValue)
    }
}

