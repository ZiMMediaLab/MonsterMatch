# 🧛 MonsterMatch

A spooky memory card game featuring 12 hand-drawn pixel monsters.
Find every pair before time runs out, or the monsters get the last laugh.

[![Play](https://img.shields.io/badge/Play_in_browser-5A0FC8?style=for-the-badge&logo=pwa&logoColor=white)](https://zimmedialabs.github.io/MonsterMatch/)
![GameMaker](https://img.shields.io/badge/GameMaker-000000?style=for-the-badge&logo=gamemaker&logoColor=white)

**▶ Play now:** https://zimmedialabs.github.io/MonsterMatch/
Works on desktop and mobile, and you can install it to your home screen. After the first visit it also works offline.

---

## How to Play

- Click or tap a card to turn it over, then pick a second card.
- If the two match, they leave the table. If they don't, they flip back.
- Clear the table before the clock runs out. In the last 10 seconds the timer turns red and the music speeds up.
- When a round ends, click anywhere (or press **Enter**) to play again. **Esc** or the **Back** button returns to the menu.

| Difficulty | Pairs | Time | Extra |
| :--- | :---: | :---: | :--- |
| Easy | 6 | 90 sec | All cards shown for 3 seconds before the round |
| Medium | 9 | 75 sec | All cards shown for 2 seconds before the round |
| Hard | 12 | 60 sec | The original game |
| Nightmare | 12 | 45 sec | Every wrong pair costs 2 seconds |

### Bonus items

Matching a pair can drop a bonus item into the empty slot. Click or tap it before it fades (3 seconds).

| Item | Effect |
| :--- | :--- |
| Potion | +5 seconds on the clock |
| Brain | Big Brain: every card flips face up for 1 second |
| Scarab | Seeker: the scarab lands on a card and that pair glows for a moment |
| Ankh | Second Life: when time runs out, you get 5 more seconds (once per round) |
| Basket | Trick or treat: a random bonus, or on Nightmare, a trick that shuffles the cards left on the table |

| Difficulty | Drop chance per match | Max per round | Items |
| :--- | :---: | :---: | :--- |
| Easy | 10% | 1 | Potion |
| Medium | 15% | 2 | Potion, Brain |
| Hard | 20% | 2 | Potion, Brain, Scarab, Ankh |
| Nightmare | 25% | 3 | All five |

Your best time on each difficulty is saved. Music, sounds, and fullscreen (desktop) can be changed in **Options**.

**The monsters:** Alien · Bigfoot · Cyclops · Demon · Dracula · Frankenstein · Merman · Mummy · Robot · Skeleton · Wolfman · Zombie

---

## Project Layout

| Path | What's in it |
| :--- | :--- |
| `Monster Match/` | GameMaker project (open `Monster Match.yyp`) |
| `pwa/` | Web app manifest, icons, and service worker template |
| `tools/Build-PWA.ps1` | Turns a GameMaker HTML5 export into the PWA in `docs/` |
| `docs/` | The live site served by GitHub Pages (generated, don't edit by hand) |

All game settings live in one place: `scripts/game_config`. That includes each difficulty's pairs, time, music, penalties, and item drops, plus layout and timing.

## Building the Web Version

1. Open the project in GameMaker and set the target to **HTML5**.
2. Choose **Build → Create Executable** and save the `.zip`.
3. From the repo root in PowerShell:

```powershell
.\tools\Build-PWA.ps1 -ExportPath "C:\path\to\MonsterMatch.zip"
git add docs
git commit -m "Update web build"
git push
```

---

## Credits

- **Game & code:** ZiMM ([ZiMMediaLabs](https://github.com/ZiMMediaLabs)), Rock Runner Studio
- **Pixel monster art:** PRIMESnakeEyes
