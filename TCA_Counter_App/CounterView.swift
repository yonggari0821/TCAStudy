//
//  CounterView.swift
//  TCA_Counter_App
//
//  Created by 안상준 on 8/15/24.
//

import SwiftUI
import Combine

class Counter: ObservableObject {
    @Published
    var count: Int = 0
    
    @Published
    var favoritePrimes: [Int] = []
}

struct CounterView: View {
    
    // 방법 1 State 활용
//    @State var count: Int = 0 // 해당 View에서만 유지됨. 다른 View를 다녀오면 초기화
//    
//    var body: some View {
//        VStack {
//          HStack {
//              Button(action: {self.count-=1}) {
//              Text("-")
//            }
//              Text("\(self.count)")
//            Button(action: {self.count+=1}) {
//              Text("+")
//            }
//          }
//          Button(action: {}) {
//            Text("Is this prime?")
//          }
//          Button(action: {}) {
//            Text("What is the 0th prime?")
//          }
//        }
//    }
    
    // 방법 2 ObservableObject 활용
    @ObservedObject var counter = Counter() // 여러 뷰에서 공유 가능함!
//    @StateObject var counter = Counter() // 여러 뷰에서 공유 가능함!
    
    @State var isPrimeModalShown = false
    
    @State private var isLoading = false
    @State var showAlert = false
    @State var alertNthPrime: Int?
 
    var body: some View {
        VStack {
          HStack {
              Button(action: {counter.count-=1}) {
              Text("-")
            }
              Text("\(counter.count)")
              Button(action: {counter.count+=1}) {
              Text("+")
            }
          }
          Button(action: {isPrimeModalShown = true}) {
            Text("Is this prime?")
          }
        Button(action: {
            if !self.isLoading {
                self.isLoading = true
                nthPrimeRetry(counter.count, retries: 3, delay: 2.0, timeout: 5.0) { prime in
                    self.alertNthPrime = prime
                    self.isLoading = false
                    self.showAlert = true
                }
            }
        }) {
          Text("What's the \(ordinal(counter.count)) prime?")
        }
        .disabled(isLoading)
        }
        .font(.title)
        .navigationBarTitle("Counter")
        .fullScreenCover(isPresented: $isPrimeModalShown) {
            MyCustomView(counter: counter, showingSheet: $isPrimeModalShown)
                .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height * 0.6)
                .background(Color.gray)
        }
        .alert(isPresented: $showAlert) {
          if let prime = alertNthPrime {
            return Alert(
              title: Text("The \(ordinal(counter.count)) prime is \(prime)"),
              dismissButton: .default(Text("OK"))
            )
          } else {
            return Alert(
              title: Text("Error"),
              message: Text("Could not retrieve the prime number. Please try again."),
              dismissButton: .default(Text("OK"))
            )
          }
        }
//        .alert(isPresented: $showAlert) {
//            Alert(
//                title: Text("The \(ordinal(counter.count)) prime is \(alertNthPrime ?? 0)"),
//                dismissButton: .default(Text("OK"))
//            )
//        }
        
        
    }
}

func ordinal(_ number: Int) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .ordinal
    return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
}

struct MyCustomView: View {
    
    private func isPrime (_ p: Int) -> Bool {
      if p <= 1 { return false }
      if p <= 3 { return true }
      for i in 2...Int(sqrtf(Float(p))) {
        if p % i == 0 { return false }
      }
      return true
    }
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var counter: Counter
    @Binding var showingSheet: Bool

    var body: some View {
        if isPrime(self.counter.count) {
          Text("\(self.counter.count) is prime 🎉")
        if self.counter.favoritePrimes.contains(self.counter.count) {
            Button(action: {
              self.counter.favoritePrimes.removeAll(where: {
                $0 == self.counter.count
              })
            }) {
            Text("Remove from favorite primes")
          }
        } else {
            Button(action: {
              self.counter.favoritePrimes.append(self.counter.count)
            }) {
            Text("Save to favorite primes")
          }
        }
        } else {
          Text("\(self.counter.count) is not prime :(")
        }
        
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("취소")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .frame(maxWidth: UIScreen.main.bounds.width * 0.9, alignment: .center)
    }
}
