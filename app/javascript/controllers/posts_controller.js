import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="posts"
export default class extends Controller {
  static targets = ["title", "status", "submit", "permalink", "error_permalink", "current_permalink"]

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
    const submitBtn = this.submitTarget

    // セットされているTimeoutをクリアする
    clearTimeout(this.timeoutPermalink)

    this.timeoutPermalink = setTimeout(() =>{
      if(permalinkInput.value === ""){ // パーマリンクが未入力の場合
        permalinkInput.style.border = "2px solid red"
        permalinkError.textContent = "パーマリンクを入力してください"
        permalinkError.style.color = "red"
        submitBtn.disabled = true
      }else{
        const csrfToken = document.getElementsByName('csrf-token')[0].content // CSRFトークンを取得
        const currentPermalink = this.current_permalinkTarget.textContent // 現在の投稿のパーマリンク
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
    // const inputContentBox = document.getElementById("postContentInput_ifr").contentWindow.document
    // const inputContent = inputContentBox.getElementById("tinymce").innerHTML
    // const inputCategories = this.categoriesTarget.querySelectorAll("input")
    // // const inputContent = inputContentBox.getElementById("tinymce")
    // console.log(this.categoriesTarget)
    // for(const category of inputCategories){
    //   console.log(category)
    // }
    // console.log(inputContent)
  }
}
