require File.dirname(__FILE__) + '/../spec_helper'

describe ForumsController, "GET #show" do

=begin
  before do
    @forum = mock_model(Forum)
    @topics = mock(Array)
    Forum.stub!(:find_by_permalink).and_return(@forum)
    @forum.should_receive(:paginate_by_forum_id).and_return(@topics)
    @topics.stub!(:paginate).and_return(@topics)
  end

  it "should select the forum and its topics" do
    get :show, :id => "arquitetura"
    assigns[:forum].should == @forum
    assigns[:topics].should == @topics
  end

  it "should render the show template" do
    get :show, :id => "arquitetura"
    response.should render_template("show")
  end

  it "should paginate the output" do
    @topics.should_receive(:paginate).with(:page => 5).and_return(@topics)
    get :show, :id => "arquitetura", :page => '5'
  end
=end

  it "should paginate all topics if show all flag is enabled" do
    pending
  end
  
  it "should paginate just the topics with score higher than 0 if show all flag is not enabled" do
    pending
  end
  
  it "should render the show template" do
    pending
  end
end