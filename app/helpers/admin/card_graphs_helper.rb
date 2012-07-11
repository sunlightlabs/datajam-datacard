module Admin::CardGraphsHelper
  def graph_group_by_options_for(card)
    card.table_head.inject({}) do |res, head| 
      res[head] = head
      res
    end
  end
end
