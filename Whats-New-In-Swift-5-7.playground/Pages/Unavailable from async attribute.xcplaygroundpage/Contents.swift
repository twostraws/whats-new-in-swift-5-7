/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)
# Unavailable from async attribute

[SE-0340](https://github.com/apple/swift-evolution/blob/main/proposals/0340-swift-noasync.md) partially closes a potentially risky situation in Swift’s concurrency model, by allowing us to mark types and functions as being unavailable in asynchronous contexts because using them in such a way could cause problems. Unless you’re using thread-local storage, locks, mutexes, or semaphores, it’s unlikely you’ll use this attribute yourself, but you might *call* code that uses it so it’s worth at least being aware it exists.

To mark something as being unavailable in async context, use `@available` with your normal selection of platforms, then add `noasync` to the end. For example, we might have a function that works on any platform, but might cause problems when called asynchronously, so we’d mark it like this:
*/
@available(*, noasync)
func doRiskyWork() {
    
}
/*:
We can then call that from a regular synchronous function as normal:
*/
func synchronousCaller() {
    doRiskyWork()
}
/*:
However, Swift will issue an error if we attempted the same from an asynchronous function, so this code will *not* work:
*/
func asynchronousCaller() async {
    doRiskyWork()
}
/*:
This protection is an improvement over the current situation, but should not be leaned on too heavily because it doesn’t stop us from nesting the call to our `noasync` function, like this:
*/
func sneakyCaller() async {
    synchronousCaller()
}
/*:
That runs in an async context, but calls a *synchronous* function, which can in turn call the `noasync` function `doRiskyWork()`. 

So, `noasync` is an improvement, but you still need to be careful when using it. Fortunately, as the Swift Evolution proposal says, “the attribute is expected to be used for a fairly limited set of specialized use-cases” – there’s a good chance you might never come across code that uses it.

&nbsp;

[< Previous](@previous)           [Home](Introduction)
*/