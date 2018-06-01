# SpotX SDK
--

### Setup

When developing our SDK we use CocoaPods to pull in our *optional* dependencies (currently only MoPub). We do this so that the compiler can resolve all of the [conditionally] available symbols.

**IMPORTANT:** The `SpotX` target uses weak (optional) linking to link to the pods library.

**IMPORTANT:** Do not use Objective C categories in the SDK code! The `-all_load` and `-ObjC` linker flags required to load the categories will load **all** of the classes and categories in the SDK, including those with unmet dependencies. This will crash.


```
> bundle install
> bundle exec pod install
> open SpotX.xcworkspace
```
