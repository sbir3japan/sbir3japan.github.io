# Creating Content

## Quick Start

To edit documentation `md` files in this repository, all you need to do is to:

1. [Fork this repository](https://guides.github.com/activities/forking/).
2. [Edit your fork](https://guides.github.com/activities/forking/#making-changes).
3. [Push to your fork](https://guides.github.com/activities/forking/#making-changes).
4. [Make a pull request](https://guides.github.com/activities/forking/#making-a-pull-request).

## Where are the articles?

All Hugo site content is stored under the `/content` folder.

The main documentation is specifically in `/content/ja`.

The file and folder layout matches what you see in the URL bar of your browser.

## How to create an article?

### 1. Fork the repository
Fork the repository into your personal github account.

### 2. Create a new branch
- Pull the repository from your personal github account into your computer
- Create a new branch `git checkout -b new-article-title`

Now you can start working in your separate branch.

### 2. Write the article
There are two ways to create an article:

1. copy another article and update the header metadata and content
2. use Hugo
3. use the `new-post.sh` script (preferred)

### 2a. (optional) Create the article use vanilla Hugo command line
From the root folder of the repository:

```shell
hugo new -k docs content/ja/docs/developers/design/new-article.md
```

This will produce a new file in `/content/ja/docs/developers/design/new-article.md`

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

### 2b. (recommended) Use the new-post.sh script
You can use an automated script where you need to enter the `category/subcategory/title` and it will generate the article automatically.

```bash
 ./new-post.sh 
--------------------------------------------
Please, select the category of your article:
--------------------------------------------
1) content/ja/docs/understanding_corda
2) content/ja/docs/FAQ
3) content/ja/docs/developers
4) content/ja/docs/release_notes
#? 3
------------------------------------------------
Please, select the sub-category of your article:
------------------------------------------------
1) content/ja/docs/developers/getting_started      4) content/ja/docs/developers/samples              7) content/ja/docs/developers/node_operations
2) content/ja/docs/developers/network_operations   5) content/ja/docs/developers/performance
3) content/ja/docs/developers/cordapp_development  6) content/ja/docs/developers/design
#? 1

-------------------------------------------------------------------------------------------------------------------
Insert the title of your article (you can always change it later, but remember to change the name of the file too):
-------------------------------------------------------------------------------------------------------------------
this-is-a-test
content/ja/docs/developers/getting_started/this-is-a-test.md create
```
### 3. Commit, push and make a pull request
- `git add content/ja/path-of-your-article/your-article.md`
- `git commit -m "New article added"`
- `git push origin your-branch`

Once the code is pushed in your personal github fork, you can make a new pull request against the main branch of the original repository.

## Everything is Markdown

We recommend that you use [Visual Studio Code](https://code.visualstudio.com/) or an editor of your choice that can edit (and preview) Markdown.

We also recommend installing [markdownlint](https://marketplace.visualstudio.com/items?itemName=DavidAnson.vscode-markdownlint) VSC extension which includes a library of rules to encourage standards and consistency for Markdown files.

Also this VSC extension is great [Markdown All In One](https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one).


## Hugo Shortcodes

[Shortcodes](https://gohugo.io/content-management/shortcodes/#readout) allow us to extend Markdown.

If you are not familiar with Markdown, you can check [markdown-example](markdown-example.md) to see many examples of shortcode that you can reuse for your article.