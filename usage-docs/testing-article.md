# Testing Your Changes

## Testing Using Hugo

In order to ensure your changes work, you should always be running hugo's webserver locally:

```
hugo serve
```

and testing your changes in your web browser.  

## Testing via Docker

You can also test using Docker, as described before.

* If you have already built the Docker images before, you need to delete them: `docker-compose rm`
* Rebuild the image and run the container: `docker-compose up --build`

and test your changes in your web browser.