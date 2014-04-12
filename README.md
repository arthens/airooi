# airooi - Am I running out of ids?

`airooi` is a ruby script that connects to your MySql database and look for integer fields where `MAX(value)` is close or equal to the maximum value.

This might seem like an unnecessary job, but if you are working on an old codebase that connects to MySql in non-strict mode this is far from impossible - I've been bitten by `MEDIUMINT` running out of valid unique IDs a couple of times myself.

## Requirements

`airooi` is tested on ruby `2.1.1`, `2.0.0` and `1.9.3`.

## Usage

Just connect to the database and let the magic happen.

```
./bin/airooi.rb -h host -u user -d database
```

By default it only shows columns over 75% of used IDs, add `-v` to get a view of all columns.

## Can I use it to check other database?

`airooi` comes with only a `mysql` driver. However, all the logic is contained in the driver so it should be pretty easy to add support for other databases. Pull requests are welcome :)

## Testing

To run tests do:

- `bundle install`
- `bin/tests.rb`

[![Build Status](https://travis-ci.org/arthens/airooi.svg?branch=master)](https://travis-ci.org/arthens/airooi)
