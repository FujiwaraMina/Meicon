class Public::DownloadController < ApplicationController
  def post_download
    @post = Post.find(params[:id])
    send_data @post.post_image.download,
              :filename => @post.post_image.filename.to_s
  end
end