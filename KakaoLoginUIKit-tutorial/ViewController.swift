//
//  ViewController.swift
//  KakaoLoginUIKit-tutorial
//
//  Created by 김혜주 on 2023/02/02.
//

import UIKit
import SnapKit
import Combine

class ViewController: UIViewController {
    
    var subscriptions = Set<AnyCancellable>()
    
    lazy var kakaoLoginStatusLabel : UILabel = {
        let label = UILabel()
        label.text = "로그인 여부 라벨"
        return label
    }()
    
//    lazy var kakaoLoginButton : UIButton = {
//        let btn = UIButton()
//        btn.setTitle("카카오 로그인", for: .normal)
//        btn.configuration = .filled()
//        btn.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        return btn
//    }()
//
//    lazy var kakaoLogoutButton : UIButton = {
//        let btn = UIButton()
//        btn.setTitle("카카오 로그아웃", for: .normal)
//        btn.configuration = .filled()
//        btn.addTarget(self, action: #selector(logoutButtonClicked), for: .touchUpInside)
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        return btn
//    }()
    
    
    lazy var kakaotButton = { (_ title: String, _ action: Selector) -> UIButton in
        let btn = UIButton()
        btn.setTitle(title, for: .normal)
        btn.configuration = .filled()
        btn.addTarget(self, action: action, for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }
    
    lazy var stackView : UIStackView = {
        let stack = UIStackView()
        stack.spacing = 8
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var kakaoAuthVM: KakaoAuthVM = {KakaoAuthVM()} ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        kakaoLoginStatusLabel.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(70)
        }
        
        let kakaoLoginButton = kakaotButton("카카오 로그인", #selector(loginButtonClicked))
        let kakaoLogoutButton = kakaotButton("카카오 로그아웃", #selector(logoutButtonClicked))

        stackView.addArrangedSubview(kakaoLoginStatusLabel)
        stackView.addArrangedSubview(kakaoLoginButton)
        stackView.addArrangedSubview(kakaoLogoutButton)
        
        self.view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.center.equalTo(self.view)
        }
        setBindings()
    } //viewDidLoad
    
    
    
    
    //MARK: - 버튼액션
    @objc func loginButtonClicked(){
        print("loginBtnClicked() called")
        kakaoAuthVM.kakaoLogin()
    }
    
    @objc func logoutButtonClicked(){
        print("logoutButtonClicked() called")
        kakaoAuthVM.kakaoLogout()
    }
}

    //MARK: = 뷰모델 바인딩
    extension ViewController {
        fileprivate func setBindings() {
   //         self.kakaoAuthVM.$isLoggedIn.sink { [weak self] isLoggedIn in
   //             guard let self = self else { return }
   //             self.kakaoLoginStatusLabel.text = isLoggedIn ? "로그인 상태" : "로그아웃 상태"
   //         }
   //         .store(in: &subscriptions)
            
            self.kakaoAuthVM.loginStatusInfo
                .receive(on: DispatchQueue.main)
                .assign(to: \.text, on: self.kakaoLoginStatusLabel)
                .store(in: &subscriptions)
        }
    }

 //ViewController

#if DEBUG

import SwiftUI

struct ViewControllerPresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        ViewController()
    }
}

struct ViewControllerPrepresentable_PreviewProvider : PreviewProvider {
    static var previews: some View {
        ViewControllerPresentable()
    }
}

#endif

