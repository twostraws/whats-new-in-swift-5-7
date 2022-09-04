/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# Opaque parameter declarations

[SE-0341](https://github.com/apple/swift-evolution/blob/main/proposals/0341-opaque-parameters.md) unlocks the ability to use `some` with parameter declarations in places where simpler generics were being used.

As an example, if we wanted to write a function that checks whether an array is sorted, Swift 5.7 and later allow us to write this:
*/
func isSorted(array: [some Comparable]) -> Bool {
    array == array.sorted()
}
/*:
The `[some Comparable]` parameter type means this function works with an array containing elements of one type that conforms to the `Comparable` protocol, which is syntactic sugar for the equivalent generic code:
*/
func isSortedOld<T: Comparable>(array: [T]) -> Bool {
    array == array.sorted()
}
/*:
Of course, we could also write the even longer constrained extension:
*/
extension Array where Element: Comparable {
    func isSorted() -> Bool {
        self == self.sorted()
    }
}
/*:
This simplified generic syntax does mean we no longer have the ability to add more complex constraints our types, because there is no specific name for the synthesized generic parameter.

**Important:** You can switch between explicit generic parameters and this new simpler syntax without breaking your API.

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/