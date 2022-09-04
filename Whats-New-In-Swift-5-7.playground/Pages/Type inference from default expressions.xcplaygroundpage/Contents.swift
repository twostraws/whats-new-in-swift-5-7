/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# Type inference from default expressions

[SE-0347](https://github.com/apple/swift-evolution/blob/main/proposals/0347-type-inference-from-default-exprs.md) expands Swift ability to use default values with generic parameter types. What it allows seems quite niche, but it does matter: if you have a generic type or function you can now provide a concrete type for a default expression, in places where previously Swift would have thrown up a compiler error.

As an example, we might have a function that returns `count` number of random items from any kind of sequence:
*/
func drawLotto1<T: Sequence>(from options: T, count: Int = 7) -> [T.Element] {
    Array(options.shuffled().prefix(count))
}
/*:
That allows us to run a lottery using any kind of sequence, such as an array of names or an integer range:
*/
print(drawLotto1(from: 1...49))
print(drawLotto1(from: ["Jenny", "Trixie", "Cynthia"], count: 2))
/*:
SE-0347 extends this to allow us to provide a concrete type as default value for the `T` parameter in our function, allowing us to keep the flexibility to use string arrays or any other kind of collection, while also defaulting to the range option that we want most of the time:
*/
func drawLotto2<T: Sequence>(from options: T = 1...49, count: Int = 7) -> [T.Element] {
    Array(options.shuffled().prefix(count))
}
/*:
And now we can call our function either with a custom sequence, or let the default take over:
*/
print(drawLotto2(from: ["Jenny", "Trixie", "Cynthia"], count: 2))
print(drawLotto2())
/*:

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/