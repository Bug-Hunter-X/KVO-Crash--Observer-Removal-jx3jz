In Objective-C, a subtle bug can arise from the interaction between KVO (Key-Value Observing) and memory management, specifically when an observed object is deallocated. If an observer isn't removed before the observed object is deallocated, sending a KVO notification to a deallocated observer leads to a crash. This is because the observer's dealloc method might already have executed, leaving the notification mechanism with an invalid pointer.  Here's an example:

```objectivec
@interface ObservedObject : NSObject
@property (nonatomic, strong) NSString *observedProperty;
@end

@implementation ObservedObject
- (void)setObservedProperty:(NSString *)observedProperty {
    [self willChangeValueForKey:@"observedProperty"];
    _observedProperty = observedProperty;
    [self didChangeValueForKey:@"observedProperty"];
}
@end

@interface ObserverObject : NSObject
@end

@implementation ObserverObject
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    // Handle the change
}
@end

int main() {
    ObservedObject *observed = [[ObservedObject alloc] init];
    ObserverObject *observer = [[ObserverObject alloc] init];
    [observed addObserver:observer forKeyPath:@"observedProperty" options:NSKeyValueObservingOptionNew context:nil];
    observed.observedProperty = "New Value";

    // Missing removeObserver before releasing the observed object
    [observed release]; // Or equivalent for ARC
    [observer release]; // Or equivalent for ARC
    return 0;
}
```