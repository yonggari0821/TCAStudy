import SwiftUI

struct FavoritePrimesView: View {
    @ObservedObject var counter: Counter
    
    var body: some View {
        List {
            ForEach(counter.favoritePrimes, id: \.self) { prime in
                Text("\(prime)")
            }
            .onDelete(perform: { indexSet in
                self.counter.favoritePrimes.remove(atOffsets: indexSet)
            })
        }
        .navigationBarTitle(Text("Favorite Primes"))
    }
}

