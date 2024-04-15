# 💎 RACK json API
Author: Ivan Talijancic | italijancic@outlook.com

This repo is hosting a `basic rack json api` that implement this features:

- Build a rack app
- Build a middleware using rack (BasicAuth)
- Handle several routes
- Answer with JSON responses
- Implement rspec
- Dockerize app:
  - Simple docker version
  - _"More production-ready version"_: using [phusion passenger](https://github.com/phusion/passenger)

The use case to illustrate this functionality is an app to work with `products`:

- Create a new product
- Get the list of all products
- Get one peoduct by `id`
- Delete a peoduct by `id`

## ⚡️ Elementary conceptions
- A global loader is implemented to handle project files, using `zeitwerk` gem.
- To handle `routes` is designed a router that tries to emulate `rails` actions:

```rb
# ----------------
# Routes to handle
# ----------------
# GET     /resource           # index   - get a list of the resources
# GET     /resource/:id       # show    - get a specific resource
# DELETE  /resource/:id       # delete  - delete the specific resource
# GET     /resource/new       # new     - get an HTML page with a form
# POST    /resource           # create  - create a new resource
#
# -------
# Pending
# -------
# PUT   -> Complete update of one resource
# PATCH -> Partial update of one resource
```
- To handle models we use an approach similar to `rails ActiveResource`.
- As DB we have two options, always persisting data on files:
  - `pstore`: binary file
  - `yml`
- To authenticate we use `BasiAuth` see credentials on `.env` files

## 🛣️ Implemented routes

### ｛｝JSON responses
  - **main:** `http://127.0.0.1:3000/products`
  - **specific resource:** `http://127.0.0.1:3000/products/:id`, where the `id` in the index on DB.

See in the next section the differents `HTTP methods` and actions that have been implemented.

### 📚 Example request

#### [💎...💎] Get all products

```bash
curl -X GET -u italijancic:test1234 http://127.0.0.1:3000/products
```
##### Compresed response

```bash
curl -X GET --compressed -u italijancic:test1234 http://127.0.0.1:3000/products
```

#### {💎} Get one product by id

```bash
curl -X GET -u italijancic:test1234 http://127.0.0.1:3000/products/:id
```

#### 🆕 Create a new product

```bash
curl -X POST -u italijancic:test1234 http://127.0.0.1:3000/products -H "Content-Type: application/json" -d '{"name":"product_name"}'
```

#### ⌫ Delete a product by id

```bash
curl -X DELETE -u italijancic:test1234 http://127.0.0.1:9292/products/:id
```

*NOTE:* `port` will be `3000` if we run app with `docker compose` or `9292` if we run app from `Dockerfile.base` or locally

## 🚀 How to run the app

### 🐳 Dockercompose: Recommended

Build app

```bash
docker compose build
```

Run app

```bash
docker compose run
```

### 🐳 Dockerfile.basic

Build app

```bash
docker build -f Dockerfile.basic -t json-rack-app .
```

Run app

```bash
docker run -p 9292:9292 -e RACK_ENV=development json-rack-app
```

### 💻 Locally
Go to app folder and run:

```bash
rackup
```

#### ⌨️ APP CLI

To interact with app using a CLI you can run

```bash
# CMD to start CLI on app
➜ mvc-rack-app (master) ✔ bundle exec rack-console
Loading development environment (Rack::Console 1.3.1)

# Example CMD to get all dogs in DB
irb(main):001> Product.all
```

## 📚 Resources

- [MVC rack app from scratch](https://tommaso.pavese.me/2016/06/05/a-rack-application-from-scratch-part-1-introducting-rack/#a-naive-and-incomplete-framework)

- [Rack Page](https://github.com/rack/rack)
