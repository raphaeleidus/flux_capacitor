require "spec_helper"

RSpec.describe Flux do
  it "has a version number" do
    expect(Flux::VERSION).not_to be nil
  end

  describe Flux::Capacitor do
    let (:now_ts) { DateTime.now.strftime("%s").to_i }
    let (:oldest) { DateTime.strptime((now_ts - 30*60).to_s, "%s") }
    let (:pivot) { DateTime.strptime((now_ts - 5*60).to_s, "%s") }
    let (:end_point) { DateTime.strptime((now_ts + 5*60).to_s, "%s") }
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

end
