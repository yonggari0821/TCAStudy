//
//  ContentView.swift
//  TCA_Counter_App
//
//  Created by 안상준 on 8/15/24.
//

import SwiftUI

class Counter: ObservableObject {
    @Published
    var count: Int = 0
    
    @Published
    var favoritePrimes: [Int] = []
}

struct ContentView: View {
    @ObservedObject var counter = Counter()
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: CounterView(counter: counter)) {
//                NavigationLink(destination: CounterView(counter: counter)) { // 방법 3시에 이 줄로 변경
                    Text("Counter")
                }
                NavigationLink(destination: FavoritePrimesView(counter: counter)) {
                    Text("Favorite Primes")
                }
            }
            .navigationBarTitle("상태관리")
        }
    }
}
