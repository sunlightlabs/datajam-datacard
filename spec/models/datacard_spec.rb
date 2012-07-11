require File.expand_path('../../spec_helper', __FILE__)

describe DataCard do

  it "can be created when passed in a CSV string" do
    csv = <<-EOF.strip_heredoc
      "Candidate","Percentage"
      "Mitt Romney","28%"
      "Ron Paul","22%"
    EOF

    params = { title: 'Straw Poll', csv: csv, source: "Gallup" }
    card = DataCard.create(params)

    card.table_head.should eql(['Candidate','Percentage'])
    card.table_body.length.should eql(2)

    card.render.should include("Gallup")
    card.render.should include("Ron Paul")
  end

  it "can be created with an explicit html body" do
    card = DataCard.create(title: "Straw Poll", body: "<div>Blah</div>")
    card.render.should == "<div>Blah</div>"
  end

  describe "#graph_data" do
    let :card do
      csv = <<-EOF.strip_heredoc
        "Candidate","Percentage","Age","Party"
        "Mitt Romney",28,42,One
        "Ron Paul",22,38,One
        "Marty MacFly",18,22,Two
      EOF

      params = { title: 'Graphed Card', csv: csv, source: "Dummy" }
      DataCard.create(params)
    end

    it "returns nothing when series are empty" do
      card.graph_data_for("Candidate", []).should_not be
    end

    it "returns nothing when grouping column or series columns are invalid" do
      card.graph_data_for("Not exists", ["Percentage"]).should_not be
      card.graph_data_for("Candidate", ["Not exists"]).should_not be
    end

    it "returns graph data when specified group and series are valid" do
      graph_data = card.graph_data_for("Party", %w{Percentage Age})
      graph_data.should have(2).items
      graph_data[0].tap do |serie|
        serie[:key].should == "Percentage"
        serie[:values].map(&:to_a).should == [
          [[:x, "One"], [:y, 50.0]],
          [[:x, "Two"], [:y, 18.0]],
        ]
      end
    end
  end

end
