class StoreController < ApplicationController
  def index
    @products = Product.find_products_for_sale
    @cart = find_cart
    if session[:counter].nil?
      session[:counter] = 0 
    end
    session[:counter] += 1
  end

  def add_to_cart
    product = Product.find(params[:id])
    @cart = find_cart
    @current_item = @cart.add_product(product)
    session[:counter] = 0
    respond_to do |format|
      format.js if request.xhr?
      format.html {redirect_to_index}
    end
  rescue ActiveRecord::RecordNotFound
    logger.error("無効な商品#{params[:id]}にアクセスしようとしました")
    redirect_to_index("無効な商品です")
  end

  def empty_cart
    session[:cart] = nil
    redirect_to_index
  end

  def redirect_to_index(msg = nil)
    flash[:notice] = msg if msg
    redirect_to :action => 'index'
  end

  private
    def find_cart
      session[:cart] ||= Cart.new 
    end

end
