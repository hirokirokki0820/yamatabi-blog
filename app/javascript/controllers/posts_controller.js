import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="posts"
export default class extends Controller {
  static targets = ["title", "status", "submit"]

  // タイトルなしの場合の処理（「無題」をタイトルに挿入)
  insertNonTitle(){
    const titleInput = this.titleTarget
    if (titleInput.value === ""){
      titleInput.value = "(無題)"
    }
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
