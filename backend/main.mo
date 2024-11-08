import Hash "mo:base/Hash";

import Text "mo:base/Text";
import HashMap "mo:base/HashMap";
import Iter "mo:base/Iter";
import Array "mo:base/Array";

actor {
  // Stable storage for guide sections
  private stable var guideEntriesStable : [(Text, Text)] = [];
  
  // HashMap to store guide content
  private var guideContent = HashMap.HashMap<Text, Text>(10, Text.equal, Text.hash);

  // Initialize default content
  private func initializeContent() {
    let defaultContent = [
      ("talents", "Recommended talents for Brewmaster Monk:\n- Tier 1: Chi Wave\n- Tier 2: Chi Torpedo\n- Tier 3: Spear Hand Strike"),
      ("stats", "1. Versatility\n2. Mastery\n3. Critical Strike\n4. Haste"),
      ("single_target", "1. Keg Smash on cooldown\n2. Breath of Fire\n3. Blackout Kick\n4. Tiger Palm as filler"),
      ("aoe", "1. Keg Smash\n2. Breath of Fire\n3. Rushing Jade Wind\n4. Spinning Crane Kick"),
      ("cooldowns", "1. Celestial Brew - 1 min cooldown\n2. Purifying Brew - 2 charges\n3. Fortifying Brew - 7 min cooldown"),
      ("utilities", "1. Ring of Peace\n2. Leg Sweep\n3. Transcendence\n4. Roll")
    ];

    for ((k, v) in defaultContent.vals()) {
      guideContent.put(k, v);
    };
  };

  // System functions for upgrades
  system func preupgrade() {
    guideEntriesStable := Iter.toArray(guideContent.entries());
  };

  system func postupgrade() {
    guideContent := HashMap.fromIter<Text, Text>(guideEntriesStable.vals(), 10, Text.equal, Text.hash);
    if (guideContent.size() == 0) {
      initializeContent();
    };
  };

  // Query calls
  public query func getSection(section : Text) : async ?Text {
    guideContent.get(section)
  };

  public query func getAllSections() : async [(Text, Text)] {
    Iter.toArray(guideContent.entries())
  };

  // Update calls
  public func updateSection(section : Text, content : Text) : async () {
    guideContent.put(section, content);
  };
}
