/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# Concurrency in top-level code

[SE-0343](https://github.com/apple/swift-evolution/blob/main/proposals/0343-top-level-concurrency.md) upgrades Swift’s support for top-level code – think main.swift in a macOS Command Line Tool project – so that it supports concurrency out of the box. This is one of those changes that might seem trivial on the surface, but [took](https://github.com/apple/swift/pull/40998) a lot of [work](https://github.com/apple/swift/pull/41061) to make [happen](https://github.com/apple/swift/pull/40963).

In practice, it means you can write code like this directly into your main.swift files:
*/
import Foundation
let url = URL(string: "https://hws.dev/readings.json")!
let (data, _) = try await URLSession.shared.data(from: url)
let readings = try JSONDecoder().decode([Double].self, from: data)
print("Found \(readings.count) temperature readings")
/*:
Previously, we had to create a new `@main` struct that had an asynchronous `main()` method, so this new, simpler approach is a big improvement.

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/