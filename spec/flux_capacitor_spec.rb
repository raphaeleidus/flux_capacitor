require "spec_helper"

RSpec.describe Flux do
  it "has a version number" do
    expect(Flux::VERSION).not_to be nil
  end

  let (:now_ts) { DateTime.now.strftime("%s").to_i }
  let (:oldest) { DateTime.strptime((now_ts - 30*60).to_s, "%s") }
  let (:pivot) { DateTime.strptime((now_ts - 5*60).to_s, "%s") }
  let (:end_point) { DateTime.strptime((now_ts + 5*60).to_s, "%s") }

  describe Flux::Capacitor do
    describe "for dates" do
      let (:cap) { Flux::Capacitor.new(pivot, end_point, oldest) }
      it 'retains pivot' do
        expect(cap.pivot).to eq(pivot)
      end

      it 'calculates time dilation' do
        expect(cap.time_dilation).to eq(2.5)
      end
      it '#travel_to? rejects too old' do
        expect(cap.travel_to?(DateTime.strptime((now_ts - 20*60).to_s, "%s"))).to eq(false)
      end

      it '#travel_to? accepts recent' do
        expect(cap.travel_to?(DateTime.strptime((now_ts - 10*60).to_s, "%s"))).to eq(true)
      end

      it '#travel_to? accepts future' do
        expect(cap.travel_to?(DateTime.strptime((now_ts + 5*60).to_s, "%s"))).to eq(true)
      end
    end

    describe "strings" do
      let (:cap) { Flux::Capacitor.new(pivot, end_point) }
      it 'retains pivot' do
        expect(cap.pivot).to eq(pivot)
      end

      it 'calculates time dilation' do
        expect(cap.time_dilation).to eq(894784.8516666667)
      end
      it '#travel_to? rejects too old' do
        expect(cap.travel_to?("bar")).to eq(false)
      end

      it '#travel_to? accepts recent' do
        expect(cap.travel_to?("foo")).to eq(true)
      end
    end
  end

  describe Flux::Falsey do
    let (:blank) { Flux::Falsey.new() }
    it 'is a Flux::Capacitor' do
      expect(blank).to be_a(Flux::Capacitor)
    end
    it 'can be initialized with the date signature' do
     expect(Flux::Falsey.new(pivot, end_point, oldest)).to be_a(Flux::Capacitor)
    end
    it 'can be initialized with the string signature' do
     expect(Flux::Falsey.new(pivot, end_point)).to be_a(Flux::Capacitor)
    end
    it '#travel_to?(DateTime) returns false' do
      expect(blank.travel_to?(DateTime.now)).to eq(false)
    end

    it '#travel_to?(String) returns false' do
      expect(blank.travel_to?('foo')).to eq(false)
    end
  end

  describe Flux::Truethy do
    let (:blank) { Flux::Truethy.new() }
    it 'is a Flux::Capacitor' do
      expect(blank).to be_a(Flux::Capacitor)
    end
    it 'can be initialized with the date signature' do
     expect(Flux::Truethy.new(pivot, end_point, oldest)).to be_a(Flux::Capacitor)
    end
    it 'can be initialized with the string signature' do
     expect(Flux::Truethy.new(pivot, end_point)).to be_a(Flux::Capacitor)
    end
    it '#travel_to?(DateTime) returns true' do
      expect(blank.travel_to?(DateTime.now)).to eq(true)
    end
    it '#travel_to?(String) returns true' do
      expect(blank.travel_to?('foo')).to eq(true)
    end
  end

end
