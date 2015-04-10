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
    expect(initial_subkey[2]).to eq("ef")
  end

  it "generates the correct next subkey" do
    des = DES.new
    des.key = ["7f","ff","ff","ff","ff","ff","ff","ff"]
    des.get_subkey
    next_subkey = des.get_subkey
    expect(next_subkey.size).to eq(6)
    expect(next_subkey[1]).to eq("bf")
  end

  it "performs s-box transformation correctly" do
    sbox_output = DES.new.s_box ["ff","ff","ff","ff","ff","ff",]
    expect(sbox_output[0]).to eq("d9")
  end

  it "encrypts to the correct value" do
    des = DES.new
    des.key = ["3b","38","98","37","15","20","f7","5e"]
    ciphertext = des.encrypt ["00","00","00","00","00","00","00","00"]
    expect(ciphertext.size).to eq(8)
    expect(ciphertext).to eq(["83", "a1", "e8", "14", "88", "92", "53", "e0"])
  end

end
