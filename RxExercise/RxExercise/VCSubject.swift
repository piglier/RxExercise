//
//  VCSubject.swift
//  RxExercise
//
//  Created by 朱彥睿 on 2021/6/20.
//

import Foundation
import UIKit
import RxSwift

class VCSubject: UIViewController {
    let dispiseBag = DisposeBag();
    let subject = PublishSubject<Int>();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        addPublishSubject();
        asObservable();
    }
    
    func addPublishSubject() {
        subject
            .subscribe(onNext: {print($0)})
            .disposed(by: self.dispiseBag);
        subject.onNext(1);
        subject.onNext(2);
        subject.onNext(1);
    }
    
    func asObservable() {
        subject.asObserver()
            .subscribe(onNext: {
                print($0)})
            .disposed(by: self.dispiseBag);
    }
    
    func delay(delayTime: Double, closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delayTime) {
            closure();
        }
    }
}
