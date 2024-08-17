//
//  ContentView.swift
//  TCA_Counter_App
//
//  Created by 안상준 on 8/15/24.
//

import SwiftUI

struct ContentView: View {
//    @StateObject var counter = Counter() // 방법 3시에만 활성화
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: CounterView()) {
//                NavigationLink(destination: CounterView(counter: counter)) { // 방법 3시에 이 줄로 변경
                    Text("Counter")
                }
                NavigationLink(destination: EmptyView()) {
                    Text("Favorite Primes")
                }
            }
            .navigationBarTitle("상태관리")
        }
    }
}
