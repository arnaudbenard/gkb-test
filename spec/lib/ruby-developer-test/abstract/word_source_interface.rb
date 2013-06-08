require 'spec_helper'

shared_examples_for "a word source" do

  subject { klass.new }

  it { should respond_to :run }
  it { should respond_to :next_word }
  it { should respond_to :top_5_consonants }
  it { should respond_to :top_5_words }
  it { should respond_to :count }
  it { should respond_to :callback }

end
