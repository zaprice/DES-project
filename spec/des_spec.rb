require 'rspec'
require_relative '../impl/des.rb'

describe "DES" do

  it "converts bytes to bits" do
    expect(DES.new.bytes_to_bits ["ff", "00"]).to eq(["1","1","1","1","1","1","1","1","0","0","0","0","0","0","0","0"])
  end

  it "converts bits to bytes" do
    expect(DES.new.bits_to_bytes ["1","1","1","1","1","1","1","1","0","0","0","0","0","0","0","0"]).to eq(["ff", "00"])
  end

end
