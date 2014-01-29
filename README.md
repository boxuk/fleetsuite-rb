# Fleetsuite-ruby

A Ruby client for Fleetsuite.com

## Use

```ruby
client = Fleetsuite::Client.new("boxuk", "API_TOKEN")
# Get all projects
client.projects()

# Get a single project
client.project(1)
```

## Running tests

```
./test.sh
```
