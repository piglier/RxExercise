//
//  ViewController.swift
//  RxExercise
//
//  Created by PIG on 2021/6/13.
//

import UIKit
import RxSwift

class ViewControllerA: UIViewController {

    let bag = DisposeBag()
    let pb1 = PublishSubject<Int>()
    let pb2 = PublishSubject<Int>()
    override func viewDidLoad() {
        super.viewDidLoad()
        throttle();
        // Do any additional setup after loading the view.
    }
    
    func throttle() {
        pb1.throttle(10, scheduler: MainScheduler.instance)
            .subscribe(onNext: { nunmber in
                print("number", nunmber);
            })
            .disposed(by: bag);
        pb1.onNext(1)
        pb1.onNext(2)
        pb1.onNext(3)
        pb1.onNext(4)
        pb1.onCompleted();
        pb1.onNext(5)
        /*
         result ▼
         number 1
         number 4
         */
    }
    
    func combineLatest() {
        Observable<String>.combineLatest(pb1, pb2) { (o1, o2) -> String in
            return "First: " + "\(o1)" + ", Secound: " + "\(o2)"
        }.subscribe {
            event in
            switch event {
            case .next(let element):
                print("element", element);
            case .error(let error):
                print("error", error);
            case .completed:
                print("completed")
            }}.disposed(by: bag)
        pb1.onNext(1);
        pb2.onNext(2);
        pb1.onNext(3);
        /*
         result ▼
         element First: 1, Secound: 2
         element First: 3, Secound: 2
         */
    }
    
    func withLatestFrom() {
        pb1.withLatestFrom(pb2) { (i1, i2) -> Int in
            return i1 + i2
        }.subscribe { (event) in
            switch event {
            case .next(let element):
                print("event: ", element)
            case .error(let error):
                print("error: \(error)")
            case .completed:
                print("complete");
            }
        }.disposed(by: bag)
        pb1.onNext(1)
        pb2.onNext(2)
        pb1.onNext(3)
        pb2.onNext(4)
        pb1.onNext(5)
        pb1.onNext(6)
        pb1.onCompleted()
        /*
         result ▼
         event:  5
         event:  9
         event:  10
         complete
         Message from debugger: Terminated due to signal 9
         */
    }

}

