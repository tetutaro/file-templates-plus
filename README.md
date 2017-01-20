# file-templates-plus

[file-templates](https://atom.io/packages/file-templates)は便利なパッケージである。
しかし、テンプレートからファイルを作った後、いちいちファイル名をつけて保存しなければならない。
そこがめんどくさい。

しかし、[tree-view](https://atom.io/packages/tree-view)では、ファイル名をつけて新規ファイルを作成できる。
もちろんtree-viewだからディレクトリが解決しやすいのではあるが。

じゃあ、file-templatesにファイル名をつけて新規作成できるようにすればよいのではないか。
それが本パッケージである。

## 本パッケージの特徴

* 基本的には[file-templates](https://atom.io/packages/file-templates)と同じ
* テンプレートに拡張子を保存できる（".txt"のようにドットを含む形で）
* ファイルを新規作成する時に、テンプレートの選択、プロジェクトディレクトリの選択、ファイル名の入力となる
* その時、拡張子を自動的につけてくれる
* プロジェクトディレクトリ以下のディレクトリも掘る

## インストール方法

* 本レポジトリをクローンしてディレクトリに移動
* `> apm install`
* `> apm link`

## TODO

* new-filename-view で focus二回しないと focus してくれない
* tree-view からテンプレートを使ったファイル作成
