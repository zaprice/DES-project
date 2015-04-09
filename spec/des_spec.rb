require 'rspec'
require_relative '../impl/des.rb'

describe "DES" do

  it "XORs hex" do
    expect(DES.new.xor("ff", "11")).to eq("ee")
  end

  it "converts bytes to bits" do
    expect(DES.new.bytes_to_bits ["ff", "10"]).to eq(["1","1","1","1","1","1","1","1","0","0","0","1","0","0","0","0"])
  end

  it "converts bits to bytes" do
    expect(DES.new.bits_to_bytes ["1","1","1","1","1","1","1","1","0","0","0","0","0","0","0","1"]).to eq(["ff", "01"])
  end

  it "converts hex to bin" do
    expect(DES.new.hex_to_bin "f1").to eq(["1","1","1","1","0","0","0","1"])
  end

  it "generates the correct initial subkey" do
    des = DES.new
    des.key = ["7f","ff","ff","ff","ff","ff","ff","ff"]
    initial_subkey = des.get_subkey
    expect(initial_subkey.size).to eq(6)
  end

end
