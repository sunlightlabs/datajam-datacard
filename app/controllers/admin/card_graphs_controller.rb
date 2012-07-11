class Admin::CardGraphsController < AdminController
  before_filter :find_card

  def index
    @graphs = @card.graphs
  end

  def new
    @graph = @card.graphs.build
  end

  def create
    @graph = @card.graphs.build(params[:card_graph])
    
    if @graph.save
      flash[:success] = "Graph generated."
      redirect_to admin_card_graph_path(@graph.card, @graph)
    else
      flash[:error] = @graph.errors.full_messages.to_sentence
      render 'new'
    end
  end

  def show
    @graph = @card.graphs.find(params[:id])
  end

  protected

  def find_card
    @card = DataCard.find(params[:card_id])
  end
end
