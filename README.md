## Containerized Setup (You need to have Docker installed and running)

- `.env` - It has important environment variables
- `localhost.postman_collection.json` - You can import endpoints into Postman
- `documentation.apib` - You can use to generate API Blueprint documentation
- `documentation.html` - You can use to view documentation directly on browser

Start container:
```
$ docker-compose up -d
```

Enter into container:
```
$ docker container exec -it github_app sh
```

Install dependencies, run tests and you are ready to go:
```
$ mix deps.get
$ mix ecto.setup
$ MIX_ENV=test mix test
$ MIX_ENV=test mix coveralls
$ mix phx.server
```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
