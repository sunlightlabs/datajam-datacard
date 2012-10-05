class Admin::CardsController < AdminController

  def index
    @cards = filter_and_sort DataCard.unscoped.all.order(:updated_at => :desc)
    @card = DataCard.new
    render_if_ajax 'admin/cards/_table'
  end

  def show
    @card = DataCard.find(params[:id])
  end

  def new
    @card = DataCard.new
  end

  def edit
    @card = DataCard.find(params[:id])
  end

  def create
    @card = DataCard.new(params[:card])

    return if render_preview
    render 'new' and return if params[:back]

    if @card.save
      flash[:success] = "Card saved."
      redirect_to admin_cards_path
    else
      flash[:error] = @card.errors.full_messages.to_sentence
      render 'new'
    end
  end

  def update
    @card = DataCard.find(params[:id])

    return if render_preview

    if params[:back]
      @card.attributes = params[:card]
      render 'edit' and return
    end

    if @card.update_attributes(params[:card])
      flash[:success] = "Card updated."
      redirect_to edit_admin_card_path(@card)
    else
      flash[:error] = @card.errors.full_messages.to_sentence
      render 'edit'
    end
  end

  def destroy
    @card = DataCard.find(params[:id])
    if @card.destroy
      flash[:success] = "Card deleted."
    else
      flash[:error] = @card.errors.full_messages.to_sentence
    end
    redirect_to admin_cards_path
  end

  private

  def render_preview
    if params[:preview]
      @card.attributes = params[:card]
      @card.rebuild_table_data!
      render 'preview'
      true
    end
  end
end
