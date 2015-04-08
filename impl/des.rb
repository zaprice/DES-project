class DES

  attr_accessor :key, :tmp_subkey

  def encrypt block
    block = initial_permutation block
    16.times do
      left = block[0..3]
      right = block[4..7]
      block = append(right, xor(left, feistel(right)))
    end
    final_permutation block
  end

  def initial_permutation block
    permutation = File.read("../config/initial_permutation.txt").strip.split " "
    return permute block, permutation
  end

  def final_permutation block
    permutation = File.read("../config/final_permutation.txt").strip.split " "
    return permute block, permutation
  end

  def feistel half-block
    bit_shuffle( s_box( xor( expand(half-block), get_subkey)))
  end

  # Aids diffusion of key material
  def expand

  end

  # Ensures non-linearity from plaintext to ciphertext
  # Each bit of ciphertext should depend on many bits of input
  def s_box expanded_block

  end

  # Diffusion of key material and s-box changes
  # Each bit of input should change many bits of output
  def bit_shuffle half-block

  end

  # Returns round keys for each Feistel node
  # Relies on internal state of tmp_subkey
  def get_subkey

  end

  def permuted_choice_1

  end

  def permuted_choice_2

  end

  def xor(hex1, hex2)
    [hex1].pack("H*").bytes.zip([hex2].pack("H*").bytes).map { |arr| arr[0] ^ arr[1] }.pack("c*").unpack("H*").first
  end

  def bytes_to_bits block
    block.map { |byte| hex_to_bin byte }.flatten
  end

  def hex_to_bin hex
    [hex].pack("H*").bytes[0].to_s(2).split("").map { |bit| bit.to_i }
  end

  def permute block, permutation
    bits = bytes_to_bits(block)
    permuted_bits = permutation.map { |index| bits[index - 1]}
    return bits_to_bytes permuted_bits
  end

end
