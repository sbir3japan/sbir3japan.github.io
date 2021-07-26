# Corda Guide (under construction)

This is a version of Corda Guide by SBI R3 Japan based on Hugo. It is not the official Corda Guide, which can be found [here](https://support.sbir3japan.co.jp/hc/ja).

## Theme

The theme in use is [Docsy](https://example.docsy.dev/).
You can find detailed theme instructions in the Docsy user guide: https://docsy.dev/docs/.

The theme is included in this project as a Git submodule:

```bash
▶ git submodule
 a053131a4ebf6a59e4e8834a42368e248d98c01d themes/docsy (heads/master)
```

If you want to do SCSS edits and want to publish these, you need to install `PostCSS`


## Running the website locally

### Requirements 
- [Hugo](https://gohugo.io) in `extended` version.
- [npm](https://nodejs.org/en/download/) 

### Build the project
1. The first installation needs to download the theme submodule. So, please run: `themes/docsy && git submodule update -f --init`
2. `npm install`
3. `hugo server`
4. Open your web browser and type `http://localhost:1313` .

## Running into a Docker container

You can run docsy-example inside a [Docker](https://docs.docker.com/) container, the container runs with a volume bound to the root folder. This approach doesn't require you to install any dependencies other than [Docker Desktop](https://www.docker.com/products/docker-desktop) on Windows and Mac, and [Docker Compose](https://docs.docker.com/compose/install/)on Linux.

1. Build the docker image `docker-compose build`
  
1. Run the built image `docker-compose up`

   > NOTE: You can run both commands at once with `docker-compose up --build`.

2. Verify that the service is working. Open your web browser and type `http://localhost:1313` .

### Cleanup Docker container

To stop Docker Compose, on your terminal window, press **Ctrl + C**. 

To remove the produced images run `docker-compose rm`

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

