import Char "mo:base/Char";
import Hash "mo:base/Hash";
import Int "mo:base/Int";
import Stack "mo:base/Stack";

import Text "mo:base/Text";
import HashMap "mo:base/HashMap";
import Iter "mo:base/Iter";
import Array "mo:base/Array";

actor {
  private stable var guideEntriesStable : [(Text, Text)] = [];
  private var guideContent = HashMap.HashMap<Text, Text>(10, Text.equal, Text.hash);

  private func initializeContent() {
    let defaultContent = [
      ("talents", "Essential Talents for Brewmaster Monk:\n- Improved Vivify\n- Chi Wave\n- Tiger's Lust\n- Ring of Peace\n- Summon Black Ox Statue\n- Improved Celestial Brew\n- Bob and Weave\n- Improved Purifying Brew\n- Celestial Flames\n- Blackout Combo\n- High Tolerance\n- Exploding Keg\n\nClass Tree Highlights:\n- Generous Pour\n- Grace of the Crane\n- Fast Feet\n- Improved Roll\n- Close to Heart"),
      
      ("stats", "1. Stamina - Primary defensive stat\n2. Armor - Baseline physical damage reduction\n3. Agility - Increases attack power and armor\n4. Secondary Stats Priority:\n- Versatility - Best overall defensive and offensive stat\n- Mastery - Increases Stagger effectiveness\n- Critical Strike - Improves healing and damage\n- Haste - Reduces ability cooldowns and GCD"),
      
      ("single_target", "Primary Rotation:\n1. Keep Blackout Kick on cooldown (with Blackout Combo talent)\n2. Keg Smash on cooldown\n3. Breath of Fire when available\n4. Purifying Brew at high Stagger levels\n5. Celestial Brew for active mitigation\n6. Tiger Palm as filler\n\nKey Notes:\n- Maintain 100% uptime on Shuffle\n- Use Purifying Brew at Yellow or Red Stagger\n- Weave Celestial Brew between damage spikes"),
      
      ("aoe", "AOE Priority:\n1. Keg Smash on cooldown (hits up to 5 targets)\n2. Breath of Fire (especially with Charred Passions)\n3. Spinning Crane Kick for 3+ targets\n4. Rushing Jade Wind maintenance\n5. Exploding Keg for burst AOE threat\n\nKey Notes:\n- Maintain Shuffle uptime\n- Position mobs in Breath of Fire cone\n- Use Bonedust Brew to amplify AOE damage\n- Black Ox Statue for additional threat generation"),
      
      ("cooldowns", "Defensive Cooldowns:\n1. Fortifying Brew - 7min cooldown\n- 20% damage reduction\n- 20% max health increase\n- Use for heavy damage phases\n\n2. Celestial Brew - 1min cooldown\n- Absorb shield based on Purified damage\n- Stack Purifying Brew before use\n\n3. Purifying Brew - 2 charges\n- Removes 50% of Staggered damage\n- Use at Yellow/Red Stagger\n\n4. Zen Meditation - 5min cooldown\n- 60% damage reduction\n- Breaks on movement/attacks"),
      
      ("utilities", "Utility Abilities:\n1. Ring of Peace\n- Area control\n- Mob positioning\n- Raid utility for mechanics\n\n2. Leg Sweep\n- AOE stun\n- Interrupt dangerous casts\n\n3. Transcendence\n- Position management\n- Cheese mechanics\n- Quick repositioning\n\n4. Roll/Chi Torpedo\n- Mobility\n- Mechanic dodging\n\n5. Provoke\n- Long-range taunt\n- Tank swap mechanics\n\n6. Spear Hand Strike\n- Interrupt\n- 15s cooldown")
    ];

    for ((k, v) in defaultContent.vals()) {
      guideContent.put(k, v);
    };
  };

  system func preupgrade() {
    guideEntriesStable := Iter.toArray(guideContent.entries());
  };

  system func postupgrade() {
    guideContent := HashMap.fromIter<Text, Text>(guideEntriesStable.vals(), 10, Text.equal, Text.hash);
    if (guideContent.size() == 0) {
      initializeContent();
    };
  };

  public query func getSection(section : Text) : async ?Text {
    guideContent.get(section)
  };

  public query func getAllSections() : async [(Text, Text)] {
    Iter.toArray(guideContent.entries())
  };

  public func updateSection(section : Text, content : Text) : async () {
    guideContent.put(section, content);
  };
}
