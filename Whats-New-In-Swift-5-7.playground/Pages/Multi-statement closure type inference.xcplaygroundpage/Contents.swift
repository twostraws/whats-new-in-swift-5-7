/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# Multi-statement closure type inference

[SE-0326](https://github.com/apple/swift-evolution/blob/main/proposals/0326-extending-multi-statement-closure-inference.md) dramatically improves Swift’s ability to use parameter and type inference for closures, meaning that many places where we had to specify explicit input and output types can now be removed.

Previously Swift really struggled for any closures that weren’t trivial, but from Swift 5.7 onwards we can now write code like this:
*/
let scores = [100, 80, 85]
    
let results = scores.map { score in
    if score >= 85 {
        return "\(score)%: Pass"
    } else {
        return "\(score)%: Fail"
    }
}
/*:
Prior to Swift 5.7, we needed to specify the return type explicitly, like this:
*/
let oldResults = scores.map { score -> String in
    if score >= 85 {
        return "\(score)%: Pass"
    } else {
        return "\(score)%: Fail"
    }
}
/*:

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/