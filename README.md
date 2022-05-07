# timelab

## 目的
### 『研究室にいる**時間**に意味を持たせること』

大学で研究をしている人は、長い時間をかけて研究を頑張っている...<br>
しかし！ 頑張った3ヶ月後、その時間・頑張り覚えていますか？記録できてますか？<br>
僕の周りではできていない人が多くいました。<br>

それじゃあ、頑張りに意味を持たせれてないってことになるんじゃない？<br>

TIMELAB は「カレンダー機能」等でその問題を解決します！


## 画面 (絶賛現在開発中!)
<img width = 80% src = "https://raw.githubusercontent.com/hamadayuuki/timelab/main/README/TIMELAB_Github_UI一覧.jpg">

## 開発人数
2名

デザイナー : 1名<br>
発案/エンジニア(iOS)/PM : 1名<br>
<!-- エンジニア(Andoroid) : 1名<br>
エンジニア(WEB/DB設計) : 1名 -->


## 使用した技術

- 主要言語(iOS)
    - Swift (Storyboardなし)
        - SwiftUIに向けて, 複数人で開発するときにコードをドキュメントとして使えるように
- アーキテクチャ
    - [MVVM](https://github.com/hamadayuuki/practice-iOS-architectures/tree/main/MVVM)
        - データバインディングに魅力を感じたから
- ライブラリ
    - [RxSwift](https://github.com/hamadayuuki/swift-storyboard-tutorial/tree/main/RxSwift_1) : データバインディング
    - SnapKit : コードでの画面描画
    - QRScanner : QRコード読み取り用
    - Alamofire + SwiftyJSON : API連携
    - Firebase : バックエンド
    - FloatingPanel, FSCalendar, IQKeyboardManagerSwift, PKHUD : UI
    - (クックパッド : ディープリンク → 未実装)
- [API作成](https://github.com/hamadayuuki/timelab-api)
    - 研究室IDからQRコードを作成
- AdobeXD
    - デザイナーが作成したデザインを見ながらコーディングを行った
- miro
    - 画面遷移をデザイナーに伝えるために使用
    - DB設計で考えをまとめるために使用
    - APIの流れを整理するために使用
- (Unitテスト → 検討,学習中)
- ([FirebaseCloudMessaging](https://github.com/hamadayuuki/swift-storyboard-tutorial/tree/main/FirebaseCloudMessaging) を使用して通知機能実装 → 今後実装)


## 制作過程 (絶賛現在開発中!!!)

👇 Notionの一覧

<img width = 60% src = "https://raw.githubusercontent.com/hamadayuuki/timelab/main/README/TIMELAB_Notion一覧.png">

<br><br>

**① : アイデアだし**<br>
    ・どのような問題があり、どのように解決したいのか

<img width = 60% src = "https://raw.githubusercontent.com/hamadayuuki/timelab/main/README/TIMELAB_Github_%E5%88%9D%E6%9C%9F%E3%82%A2%E3%82%A4%E3%83%87%E3%82%A2.jpg">
<br><br>

**② : 問題/解決策 に関する調査**<br>
    ・本当に問題が起こっているのか、考えている解決策で解決できるのか<br><br>

**③ : アイデアのブラッシュアップ**<br>
    ・目的は何なのか<br>
    ・どのような人をターゲットにするのか<br>
    ・ゴールはどこか<br>
    ・どのような機能をつけたいのか<br><br>

**④ : 競合アプリの調査**<br>
    ・周りに似たようなアプリはないのか、30個程度アプリ(カレンダー, タイムカード, 出退勤管理, 学習アプリ 等)をインストールし調査<br>
        ・研究室×時間管理×共有 を強みにしているアプリはなかった<br>
        ・Studyplus, Github, mikan 辺りが機能の参考になりそう<br><br>

**⑤ : デザイナーへの呼びかけ**<br>
    ・同大学 文系学部 の女の子が協力してくれることに！<br><br>

**⑥ : デザイナー含めアイデア/UIのブラッシュアップ**<br>

<img width = 60% src = "https://raw.githubusercontent.com/hamadayuuki/timelab/main/README/TIMELAB_Github_画面遷移図.png">

<br><br>

**⑦ : 工数決定**<br>

<img width = 60% src = "https://raw.githubusercontent.com/hamadayuuki/timelab/main/README/TIMELAB_工数表.png">

<br><br>

**⑧ : 作業 → 現在進行中！**<br>
    ・デザインは一通り完成！<br>
        ・現在、毎週zoomで確認/修正中<br>
    ・Firebase との接続を確認するため、[プロトタイプを作成済み](https://github.com/hamadayuuki/timelab/tree/prototype/main)
