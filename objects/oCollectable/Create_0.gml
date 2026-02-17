
// Properties
itemId = ""; // To be set by child objects
pickupRange = 20;
amount = 1;

/// @function OnCollect()
/// @description Virtual method called when item is collected. Override in children.
OnCollect = function() {
    // Default: do nothing
}
