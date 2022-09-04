/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# Structural opaque result types

[SE-0328](https://github.com/apple/swift-evolution/blob/main/proposals/0328-structural-opaque-result-types.md) widens the range of places that opaque result types can be used.

For example, we can now return more than one opaque type at a time:
*/
import SwiftUI

func showUserDetails() -> (some Equatable, some Equatable) {
    (Text("Username"), Text("@twostraws"))
}
/*:
We can also return opaque types:
*/
func createUser() -> [some View] {
    let usernames = ["@frankefoster", "@mikaela__caron", "@museumshuffle"]
    return usernames.map(Text.init)
}
/*:
Or even send back a function that itself returns an opaque type when called:
*/
func createDiceRoll() -> () -> some View {
    return {
        let diceRoll = Int.random(in: 1...6)
        return Text(String(diceRoll))
    }
}
/*:
So, this is another great example of Swift harmonizing the language to make things consistently possible.

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/