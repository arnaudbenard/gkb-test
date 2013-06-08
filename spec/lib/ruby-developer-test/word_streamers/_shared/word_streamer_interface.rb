shared_examples_for "a word streamer" do

  subject { instance }

  it { should respond_to :next_word }
end
