//
//  ViewController.swift
//  combine_ToyProject
//
//  Created by 최광호 on 2022/06/13.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {
    let controller = UIHostingController(rootView: ContentsView())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(controller)
        view.addSubview(controller.view)
        
        setConstraints()
    }
    
    func setConstraints() {
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        controller.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        controller.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        controller.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }

    // 29일까지 Toy Proj 만들기
    // section 2 살펴보는 중
    // - Publisher, Subscriner, Subject, sink, cancel, AnyCancel
    // Section 3
    // - collect, map, flatMap, replaceNil, replaceEmpty, scan
    // Section 4
    // - filter, compactMap, ignoreOutput, first, last, dropFirst, drop, prefix,
    // Section 5
    // - prepend, append, switchToLatest, merge, combineLatest, zip
    // Section 6
    // - PlaygroundPage, delay, collect(byTime), debounce, Throttle, TimeOut, Measuring
    // Section 7
    // - min, max, first, last, output(at:), output(in:), count, contains, allSatisfy, reduce
    // Section 8
    // - Toy Project _ Practice : Shared, PHPhotoLibrary
    // Question 1. [weak self] vs [unowned self]
}

