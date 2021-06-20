//
//  VCObservable.swift
//  RxExercise
//
//  Created by 朱彥睿 on 2021/6/20.
//

import Foundation
import RxSwift

class VCObservable: UIViewController {
    var disposedbag = DisposeBag();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setbackground();
        addButton();
        testJust();
        testFromOptional(isNil: false);
        testNever();
        testError();
        testEmpty();
        testCreate(number: 1);
}
    func setbackground() {
        self.view.backgroundColor = UIColor.yellow;
    }
    
    func addButton() {
        let button: UIButton = UIButton(type: .custom);
        self.view.addSubview(button);
        button.frame = CGRect(x: 100,y: 100, width: 70, height: 35);
        button.setTitle("Touch", for: .normal);
        button.backgroundColor = UIColor.red;
        button.tintColor = UIColor.white;
        button.addTarget(self, action: #selector(testMemoryLeak), for: .touchUpInside);
    }
    
    /// 發送單一物件的Observable for單一物件發送
    func testJust() {
        Observable<Bool>.just(true)
            .subscribe(onNext: {item in NSLog("just \(item)")})
            .disposed(by: self.disposedbag);
    }
    

    /// 發送陣列的Observable
    /// - Parameter isNil: 是否為空值
    func testFromOptional(isNil: Bool) {
        Observable.from(optional: isNil ? [1,2,4] : nil)
            .subscribe(onNext: {items in NSLog("form: \(items)")})
            .disposed(by: self.disposedbag);
    }
    
    /// 一個不會發送也不會結束的Observable
    func testNever() {
        Observable.never()
            .subscribe(onNext: {NSLog("never")})
            .disposed(by: self.disposedbag);
    }
    
    /// 發送一個結束的Observable
    func testEmpty() {
        let observable: Observable<Int> = .empty();
        observable.subscribe(onNext: {item in NSLog("Empty: \(item)")},
                             onError: {error in NSLog("error: \(error)")},
                             onCompleted: {NSLog("EmptyCompleted")},
                             onDisposed: nil)
            .disposed(by: self.disposedbag);
    }
    
    /// 發送錯誤的Observale
    func testError() {
        let error = NSError.init(domain: "Test", code: -1, userInfo: nil);
        let observable: Observable<Int> = .error(error);
        observable.subscribe(onNext: {item in NSLog("Error: \(item)")},
                             onError: {error in NSLog("error: \(error)")},
                             onCompleted: {NSLog("ErrorCompleted")},
                             onDisposed: nil)
            .disposed(by: self.disposedbag);
    }
    
    /// 提供客製化的Observable,給予一個數字判定是不是偶數
    /// - Parameter number: 給予的數字
    /// - Returns: 若是偶數發送一個Observable形式回來,不是則發送.error
    func isEven(number: Int) -> Observable<Int> {
        return Observable.create { observer in
            if number % 2 == 0 {
                observer.onNext(number);
                observer.onCompleted();
            } else {
                observer.onError(NSError.init(domain: "Not Even", code: 401, userInfo: nil));
            }
            return Disposables.create();
        }
    }
    
    func testCreate(number: Int) {
        isEven(number: number)
            .subscribe(onNext: {item in NSLog("testCreate: \(item)")})
            .disposed(by: self.disposedbag);
    }
    
    
    
    /// 測試VCDisposed頁面有無disposed造成的memory leak
    @objc
    func testMemoryLeak() {
        if let vcDisposed = storyboard?.instantiateViewController(identifier: "Disposed") as? VCDisposed {
            self.navigationController?.pushViewController(vcDisposed, animated: true);
        }
    }
}
