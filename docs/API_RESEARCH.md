# Maktabah API reference for the implementation roadmap

Verified on **7 October 2026** against the live, first-party [OpenAPI 3.1 contract](https://maktabah-demo-api.ashahin.workers.dev/openapi.json) and the successful GET responses linked below. API version: `v1`; document version: `1.0.0`.

Observed examples below come from successful GET responses. Validation and error behavior are identified separately where they are supported by the contract.

## Scope and limitations

The contract describes 12 fictional books across four categories, with three original sample chapters per book. Authors, ratings, and full-book page counts are illustrative. There are no full ebook files, accounts, authentication, mutation endpoints, or server-side user records. Saved books, reading positions, bookmarks, and preferences belong on the device. Supported methods are GET, HEAD, and OPTIONS. These capabilities are **documented**, rather than verified by attempts to write to the API. [OpenAPI overview and endpoint descriptions](https://maktabah-demo-api.ashahin.workers.dev/openapi.json)

Origin: `https://maktabah-demo-api.ashahin.workers.dev`. Successful API payloads have `data` and `meta`; errors have `error` and `meta`. The raw `/openapi.json` document and PNG images do not use this envelope. [Response schemas](https://maktabah-demo-api.ashahin.workers.dev/openapi.json)

```json
{
  "data": "object or list appropriate to the endpoint",
  "meta": {
    "apiVersion": "v1",
    "language": "ar",
    "direction": "rtl",
    "isDemo": true
  }
}
```

The `data` string above is an explanation of shape, not an actual payload value. Render Arabic text as RTL and preserve Unicode. If using `package:http`, decode `response.bodyBytes` as UTF-8 before JSON decoding, as the contract's example does. Dio normally decodes JSON automatically. [API overview](https://maktabah-demo-api.ashahin.workers.dev/openapi.json)

## Routes and query parameters

| GET route | `data` shape | Accepted query keys |
| --- | --- | --- |
| `/` | Directory with API/document links | Query parameters ignored |
| `/health` | `{status, catalogVersion}` | Query parameters ignored |
| `/api/v1/categories` | Category array | None |
| `/api/v1/books` | Book array | `q`, `category`, `page`, `limit`, `sort` |
| `/api/v1/books/{bookId}` | Book detail object | None |
| `/api/v1/books/{bookId}/chapters` | Chapter summary array | None |
| `/api/v1/books/{bookId}/chapters/{index}` | Full chapter object | None |
| `/api/v1/home` | Home object | `category` |
| `/api/v1/demo-state` | Initial local-state object | None |
| `/images/{file}` | PNG bytes | Query parameters ignored |
| `/openapi.json` | Raw OpenAPI document | Query parameters ignored |

All `/api/v1` routes reject undocumented and duplicate query keys. Routes accept trailing slashes. Do not send `categoryId`, `search`, `offset`, or reader preferences as query keys. [Route definitions](https://maktabah-demo-api.ashahin.workers.dev/openapi.json)

| Books parameter | Type and accepted values | Default |
| --- | --- | --- |
| `q` | String; maximum 200 UTF-16 code units | Empty string |
| `category` | `all`, `literature`, `self-development`, `history`, `science` | `all` |
| `page` | Canonical positive decimal integer, 1 through 9007199254740991 | `1` |
| `limit` | Canonical positive decimal integer, 1 through 50 | `12` |
| `sort` | `catalog`, `title`, `rating` | `catalog` |

Canonical numbers have no leading zero, sign, exponent, decimal point, or surrounding whitespace. `catalog` preserves catalog order, `title` uses ascending Arabic collation, and `rating` uses descending ratings with catalog order for ties. Search checks title, author, description, and category name; normalization removes Arabic diacritics/tatweel, maps alef variants to `ا` and `ى` to `ي`, and collapses whitespace. These search and validation behaviors are documented, not exhaustively probed. [Books operation](https://maktabah-demo-api.ashahin.workers.dev/openapi.json)

### Observed pagination example

The [literature query with two books per page](https://maktabah-demo-api.ashahin.workers.dev/api/v1/books?category=literature&limit=2&page=1&sort=rating) returned IDs `light` and `sea`, plus:

```json
{
  "pagination": {
    "page": 1,
    "limit": 2,
    "total": 3,
    "totalPages": 2,
    "hasNextPage": true,
    "hasPreviousPage": false
  },
  "filters": {
    "q": "",
    "category": "literature",
    "sort": "rating"
  }
}
```

These two objects are inside **`meta`**, alongside the four common metadata fields. Empty searches and pages beyond the last page are documented to return HTTP 200 with `data: []`; zero matches have `totalPages: 0`. Those empty/error branches were not independently verified during this research. [Books response and examples](https://maktabah-demo-api.ashahin.workers.dev/openapi.json)

## Category, book, and chapter fields

The category schema requires `id: String`, `name: String`, `icon: String`, and `bookCount: int`. The four IDs are `literature`, `self-development`, `history`, and `science`; `all` is a filter value, not a category object. Icon strings are symbolic names, not image URLs. The observed home response included these icon mappings: `feather`, `sprout`, `history`, and `science`, with three books per category. [Observed home response](https://maktabah-demo-api.ashahin.workers.dev/api/v1/home), [Category schema](https://maktabah-demo-api.ashahin.workers.dev/openapi.json)

The Book schema requires all of these fields:

| Type | Fields |
| --- | --- |
| String | `id`, `title`, `author`, `categoryId`, `categoryName`, `language`, `description`, `tagline`, `coverUrl`, `coverBackgroundColor`, `direction`, `contentType` |
| Number | `rating` (0 through 5) |
| Integer | `pageCount`, `coverWidth`, `coverHeight`, `chapterCount` |
| Boolean | `isFictional` |

`language` is `ar`, `direction` is `rtl`, `isFictional` is true, and `contentType` is `sample`. `coverUrl` is already absolute. Use the supplied `chapterCount` for available reading content; `pageCount` is an illustrative full-book length. Parse a JSON number through Dart's `num` when converting it to `double`. [Book schema](https://maktabah-demo-api.ashahin.workers.dev/openapi.json)

Observed [book details for `light`](https://maktabah-demo-api.ashahin.workers.dev/api/v1/books/light): title `أثر الضوء`, rating `4.8`, `pageCount: 216`, `chapterCount: 3`, cover dimensions `600 × 855`, and [cover URL](https://maktabah-demo-api.ashahin.workers.dev/images/light.png). Details contain every Book field plus `chapters` and an Arabic `notice` explaining the fictional sample content.

Each detail `chapters` entry requires `index: int`, `number: int`, `title: String`, and `paragraphCount: int`. The observed [standalone chapter-list response](https://maktabah-demo-api.ashahin.workers.dev/api/v1/books/light/chapters) returns the same summaries in `data`, with the common metadata plus `meta.bookId: "light"`. Summaries do not contain reading text.

Observed [full chapter `light/0`](https://maktabah-demo-api.ashahin.workers.dev/api/v1/books/light/chapters/0):

| Field | Type | Observed value or shape |
| --- | --- | --- |
| `index` | int | `0` |
| `number` | int | `1` |
| `bookId` | String | `light` |
| `title` | String | `البداية التي نختارها` |
| `paragraphs` | List of Strings | Four Arabic paragraphs |
| `chapterCount` | int | `3` |
| `previousChapterIndex` | int or null | `null` |
| `nextChapterIndex` | int or null | `1` |

All eight fields are required by the schema; the navigation fields are nullable. Chapter indexes are zero-based, while display numbers are one-based. Currently indexes `0`, `1`, and `2` are available. Malformed/unsafe indexes are documented as HTTP 400; valid unavailable indexes as HTTP 404. [Chapter schema and route](https://maktabah-demo-api.ashahin.workers.dev/openapi.json)

## Home response

The observed [home GET](https://maktabah-demo-api.ashahin.workers.dev/api/v1/home) contains these top-level `data` keys:

| Key | Shape |
| --- | --- |
| `welcomeTitle`, `welcomeSubtitle` | Strings |
| `hero` | `{eyebrow, title, actionLabel, books: Book[]}` |
| `quote` | `{text, attribution}` |
| `categories` | Category array |
| `featuredBooks` | Book array |
| `demoContinueReading` | `{book: Book, position: ReadingPosition, progressPercent: int}` |

The unfiltered sample had three hero books (`slow`, `sea`, `light`) and five featured books (`light`, `sea`, `memory`, `slow`, `cosmos`). Its continue-reading book was `beginnings`, with `progressPercent: 32`.

The contract states that `category` filters **only `featuredBooks`**. Hero books, category counts, and the continue-reading seed stay unchanged. After local initialization, construct continue reading from the device's current state rather than treating `demoContinueReading` as current user history. [Home operation](https://maktabah-demo-api.ashahin.workers.dev/openapi.json)

## Demo state and local storage

The observed [demo-state GET](https://maktabah-demo-api.ashahin.workers.dev/api/v1/demo-state) returned this complete `data` object:

```json
{
  "saved": ["light", "slow", "beginnings"],
  "progress": {
    "beginnings": {"chapter": 0, "scroll": 0.96, "updatedAt": 0}
  },
  "bookmarks": [],
  "preferences": {"fontSize": 21, "theme": "light"},
  "lastRead": "beginnings"
}
```

`saved` is a unique array of book IDs. `progress` is a map keyed by book ID. Each position requires `chapter` (nonnegative integer), `scroll` (number from 0 to 1), and `updatedAt` (nonnegative integer milliseconds since the Unix epoch). Zero is the seed's placeholder timestamp. `preferences` requires positive numeric `fontSize` and `theme` equal to `light` or `dark`. `lastRead` is a book ID. [DemoState and ReadingPosition schemas](https://maktabah-demo-api.ashahin.workers.dev/openapi.json)

The empty observed bookmarks list does not demonstrate bookmark serialization. The contract nevertheless defines the required Bookmark fields as **`bookId: String`, `chapter: int >= 0`, and `scroll: number 0..1`**. It does not require a bookmark ID, label, or timestamp. Add any such fields only as an app-owned local extension. [Bookmark schema](https://maktabah-demo-api.ashahin.workers.dev/openapi.json)

Import this seed **once into a new local store**. Subsequent launches must preserve all user changes, including intentionally empty collections. An initialization marker, versioned local document, serialized updates, and optional Start empty flow are implementation decisions specified in the [implementation roadmap](BUILD_ROADMAP.md); the API does not supply them. [Demo-state operation](https://maktabah-demo-api.ashahin.workers.dev/openapi.json)

`scroll` describes fractional position within one chapter. The contract's sample progress calculation is:

```text
overallFraction = (chapter + scroll) / chapterCount
progressPercent = round(overallFraction * 100)
```

For the seed, `(0 + 0.96) / 3 = 0.32`, so display **32%**, using `0.32` as the progress-indicator fraction. Restore a saved fraction against the rendered chapter's scroll extent; it is not a paragraph index or a whole-book percentage. The API does not specify pixel offsets, paragraph anchors, or the rule for chapters that fit without scrolling. Those are client decisions. [Home progress description and ReadingPosition schema](https://maktabah-demo-api.ashahin.workers.dev/openapi.json)

Library tab semantics are also client decisions. If All books means `saved ∪ progress.keys`, the observed seed has **three unique All books, one Reading now book, and three Saved books**, because `beginnings` is already saved. There are no Library-tab endpoints or server counts for the user's library. [Observed seed](https://maktabah-demo-api.ashahin.workers.dev/api/v1/demo-state)

## Documented error handling and verification limits

The documented error shape is:

```json
{
  "error": {
    "code": "INVALID_QUERY",
    "message": "Arabic explanation",
    "field": "limit"
  },
  "meta": {
    "apiVersion": "v1",
    "language": "ar",
    "direction": "rtl",
    "isDemo": true
  }
}
```

`code` and `message` are required. `field` is present for `INVALID_QUERY`. Other documented codes are `BOOK_NOT_FOUND`, `INVALID_CHAPTER_INDEX`, `CHAPTER_NOT_FOUND`, `IMAGE_NOT_FOUND`, `NOT_FOUND`, `METHOD_NOT_ALLOWED`, and `INTERNAL_ERROR`. Statuses include 400 for invalid inputs, 404 for unavailable resources, 405 for unsupported methods, and 500 for internal failures. Successful JSON caching is documented as `public, max-age=300`; errors use `no-store`; CORS allows all origins. [Error and response definitions](https://maktabah-demo-api.ashahin.workers.dev/openapi.json)

Live payloads checked: OpenAPI, home, demo state, `light` details, `light` chapter list, `light` chapter 0, and one filtered/paginated books request. The full 12-book catalog, every chapter, cover image bytes, empty-result branches, all invalid-input branches, HTTP headers, unsupported methods, and any outage behavior were not independently tested. Use the contract for these details and fixed fixtures for automated tests; do not rely on a live server in ordinary unit tests.
