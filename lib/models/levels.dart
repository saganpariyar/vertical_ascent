import 'package:flutter/material.dart';
import 'game_models.dart';

class VerticalLevels {
  static List<VerticalLevelDefinition> buildAll() => [
        // Level 1: Starter Chimney
        const VerticalLevelDefinition(
          levelNumber: 1,
          title: 'Starter Chimney',
          subtitle: 'Launch Up & Haul Heavy',
          hint: 'Launch Light up the narrow shaft (hold LAUNCH or wall-kick), lock onto the top HOIST RING, then HAUL Heavy up!',
          worldSize: Size(700, 1140),
          lightSpawn: Offset(390, 1020),
          heavySpawn: Offset(310, 1015),
          goalZone: Rect.fromLTWH(430, 120, 100, 100),
          parSeconds: 26,
          blocks: [
            ShaftBlock(Rect.fromLTWH(0, 1060, 700, 80)), // ground floor
            ShaftBlock(Rect.fromLTWH(0, 0, 210, 1060)), // left shaft wall
            ShaftBlock(Rect.fromLTWH(490, 220, 210, 840)), // right shaft wall below top landing
            ShaftBlock(Rect.fromLTWH(490, 220, 210, 32)), // top exit shelf
            ShaftBlock(Rect.fromLTWH(560, 0, 140, 220)), // far right wall
          ],
          steamJets: [],
          anchors: [
            HoistAnchorPoint(Offset(350, 150), label: 'TOP HOIST'),
          ],
          gates: [],
          corePositions: [
            Offset(350, 800),
            Offset(350, 520),
            Offset(350, 260),
          ],
        ),

        // Level 2: Wall-Kick Spire
        const VerticalLevelDefinition(
          levelNumber: 2,
          title: 'Wall-Kick Spire',
          subtitle: 'Bounce Off Narrow Shaft Walls',
          hint: 'Wall-kick Light between left and right ledges to climb above the baffles, anchor high, and guide Heavy around them!',
          worldSize: Size(700, 1280),
          lightSpawn: Offset(390, 1160),
          heavySpawn: Offset(305, 1155),
          goalZone: Rect.fromLTWH(130, 130, 100, 100),
          parSeconds: 34,
          blocks: [
            ShaftBlock(Rect.fromLTWH(0, 1200, 700, 80)),
            ShaftBlock(Rect.fromLTWH(0, 230, 110, 970)), // left wall below top shelf
            ShaftBlock(Rect.fromLTWH(0, 230, 250, 36)), // top left goal platform
            ShaftBlock(Rect.fromLTWH(580, 0, 120, 1200)), // right wall
            // Staggered baffles inside shaft
            ShaftBlock(Rect.fromLTWH(110, 880, 210, 32)),
            ShaftBlock(Rect.fromLTWH(380, 620, 200, 32)),
            ShaftBlock(Rect.fromLTWH(110, 400, 190, 32)),
          ],
          steamJets: [],
          anchors: [
            HoistAnchorPoint(Offset(350, 180), label: 'SPIRE HOIST'),
          ],
          gates: [],
          corePositions: [
            Offset(450, 820),
            Offset(240, 560),
            Offset(350, 310),
          ],
        ),

        // Level 3: Steam Vent Shaft
        const VerticalLevelDefinition(
          levelNumber: 3,
          title: 'Steam Vent Shaft',
          subtitle: 'Time the Thermal Bursts',
          hint: 'Wait for steam vents to pause, rocket Light past them to the Hoist Ring, then haul Heavy cleanly between bursts!',
          worldSize: Size(700, 1320),
          lightSpawn: Offset(390, 1200),
          heavySpawn: Offset(310, 1195),
          goalZone: Rect.fromLTWH(450, 120, 100, 100),
          parSeconds: 38,
          blocks: [
            ShaftBlock(Rect.fromLTWH(0, 1240, 700, 80)),
            ShaftBlock(Rect.fromLTWH(0, 0, 200, 1240)),
            ShaftBlock(Rect.fromLTWH(500, 220, 200, 1020)),
            ShaftBlock(Rect.fromLTWH(430, 220, 270, 34)),
            ShaftBlock(Rect.fromLTWH(620, 0, 80, 220)),
          ],
          steamJets: [
            SteamJetHazard(
              zone: Rect.fromLTWH(205, 860, 175, 44),
              periodSeconds: 3.4,
              activeDuration: 1.25,
              phaseOffset: 0.0,
            ),
            SteamJetHazard(
              zone: Rect.fromLTWH(320, 540, 175, 44),
              periodSeconds: 3.4,
              activeDuration: 1.25,
              phaseOffset: 1.7,
            ),
          ],
          anchors: [
            HoistAnchorPoint(Offset(350, 160), label: 'VENT HOIST'),
          ],
          gates: [],
          corePositions: [
            Offset(435, 880),
            Offset(265, 560),
            Offset(350, 280),
          ],
        ),

        // Level 4: Weight-Gate Tower
        VerticalLevelDefinition(
          levelNumber: 4,
          title: 'Weight-Gate Tower',
          subtitle: 'Heavy Opens the Upper Hatch',
          hint: 'Anchor at Mid-Hoist first, haul Heavy onto the glowing Weight Plate to unlock the upper blast hatch, then climb to the summit!',
          worldSize: const Size(720, 1440),
          lightSpawn: const Offset(400, 1320),
          heavySpawn: const Offset(310, 1315),
          goalZone: const Rect.fromLTWH(470, 120, 100, 100),
          parSeconds: 48,
          blocks: const [
            ShaftBlock(Rect.fromLTWH(0, 1360, 720, 80)),
            ShaftBlock(Rect.fromLTWH(0, 0, 180, 1360)),
            ShaftBlock(Rect.fromLTWH(540, 220, 180, 1140)),
            ShaftBlock(Rect.fromLTWH(460, 220, 260, 32)),
            ShaftBlock(Rect.fromLTWH(640, 0, 80, 220)),
            // Mid platform with weight switch on left
            ShaftBlock(Rect.fromLTWH(180, 820, 210, 34)),
            // Upper divider beside gate
            ShaftBlock(Rect.fromLTWH(180, 560, 170, 34)),
          ],
          steamJets: const [],
          anchors: const [
            HoistAnchorPoint(Offset(455, 740), label: 'MID HOIST'),
            HoistAnchorPoint(Offset(370, 160), label: 'TOP HOIST'),
          ],
          gates: [
            WeightSwitchGate(
              switchPlate: const Rect.fromLTWH(200, 806, 95, 14),
              gateRect: const Rect.fromLTWH(350, 560, 190, 32),
            ),
          ],
          corePositions: const [
            Offset(460, 1040),
            Offset(245, 750),
            Offset(435, 390),
          ],
        ),

        // Level 5: Twin-Tier Chimney
        const VerticalLevelDefinition(
          levelNumber: 5,
          title: 'Twin-Tier Chimney',
          subtitle: 'Dual Offset Vertical Shafts',
          hint: 'Haul Heavy up Shaft 1 onto the mid landing, unlock Light, cross to Shaft 2, and hoist Heavy to the roof!',
          worldSize: Size(860, 1380),
          lightSpawn: Offset(250, 1260),
          heavySpawn: Offset(175, 1255),
          goalZone: Rect.fromLTWH(690, 120, 100, 100),
          parSeconds: 50,
          blocks: [
            ShaftBlock(Rect.fromLTWH(0, 1300, 860, 80)),
            ShaftBlock(Rect.fromLTWH(0, 0, 110, 1300)),
            // Center pillar separating Shaft 1 (left) and Shaft 2 (right)
            ShaftBlock(Rect.fromLTWH(330, 740, 180, 560)),
            // Mid landing bridge
            ShaftBlock(Rect.fromLTWH(330, 740, 310, 36)),
            // Right wall of Shaft 1 upper ceiling + Shaft 2 right wall
            ShaftBlock(Rect.fromLTWH(760, 220, 100, 1080)),
            ShaftBlock(Rect.fromLTWH(660, 220, 200, 32)),
            ShaftBlock(Rect.fromLTWH(330, 0, 130, 620)),
          ],
          steamJets: [
            SteamJetHazard(
              zone: Rect.fromLTWH(465, 440, 165, 40),
              periodSeconds: 3.2,
              activeDuration: 1.15,
              phaseOffset: 0.5,
            ),
          ],
          anchors: [
            HoistAnchorPoint(Offset(230, 670), label: 'SHAFT 1'),
            HoistAnchorPoint(Offset(600, 165), label: 'SHAFT 2'),
          ],
          gates: [],
          corePositions: [
            Offset(220, 980),
            Offset(420, 680),
            Offset(600, 320),
          ],
        ),

        // Level 6: Orbital Reactor Climb
        VerticalLevelDefinition(
          levelNumber: 6,
          title: 'Orbital Reactor',
          subtitle: 'Multi-Hazard Spire Ascent',
          hint: 'Combine wall-kicks, weight-gate activation, and timed steam dodges to reach the orbital exit!',
          worldSize: const Size(760, 1580),
          lightSpawn: const Offset(430, 1460),
          heavySpawn: const Offset(335, 1455),
          goalZone: const Rect.fromLTWH(510, 120, 100, 100),
          parSeconds: 60,
          blocks: const [
            ShaftBlock(Rect.fromLTWH(0, 1500, 760, 80)),
            ShaftBlock(Rect.fromLTWH(0, 0, 160, 1500)),
            ShaftBlock(Rect.fromLTWH(600, 220, 160, 1280)),
            ShaftBlock(Rect.fromLTWH(500, 220, 260, 34)),
            ShaftBlock(Rect.fromLTWH(680, 0, 80, 220)),
            ShaftBlock(Rect.fromLTWH(160, 960, 220, 32)), // mid weight shelf
            ShaftBlock(Rect.fromLTWH(390, 680, 210, 32)), // upper baffle
          ],
          steamJets: const [
            SteamJetHazard(
              zone: Rect.fromLTWH(380, 1180, 215, 42),
              periodSeconds: 3.3,
              activeDuration: 1.15,
              phaseOffset: 0.0,
            ),
            SteamJetHazard(
              zone: Rect.fromLTWH(165, 470, 215, 42),
              periodSeconds: 3.3,
              activeDuration: 1.15,
              phaseOffset: 1.6,
            ),
          ],
          anchors: const [
            HoistAnchorPoint(Offset(485, 860), label: 'TIER 1'),
            HoistAnchorPoint(Offset(380, 165), label: 'ORBITAL'),
          ],
          gates: [
            WeightSwitchGate(
              switchPlate: const Rect.fromLTWH(185, 946, 95, 14),
              gateRect: const Rect.fromLTWH(160, 680, 230, 32),
            ),
          ],
          corePositions: const [
            Offset(485, 1280),
            Offset(240, 890),
            Offset(380, 310),
          ],
        ),
      ];
}
