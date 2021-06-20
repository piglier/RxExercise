//
//  ViewControllerB.swift
//  RxExercise
//
//  Created by 朱彥睿 on 2021/6/18.
//

import Foundation
import UIKit
import RxSwift


class VCDisposed: UIViewController {
    var disposableBag = DisposeBag();
    
    override func viewDidLoad() {
        setBakground();
        addButton();
        addObservable();
    }
    
    func setBakground() {
        self.view.backgroundColor = UIColor.gray;
    }
    
    func addButton() {
        let button: UIButton = UIButton();
        button.frame = CGRect(x: 100 ,y: 100, width: 41, height: 35);
        button.setTitle("Back", for: .normal);
        button.tintColor = UIColor.white;
        button.backgroundColor = UIColor.red;
        button.addTarget(self, action: #selector(back), for: .touchUpInside);
        self.view.addSubview(button);
    }
    
    func addObservable() {
        Observable<Int>.interval(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: {item in NSLog("IntObservable: \(item)")}).disposed(by: self.disposableBag)
    }
    
    @objc
    func back() {
        self.navigationController?.popViewController(animated: true);
    }
    
}
