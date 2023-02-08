//
//  KakaoAuthVM.swift
//  KakaoLoginUIKit-tutorial
//
//  Created by 김혜주 on 2023/02/05.
//

import Foundation
import Combine
import KakaoSDKAuth
import KakaoSDKUser

class KakaoAuthVM: ObservableObject {
    
    var subscriptions = Set<AnyCancellable>()
    
    @Published var isLoggedIn : Bool = false
    
    lazy var loginStatusInfo : AnyPublisher<String?, Never> =
    $isLoggedIn.compactMap{ $0 ? "로그인상태" : "로그아웃 상태" }.eraseToAnyPublisher()
    
    init() {
        print("KakaoAuthVM - init() called")

    }
    
    //카카오톡 앱으로 로그인 인증
    func kakaoLoginWithApp() async -> Bool {
        
        await withCheckedContinuation{ continuation in
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                }
                else {
                    print("loginWithKakaoTalk() success.")
                    //do something
                    _ = oauthToken
                    continuation.resume(returning: true)
                }
            }
        }
        
    }
    
    //카카오 계정으로 로그인
    func kakaoLoginWithAccount() async -> Bool{
        await withCheckedContinuation{ continuation in
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                    if let error = error {
                        print(error)
                        continuation.resume(returning: false)
                    }
                    else {
                        print("loginWithKakaoAccount() success.")

                        //do something
                        _ = oauthToken
                        continuation.resume(returning: true)

                    }
                }
        }
       
    }
    
    @MainActor
    func kakaoLogin(){
        print("KakaoAuthVM - handleKakaoLogin() called")
        Task{
            // 카카오톡 실행 가능 여부 확인
            if (UserApi.isKakaoTalkLoginAvailable()) {
                
                isLoggedIn = await kakaoLoginWithApp()
            } else { //카톡이 설치가 안되어 있으면
                
                // 카카오 계정으로 로그인
                isLoggedIn = await kakaoLoginWithAccount()

                
            }
        }
        
    }// login
    
    @MainActor
    func kakaoLogout(){
        Task {
            if await handleKakaoLogout() {
                self.isLoggedIn = false
            }
        }
    }
    
    func handleKakaoLogout() async-> Bool{
        await withCheckedContinuation{ continuation in
            UserApi.shared.logout {(error) in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                }
                else {
                    print("logout() success.")
                    continuation.resume(returning: true)
                }
            }
        }
        
    }
    
    
    
}
