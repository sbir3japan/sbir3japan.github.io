---
title: "DockerComposeを使用したネットワークブートストラップする"
linkTitle: "DockerComposeを使用したネットワークブートストラップする"
date: 2021-07-29T11:30:24+09:00
tags: ["docker", "bootstrap"]
description: >
  Dockerformは、CordaノードをDockerコンテナのローカルに簡単にデプロイすることができます
---

Dockerformは、CordaノードをDockerコンテナのローカルに簡単にデプロイすることができます。

これは、Cordaのgradleプラグインが提供するタスクで、Network Bootstrapperが生成したアウトプットを使って、ブートストラップされたCordaネットワークを簡単に起動するために使用できる`docker-compose.yml`ファイルを自動的に生成します。

Network Bootstrapperの公式ドキュメントは[こちら](https://docs.corda.net/docs/corda-os/4.8/network-bootstrapper.html#network-bootstrapper)です。

## メリット

- Network Bootstrapper（こちらでも説明しています）構築を簡略化できるdocker-compose.yamlを自動的に作成します。これにより手動での構築が不要になります。
- Cordaノードとそのデータベースの両方のデプロイメントをより適切に制御できるようになります。
- [Kubernetes](https://docs.corda.net/docs/corda-enterprise/4.8/operations/deployment/deployment-kubernetes.html)でも使用可能な公式[Dockerイメージ](https://docs.corda.net/docs/corda-os/4.8/docker-image.html#official-corda-docker-image)の使用方法を理解することができます。

## ウォークスルー事例

ドキュメントには、Dockerformがどのように機能するかが非常によく説明されています。ここでは、R3のGitHubにあるCorDappのサンプルを見てみましょう。

[https://github.com/corda/samples-kotlin/tree/master/Features/dockerform-yocordapp](https://github.com/corda/samples-kotlin/tree/master/Features/dockerform-yocordapp) .

{{% pageinfo color="primary" %}}
Dockerformについてのドキュメントは[こちら](https://docs.corda.net/docs/corda-os/4.8/generating-a-node.html#use-cordform-and-dockerform-to-create-a-set-of-local-nodes-automatically)。
{{% /pageinfo %}}

### build.gradleの新しいタスク

- 外部からSSHでDockerコンテナに接続するために必要な "sshdPort "を追加します
  - ノードに使用する公式Corda Docker Imageを宣言します
  - 外部からSSHでDockerコンテナに接続するために必要な "sshdPort "を追加します

<img src="/docs/images/developers/docker-1.png" alt="drawing" style="width:600px;"/>

### prepareDockerNodes "タスクを実行する

`./gradlew prepareDockerNodes`を実行すると、`/build/nodes`フォルダ内に以下のようなアウトプットが作成されます。

- `docker-compose.yaml`は、`prepareDockerNodes`タスクから取得した情報で自動的に生成されます。
  
<img src="/docs/images/developers/docker-2.png" alt="drawing" style="width:300px;"/>

以下は、`docker-compose.yaml`の内容です。Dockerのすべてのボリュームが、`build/nodes`内に生成されたフォルダに関連付けられています。

<img src="/docs/images/developers/docker-3.png" alt="drawing" style="width:600px;"/>

### 外部データベースを追加する

上記の例ではH2データベースを使用していますが、他のデータベースを追加することも可能です。DockerformがDockerコンテナの作成を行います。PostgreSQLを使った例を見てみましょう。

{{% pageinfo color="primary" %}}
こちらの内容は、[こちら](https://www.notion.so/JP-Docker-Compose-Corda-Dockerform-8fd2801bee984865ba2822ee018ad6d4#4c0677cf98d84e9d8bb8274c63c28d96)のドキュメントにも記載されています。
{{% /pageinfo %}}

ドキュメントに記載されている手順が完了したら、`./gradlew prepareDockerNodes`を実行します。ここでは、出力と`docker-compose.yaml` が更新されます。PostgreSQLのパラメータを設定した新しいサービスである`notary-db`があります。

<img src="/docs/images/developers/docker-4.png" alt="drawing" style="width:600px;"/>

また、Dockerformは上記のDocker Composeで使用されるPostgreSQLのDockerfileと、データベースを初期化するスクリプトも作成します。

<img src="/docs/images/developers/docker-5.png" alt="drawing" style="width:600px;"/>


<img src="/docs/images/developers/docker-6.png" alt="drawing" style="width:800px;"/>