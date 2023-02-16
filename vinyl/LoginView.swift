//
//  LoginView.swift
//  vinyl
//
//  Created by Matt Lunsford on 11/13/22.
//

import SwiftUI
import Firebase

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    @State private var userIsLoggedIn = false // **CHANGE ON PRODUCTION**
    @StateObject var dataManager = DataManager()
    @EnvironmentObject var contextHolder: ContextHolder

    
    
    var body: some View {
        if userIsLoggedIn {
            TabView {
                HomeView()
                    .environmentObject(dataManager)
                    .environmentObject(contextHolder)
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                SearchView()
                    .environmentObject(dataManager)
                    .environmentObject(contextHolder)
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
               
                ProfileView()
                    .environmentObject(dataManager)
                    .environmentObject(contextHolder)
                    .tabItem {
                        Label("Profile", systemImage: "person.crop.circle")
                    }
            }
        } else {
            content
        }
    }
    
    var content: some View {
        ZStack {
            Image("background")
                       .resizable()
                       .edgesIgnoringSafeArea(.all)
            VStack(spacing: 20) {
                
                Image("record") //can use logo, logo2, or record
                    .resizable()
                    .frame(width: 200.0, height: 200.0)
                
                Text("Welcome to Vinyl")
                    .foregroundColor(.black)
                    .font(.system(size: 35, weight: .bold, design: .rounded))
                    

                
                TextField("Email", text: $email)
                    .foregroundColor(.black)
                    .textFieldStyle(.plain)
                    .placeholder(when: email.isEmpty) {
                        Text("Email")
                            .foregroundColor(.black)
                            .bold()
                    }
                
                Rectangle()
                    .frame(width: .infinity, height: 1)
                    .foregroundColor(.black)
                
                SecureField("Password", text: $password)
                    .foregroundColor(.black)
                    .textFieldStyle(.plain)
                    .placeholder(when: password.isEmpty) {
                        Text("Password")
                            .foregroundColor(.black)
                            .bold()
                    }
                
                Rectangle()
                    .frame(width: .infinity, height: 1)
                    .foregroundColor(.black)
                
                Button {
                    handleSignUp()
                } label: {
                    Text("Sign up")
                        .bold()
                        .frame(width: 200, height: 40)
                }
                .padding(.top)
                .offset(y: 20)
                
                Button {
                    handleLogIn()
                } label: {
                    Text("Already have an account? Log in")
                        .bold()
                }
                .padding(.top)
                .offset(y: 110)


            }
            .padding(40)
            .onAppear {
                Auth.auth().addStateDidChangeListener { auth, user in if user != nil {
                    userIsLoggedIn.toggle()
                }
                    
                }
            }
        }
    }
    
    func handleSignUp() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
    
    func handleLogIn() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in if error != nil {
            print(error!.localizedDescription)
            }
        }
    }
    
    func handleLogOut() {
        do {
            try Auth.auth().signOut()
                print("Logged out")
        } catch let error {
                debugPrint(error.localizedDescription)
        }
        
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
