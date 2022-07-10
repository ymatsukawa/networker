# Networker

Network test tool.

## Installation

```shell
$ rake build
$ gem install pkg/networker-x.x.x.gem
```

## Usage

In `irb`

```
require 'networker'

Networker::Http.req(:file, '/path/to/request_file.json')
```

example format is in [spec/FILES](./spec/FILES)

## Testing

```shell
$ rake test:server

# on another console
$ rspec spec
```

## License

[MIT License](https://opensource.org/licenses/MIT).
