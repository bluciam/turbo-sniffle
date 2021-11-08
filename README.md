# ShippingCalculator

Contains the implementation of a shipping calculator given a file of
transactions and returning the list with the applied discounts.

The discount follow these rules:

* All S shipments should always match the lowest S package price among the providers.
* The third L shipment via LP should be free, but only once a calendar month.
* Accumulated discounts cannot exceed 10 € in a calendar month. If there are
  not enough funds to fully cover a discount this calendar month, it should be
  covered partially.

Prices are included in the code.

## Installation

This installation assumes your are using `rvm`.
- clone the repository
- cd into the directory
- run `gem install bundle`
- run `bundle`


## Testing

Tests are written in RSpec and can be run with:
```
  rake test
```

## Ruby style guide

I followed the default style guide from rubocop:
```
  rake rubocop
```


## Usage

```
  rake run input.txt
```


## License

This code is available as open source under the terms of
the [MIT License](https://opensource.org/licenses/MIT).
