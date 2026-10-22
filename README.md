# 🧛 MonsterMatch

A 60-second memory card game featuring 12 hand-drawn pixel monsters.
Find all 12 pairs before time runs out, or the monsters get the last laugh.

[![Play](https://img.shields.io/badge/Play_in_browser-5A0FC8?style=for-the-badge&logo=pwa&logoColor=white)](https://zimmworks.github.io/MonsterMatch/)
![GameMaker](https://img.shields.io/badge/GameMaker-000000?style=for-the-badge&logo=gamemaker&logoColor=white)

**▶ Play now:** https://zimmworks.github.io/MonsterMatch/
Works on desktop and mobile, and you can install it to your home screen. After the first visit it also works offline.

---

## How to Play

- Click or tap a card to turn it over, then pick a second card.
- If the two match, they leave the table. If they don't, they flip back.
- Clear all 24 cards within 60 seconds to win.
- When a round ends, click anywhere (or press **Enter**) to play again.

**The monsters:** Alien · Bigfoot · Cyclops · Demon · Dracula · Frankenstein · Merman · Mummy · Robot · Skeleton · Wolfman · Zombie

---

## Project Layout

| Path | What's in it |
| :--- | :--- |
| `Monster Match/` | GameMaker project (open `Monster Match.yyp`) |
| `pwa/` | Web app manifest, icons, and service worker template |
| `tools/Build-PWA.ps1` | Turns a GameMaker HTML5 export into the PWA in `docs/` |
| `docs/` | The live site served by GitHub Pages (generated, don't edit by hand) |

All game settings live in one place: `scripts/game_config`. That includes pair count, round length, layout, and timing.

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

- **Game & code:** ZiMM ([ZiMMworks](https://github.com/ZiMMworks)), Rock Runner Studio
- **Pixel monster art:** PRIMESnakeEyes
