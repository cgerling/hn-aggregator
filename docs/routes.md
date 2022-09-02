# Routes

## `GET` `/top-stories`

A paginated list of top stories, each page will return at most 10 itens.

### Parameters

* `[page=1]` (query) - a positive integer to specify the page to fetch, when
not specified it defaults to the first page.

### Responses

```
200 OK

[
  {
    "by": String,
    "descendants": Integer,
    "id": Integer,
    "score": Integer,
    "time": DateTime,
    "title": String,
    "url": String
  },
  ...
]
```

## `GET` `/top-stories/{id}`


### Parameters
* `id` (path) - a positive integer representing the id of a given story.

### Responses

```
200 OK

{
  "by": String,
  "descendants": Integer,
  "id": Integer,
  "score": Integer,
  "time": DateTime,
  "title": String,
  "url": String
}
```

```
404 Not Found

{
  "message": "No top story was found with id={id}"
}
```

## `WebSocket` `/top-stories/ws`

Sends the most popular stories on a 5 minutes interval.

### Messages

#### `[SUB]` `Top stories`

A list with the 50 most popular stories in the moment.

```
[
  {
    "by": String,
    "descendants": Integer,
    "id": Integer,
    "score": Integer,
    "time": DateTime,
    "title": String,
    "url": String
  },
  ...
]
```

