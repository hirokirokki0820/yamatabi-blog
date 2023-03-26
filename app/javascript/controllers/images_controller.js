import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="images"
export default class extends Controller {
  static targets = ["images", "image_box"]

  selectedImageBox(){
    const imageBoxSelected = this.image_boxTarget
    const imageBoxes = document.querySelectorAll(".image-box-selected")
    for(const imageBox of imageBoxes){
      imageBox.classList.remove("image-box-selected")
    }
    imageBoxSelected.classList.add("image-box-selected")
    // if(imageBox.classList.contains("image-box-selected")){
    //   imageBox.classList.remove("image-box-selected")
    // }else{
    //   imageBox.classList.add("image-box-selected")
    // }
  }

  insertImageTag() {
    const selectedImageTag = document.querySelector(".image-box-selected").firstElementChild
    // tinymce.activeEditor.insertContent(`"${selectedImageTag}"`)
    // tinymce.activeEditor.insertContent(`"${selectedImageTag}"`)
    const sr = `${selectedImageTag.getAttribute('src')}`
    tinymce.activeEditor.insertContent('<img src="' + sr + '" class="image-size" />')
  }

  imageSelectReset(){
    const selectedImages = this.imagesTarget.querySelectorAll(".image-box-selected")
    for(const selectedImage of selectedImages){
      selectedImage.classList.remove("image-box-selected")
    }
  }
}
