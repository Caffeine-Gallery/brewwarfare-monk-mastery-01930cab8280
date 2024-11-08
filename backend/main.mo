import Hash "mo:base/Hash";
import Int "mo:base/Int";
import List "mo:base/List";
import Order "mo:base/Order";
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
      ("talents", "Essential Talents for Brewmaster Monk:\n\nClass Tree:\n- Improved Vivify\n- Chi Wave\n- Tiger's Lust\n- Ring of Peace\n- Summon Black Ox Statue\n- Improved Celestial Brew\n- Bob and Weave\n- Improved Purifying Brew\n- Celestial Flames\n- Blackout Combo\n- High Tolerance\n- Exploding Keg\n\nMonk Tree Highlights:\n- Generous Pour\n- Grace of the Crane\n- Fast Feet\n- Improved Roll\n- Close to Heart\n- Touch of Death\n- Detox\n- Healing Elixir\n\nKey Talents Explanation:\n- Blackout Combo: Essential for single-target damage and mitigation\n- High Tolerance: Provides consistent damage reduction\n- Exploding Keg: Strong AOE damage and defensive cooldown"),
      
      ("stats", "Stat Priority Guide:\n\nPrimary Stats:\n1. Stamina - Your most important defensive stat\n2. Armor - Base physical damage reduction\n3. Agility - Increases attack power and armor\n\nSecondary Stats (in order):\n1. Versatility\n- Increases damage done\n- Reduces damage taken\n- Best overall defensive stat\n\n2. Mastery\n- Increases Stagger effectiveness\n- Improves Elusive Brawler dodge chance\n\n3. Critical Strike\n- Improves healing received\n- Increases damage output\n- Affects Celestial Fortune healing\n\n4. Haste\n- Reduces global cooldown\n- Faster energy regeneration\n- More frequent Keg Smash casts\n\nGearing Strategy:\n- Aim for balanced secondary stats\n- Prioritize item level over perfect stats\n- Keep Versatility and Mastery roughly equal"),
      
      ("single_target", "Single Target Rotation:\n\nPriority List:\n1. Maintain Shuffle (100% uptime required)\n2. Keg Smash on cooldown\n3. Blackout Kick (with Blackout Combo)\n4. Breath of Fire\n5. Tiger Palm as filler\n\nDefensive Priorities:\n1. Keep Shuffle active at all times\n2. Use Purifying Brew at:\n   - Yellow Stagger: 50%+ health\n   - Red Stagger: Immediate priority\n3. Celestial Brew between damage spikes\n\nAdvanced Tips:\n- Pool energy for Keg Smash\n- Track Shuffle duration\n- Use Weapons of Order on pull\n- Save Purifying Brew charges for heavy damage\n\nOpener Sequence:\n1. Weapons of Order\n2. Keg Smash\n3. Breath of Fire\n4. Blackout Kick\n5. Establish rotation"),
      
      ("aoe", "AOE Rotation Guide:\n\nPriority for 3+ Targets:\n1. Keg Smash on cooldown\n2. Breath of Fire\n3. Spinning Crane Kick\n4. Rushing Jade Wind\n5. Exploding Keg\n\nKey Mechanics:\n- Position mobs for Breath of Fire cone\n- Maintain Shuffle uptime\n- Use Black Ox Statue for threat\n- Bonedust Brew for damage amp\n\nCooldown Usage:\n1. Weapons of Order for burst\n2. Invoke Niuzao for damage\n3. Exploding Keg for control\n\nThreat Management:\n- Tab target for Keg Smash\n- Use Provoke strategically\n- Position Black Ox Statue centrally\n\nAdvanced Techniques:\n- Kite when necessary\n- Stack mobs efficiently\n- Use Ring of Peace for positioning"),
      
      ("cooldowns", "Defensive Cooldowns Guide:\n\nMajor Cooldowns:\n1. Fortifying Brew (7 min)\n- 20% damage reduction\n- 20% health increase\n- Use for heavy damage phases\n- Best paired with other defensives\n\n2. Celestial Brew (1 min)\n- Absorb shield scaling with Purified damage\n- Stack Purifying Brew before use\n- Save for predictable damage\n\n3. Zen Meditation (5 min)\n- 60% damage reduction\n- Breaks on movement/attacks\n- Use for magic damage spikes\n\nRotational Defensives:\n1. Purifying Brew\n- 2 charges\n- Removes 50% Stagger\n- Use at Yellow/Red Stagger\n\n2. Dampen Harm\n- 45% reduction to big hits\n- Good for predictable damage\n\nEmergency Buttons:\n1. Healing Elixir\n2. Health Stone\n3. Healthstone"),
      
      ("utilities", "Utility Abilities Guide:\n\nMovement Abilities:\n1. Roll/Chi Torpedo\n- Quick positioning\n- Dodge mechanics\n- 2 charges baseline\n\n2. Transcendence\n- Place in safe spot\n- Transfer for mechanics\n- 45 sec cooldown\n\nCrowd Control:\n1. Ring of Peace\n- Displacement tool\n- Interrupt casts\n- Position control\n\n2. Leg Sweep\n- AOE stun (5 yards)\n- 5 second duration\n- 60 sec cooldown\n\nTank Utilities:\n1. Provoke\n- 40 yard range\n- Tank swaps\n- Snap threat\n\n2. Spear Hand Strike\n- Interrupt\n- 15 sec cooldown\n- Critical for casters\n\nRaid Utilities:\n1. Mystic Touch\n- 5% physical damage\n- Raid-wide benefit\n\n2. Summon Black Ox Statue\n- Additional threat\n- Mob positioning")
    ];

    for ((k, v) in defaultContent.vals()) {
      guideContent.put(k, v);
    };
  };

  // Initialize content immediately
  initializeContent();

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
