# require "rubygems"
# require "bundler/setup"
require 'simplecov'
SimpleCov.start
# require File.expand_path(File.dirname(__FILE__) + '/../lib/technology.rb')
require_relative '../lib/technology.rb'

describe "states" do

  subject { Technology.new } 

  it "should start unapproved" do
    subject.current_state.to_s.should == "unapproved"
  end


  #
  # UNAPPROVED
  #
  context "when unapproved" do

    it "should be unapproved" do
      subject.unapproved?.should == true
      subject.current_state.to_s.should == "unapproved"
    end

    it "should tell us it is unapproved when set to unapproved" do
      # pending
      subject.approve!
      subject.unapprove!
    end

    it "cannot be set to unapproved" do
      expect { subject.unapprove! }.to raise_error
    end

    it "available events should be approve and reject" do
      subject.current_state.events.should have_key(:approve)
      subject.current_state.events.should have_key(:reject)
      subject.current_state.events.keys.should == [:approve, :reject]
    end

    it "can be set to rejected" do
      expect { subject.reject! }.to_not raise_error
      subject.rejected?.should == true
      subject.current_state.to_s.should == "rejected"
    end

    it "can be set to approved" do
      expect { subject.approve! }.to_not raise_error
      subject.approved?.should == true
      subject.current_state.to_s.should == "approved"
    end

    it "cannot be set to published" do
      expect { subject.publish! }.to raise_error
      subject.unapproved?.should == true
    end

    it "cannot be set to retired" do
      expect { subject.retire! }.to raise_error
      subject.unapproved?.should == true
    end

  end


  #
  # APPROVED
  #
  context "when approved" do
    it "should be approved" do
      subject.approve!
      subject.approved?.should == true
      subject.current_state.to_s.should == "approved"
    end
    it "should not be publishable when unapproved" do
      expect { subject.publish! }.to raise_error
    end

    it "should tell us it is approved when set to approved" do
      # pending
      # expect { subject.approve! }.to_s == "technology is approved"
      expect { subject.approve! }.call.should == "approved"
      subject.approved?.should == true
    end

    it "available events should be publish and unapprove" do
      subject.approve!
      subject.current_state.events.should have_key(:publish)
      subject.current_state.events.should have_key(:unapprove)
      subject.current_state.events.keys.should == [:publish,:unapprove]
    end

    it "can be set back to unapproved" do
      subject.approve!
      subject.approved?.should == true
      subject.unapprove!
      subject.current_state.to_s.should == "unapproved"
    end

    it "can be set back to published" do
      subject.approve!
      subject.approved?.should == true
      subject.publish!
      subject.current_state.to_s.should == "published"
    end

    it "cannot be set to approved when already approved" do
      subject.approve!
      subject.approved?.should == true
      expect { subject.approve! }.to raise_error
    end
     
    it "cannot be set to retired" do
      subject.approve!
      subject.approved?.should == true
      expect { subject.retire! }.to raise_error
      subject.approved?.should == true
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
     
    it "should tell us it is published when set to published" do
      # pending
      subject.approve!
      expect { subject.publish! }.call.should == "published"
      subject.published?.should == true
    end
     
    it "available events should be retire" do
      subject.approve!
      subject.publish!
      subject.published?.should == true
      subject.current_state.events.should have_key(:retire)
      subject.current_state.events.keys.should == [:retire]
    end
     
    it "can be set to retired" do
      subject.approve!
      subject.publish!
      subject.published?.should == true
      expect { subject.retire! }.to_not raise_error
      subject.retired?.should == true
    end

    it "cannot be set to published when already published" do
      subject.approve!
      subject.publish!
      subject.published?.should == true
      expect { subject.publish! }.to raise_error
    end
     
    it "cannot be set to approved" do
      subject.approve!
      subject.publish!
      subject.published?.should == true
      expect { subject.approve! }.to raise_error
      subject.published?.should == true
    end
     
    it "cannot be set to unapproved" do
      subject.approve!
      subject.publish!
      subject.published?.should == true
      expect { subject.unapprove! }.to raise_error
      subject.published?.should == true
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

    it "should tell us it is retired when set to retired" do
      # pending
      subject.approve!
      subject.publish!
      expect { subject.retire! }.call.should == "retired"
      subject.retired?.should == true
    end

    it "there should be no available events" do
      subject.approve!
      subject.publish!
      subject.retire!
      subject.retired?.should == true
      subject.current_state.events.keys.should == []
    end

    it "cannot be set to retired when already retired" do
      subject.approve!
      subject.publish!
      subject.retire!
      expect { subject.retire! }.to raise_error
    end

    it "cannot be set to approved" do
      subject.approve!
      subject.publish!
      subject.retire!
      subject.retired?.should == true
      expect { subject.approve! }.to raise_error
      subject.retired?.should == true
    end

    it "cannot be set to unapproved" do
      subject.approve!
      subject.publish!
      subject.retire!
      subject.retired?.should == true
      expect { subject.unapprove! }.to raise_error
      subject.retired?.should == true
    end

    it "cannot be set to published" do
      subject.approve!
      subject.publish!
      subject.retire!
      subject.retired?.should == true
      expect { subject.publish! }.to raise_error
      subject.retired?.should == true
    end

  end


  #
  # REJECTED
  #
  context "when rejected" do

    it "should be rejected" do
      subject.reject!
      subject.rejected?.should == true
      subject.current_state.to_s.should == "rejected"
    end

    it "there should be no available events" do
      subject.reject!
      subject.rejected?.should == true
      subject.current_state.events.keys.should == []
    end

    it "cannot be set to rejected when already rejected" do
      subject.reject!
      expect { subject.reject! }.to raise_error
    end

    it "cannot be set to approved" do
      subject.reject!
      subject.rejected?.should == true
      expect { subject.approve! }.to raise_error
      subject.approved?.should == false
    end

    it "cannot be set to unapproved" do
      subject.reject!
      subject.rejected?.should == true
      expect { subject.unapprove! }.to raise_error
      subject.unapproved?.should == false
    end

    it "cannot be set to published" do
      subject.reject!
      subject.rejected?.should == true
      expect { subject.publish! }.to raise_error
      subject.published?.should == false
    end

    it "cannot be set to retired" do
      subject.reject!
      subject.rejected?.should == true
      expect { subject.retire! }.to raise_error
      subject.retired?.should == false
    end

  end

end
