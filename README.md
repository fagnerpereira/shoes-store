## Shoe Store
This project is a shoes store implementation with a websocket endpoint that listens to some Shopify events and performs certain behaviors based on those events. The application was implemented using Rails 7 with Hotwire, without using any additional JS frameworks such as React or Vue.js, in order to keep it as simple as possible.

## Approach
- I created a `/webhooks` endpoint where I receive inventory update requests. The idea I thought of here was to simulate as if I had done an integration with Shopify and I would receive all the updates regarding my store on that endpoint and then process them.
- As soon as I receive the request, I enqueue the received data in the `Webhooks::CreateJob` worker. This worker is responsible for saving the payload received in a table called Webhooks. 
PS: I could simply process this webhook synchronously or asynchronously directly without saving the data, as I did in the first place. However, I used this approach because I wanted to guarantee first that the request would not take too long depending on the insertion of the record in the table, second that if the webhook could not be processed, for example if it had incorrect or incomplete data, I could find it later in the database and be able to debug why this happened, third that maybe it wasn't really necessary to process this webhook immediately, giving me the freedom to choose the time interval that I process it using sidekiq's screduler.
- Every 10 seconds the sidekiq scheduler calls the `Webhooks::ProcessJob` worker, where I get all the pending approval webhooks and process them. This webhook processing performs:
  - Inserts a record in the sales table of a sale

  PS: at first I wasted some time trying to understand if I would really create just one sale. Because with each request in the webhook I simply receive the updated inventory, so I thought that, for example, if I calculated the previous value of the inventory with the new value of the inventory, I could take the quantity of products sold. Later I ended up changing this approach to make it simpler and because I'm assuming that maybe the inventory is always changing regardless of online sales because there are also sales in physical stores. So here I simply tried to simplify and simulate that every request received I simulate a fake sale. I may have misunderstood, sorry :(
  - I update the inventory of a certain store for that product
  - I update the status of the webhook to processed
  - I queue the webhook to be removed if everything goes without any problem


When I create a new record in the Sales table I perform some important actions:

    1. I save the metadata related to the sale, so as not to be directly dependent  on the relationship with the Product/Store, for example price changes. So I will have the sale price and not the updated product
    2. I update the graphics using turbo rails broadcasts. As I said at the beginning, I'm not using any js framework, but simply the rails 7 stack leaving the app reactive using stimulus, turbo frames and turbo streams. So I don't update the graphics every second a new sale is created, I created a cache in redis to control when I update. This is cool for example, if there is a demand for me to implement a feature on the screen to allow the user to choose whether he wants to view the graph in real time, if so, what interval, 10 seconds, 1min, etc.Here I had some problems implementing this update with turbo and the chartjs lib, but later I can try to explain more calmly.
    3. I update a counter cache that I put in the stores table, so I don't need to get millions of sales to calculate the total that each store had

For the rest, I simply created some validation tests and the webhook processing flow. I created some graphics on the screen to show stores that sold the most, products that sold the most, I put a pagination because I created a lot of sales to test performance. I used appsignal to add improvements as I worked on the project and tested it.



## Running Tests

To run tests, run the following command

```bash
  rails t
```


## Demo

https://damp-surf-4903.fly.dev/


## Features

- All sales charts
- Sales by stores charts
- Top Products sales charts
- Top Stores sales charts
- Realtime update charts
- Light/dark mode toggle
- CRUD for stores/products
- Inventory index
- ~~Realtime notifications~~
- Pagination
- ~~Scale using Anycable or Ably~~

## Lessons Learned

What did you learn while building this project? What challenges did you face and how did you overcome them?

- I wanted to try to do it in a way that is really similar to Shopify's webhooks, for example they send a payload containing several sales and not a request for each sale. I tried to do this using sqs with aws lambda, that is, instead of the websocket client making the request directly in my app, it would go to this aws queue, so there it would save these webhooks and then send them every n time or n requests a single request for my app. That way I would save a lot in a real case. As I don't know much about aws, I ended up spending a few days testing this approach, I even managed to implement it, but after I saw that it was getting too complex and I had already delayed a lot in delivery, I ended up giving up. But it turned out that learning paid off in a way.

- Another concern I had too was with rails scalability using turbo streams (action cable). I did a lot of research on the subject, and found some options, but I didn't implement them.
    - One option is to use any cable, which is an alternative to the actio cable and has the ease of being more easily scalable, as you configure one or other servers and manage to connect to the rails and thus keep the turbo streams working normally. https://anycable.io/
    - Another alternative that seemed interesting to me was Ably. This probably in the next few days I will try to do a test in this project, because it seemed like an interesting solution to this type of problem.
      Here is a interesting article about good/bad abount action cable https://ably.com/blog/rails-actioncable-the-good-and-the-bad
    - in the beginning I used tailwindcss, because I'm very used and I feel very productive with the framework. However, after a few days I saw that it wouldn't be very useful, because I wouldn't invest a lot of time to produce something very beautiful, so I removed tailwind and added a lib called Pico.css (I didn't know it, but I already love it a lot hehe ). It is very useful to implement small projects and leave the css very clean using a more html semantic approach to create grids, navs, containers and leaving the dev free to create on top of that without the need to use a heavier css lib . https://picocss.com/
## Run Locally

Clone the project

```bash
  git clone git@github.com:fagnerpereira/shoes-store.git
```

Go to the project directory

```bash
  cd shoes-stores
```

Install or set ruby version 3.2.1

```bash
  rvm install 3.2.1
  rvm use 3.2.1
```

Install dependencies

```bash
  bundle
```

Run the migrations and seed database

```bash
  rails db:create db:migrate db:seed
```

Start rails server

```bash
  rails s
```

Start websocket server

```bash
  git clone https://github.com/mathieugagne/shoe-store
  cd shoe-store
  websocketd --port=8080 ruby inventory.rb
```

Start websocket client to push webhook requests

```bash
  gem install faye-websocket
  gem install eventmachine
```

Example
```bash
  require 'faye/websocket'
  require 'eventmachine'
  require 'json'
  require 'net/http'

  EM.run {
    ws = Faye::WebSocket::Client.new('ws://localhost:8080')
    #uri = URI('http://localhost:3000/webhooks')
    uri = URI('https://damp-surf-4903.fly.dev/webhooks')

    ws.on :message do |event|
      p JSON.parse(event.data)
      begin
        res = Net::HTTP.post_form(uri, JSON.parse(event.data))
        p res
      rescue => exception
        p exception.message
      end
    end
  }
```
## Tech Stack

**Client:** Stimulus, Pico.css, Chartjs

**Server:** Rails 7 with Hotwire

