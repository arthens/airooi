# airooi - Am I running out of ids?

`airooi` is a ruby script that connects to your MySql database and look for integer fields where `MAX(value)` is close or equal to the maximum value.

This might seem like an unnecessary job, but if you are working on an old codebase that connects to MySql in non-strict mode this is far from impossible - I've been bitten by `MEDIUMINT` running out of valid unique IDs multiple times.

## Usage

Well, it doesn't do much yet, but here it is:

```
./airooi.rb -h host -u user -d database
```
