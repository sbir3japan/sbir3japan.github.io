#  Corda Guide Usage

These pages explain how to add and submit documentation to Corda Guide.

Hugo has extensive [documentation](https://gohugo.io/getting-started/quick-start/).


## Build - Quick Start

Download:

* [Visual Studio Code](https://code.visualstudio.com/) or an editor of your choice.
* [Hugo - extended version](https://github.com/gohugoio/hugo/releases)
  * Ensure the `hugo` binary is on your `PATH`
* [npm](https://nodejs.org/en/download/) 
    
* [Fork this repository](https://guides.github.com/activities/forking/)

Then:

```
cd sbir3japan.github.io

./build.sh

hugo serve
```

* Open http://localhost:1313 (or whatever it says in the console) and you should be able to see the Corda Guide website.

## Build with Docker
If you do not want to download and install Hugo and npm, you can use Docker:

1. From the root folder, run `docker-compose build`
  
2. Once it is completed, run `docker-compose up`

   > NOTE: You can run both commands at once with `docker-compose up --build`.

3. Open your web browser and type `http://localhost:1313` 

### Cleanup Docker container

To stop Docker Compose, on your terminal window, press **Ctrl + C**. 

To delete the built containers and images, run `docker-compose rm`

## How To

* [Create new articles](creating-article.md)
* [Test your articles](testing-article.md)
* [Push your article](pushing-article.md)

## Troubleshooting

As you run the website locally, you may run into the following error:

```
➜ hugo server

INFO 2021/01/21 21:07:55 Using config file: 
Building sites … INFO 2021/01/21 21:07:55 syncing static files to /
Built in 288 ms
Error: Error building site: TOCSS: failed to transform "scss/main.scss" (text/x-scss): resource "scss/scss/main.scss_9fadf33d895a46083cdd64396b57ef68" not found in file cache
```

This error occurs if you have not installed the extended version of Hugo.
See our [user guide](https://www.docsy.dev/docs/getting-started/) for instructions on how to install Hugo.
