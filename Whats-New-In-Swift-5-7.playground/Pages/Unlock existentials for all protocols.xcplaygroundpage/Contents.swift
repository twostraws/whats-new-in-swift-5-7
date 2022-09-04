/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# Unlock existentials for all protocols

[SE-0309](https://github.com/apple/swift-evolution/blob/main/proposals/0309-unlock-existential-types-for-all-protocols.md) significantly loosens Swift’s ban on using protocols as types when they have `Self` or associated type requirements, moving to a model where only specific properties or methods are off limits based on what they do.

In simple terms, this means the following code becomes legal:
*/
let firstName: any Equatable = "Paul"
let lastName: any Equatable = "Hudson"
/*:
`Equatable` is a protocol with `Self` requirements, which means it provides functionality that refers to the specific type that adopts it. For example, `Int` conforms to `Equatable`, so when we say `4 == 4` we’re actually running a function that accepts two integers and returns true if they match.

Swift *could* implement this functionality using a function similar to `func ==(first: Int, second: Int) -> Bool`, but that wouldn’t scale well – they would need to write dozens of such functions to handle Booleans, strings, arrays, and so on. So, instead the `Equatable` protocol has a requirement like this: `func ==(lhs: Self, rhs: Self) -> Bool`. In English, that means “you need to be able to accept two instances of the same type and tell me if they are the same.” That might be two integers, two strings, two Booleans, or two of any other type that conforms to `Equatable`.

To avoid this problem and similar ones, any time `Self` appeared in a protocol before Swift 5.7 the compiler would simply not allow us to use it in code such as this:
*/
let tvShow: [any Equatable] = ["Brooklyn", 99]
/*:
From Swift 5.7 onwards, this code *is* allowed, and now the restrictions are pushed back to situations where you attempt to use the type in a place where Swift must actually enforce its restrictions. This means we *can’t* write `firstName == lastName` because as I said `==` must be sure it has two instances of the same type in order to work, and by using `any Equatable` we’re hiding the exact types of our data.

However, what we have gained is the ability to do runtime checks on our data to identify specifically what we’re working with. In the case of our mixed array, we could write this:
*/
for item in tvShow {
    if let item = item as? String {
        print("Found string: \(item)")
    } else if let item = item as? Int {
        print("Found integer: \(item)")
    }
}
/*:
Or in the case of our two strings, we could use this:
*/
if let firstName = firstName as? String, let lastName = lastName as? String {
    print(firstName == lastName)
}
/*:
The key to understanding what this change does is remembering that it allow us to use these protocol more freely, as long as we don’t do anything that specifically needs to knows about the internals of the type. So, we could write code to check whether all items in any sequence conform to the `Identifiable` protocol:
*/
func canBeIdentified(_ input: any Sequence) -> Bool {
    input.allSatisfy { $0 is any Identifiable }
}
/*:

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/