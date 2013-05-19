# Rubik's Cube

[![Travis CI](https://travis-ci.org/chrishunt/rubiks-cube.png)](https://travis-ci.org/chrishunt/rubiks-cube)
[![Coverage Status](https://coveralls.io/repos/chrishunt/rubiks-cube/badge.png)](https://coveralls.io/r/chrishunt/rubiks-cube)

Solve your Rubik's Cube with an **easy** two-cycle solution

## Description

Can you solve the Rubik's Cube? Do you want to learn how? GREAT!

We will teach you a very simple two-cycle solution for solving the Rubik's
Cube. It's so simple that I used this exact solution to solve the cube
blindfolded in the [2005 Rubik's World
Championship](http://worldcubeassociation.org/results/p.php?i=2005HUNT01) with
a time of 5 minutes and 40 seconds. After you've mastered this solution, you
will average less than 3 minutes and will have enough understanding to progress
to the [Fridrich CFOP](http://en.wikipedia.org/wiki/Fridrich_Method) method.
You'll be solving in less than 15 seconds in no time. WOW!

## Sections

  1. [Usage](#usage)
  1. [Setting Rubik's Cube State](#setting-rubiks-cube-state)
     - [Examples](#examples)
       - [Solved Cube](#solved-cube)
       - [Slightly Scrambled Cube](#slightly-scrambled-cube)
       - [Fully Scrambled Cube](#fully-scrambled-cube)
  1. [Turning a Rubik's Cube](#turning-a-rubiks-cube)
  1. [Solving a Rubik's Cube](#solving-a-rubiks-cube)
     - [Two Cycle Solution](#two-cycle-solution)
       -  [How It Works: Permutation](#how-it-works-permutation)
       -  [How It Works: Orientation](#how-it-works-orientation)
  1. [Algorithms](#algorithms)
     - [Algorithm Notation](#algorithm-notation)
       - [M Slice](#m-slice)
  1. [Installation](#installation)
  1. [Contributing](#contributing)
  1. [License](#license)

## Usage

```ruby
require 'rubiks_cube'

cube = RubiksCube::Cube.new
cube.solved? #=> true

scramble = "U D B2 U B D2 B2 F' R' U2 F U' L2 F L2 B2 L2 R' U R' U' D R2 F2 B2"

cube.perform! scramble
cube.solved? #=> false

solution = RubiksCube::TwoCycleSolution.new(cube)

solution.length #=> 458

puts solution.pretty

  # Setup:  L2
  # Fix:    R U R' U' R' F R2 U' R' U' R U R' F'
  # Undo:   L2
  #
  # Setup:  M2 D L2
  # Fix:    R U R' U' R' F R2 U' R' U' R U R' F'
  # Undo:   L2 D' M2
  #
  # Setup:  U' F' U
  # Fix:    R U R' U' R' F R2 U' R' U' R U R' F'
  # Undo:   U' F U
  # ...
```

## Setting Rubik's Cube State

If you have a scrambled Rubik's Cube sitting in front of you right now, you
may not know how to get it back to the solved position. That's OK! We can set
the Rubik's Cube state manually and learn how to solve it.

Describing a cube state may seem complicated at first, but it quickly becomes
easy after you've done it a few times.

Hold your Rubik's Cube in your hand. Notice that the center of each face does
not move when you rotate a side. The is the basis for entering cube state
manually. If the center of a face is red, then that face will be red when the
cube is solved.

Starting with top edges and working down (counter-clockwise), enter the state
of each cubie. After edges are entered, proceed to corners. See the
[examples](#examples) below for more help.

![](https://raw.github.com/chrishunt/rubiks-cube/master/img/cube_instructions.jpg)

### Examples

Entering cube state manually can be confusing at first. Here are some examples
to help you out.

#### Solved Cube

![](https://raw.github.com/chrishunt/rubiks-cube/master/img/cube_solved.jpg)

A Rubik's Cube is solved by default.

```ruby
require 'rubiks_cube'

cube = RubiksCube::Cube.new

cube.state
  #=> "UF UR UB UL FL FR BR BL DF DR DB DL UFL URF UBR ULB DLF DFR DRB DBL"

cube.solved? #=> true
```

#### Slightly Scrambled Cube

![](https://raw.github.com/chrishunt/rubiks-cube/master/img/cube_scramble_1.jpg)

Notice our cube is now slightly scrambled. We can start our Rubik's Cube in
this state if we like:

```ruby
require 'rubiks_cube'

cube = RubiksCube::Cube.new(
  "RF FU UB UL FL UR BR BL DF DR DB DL UFL FUR UBR ULB DLF DFR DRB BLD"
)

cube.solved? #=> false
```

#### Fully Scrambled Cube

![](https://raw.github.com/chrishunt/rubiks-cube/master/img/cube_scramble_2.jpg)

And here's a fully scrambled cube. This looks hard to solve. We can start our
cube in this state if we like and have the solver tell us a solution.

Here's the scramble we used to mix the cube if you'd like to try it yourself:

```
U D B2 U B D2 B2 F' R' U2 F U' L2 F L2 B2 L2 R' U R' U' D R2 F2 B2
```

```ruby
require 'rubiks_cube'

cube = RubiksCube::Cube.new(
  "RF DL UB DF UF DB FL LB UL DR BR UR FUR LFD UFL DRB BLD DFR BRU LBU"
)

cube.solved? #=> false
```

## Turning a Rubik's Cube

Each Rubik's Cube face ( **L**, **R**, **F**, **B**, **D**, **U** ) can be
turned clockwise manually by calling the appropriate method on the cube. For
example, if we'd like to turn the right face twice, the down face once, and the
back face three times:

```ruby
require 'rubiks_cube'

cube = RubiksCube::Cube.new

cube.r.r.d.b.b.b
```

Most people will prefer to use standard Rubik's Cube [algorithm
notation](#algorithm-notation) for turning the cube. Here's the same example
with with cube notation:

```ruby
require 'rubiks_cube'

cube = RubiksCube::Cube.new

cube.perform! "R2 D B'"
```

Performing face turns on the cube changes the state.

```ruby
require 'rubiks_cube'

cube = RubiksCube::Cube.new

cube.perform!(
  "U D2 F2 L' R' D' B' U' D L D U2 B' L2 F2 R' U D F2 B' R' F2 U F2 B"
)

cube.solved? #=> false

cube.state
  # "DB UF RB RF LB DL UR RD FD UB LF UL FDL DFR UBR BDR UFL LDB FUR LBU"
```

## Solving a Rubik's Cube

We've provided a simple two-cycle solution to help you solve the Rubik's Cube.
This solution is very inefficient, but wonderful for humans. Using the
two-cycle solution, you can quickly learn how to solve the Rubik's Cube without
using the computer.

### Two Cycle Solution

The two-cycle solution is a popular solution used to solve the Rubik's Cube
blindfolded. It requires little memorization and takes little time to learn.
Solutions usually range from 400-600 turns, but most of those turns are quickly
executed. We can easily achieve times of less than 4 minutes with this
solution.

The two-cycle solution solves the cube by swapping two cubies at a time until
all cubies are in the correct location. This is the permutation step. After the
cubies are permuted, we then rotate two cubies at a time (in their current
location) until all are oriented correctly. This is the orientation step. We
call this the *two-cycle* solution because everything is done in pairs.

You can use the `rubiks_cube` gem to *learn* the two-cycle solution. For each
step, we provide setup moves, the [fixing algorithm](#algorithms) (either
changing permutation or orientation), and the undo moves. Pay close attention
to how the cube moves and you will be solving by yourself in no time.

See [Usage](#usage) for an example of the `TwoCycleSolution`

#### How It Works: Permutation

![](https://raw.github.com/chrishunt/rubiks-cube/master/img/cube_permutation.jpg)

The permutation step is completed using only two algorithms. One swaps two
edges and the other swaps two corners. The diagram above shows which edges and
corners are swapped.

When a solution is calculated, we present a 'setup' algorithm (which gets the
cubies into a position where they can be swapped), then we present one of the
two swapping algorithms, followed by an 'undo' algorithm that reverses the
setup move.

#### How It Works: Orientation

![](https://raw.github.com/chrishunt/rubiks-cube/master/img/cube_orientation.jpg)

The orientation step is completed using only two algorithms. One flips two
edges and the other rotates two corners (one clockwise and the other
counter-clockwise). The diagram above shows which edges and corners are
rotated.

When a solution is calculated, we present a 'setup' algorithm (which gets the
cubies into a position where they can be rotated), then we present one of the
two rotation algorithms, followed by an 'undo' algorithm that reverses the
setup move.

## Algorithms

All algorithms can be found in
[`RubiksCube::Algorithms`](https://github.com/chrishunt/rubiks-cube/blob/master/lib/rubiks_cube/algorithms.rb)

### Algorithm Notation

![](https://raw.github.com/chrishunt/rubiks-cube/master/img/cube_algorithm.jpg)

Rubik's Cube algorithm notation is easy to understand, but may look confusing
at first. Each face is represented by a letter:

- **L**: Left Face
- **R**: Right Face
- **F**: Front Face
- **B**: Back Face
- **U**: Up Face (top)
- **D**: Up Face (bottom)

When we see a letter in an algorithm, then we turn that face 90 degrees
clockwise. To determine which direction is clockwise, rotate the cube so that
you are looking at the face, then make the turn.

Faces may be followed by one of two modifiers:

- **'**: Rotate the face 90 degrees *counter*-clockwise
- **2**: Rotate the face 180 degrees (two turns)

For example, if we want to apply the algorithm `F2 B D' R`, then we would take
these steps:

1. Rotate **F** face 180 degrees (two turns)
2. Rotate **B** face 90 degrees clockwise
3. Rotate **D** face 90 degrees *counter*-clockwise
4. Rotate **R** face 90 degrees clockwise

#### M Slice

![](https://raw.github.com/chrishunt/rubiks-cube/master/img/cube_m_slice.jpg)

There is one special algorithm notation that does not map to a face. This is
called the M slice. The M slice is the middle vertical layer of the Rubik's
Cube.

When you see **M**, then rotate this slice 90 degrees clockwise. To figure out
which direction is clockwise, look at the **L** face.

For example, if we want to apply the algorithm `M2 F M2`, then we would take
these steps:

1. Rotate **M** slice 180 degrees (two turns)
2. Rotate **F** face 90 degrees clockwise
3. Rotate **M** slice 180 degrees (two turns)

## Installation

```bash
$ gem install rubiks_cube
```

## Contributing

Please see the [Contributing
Document](https://github.com/chrishunt/rubiks-cube/blob/master/CONTRIBUTING.md)

## License

Copyright (C) 2013 Chris Hunt, [MIT
License](https://github.com/chrishunt/rubiks-cube/blob/master/LICENSE.txt)
