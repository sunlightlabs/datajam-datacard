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

  it "Can be changed with new CSV text" do
    csv = <<-EOF.strip_heredoc
      "Candidate","Percentage"
      "Mitt Romney","28%"
      "Ron Paul","22%"
    EOF

    params = { title: 'Straw Poll', csv: csv, source: "Gallup" }
    card = DataCard.create(params)

    csv = <<-EOF.strip_heredoc
      "Candidate","Percentage"
      "Mitt Romney","28%"
      "Barack Obama","28%"
    EOF

    params = { title: 'Straw Poll', csv: csv, source: "Gallup" }
    card.update_attributes(params)

    card = DataCard.find(card._id.to_s)
    card.table_body.should include(["Barack Obama", "28%"])
    card.csv.to_s.should include("Barack Obama")
    card.render.should include("Barack Obama")
  end

  it "throws an error when passed in an invalid CSV string" do
    csv = <<-EOF.strip_heredoc
      "Candidate", "Percentage"
      "Mitt Romney", "20%"
      "Ron Paul", "22%"
    EOF

    params = {title: 'Straw Poll', csv: csv, source: "Rasmussen" }
    card = DataCard.create(params)

    card.persisted?.should be_false
    card.table_head.should be_empty
    card.errors.full_messages.to_sentence.should include("Illegal quoting")
  end

  it "can be created with an explicit html body" do
    card = DataCard.create(title: "Straw Poll", body: "<div>Blah</div>")
    card.render.should == "<div>Blah</div>"
  end

  it "caches its tags on save" do
    card = DataCard.create(title: "Straw Poll", body: "<div>Blah</div>", tag_string: '2012,global')
    card.cached_tag_string.should include "2012"
    card.cached_tag_string.should include "global"
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
