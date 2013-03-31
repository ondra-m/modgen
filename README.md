# Modgen API klient

Ještě nejsou žádné testy. Pouze ukazuji jak to funguje.

Spuštění konzole:

    bundle console

nebo

    pry --gem

Pro komunikaci s API je nejdříve nutné ve složce `test_api` spustit `rackup`. Aby server reagoval na změny tak `shotgun config.ru --port=9292`. 

## Konfigurace

Ještě není potřeba nic konfigurovat ale bude se to dělat takhle:

```ruby
# 1. možnost
Modgen.configure do
  client_id "1"
end

# 2. možnost
Modgen.config.client_id = "1"
```

## Discovery

Pokud tady nejsou zadané verze, klient načte preferovanou. Pokud verze neexistuje vyhodí se error.

```ruby
Modgen::Discovery.versions         # všechny verze API
Modgen::Discovery.version(:verze)  # detail jedné verze
Modgen::Discovery.discover(:verze) # načte API a vytvoří metody
```

## Dotazy na API

Detaily API.

```ruby
Modgen::API.api.name
               .description
               .version
               .created_at
               .updated_at
               .base_path
```

Detaily metody.

```ruby
Modgen::API.dataset.get
```

Dotaz na metodu.

```ruby
# Error, Id je povinné
response = Modgen::API.dataset.get(a: "a")

# Error, Id musí být číslo
response = Modgen::API.dataset.get(id: "a")

# Požadavek se odešle
response = Modgen::API.dataset.get(id: 1)
response.request
        .status
        .content_type
        .body
```

Příklady.

```ruby
# Parametr user['name'] je povinný
response = Modgen::API.profile.update(user: {})

# Name musí být string
response = Modgen::API.profile.update(user: {name: 1})

# Name nemá správný formát
response = Modgen::API.profile.update(user: {name: "."})

# Správně
response = Modgen::API.profile.update(user:{name: "a"})
```

Ještě je třeba dost udělat na Discovery ale zatím se mi to zdá dobré. Ještě uvažuji jak řešit, když nebude třeba zadat žádný parameter.
