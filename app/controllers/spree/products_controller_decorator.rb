module Spree
	ProductsController.class_eval do
		before_action :write_recently_visited, only: :show
		before_action :load_all_products, only: :index

		def favorites
			@favorites = Product.active(current_currency).where(:id => session[:favorite])
		end

		def add_favorite
			session[:favorite] = Array(session[:favorite]).push(params[:product_id].to_i).uniq
			redirect_to "/favorites"
		end

		def remove_favorite
			session[:favorite] = Array(session[:favorite]).delete(params[:product_id].to_i)
			redirect_to "/favorites"
		end


		private

		def	write_recently_visited
			load_product
			session[:recently_visited] = Array(session[:recently_visited]).insert(0, @product.id).uniq.take(10)
		end

		def load_all_products
			if try_spree_current_user.try(:has_spree_role?, "admin")
				@all_products = Product.with_deleted
			else
				@all_products = Product.active(current_currency)
			end
		end

	end
end
