# Creating Content

## Quick Start

To edit documentation `md` files in this repository, all you need to do is to:

1. [Fork this repository](https://guides.github.com/activities/forking/).
2. [Edit your fork](https://guides.github.com/activities/forking/#making-changes).
3. [Push to your fork](https://guides.github.com/activities/forking/#making-changes).
4. [Make a pull request](https://guides.github.com/activities/forking/#making-a-pull-request).

## Where are the articles?

All Hugo site content is stored under the `/content` folder.

The main documentation is specifically in `/content/jp`.

The file and folder layout matches what you see in the URL bar of your browser.

## Creating an article

There are two ways to create an article:

1. copy another article
2. use Hugo (preferred)
3. use the `new-post.sh` script

### Use Hugo (preferred)
From the root folder of the repository:

```shell
hugo new docs/developers/design/new-article.md
```

This will produce a new file in `/content/en/docs/developers/design/new-article.md`

```markdown
---
title: "New Article"
linkTitle: "New Article"
date: 2021-07-28T16:21:40+09:00
tags: ["this", "another-tag"]
description: >
  Put a single line description of the article
---

This is a new article.
```

Update the `tags` and `description` with the ones of your choice.

You are free to change also the title even after the file has been generated (remember to also change the `linkTitle`). 

### Use the new-post.sh script
You can use an automated script where you need to enter the `category/subcategory/title` and it will generate the article automatically.

```bash
$ ./new-post.sh 
Please, select the category of your article:
1) developers
2) FAQ
3) release_note
4) understanding_corda
#? 1
You chose developers

Please, select the sub-category:
1) cordapp_development  3) getting_started      5) node_operations      7) samples
2) design               4) network_operations   6) performance
#? 2
You chose developers/design

Please, select the title of the article (if you want to change it later, you will have to change the name of the file under developers/design
this-is-a-test
/home/brain/workspace/sbir3japan.github.io/content/jp/docs/developers/design/this-is-a-test.md created
```

## Everything is Markdown

We recommend that you use [Visual Studio Code](https://code.visualstudio.com/) or an editor of your choice that can edit (and preview) Markdown.

We also recommend installing [markdownlint](https://marketplace.visualstudio.com/items?itemName=DavidAnson.vscode-markdownlint) VSC extension which includes a library of rules to encourage standards and consistency for Markdown files.

Also this VSC extension is great [Markdown All In One](https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one).


## Hugo Shortcodes

[Shortcodes](https://gohugo.io/content-management/shortcodes/#readout) allow us to extend Markdown.

If you are not familiar with Markdown, you can check [markdown-example](markdown-example.md) to see many examples of shortcode that you can reuse for your article.