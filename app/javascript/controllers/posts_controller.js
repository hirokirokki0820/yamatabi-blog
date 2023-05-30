import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="posts"
export default class extends Controller {
  static targets = ["title", "status", "submit", "permalink", "error_permalink", "current_permalink", "embed_type", "embed_input"]

  // タイトルなしの場合の処理（「無題」をタイトルに挿入)
  insertNonTitle(){
    const titleInput = this.titleTarget
    if (titleInput.value === ""){
      titleInput.value = "(無題)"
    }
  }

  // パーマリンクのバリデーション
  permalinkValidation(){
    const permalinkInput = this.permalinkTarget
    const permalinkError = this.error_permalinkTarget
    const permalinkRegex = /^[0-9a-zA-Z\-]*$/ // 半角英数字とハイフンのみ(空白NG)
    const currentPermalink = this.current_permalinkTarget.textContent // 現在の投稿のパーマリンク
    const submitBtn = this.submitTarget

    // セットされているTimeoutをクリアする
    clearTimeout(this.timeoutPermalink)

    this.timeoutPermalink = setTimeout(() =>{
      if(!permalinkRegex.test(permalinkInput.value)){
        permalinkInput.style.border = "2px solid red"
        permalinkError.textContent = "半角英数字とハイフンのみで入力してください(空白NG)"
        permalinkError.style.color = "red"
        submitBtn.disabled = true
      }else{
        const csrfToken = document.getElementsByName('csrf-token')[0].content // CSRFトークンを取得
        const options = {
          method: "POST", // POSTメソッドを指定
          headers: {
                  'Accept': 'application/json',
                  'Content-Type': 'application/json',
                  'X-CSRF-Token': csrfToken // CSRFトークンを設定
                }
        }
        const params = { // 入力したパーマリンクをパラメータオブジェクトに代入する
          permalink: permalinkInput.value
        }
        const query_params = new URLSearchParams(params) // オブジェクト形式のparamsをクエリ文字列に変換
        // posts#is_registered?アクション に POSTリクエスト(クリエパラメータでemail情報の送信)
        fetch("/check_permalink" + "?" + query_params, options)
          .then(response => response.json())
          .then(data => {
            if (data && !(data.permalink === currentPermalink)) { // レスポンスに投稿内容が返ってきた場合（すでにパーマリンクが存在する場合）
              permalinkError.textContent = 'このパーマリンクはすでに登録されています'
              permalinkInput.style.border = "2px solid red"
              permalinkError.style.color = "red"
              submitBtn.disabled = true
            }else{ // 投稿が存在しない場合
              permalinkInput.style.border = "2px solid lightgreen"
              permalinkError.textContent = ""
              submitBtn.disabled = false
            }
          })
      }
    }, 300)
  }

  // 「下書き保存」 or 「公開」 の選択
  changeStatus(){
    const selectedStatus = this.statusTarget.value
    const submitBtn = this.submitTarget
    if (selectedStatus === "draft"){
      submitBtn.value = "下書き保存"
      submitBtn.classList.add("btn-secondary")
      submitBtn.classList.remove("btn-primary")
    }else{
      submitBtn.value = "公開する"
      submitBtn.classList.add("btn-primary")
      submitBtn.classList.remove("btn-secondary")
    }
  }

  /********** モーダルの表示(Bootstraoo) ***********/
  openModal(e){
    const imageModal = new bootstrap.Modal(document.getElementById('embedLinkModal'), {})
    imageModal.show()

  }

  /******* Twitter または YouTube の埋め込み *******/
  insertEmbedLink(){
    const embedSelects = this.embed_typeTarget.querySelectorAll("input")
    const embedInput = this.embed_inputTarget
    for(const embedSelect of embedSelects){
      if(embedSelect.checked){
        if(embedSelect.value === "twitter" && !(embedInput.value === "")){
          const csrfToken = document.getElementsByName('csrf-token')[0].content // CSRFトークンを取得
          const tweetURL = `${embedInput.value}`
          const tweetID = `${tweetURL.split('/').pop()}`
          const options = {
            method: "POST", // POSTメソッドを指定
            headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json',
                    'X-CSRF-Token': csrfToken // CSRFトークンを設定,
                  },
          }
          const params = { // 入力したパーマリンクをパラメータオブジェクトに代入する
            tweet_id: tweetID
          }
          const query_params = new URLSearchParams(params) // オブジェクト形式のparamsをクエリ文字列に変換
          fetch("/get_tweet" + "?" + query_params, options)
            .then(response => response.json())
            .then(response => {
              tinymce.activeEditor.insertContent('<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">' + response.data.text + '</p><a href="' + tweetURL + '"></a></blockquote><script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>')
          })
        }else if(embedSelect.value === "youtube" && !(embedInput.value === "")){
          const youtubeEmbedURL = `${embedInput.value}`
          const youtubeEmbedID = `${youtubeEmbedURL.split('/').pop()}`
          const shareURL = youtubeEmbedURL.split('/').splice(2, 1).join()
          if(shareURL === "youtu.be"){
            tinymce.activeEditor.insertContent('<iframe width="560" height="315" src="https://www.youtube.com/embed/' + youtubeEmbedID + '" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>')
          }
        }
      }
    }
    embedInput.value = ""
  }

}
