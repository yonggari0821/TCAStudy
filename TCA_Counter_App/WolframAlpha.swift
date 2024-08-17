//
//  WolframAlpha.swift
//  TCA_Counter_App
//
//  Created by 안상준 on 8/17/24.
//

import Foundation

struct WolframAlphaResult: Decodable {
  let queryresult: QueryResult

  struct QueryResult: Decodable {
    let pods: [Pod]

    struct Pod: Decodable {
      let primary: Bool?
      let subpods: [SubPod]

      struct SubPod: Decodable {
        let plaintext: String
      }
    }
  }
}

let wolframAlphaApiKey = Bundle.main.infoDictionary?["ApiKey"] as? String ?? "" // info.plist에서 가져옴

func wolframAlpha(
  query: String,
  callback: @escaping (WolframAlphaResult?) -> Void
) -> Void {
  var components = URLComponents(
    string: "https://api.wolframalpha.com/v2/query"
  )!
    print("wolframAlphaApiKey = \(wolframAlphaApiKey)")
  components.queryItems = [
    URLQueryItem(name: "input", value: query),
    URLQueryItem(name: "format", value: "plaintext"),
    URLQueryItem(name: "output", value: "JSON"),
    URLQueryItem(name: "appid", value: wolframAlphaApiKey),
  ]
    
print(components)
    
  URLSession.shared.dataTask(
    with: components.url(relativeTo: nil)!
  ) { data, response, error in
    callback(
      data.flatMap {
        try? JSONDecoder().decode(WolframAlphaResult.self, from: $0)
      }
    )
  }
  .resume()
}

func nthPrime(
  _ n: Int, callback: @escaping (Int?) -> Void
) -> Void {
  wolframAlpha(query: "prime \(n)") { result in
    callback(
      result
        .flatMap {
          $0.queryresult
            .pods
            .first(where: { $0.primary == .some(true) })?
            .subpods
            .first?
            .plaintext
        }
        .flatMap(Int.init)
    )
  }
}

func nthPrimeRetry(
    _ n: Int,
    retries: Int = 5,
    delay: TimeInterval = 1.0,
    timeout: TimeInterval = 5.0,
    callback: @escaping (Int?) -> Void
) {
    let startTime = Date()
    
    func attempt() {
        nthPrime(n) { prime in
            if prime != nil || retries <= 0 || Date().timeIntervalSince(startTime) > timeout {
                callback(prime)
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    attempt()
                }
            }
        }
    }
    
    attempt()
}
