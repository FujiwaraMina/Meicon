// ①新規投稿ページでのみ発火
if (document.URL.match(/new/)){
  // HTMLが最初に読み込まれたときに作動する関数
  document.addEventListener('DOMContentLoaded', () => {
    const createImageHTML = (blob) => {
      const imageElement = document.getElementById('new-image'); //div要素のidのnew-imageを取得

      const blobImage = document.createElement('img'); //HTML要素の「img」を作成し、blobImageに格納
      blobImage.setAttribute('class', 'new-img')
      blobImage.setAttribute('src', blob); //classとsrcをimgに付与

      imageElement.appendChild(blobImage); //new.html.erbに追加したdiv要素の中にimg要素を入れる(画像を表示)

    };
    // フォームのidを取得し、フォームのファイル選択ボックスに変化が起こったときに行われる処理
    document.getElementById('post_post_image').addEventListener('change', (e) =>{
      //querySelector('.new-img')の()内は、上記で設定したクラスを入れるとうまくremoveされる
      const imageContent = document.querySelector('.new-img'); //.new-img要素を取得し、imageContentに格納
      if (imageContent){ //(imageContentに要素が入っている場合、removeされる
        imageContent.remove();
      }

      const file = e.target.files[0]; //取得したファイルの情報を定数fileに格納
      const blob = window.URL.createObjectURL(file); //取得した情報を文字列に変換し、定数blobに格納
      createImageHTML(blob); //blobを引数にcreateImageHTML( )関数を呼び出す
    });
  });
}