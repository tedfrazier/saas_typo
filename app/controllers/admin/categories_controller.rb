class Admin::CategoriesController < Admin::BaseController
  cache_sweeper :blog_sweeper

  def index
    redirect_to :action => 'new'
  end
  def edit
    new_or_edit
  end

  def new
    respond_to do |format|
      format.html {
        new_or_edit
      }
      format.js { 
        @category = Category.new
      }
    end
  end

  def destroy
    @record = Category.find(params[:id])
    return(render 'admin/shared/destroy') unless request.post?

    @record.destroy
    redirect_to :action => 'new'
  end

  private

  def new_or_edit
    
    @categories = Category.find(:all)
    
    # check to see if this is new or existing
      if params[:id] # existing case
        # set category attributes
        @category = Category.find(params[:id])
        @category.attributes = params[:category]
      else # new case
        @category = Category.new
        @category.attributes = params[:category]
      end
      if request.post?
        save_category
        return
      end
    render 'new'
  end

  def save_category
   respond_to do |format|
      format.html do
        if @category.save!
          flash[:notice] = _('Category was successfully saved.')
        else
          flash[:error] = _('Category could not be saved.')
        end
        redirect_to :action => 'new'
      end
      format.js do 
        @category.save
        @article = Article.new
        @article.categories << @category
        return render(:partial => 'admin/content/categories')
      end
    end
  end
end

