# Photos for the app

Put your photos in this folder with exactly these file names. Until a file is
added, the app shows a grey placeholder box with the file name written in it,
so nothing crashes.

| File name | Where it shows | Suggested size |
| --- | --- | --- |
| `splash_photo.jpeg` | Splash screen, inside the small polaroid | square, 400 × 400 |
| `onboarding_places.jpeg` | Onboarding page 1 ("Save the places that matter") | portrait, 1080 × 1300 |
| `onboarding_memories.jpeg` | Onboarding page 2 ("Turn moments into memories") | portrait, 1080 × 1300 |
| `onboarding_timeline.jpeg` | Onboarding page 3 ("Relive them, month by month") | portrait, 1080 × 1300 |
| `login_polaroid_left.jpeg` | Log in screen, left polaroid | square, 400 × 400 |
| `login_polaroid_center.jpeg` | Log in screen, middle polaroid | square, 400 × 400 |
| `login_polaroid_right.jpeg` | Log in screen, right polaroid | square, 400 × 400 |
| `sample_memory_1.jpeg` | Home, sample memory (mock mode only) | landscape, 1200 × 800 |
| `sample_memory_2.jpeg` | Home, sample memory (mock mode only) | landscape, 1200 × 800 |
| `sample_memory_3.jpeg` | Home, sample memory (mock mode only) | landscape, 1200 × 800 |

`.jpeg` and `.png` both work, but the name must match. If you use `.png`, change
the extension in `lib/core/constants/asset_paths.dart` too.

After adding or renaming files, stop the app and run it again (hot reload does
not pick up new assets).
