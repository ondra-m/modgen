# Modgen API klient

## Instalation

Install

    gem install modgen

Bundler

    gem 'modgen'

Ruby

    require 'modgen'



## Configuration

```ruby
Modgen.configure do
  client_id "1"
end

# ------------ or ------------

Modgen.config.client_id = "1"
```

List of all available conf.

<table>
  <thead>
    <tr>
      <th><b>key</b></th>
      <th><b>example and description</b></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>oauth2.client_id</td>
      <td>
        Id of client generated by API server.<br><br>

        <i>e.g. egt45e5t5trh54rth5rth54rt5h4r5t4h5rt4h</i>
      </td>
    </tr>
    <tr>
      <td>oauth2.client_secret</td>
      <td>
        Secret key generated by API server.<br><br>

        <i>e.g. 4546846846th468684684t684hthrthrt6h871rh78888</i>
      </td>
    </tr>
    <tr>
      <td>oauth2.redirect_uri</td>
      <td>
        Address of web page where request will be redirected for gain access code.<br><br>

        <i>e.g http://localhost/oauth2callback</i>
      </td>
    </tr>
  </tbody>
</table>



## Usage

First you must discovery API. For displaying all available versions.



### Discovery

```ruby
Modgen::Discovery.versions
```

Details of specific version. If version is nil Modgen show preffered version.

```ruby
Modgen::Discovery.version(version)
```

Discover specific version. If version is nil Modgen discover preffered version.

```ruby
Modgen::Discovery.discover(version)
```



### API details

```ruby
Modgen::API.api.name
               .description
               .version
               .created_at
               .updated_at
               .base_url
```



### API request


```ruby
Modgen::API.dataset.get(id: 1)
```


## Test

First start testing API in /test_api and than.

    rake
