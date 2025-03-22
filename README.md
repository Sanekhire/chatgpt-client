# ChatGPT Client

ChatGPT Client – это Ruby-гем, предназначенный для взаимодействия с API OpenAI. Позволяет отправлять запросы к модели ChatGPT и получать ответы, поддерживает использование прокси-серверов.

## Установка

Добавьте в `Gemfile` вашего проекта:

`gem 'chatgpt-ruby-client'`

Затем выполните команду:

`bundle install`

Или установите вручную:

`gem install chatgpt-ruby-client`

## Использование

### Инициализация клиента

```ruby
require 'chatgpt-ruby-client'

api_key = 'your_openai_api_key'
client = Chatgpt::Client.new(api_key)
```

### Отправка запроса

```ruby
response = client.send_request("Напиши короткое стихотворение")
puts response.dig('choices', 0, 'message', 'content')
```

### Настройка параметров

Вы можете настроить различные параметры клиента:

```ruby
Chatgpt::Client.model = "gpt-4"
Chatgpt::Client.temperature = 0.5
Chatgpt::Client.system_message = "Ты – эксперт по программированию."
Chatgpt::Client.prompt_prefix = "Перефразируй: "
Chatgpt::Client.proxy = "socks5://user:password@proxyserver:1080"
```

### Использование прокси

Вы можете передавать прокси в методе `send_request:`

```ruby
response = client.send_request("Как работает Ruby?", "<http://proxyserver:8080>")
puts response.dig('choices', 0, 'message', 'content')
```

## Как это работает

### Класс `Chatgpt::Client`

Этот класс отвечает за создание запросов к API OpenAI. Он управляет настройками модели, заголовками и обработкой ответов.

### Основные методы

* `initialize(api_key)` – создаёт клиент с API-ключом.

* `send_request(prompt, proxy = nil)` – отправляет запрос к ChatGPT.

* `build_request_data(prompt)` – формирует данные для запроса.

* `request_headers` – задаёт заголовки HTTP-запроса.

* `parse_response(response)` – обрабатывает ответ API.

### Класс `Chatgpt::ApiRequest`

Этот класс отвечает за выполнение HTTP-запросов с использованием библиотеки `curb`.
Основные методы:

* `initialize(url:, data:, headers:, proxy: nil)` – принимает параметры запроса.

* `post` – выполняет POST-запрос к API OpenAI.

* `configure_proxy(curl, proxy)` – настраивает прокси-сервер, если он указан.

### Ошибки и обработка

Если при выполнении запроса возникает ошибка, она возвращается в виде хэша:

```ruby
{ "error" => "Описание ошибки" }
```

### Лицензия

Этот проект распространяется под лицензией MIT.
