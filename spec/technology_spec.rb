# require "rubygems"
# require "bundler/setup"
# require 'simplecov'
# SimpleCov.start
# require File.expand_path(File.dirname(__FILE__) + '/../lib/technology.rb')
require_relative '../lib/technology.rb'

describe "states" do

  subject { Technology.new } 

  it "should start unapproved" do
    subject.current_state.to_s.should == "unapproved"
  end

  context "when approved" do
    it "should be approved" do
      subject.approve!
      subject.approved?.should == true
      subject.current_state.to_s.should == "approved"
    end
    it "should not be publishable when unapproved" do
      expect { subject.publish! }.to raise_error
    end
    it "should tell us it is approved" do
      expect { subject.approve! }.to_s == "technology is approved"
    end
    it "can be set back to unapproved" do
      subject.approve!
      subject.unapprove!
      subject.current_state.to_s.should == "unapproved"
    end
    it "available events should be publish and unapprove" do
      subject.approve!
      subject.current_state.events.should have_key(:publish)
      subject.current_state.events.should have_key(:unapprove)
      subject.current_state.events.keys.should == [:publish,:unapprove]
    end
  end

  #
  # PUBLISHED
  #
  context "when published" do
    it "should be published" do
      subject.approve!
      subject.publish!
      subject.published?.should == true
      subject.current_state.to_s.should == "published"
    end
    it "should tell us it is published" do
      pending
      subject.approve!
      subject.publish!
    end
    it "available events should be retire" do
      subject.approve!
      subject.publish!
      subject.current_state.events.should have_key(:retire)
      subject.current_state.events.keys.should == [:retire]
    end
    it "cannot be set to approved" do
      subject.approve!
      subject.publish!
      subject.retire!
      expect { subject.approve! }.to raise_error
    end
    it "cannot be set to unapproved" do
      subject.approve!
      subject.publish!
      expect { subject.unapprove! }.to raise_error
    end
    it "cannot be set to published" do
      subject.approve!
      subject.publish!
      expect { subject.publish! }.to raise_error
    end
    it "can be set to retired" do
      subject.approve!
      subject.publish!
      expect { subject.retire! }.to_not raise_error
    end
  end

  #
  # RETIRED
  #
  context "when retired" do
    it "should be retired" do
      subject.approve!
      subject.publish!
      subject.retire!
      subject.retired?.should == true
      subject.current_state.to_s.should == "retired"
    end
    it "should tell us it is retired" do
      # pending
      subject.approve!
      subject.publish!
      expect { subject.retire! }.call.should == "retired"
      # subject.retire!
      # should_receive(:puts).once
    end
    it "there should be no available events" do
      subject.approve!
      subject.publish!
      subject.retire!
      subject.current_state.events.keys.should == []
    end
    it "cannot be set to approved" do
      subject.approve!
      subject.publish!
      subject.retire!
      expect { subject.approve! }.to raise_error
    end
    it "cannot be set to unapproved" do
      subject.approve!
      subject.publish!
      subject.retire!
      expect { subject.unapprove! }.to raise_error
    end
    it "cannot be set to published" do
      subject.approve!
      subject.publish!
      subject.retire!
      expect { subject.publish! }.to raise_error
    end
    it "cannot be set to retired" do
      subject.approve!
      subject.publish!
      subject.retire!
      expect { subject.retire! }.to raise_error
    end
  end

end
