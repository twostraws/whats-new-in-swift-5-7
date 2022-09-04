/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# Implicitly opened existentials 

[SE-0352](https://github.com/apple/swift-evolution/blob/main/proposals/0352-implicit-open-existentials.md) allows Swift to call generic functions using a protocol in many situations, which removes a somewhat odd barrier that existed previously.

As an example, here’s a simple generic function that is able to work with any kind of `Numeric` value:
    
*/
func double<T: Numeric>(_ number: T) -> T {
    number * 2
}
/*:
If we call that directly, e.g. `double(5)`, then the Swift compiler can choose to *specialize* the function – to effectively create a version that accepts an `Int` directly, for performance reasons.

However, what SE-0352 does is allow that function to be callable when all we know is that our data conforms to a protocol, like this:
    
*/
let first = 1
let second = 2.0
let third: Float = 3
    
let numbers: [any Numeric] = [first, second, third]
    
for number in numbers {
    print(double(number))
}
/*:
Swift calls these *existential types*: the actual data type you’re using sits inside a box, and when we call methods on that box Swift understands it should implicitly call the method on the data *inside* the box. SE-0352 extends this same power to function calls too: the `number` value in our loop is an existential type (a box containing either an `Int`, `Double`, or `Float`), but Swift is able to pass it in to the generic `double()` function by sending in the value inside the box.

There are limits to what this capable of, and I think they are fairly self explanatory. For example, this kind of code won’t work:
*/
func areEqual<T: Numeric>(_ a: T, _ b: T) -> Bool {
    a == b
}
    
print(areEqual(numbers[0], numbers[1]))
/*:
Swift isn’t able to statically verify (i.e., at compile time) that both values are things that can be compared using `==`, so the code simply won’t build.

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/