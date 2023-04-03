import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="confirms"
export default class extends Controller {

  connect() {
      const confirmMsg = true
      window.onbeforeunload = function(e){
        e.preventDefault()
        if(confirmMsg){
          e = e || window.e
          e.returnValue = '入力中のページから移動しますか？';
        }
      }
  }

  notConfirm(){
    window.onbeforeunload = false;
  }
}
