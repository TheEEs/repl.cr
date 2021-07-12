# exp_parser

This is a project that demonstrates how to create a tree-walker interpreter. It now can only evaluate simple expressions including add, subtract, division, exponent and unary. 

## Installation

1. Clones this repository:

   ```shell
  $ git clone https://github.com/TheEEs/expression_repl.git
   ```

2. Navigates into the cloned directory then run: `crystal run -Drepl ./src/repl.cr`

## Usage

1. Evalutes single expression.

  ```crystal
  1 * (6 + 10 / 2)
  ```

2. Evalutes multiple expression.

  ```crystal
  1 * (6 + 10 / 2); 8 ** 3
  ```

3. Types `exit` to terminate the program

