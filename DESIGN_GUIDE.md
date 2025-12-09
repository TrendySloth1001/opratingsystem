# OS Mastery - Manga Theme Design Guide

## Color Palette

### Primary Colors
- **Ink Black** (#0D0D0D) - Main text, borders, shadows
- **Paper White** (#FFFEF8) - Background, light elements
- **Manga Red** (#E63946) - Primary action color, emphasis
- **Highlight Yellow** (#FFC857) - Completion status, success

### Accent Colors
- **Accent Orange** (#FF6B35) - Secondary actions, badges
- **Speedline Blue** (#457B9D) - Info elements, progress
- **Panel Gray** (#E5E5E5) - Inactive/background elements
- **Shadow Gray** (#6C757D) - Subtle elements, metadata

## Typography

### Display Text (Bangers Font)
- **Extra Large**: 48px, Bold, Letter Spacing 2px
  - Used for: App title, main headers
  - Style: All caps, high impact

- **Large**: 36px, Bold, Letter Spacing 1.5px
  - Used for: Section titles
  - Style: Strong presence

- **Medium**: 28px, Bold
  - Used for: Module numbers, emphasis
  - Style: Clear hierarchy

### Body Text (Comic Neue Font)
- **Headline**: 24-20-18px, Bold
  - Used for: Card titles, topic headings
  
- **Body**: 16-14px, Normal, Line Height 1.5-1.6
  - Used for: Content, descriptions, questions
  - Style: Readable, comic-style

- **Labels**: 16px, Bold
  - Used for: Buttons, badges
  - Style: Clear action indicators

## UI Components

### Manga Panel
```
┏━━━━━━━━━━━━━━━━━━━━━━┓
┃                      ┃
┃   Content Here       ┃
┃                      ┃
┗━━━━━━━━━━━━━━━━━━━━━━┛
  ┗━━━━━ Hard Shadow
```
- 3px black border
- Hard shadow (4px offset, no blur)
- Rounded corners (8px)
- White background

### Completed Panel
```
┏━━━━━━━━━━━━━━━━━━━━━━┓ Yellow border
┃  ☆ COMPLETED ☆       ┃ Yellow highlight
┗━━━━━━━━━━━━━━━━━━━━━━┛
  ┗━━━━━ Yellow shadow
```

### Action Panel (Buttons)
```
┏━━━━━━━━━━━━━━┓
┃  ACTION!     ┃ White text
┗━━━━━━━━━━━━━━┛ Red background
  ┗━━━━ Black shadow
```

### Badges
```
╭──────────╮
│ 5 PYQs   │ Small, rounded pill
╰──────────╯
```
- 2px border
- High contrast
- Colored backgrounds

## Animation Style

### Splash Screen
1. **Scale + Elastic**: Logo bounces in (1000ms)
2. **Rotation**: Full 360° spin (1500ms)
3. **Fade**: Text appears (800ms)
4. **Transition**: Fade to home (500ms)

### Transitions
- **Module to Topic**: Slide + fade
- **Completion**: Scale + bounce
- **Progress bars**: Smooth ease-out (500ms)

### Interactive Elements
- **Tap**: Quick scale down (0.95x)
- **Hover**: Lift effect (shadow increase)
- **Complete**: Bounce animation

## Screen Layouts

### Home Screen
```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃   [OS MASTERY TITLE BAR]     ┃ Black background
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃  YOUR PROGRESS               ┃
┃  [=========>         ] 60%   ┃ Progress bar
┃  5/8 Topics  |  120 Minutes  ┃ Stats
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃ [2] MODULE 2                 ┃ Module card
┃     Process & Scheduling     ┃
┃     [3/3 Topics] [COMPLETE]  ┃
┃     [====================]   ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

### Topic Detail Screen
```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃  ← 2.1              ⏱ 05:23 ┃ Timer
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃  Topic Title                 ┃
┃  [8 PYQs]                    ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃  CONTENT                     ┃
┃  Theory and explanations...  ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

                          ╭───╮
                          │ ✓ │ Floating button
                          ╰───╯
```

## Manga Elements

### Speech Bubble Style
- Rounded edges
- 3px black outline
- Small tail pointing to content
- Used for hints/tips (if added)

### Panel Borders
- Always 3px solid black
- Sharp corners with 8px radius
- Hard drop shadows (no blur)

### Progress Indicators
```
Empty:  [░░░░░░░░░░]
Filled: [██████░░░░] 60%
```
- High contrast
- Bold borders
- Percentage overlay

### Icon Style
- Solid fill
- High contrast
- Clear silhouettes
- 24px or larger

## Responsive Behavior

### Padding
- Screen edges: 16px
- Between elements: 12-24px
- Inside panels: 16-20px

### Touch Targets
- Minimum 48x48px
- Clear active states
- Immediate visual feedback

### Text Scaling
- Supports system font scaling
- Maintains hierarchy
- Readable at all sizes

## Best Practices

1. **High Contrast**: Always use black on white or white on black
2. **Bold Borders**: 3px minimum for manga effect
3. **Hard Shadows**: No blur, solid offset
4. **Clear Hierarchy**: Size and weight differences obvious
5. **Playful Animations**: Bounce, elastic, energetic
6. **No Gradients**: Solid colors only
7. **Sharp Edges**: Even with radius, maintain clean lines
8. **Impact Text**: All caps for important elements
