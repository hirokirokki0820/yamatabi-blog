import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="images"
export default class extends Controller {
  static targets = ["select", "preview_images", "preview_thumbnail", "error", "drop", "modal_footer"]


  /********** 画像アップロード時の処理 ***********/
  imageSizeOver(file){ // 1枚あたりのファイルサイズの上限（2MB)
    const fileSize = (file.size)/1000
    if(fileSize > 2000){
      return true
    }else{
      return false
    }
  }

  // ファイルを選択、アップロード
  selectImages(){
    const files = this.selectTargets[0].files
    // clearTimeout(this.timeoutImages)
    for(const file of files){
      if(this.imageSizeOver(file)){
        this.errorTarget.textContent = "ファイルサイズの上限(1枚あたり2MB)を超えている画像はアップロードできません。"
        this.timeoutImages = setTimeout(() =>{
          this.errorTarget.textContent = ""
        }, 3000)
      }else{
        this.uploadImage(file)
      }
    }
    this.selectTarget.value = "" // 選択中のファイルをリセット
  }

  dragover(e){
    e.preventDefault()
    this.dropTarget.classList.add("image-drag-over")
  }

  dragleave(e){
    e.preventDefault()
    this.dropTarget.classList.remove("image-drag-over")
  }

  dropImages(e){
    e.preventDefault()
    this.dropTarget.classList.remove("image-drag-over")
    const files = e.dataTransfer.files
    for(const file of files){
      if(this.imageSizeOver(file)){
        this.errorTarget.textContent = "ファイルサイズの上限(1枚あたり2MB)を超えている画像はアップロードできません。"
        this.timeoutImages = setTimeout(() =>{
          this.errorTarget.textContent = ""
        }, 3000)
      }else{
        this.uploadImage(file)
      }
    }
  }

  // 画像のアップロード
  uploadImage(file){
    const csrfToken = document.getElementsByName('csrf-token')[0].content // CSRFトークンを取得
    const formData = new FormData()
    formData.append("file", file) // formDataオブジェクトに画像ファイルをセット
    const options = {
      method: 'POST',
      headers: {
        'X-CSRF-Token': csrfToken
      },
      body: formData
    }
    fetch("/images/upload_image", options)
      .then(response => response.json())
      .then(data => {
        this.previewImage(file, data.id)
      })
      .catch((error) => {
        console.error(error)
      })
  }

  // 画像の削除
  deleteImage(){
    const thisImageBox = document.querySelector(".image-box-selected")
    if(thisImageBox){
      const imageId = thisImageBox.firstElementChild.id
      const csrfToken = document.getElementsByName('csrf-token')[0].content // CSRFトークンを取得
      const formData = new FormData()
      formData.append("image_id", imageId)
      const options = {
        method: 'POST',
        headers: {
          'X-CSRF-Token': csrfToken
        },
        body: formData
      }
      const result = window.confirm("本当に削除しますか？")
      if(result){
        fetch("/images/delete_image", options)
        thisImageBox.remove()
      }
    }
  }

  // 画像のプレビュー
  previewImage(file, blob_id){
    const previewImages = this.preview_imagesTarget
    const fileReader = new FileReader()
    const setAttr = (element, obj)=>{
      Object.keys(obj).forEach((key)=>{
        element.setAttribute(key, obj[key])
      })
    }
    fileReader.readAsDataURL(file)
    fileReader.onload = (function() {
      const img = new Image()
      const imgBox = document.createElement("div")
      const imgBoxAttr = {
        "class" : "image-box d-inline-flex justify-content-center mx-1 mb-3",
        "data-action" : "click->images#selectedImageBox"
      }
      setAttr(imgBox, imgBoxAttr)
      imgBox.appendChild(img)
      img.src = this.result
      img.id = blob_id
      img.class = "mx-auto"
      previewImages.prepend(imgBox)
    })
  }

  // アイキャッチ画像のプレビュー
  previewThumbnail(){
    const previewThumbnail = this.preview_thumbnailTarget
    const selectedImageBox = document.querySelector(".image-box-selected")
    if(selectedImageBox){
      if(previewThumbnail.hasChildNodes()){
        this.deletePreviewThumbnail()
      }
      const selectedImageTag = selectedImageBox.firstElementChild
      const setAttr = (element, obj)=>{
        Object.keys(obj).forEach((key)=>{
          element.setAttribute(key, obj[key])
        })
      }
      const img = new Image()
      const hiddenField = document.createElement("input")
      const hiddenFieldAttr = {
        "name" : "post[thumbnail]",
        "style" : "none",
        "type" : "hidden",
        "value" : selectedImageTag.id
      }
      setAttr(hiddenField, hiddenFieldAttr)
      img.src = selectedImageTag.src
      img.id = selectedImageTag.id
      previewThumbnail.appendChild(img)
      previewThumbnail.appendChild(hiddenField)
    }
  }

  deletePreviewThumbnail(){
    const previewThumbnail = this.preview_thumbnailTarget
    while(previewThumbnail.firstChild){
      previewThumbnail.removeChild(previewThumbnail.firstChild)
    }
  }


  /********** 画像挿入時の処理 ***********/
  selectedImageBox(e){
    const imageBoxSelected = e.currentTarget // 現在の要素を取得( e.currentTarget )
    const imageBoxes = document.querySelectorAll(".image-box-selected")
    for(const imageBox of imageBoxes){
      imageBox.classList.remove("image-box-selected")
    }
    imageBoxSelected.classList.add("image-box-selected")
  }


  insertImageTag() {
    const selectedImageBox = document.querySelector(".image-box-selected")
    if(selectedImageBox){
      const selectedImageTag = selectedImageBox.firstElementChild
      const sr = `${selectedImageTag.getAttribute("src")}`
      tinymce.activeEditor.insertContent('<img src="' + sr + '" class="image-size" />')
    }
  }

  //resetSelectedImage
  resetSelectedImage(){
    const selectedImages = this.preview_imagesTarget.querySelectorAll(".image-box-selected")
    for(const selectedImage of selectedImages){
      selectedImage.classList.remove("image-box-selected")
    }
  }

  /********** モーダルの表示(Bootstraoo) ***********/
  openModal(e){
    const imageModal = new bootstrap.Modal(document.getElementById('fileUploadModal'), {})
    imageModal.show()
    const modalFooterBtn = this.modal_footerTarget
    const modalType = e.currentTarget.getAttribute("data-modal-type")
    const setAttr = (element, obj)=>{
      Object.keys(obj).forEach((key)=>{
        element.setAttribute(key, obj[key])
      })
    }
    if(modalFooterBtn.firstElementChild){
      modalFooterBtn.firstElementChild.remove()
    }
    if(modalType === "thumbnail"){
      const thumbnailBtn = document.createElement("button")
      const thumbnailBtnAttr = {
        "type" : "button",
        "class" : "btn btn-primary",
        "data-bs-dismiss" : "modal",
        "data-action" : "click->images#previewThumbnail click->images#resetSelectedImage"
      }
      setAttr(thumbnailBtn, thumbnailBtnAttr)
      thumbnailBtn.textContent = "アイキャッチ画像に設定"
      modalFooterBtn.appendChild(thumbnailBtn)
    }else if(modalType === "content"){
      const contentBtn = document.createElement("button")
      const contentBtnAttr = {
        "type" : "button",
        "class" : "btn btn-primary",
        "data-bs-dismiss" : "modal",
        "data-action" : "click->images#insertImageTag click->images#resetSelectedImage"
      }
      setAttr(contentBtn, contentBtnAttr)
      contentBtn.textContent = "選択"
      modalFooterBtn.appendChild(contentBtn)
    }
  }

}
