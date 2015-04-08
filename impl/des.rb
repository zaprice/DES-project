class DES

  attr_accessor :key, :left_subkey, :right_subkey, :ctr

  shifts = [1, 1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1]

  def encrypt block
    block = initial_permutation block
    for @ctr in 0..15
      left = block[0..3]
      right = block[4..7]
      block = append(right, xor(left, feistel(right)))
    end
    final_permutation block
  end

  def initial_permutation block
    permutation = File.read("../config/initial_permutation.txt").strip.split " "
    permute block, permutation
  end

  def final_permutation block
    permutation = File.read("../config/final_permutation.txt").strip.split " "
    permute block, permutation
  end

  def feistel  half_block
    bit_shuffle( s_box( expand( half_block).zip(get_subkey).map { |byte, key| xor(byte, key) }))
  end

  # Aids diffusion of key material
  def expand  half_block

  end

  # Ensures non-linearity from plaintext to ciphertext
  # Each bit of ciphertext should depend on many bits of input
  def s_box expanded_block

  end

  # Diffusion of key material and s-box changes
  # Each bit of input should change many bits of output
  def bit_shuffle  half_block

  end

  # Returns round keys for each Feistel node
  # Relies on internal state of tmp_subkey
  def get_subkey
    if ctr == 0
      selected_bits = bytes_to_bits permuted_choice_1 @key
      @left_subkey = selected_bits[0..27]
      @right_subkey = selected_bits[28..55]
    end

    @left_subkey = shift @left_subkey, shifts[ctr]
    @right_subkey = shift @right_subky, shift[ctr]

    permuted_choice_2 @left_subkey.add(@right_subkey)
  end

  def permuted_choice_1 key
    permutation = File.read("../config/permuted_choice_1.txt").strip.split " "
    permute key, permutation
  end

  def permuted_choice_2 key
    permutation = File.read("../config/permuted_choice_2.txt").strip.split " "
    permute key, permutation
  end

  ##############################################################################
  # Helper functions
  ##############################################################################

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
    bits_to_bytes permuted_bits
  end

  def shift subkey, value
    removed = subkey.shift value
    subkey.push(removed).flatten
  end

end
