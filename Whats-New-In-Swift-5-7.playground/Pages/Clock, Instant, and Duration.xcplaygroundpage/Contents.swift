/*:


&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
# Clock, Instant, and Duration

[SE-0329](https://github.com/apple/swift-evolution/blob/main/proposals/0329-clock-instant-duration.md) introduces a new, standardized way of referring to times and durations in Swift. As the name suggests, it’s broken down into three main components:

- Clocks represent a way of measuring time passing. There are two built in: the continuous clock keeps incrementing time even when the system is asleep, and the suspending clock does not.
- Instants represent an exact moment in time.
- Durations represent how much time elapsed between two instants.

The most immediate application of this for many people will be the newly upgraded `Task` API, which can now specify sleep amounts in much more sensible terms than nanoseconds:
*/
try await Task.sleep(until: .now +  .seconds(1), clock: .continuous)
/*:
This newer API also comes with the benefit of being able to specify tolerance, which allows the system to wait a little beyond the sleep deadline in order to maximize power efficiency. So, if we wanted to sleep for at least 1 seconds but would be happy for it to last up to 1.5 seconds in total, we would write this:
*/
try await Task.sleep(until: .now + .seconds(1), tolerance: .seconds(0.5), clock: .continuous)
/*:
**Tip:** This tolerance is only in *addition* to the default sleep amount – the system won’t end the sleep before at least 1 second has passed.

Although it hasn’t happened yet, it looks like the older nanoseconds-based API will be deprecated in the near future.

Clocks are also useful for measuring some specific work, which is helpful if you want to show your users something like how long a file export took:
*/
let clock = ContinuousClock()

let time = clock.measure {
    // complex work here
}

print("Took \(time.components.seconds) seconds")
/*:

&nbsp;

[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/